import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'perf_probe.dart';

import 'ais/ais_decoder.dart' show NmeaFormat, applyNmeaFormat;
import 'target_config.dart';

enum ForwardProtocol { udpServer, tcpClient, udpClient, tcpServer }

typedef LogCallback =
    void Function(String message, String? starter, String? name);
typedef StatusCallback = void Function(LogMessage message);

/// A structured, localizable status message shown in the reception log.
/// [fallback] is the English text used when no localization is available.
class LogMessage {
  final String key;
  final Map<String, Object?> args;
  final String fallback;

  const LogMessage(this.key, this.args, this.fallback);
}

/// Serializes writes to one target without allowing a slow destination to
/// block the feed pipeline indefinitely.
class TargetSendQueue {
  final int maxPending;
  final Future<void> Function(String line) writer;
  final List<String> _pending = [];
  Future<void> _idle = Future<void>.value();
  bool _draining = false;
  int dropped = 0;

  TargetSendQueue({required this.writer, this.maxPending = 2048})
    : assert(maxPending > 0);

  Future<void> get idle => _idle;

  void enqueue(String line) {
    if (_pending.length >= maxPending) {
      _pending.removeAt(0);
      dropped++;
    }
    _pending.add(line);
    if (_draining) return;
    _draining = true;
    final completer = Completer<void>();
    _idle = completer.future;
    unawaited(_drain(completer));
  }

  Future<void> _drain(Completer<void> completer) async {
    try {
      while (_pending.isNotEmpty) {
        final line = _pending.removeAt(0);
        try {
          await writer(line);
        } catch (_) {
          // Keep draining after a failed write so later frames are not stuck.
        }
      }
    } finally {
      _draining = false;
      completer.complete();
    }
  }
}

typedef DataCallback =
    Future<void> Function(String feedName, String flag, String line);

class FeedStatus {
  final bool connecting;
  final bool connected;
  final String? error;
  final int messageCount;
  final DateTime? lastMessageAt;

  const FeedStatus({
    this.connecting = false,
    this.connected = false,
    this.error,
    this.messageCount = 0,
    this.lastMessageAt,
  });

  FeedStatus copyWith({
    bool? connecting,
    bool? connected,
    String? error,
    bool clearError = false,
    int? messageCount,
    DateTime? lastMessageAt,
  }) => FeedStatus(
    connecting: connecting ?? this.connecting,
    connected: connected ?? this.connected,
    error: clearError ? null : (error ?? this.error),
    messageCount: messageCount ?? this.messageCount,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
  );
}

/// Receives AIS frames from feeds (reception) and forwards them to every
/// enabled [TargetConfig] (send).
/// Returns true if [line] should be forwarded to [config] given its
/// [allowedTypes] filter. Empty filter means allow all.
bool shouldForwardToTarget(String line, TargetConfig config) {
  if (config.allowedTypes.isEmpty) return true;
  final type = tryExtractAisMessageType(line);
  if (type == null) return true; // non-AIS or unparseable -> forward
  return config.allowedTypes.contains(type);
}

/// Lightweight AIS type extraction without full decode. Decodes first 6-bit char.
int? tryExtractAisMessageType(String line) {
  try {
    // Find payload between 5th and last comma (NMEA AIS sentence)
    final star = line.lastIndexOf('*');
    final body = star > 0 ? line.substring(1, star) : line;
    if (!body.contains(',')) return null;
    final parts = body.split(',');
    if (parts.length < 6) return null;
    final payload = parts[5];
    if (payload.isEmpty) return null;
    // AIS 6-bit decoding: first char -> 6 bits, type is first 6 bits
    const table = '0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVW`abcdefghijklmnopqrstuvw';
    int val(int c) {
      if (c >= 48 && c <= 87) return c - 48;
      if (c >= 96 && c <= 119) return c - 56;
      return -1;
    }
    final v = val(payload.codeUnitAt(0));
    if (v < 0) return null;
    return v; // 6-bit value of first payload char == message type (1-27)
    // Actually type is 6 bits of first payload char
  } catch (_) {
    return null;
  }
  return null;
}

class ForwarderService {
  static const _statusUpdateInterval = Duration(milliseconds: 50);
  final LogCallback onLog;
  final StatusCallback? onStatus;
  final Duration reconnectDelay;

  ForwarderService({
    required this.onLog,
    this.onStatus,
    this.reconnectDelay = const Duration(seconds: 5),
  });

  void _status(LogMessage m) {
    if (onStatus != null) {
      onStatus!(m);
    } else {
      onLog(m.fallback, null, null);
    }
  }

  final Map<String, _FeedConnection> _feeds = {};
  final ValueNotifier<Map<String, FeedStatus>> feedStatuses = ValueNotifier({});
  final Map<String, _TargetConnection> _targets = {};
  final Map<String, FeedStatus> _pendingStatuses = {};
  Timer? _statusUpdateTimer;

  List<TargetConfig> configuredTargets = [];
  bool _running = false;
  bool _stopping = false;

  /// How frames are normalized when they enter the pipeline (import): keep
  /// them as received, strip their tag blocks, or tag them.
  NmeaFormat importFormat = NmeaFormat.passthrough;

  /// Source id used when [importFormat] is [NmeaFormat.tag].
  String importTagSourceId = 'KIKAIS';

  /// Stores the configured destinations and, while running, connects /
  /// disconnects the corresponding transports.
  Future<void> setTargets(List<TargetConfig> list) async {
    configuredTargets = List.of(list);
    if (!_running) return;

    for (final id in List.of(_targets.keys)) {
      final found = configuredTargets.where((c) => c.id == id).toList();
      if (found.isEmpty || !found.first.enabled) {
        await _targets.remove(id)?.disconnect();
      }
    }
    for (final t in configuredTargets) {
      if (t.enabled && !_targets.containsKey(t.id)) {
        final conn = _TargetConnection(t, onLog, _status);
        _targets[t.id] = conn;
        try {
          await conn.connect();
          _status(
            LogMessage(
              'targetConnected',
              {
                'name': t.name,
                'protocol': t.protocol,
                'host': t.host,
                'port': t.port,
              },
              'Target ${t.name} connected '
                  '(${protocolLabel(t.protocol)} ${t.host}:${t.port}).',
            ),
          );
        } catch (e) {
          _status(
            LogMessage('targetConnectFailed', {
              'name': t.name,
              'error': '$e',
            }, 'Failed to connect target ${t.name}: $e'),
          );
          _targets.remove(t.id);
        }
      }
    }
  }

  Future<void> start() async {
    _stopping = false;
    _running = true;
    await setTargets(configuredTargets);
    for (var feed in _feeds.values) {
      unawaited(_connectFeed(feed));
    }
  }

  Future<void> stop() async {
    _stopping = true;
    _running = false;
    _status(const LogMessage('stopping', {}, 'Stopping forwarder...'));
    for (var feed in _feeds.values) {
      await feed.disconnect();
    }
    _feeds.clear();
    for (final t in _targets.values) {
      await t.disconnect();
    }
    _targets.clear();
    _statusUpdateTimer?.cancel();
    _statusUpdateTimer = null;
    _pendingStatuses.clear();
    feedStatuses.value = {};
    _status(const LogMessage('stopped', {}, 'Forwarder stopped.'));
  }

  /// Forwards a raw NMEA line to every connected target, applying each
  /// target's configured frame format.
  Future<void> _send(String line) async {
    final clean = line.trim();
    if (clean.isEmpty) return;
    for (final t in _targets.values) {
      if (!shouldForwardToTarget(clean, t.config)) continue;
      final out = applyNmeaFormat(
        clean,
        t.config.sendFormat,
        sourceId: t.config.tagSourceId ?? t.config.name,
      );
      if (out.isNotEmpty) t.send(out);
    }
  }

  Future<void> sendRaw(String nmea) => _send(nmea);

  /// Injects a raw NMEA line into the pipeline as if it came from [feedName]
  /// (used by the simulation tab): it is forwarded to the enabled targets,
  /// logged and decoded exactly like a real feed frame.
  Future<void> ingest(String feedName, String flag, String line) =>
      _handleData(feedName, flag, line);

  Future<void> addFeed(
    String name,
    String flag,
    String host,
    int port, {
    String? header,
  }) async {
    if (_feeds.containsKey(name)) return;

    var feed = _FeedConnection(name, flag, host, port, header);
    _feeds[name] = feed;
    feedStatuses.value = {...feedStatuses.value, name: feed.status};
    feed.statusNotifier.addListener(
      () => _publishFeedStatus(name, feed.status),
    );

    if (_running && !_stopping) {
      unawaited(_connectFeed(feed));
    }

    _status(
      LogMessage('feedAdded', {
        'name': name,
        'host': host,
        'port': port,
      }, 'Feed added: $name ($host:$port)'),
    );
  }

  Future<void> removeFeed(String name) async {
    var feed = _feeds.remove(name);
    if (feed != null) {
      await feed.disconnect();
      feed.statusNotifier.dispose();
      feedStatuses.value = Map.of(feedStatuses.value)..remove(name);
      _status(LogMessage('feedRemoved', {'name': name}, 'Feed removed: $name'));
    }
  }

  /// Updates the displayed status of a source that is not backed by a socket
  /// connection (e.g. file feeds), so its tile reuses the same dot semantics.
  void setFeedStatus(String name, FeedStatus status) {
    _publishFeedStatus(name, status);
  }

  void _publishFeedStatus(String name, FeedStatus status) {
    final previous = feedStatuses.value[name];
    if (previous == null ||
        previous.connected != status.connected ||
        previous.connecting != status.connecting ||
        previous.error != status.error) {
      feedStatuses.value = {...feedStatuses.value, name: status};
      return;
    }
    _pendingStatuses[name] = status;
    _statusUpdateTimer ??= Timer(_statusUpdateInterval, () {
      _statusUpdateTimer = null;
      if (_pendingStatuses.isEmpty) return;
      feedStatuses.value = {...feedStatuses.value, ..._pendingStatuses};
      _pendingStatuses.clear();
    });
  }

  void removeFeedStatus(String name) {
    feedStatuses.value = Map.of(feedStatuses.value)..remove(name);
  }

  Future<void> _connectFeed(_FeedConnection feed) async {
    while (!_stopping && !feed.isDisposed) {
      try {
        await feed.connect(_handleData);
        _status(
          LogMessage('feedConnected', {
            'name': feed.name,
          }, 'Feed ${feed.name} connected.'),
        );
        await feed.closed;
        if (_stopping || feed.isDisposed) break;
        _status(
          LogMessage(
            'feedDisconnected',
            {'name': feed.name},
            'Feed ${feed.name} disconnected. Reconnecting in 5s...',
          ),
        );
        await Future<void>.delayed(reconnectDelay);
      } catch (e) {
        if (_stopping || feed.isDisposed) break;
        _status(
          LogMessage(
            'feedConnectFailed',
            {'name': feed.name, 'error': '$e'},
            'Failed to connect feed ${feed.name}: $e. Retrying in 5s...',
          ),
        );
        await Future<void>.delayed(reconnectDelay);
      }
    }
  }

  Future<void> _handleData(String feedName, String flag, String line) async {
    final sw = Stopwatch()..start();
    PerfProbe.pendingHandleData++;
    try {
      final normalized = applyNmeaFormat(
        line,
        importFormat,
        sourceId: importTagSourceId,
      );
      if (normalized.isEmpty) return;

      for (final t in _targets.values) {
        if (!shouldForwardToTarget(normalized, t.config)) continue;
        final out = applyNmeaFormat(
          normalized,
          t.config.sendFormat,
          sourceId: t.config.tagSourceId ?? t.config.name,
        );
        if (out.isNotEmpty) t.send(out);
      }
      onLog(normalized, flag, feedName);
    } finally {
      sw.stop();
      PerfProbe.pendingHandleData--;
      PerfProbe.recordHandleData(sw.elapsedMicroseconds);
    }
  }
}

class _TargetConnection {
  final TargetConfig config;
  final LogCallback onLog;
  final StatusCallback onStatus;

  RawDatagramSocket? _udp;
  Socket? _tcp;
  ServerSocket? _server;
  final List<Socket> _clients = [];
  late final TargetSendQueue _sendQueue;

  _TargetConnection(this.config, this.onLog, this.onStatus) {
    _sendQueue = TargetSendQueue(writer: _write);
  }

  Future<void> connect() async {
    switch (config.protocol) {
      case ForwardProtocol.udpServer || ForwardProtocol.udpClient:
        _udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      case ForwardProtocol.tcpClient:
        _tcp = await Socket.connect(config.host, config.port);
      case ForwardProtocol.tcpServer:
        _server = await ServerSocket.bind(InternetAddress.anyIPv4, config.port);
        onStatus(
          LogMessage(
            'tcpListening',
            {'name': config.name, 'port': config.port},
            'Target ${config.name}: TCP server listening on port '
                '${config.port}',
          ),
        );
        _server!.listen((client) {
          _clients.add(client);
          onStatus(
            LogMessage(
              'tcpClientConnected',
              {
                'name': config.name,
                'address': client.remoteAddress.address,
                'port': client.remotePort,
              },
              'Target ${config.name}: client connected '
                  '${client.remoteAddress.address}:${client.remotePort}',
            ),
          );
          client.listen(
            (_) {},
            onDone: () {
              _clients.remove(client);
              onStatus(
                LogMessage(
                  'tcpClientDisconnected',
                  {'name': config.name},
                  'Target ${config.name}: client disconnected',
                ),
              );
            },
            onError: (Object e) => onStatus(
              LogMessage('tcpClientError', {
                'name': config.name,
                'error': '$e',
              }, 'Target ${config.name}: client error $e'),
            ),
          );
        });
    }
  }

  void send(String line) {
    _sendQueue.enqueue(line);
  }

  Future<void> _write(String line) async {
    try {
      switch (config.protocol) {
        case ForwardProtocol.udpServer || ForwardProtocol.udpClient:
          _udp?.send(line.codeUnits, InternetAddress(config.host), config.port);
        case ForwardProtocol.tcpClient:
          _tcp?.write('$line\n');
          // Fire-and-forget flush: don't block event loop when downstream is slow.
          // The OS TCP buffer handles flow control; awaiting flush would stall
          // the entire pipeline and cause the feed to back up to 0.0/s.
          final sw = Stopwatch()..start();
          _tcp?.flush().then(
            (_) {
              sw.stop();
              PerfProbe.recordTcpFlush(sw.elapsedMicroseconds);
            },
            onError: (_) {
              sw.stop();
              PerfProbe.recordTcpFlush(sw.elapsedMicroseconds);
            },
          );
        case ForwardProtocol.tcpServer:
          for (var client in List<Socket>.of(_clients)) {
            client.write('$line\n');
            final sw = Stopwatch()..start();
            client.flush().then(
              (_) {
                sw.stop();
                PerfProbe.recordTcpFlush(sw.elapsedMicroseconds);
              },
              onError: (_) {
                sw.stop();
                PerfProbe.recordTcpFlush(sw.elapsedMicroseconds);
              },
            );
          }
      }
    } catch (e) {
      onStatus(
        LogMessage('sendError', {
          'name': config.name,
          'error': '$e',
        }, 'Target ${config.name} send error: $e'),
      );
    }
  }

  Future<void> disconnect() async {
    for (final c in _clients) {
      c.destroy();
    }
    _clients.clear();
    _udp?.close();
    _udp = null;
    _tcp?.destroy();
    _tcp = null;
    _server?.close();
    _server = null;
  }
}

class _FeedConnection {
  final String name;
  final String flag;
  final String host;
  final int port;
  final String? header;

  final StringBuffer _buffer = StringBuffer();
  final ValueNotifier<FeedStatus> statusNotifier = ValueNotifier(
    const FeedStatus(connecting: true),
  );
  Completer<void> _closedCompleter = Completer<void>();
  Socket? _socket;
  StreamSubscription<List<int>>? _subscription;
  Timer? _watchdog;
  DateTime? _connectedAt;
  bool _disposed = false;

  static const Duration _watchdogInterval = Duration(seconds: 15);
  static const Duration _silentTimeout = Duration(seconds: 45);

  FeedStatus get status => statusNotifier.value;
  Future<void> get closed => _closedCompleter.future;
  bool get isDisposed => _disposed;

  _FeedConnection(this.name, this.flag, this.host, this.port, this.header);

  Future<void> connect(DataCallback onData) async {
    _closedCompleter = Completer<void>();
    _setStatus(const FeedStatus(connecting: true));
    try {
      _socket = await Socket.connect(host, port);
      if (_disposed) {
        _socket?.destroy();
        _socket = null;
        _completeClosed();
        return;
      }
      if (header != null) {
        _socket!.write(header!);
      }
      // Enable TCP keepalive to detect dead connections quickly after sleep
      try {
        _socket!.setOption(SocketOption.tcpNoDelay, true);
      } catch (_) {}
      try {
        // SO_KEEPALIVE
        _socket!.setRawOption(
          RawSocketOption.fromBool(RawSocketOption.levelSocket, 0x0008, true),
        );
        if (Platform.isWindows) {
          _socket!.setRawOption(
            RawSocketOption.fromInt(6, 3, 30),
          ); // TCP_KEEPIDLE
          _socket!.setRawOption(
            RawSocketOption.fromInt(6, 17, 10),
          ); // TCP_KEEPINTVL
          _socket!.setRawOption(
            RawSocketOption.fromInt(6, 10, 3),
          ); // TCP_KEEPCNT (Winsock)
        } else {
          _socket!.setRawOption(
            RawSocketOption.fromInt(6, 4, 30),
          ); // TCP_KEEPIDLE
          _socket!.setRawOption(
            RawSocketOption.fromInt(6, 5, 10),
          ); // TCP_KEEPINTVL
          _socket!.setRawOption(
            RawSocketOption.fromInt(6, 6, 3),
          ); // TCP_KEEPCNT
        }
      } catch (_) {}

      _setStatus(const FeedStatus(connected: true));
      _connectedAt = DateTime.now();

      // Watchdog: force reconnect if no data for _silentTimeout
      _watchdog?.cancel();
      _watchdog = Timer.periodic(_watchdogInterval, (_) {
        if (_disposed) return;
        final last = statusNotifier.value.lastMessageAt ?? _connectedAt;
        if (last != null &&
            statusNotifier.value.connected &&
            DateTime.now().difference(last) > _silentTimeout) {
          debugPrint(
            "[FEED] $name: silent for ${DateTime.now().difference(last).inSeconds}s, forcing reconnect",
          );
          try {
            _socket?.destroy();
          } catch (_) {}
        }
      });

      _subscription = _socket!.listen(
        (data) {
          if (PerfProbe.pendingHandleData > 100) {
            PerfProbe.recordBacklog();
          }
          _buffer.write(String.fromCharCodes(data));
          final lines = _buffer.toString().split('\n');
          final lineCount = lines.length - 1;
          PerfProbe.recordChunk(data.length, lineCount);
          _buffer.clear();
          _buffer.write(lines.removeLast());
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isEmpty) continue;
            onData(name, flag, trimmed);
            if (trimmed.contains('!')) {
              _setStatus(
                status.copyWith(
                  connected: true,
                  messageCount: status.messageCount + 1,
                  lastMessageAt: DateTime.now(),
                ),
              );
            }
          }
        },
        onError: (Object e) {
          if (_disposed) return;
          _setStatus(status.copyWith(connected: false, error: '$e'));
          _completeClosed();
        },
        onDone: () {
          if (_disposed) return;
          _setStatus(
            status.copyWith(connected: false, error: 'Feed disconnected'),
          );
          _completeClosed();
        },
      );
    } catch (e) {
      _setStatus(status.copyWith(connecting: false, error: '$e'));
      _completeClosed();
      rethrow;
    }
  }

  void _setStatus(FeedStatus next) {
    final prev = statusNotifier.value;
    statusNotifier.value = next;
    if (prev.connected != next.connected || prev.error != next.error) {
      debugPrint(
        "[FEED] $name: connected=${next.connected} error=${next.error} msgs=${next.messageCount}",
      );
    }
  }

  void _completeClosed() {
    _watchdog?.cancel();
    _watchdog = null;
    if (!_closedCompleter.isCompleted) {
      _closedCompleter.complete();
    }
  }

  Future<void> disconnect() async {
    _disposed = true;
    _watchdog?.cancel();
    _watchdog = null;
    await _subscription?.cancel();
    _socket?.destroy();
    _socket = null;
    _subscription = null;
    _buffer.clear();
    _connectedAt = null;
    _completeClosed();
  }
}
