import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'ais/ais_decoder.dart' show NmeaFormat, applyNmeaFormat;
import 'target_config.dart';

enum ForwardProtocol { udpServer, tcpClient, udpClient, tcpServer }

typedef LogCallback =
    void Function(String message, String? starter, String? name);
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
  }) =>
      FeedStatus(
        connecting: connecting ?? this.connecting,
        connected: connected ?? this.connected,
        error: clearError ? null : (error ?? this.error),
        messageCount: messageCount ?? this.messageCount,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      );
}

/// Receives AIS frames from feeds (reception) and forwards them to every
/// enabled [TargetConfig] (send).
class ForwarderService {
  final LogCallback onLog;

  ForwarderService({required this.onLog});

  final Map<String, _FeedConnection> _feeds = {};
  final ValueNotifier<Map<String, FeedStatus>> feedStatuses = ValueNotifier({});
  final Map<String, _TargetConnection> _targets = {};

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
        final conn = _TargetConnection(t, onLog);
        _targets[t.id] = conn;
        try {
          await conn.connect();
          onLog(
            'Target ${t.name} connected '
            '(${protocolLabel(t.protocol)} ${t.host}:${t.port}).',
            null,
            null,
          );
        } catch (e) {
          onLog('Failed to connect target ${t.name}: $e', null, null);
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
    onLog("Stopping forwarder...", null, null);
    for (var feed in _feeds.values) {
      await feed.disconnect();
    }
    _feeds.clear();
    for (final t in _targets.values) {
      await t.disconnect();
    }
    _targets.clear();
    feedStatuses.value = {};
    onLog("Forwarder stopped.", null, null);
  }

  /// Forwards a raw NMEA line to every connected target, applying each
  /// target's configured frame format.
  Future<void> _send(String line) async {
    final clean = line.trim();
    if (clean.isEmpty) return;
    for (final t in _targets.values) {
      final out = applyNmeaFormat(
        clean,
        t.config.sendFormat,
        sourceId: t.config.tagSourceId ?? t.config.name,
      );
      if (out.isNotEmpty) await t.send(out);
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
    feed.statusNotifier.addListener(() {
      feedStatuses.value = {...feedStatuses.value, name: feed.status};
    });

    if (_running && !_stopping) {
      unawaited(_connectFeed(feed));
    }

    onLog("Feed added: $name ($host:$port)", null, null);
  }

  Future<void> removeFeed(String name) async {
    var feed = _feeds.remove(name);
    if (feed != null) {
      await feed.disconnect();
      feed.statusNotifier.dispose();
      feedStatuses.value = Map.of(feedStatuses.value)..remove(name);
      onLog("Feed removed: $name", null, null);
    }
  }

  /// Updates the displayed status of a source that is not backed by a socket
  /// connection (e.g. file feeds), so its tile reuses the same dot semantics.
  void setFeedStatus(String name, FeedStatus status) {
    feedStatuses.value = {...feedStatuses.value, name: status};
  }

  void removeFeedStatus(String name) {
    feedStatuses.value = Map.of(feedStatuses.value)..remove(name);
  }

  Future<void> _connectFeed(_FeedConnection feed) async {
    while (!_stopping) {
      try {
        await feed.connect(_handleData);
        onLog("Feed ${feed.name} connected.", null, null);
        await feed.closed;
        if (_stopping || feed.isDisposed) break;
        onLog(
          "Feed ${feed.name} disconnected. Reconnecting in 5s...",
          null,
          null,
        );
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        if (_stopping || feed.isDisposed) break;
        onLog(
          "Failed to connect feed ${feed.name}: $e. Retrying in 5s...",
          null,
          null,
        );
        await Future.delayed(const Duration(seconds: 5));
      }
    }
  }

  Future<void> _handleData(String feedName, String flag, String line) async {
    // Normalize the incoming frame according to the chosen import format.
    final normalized = applyNmeaFormat(line, importFormat,
        sourceId: importTagSourceId);
    if (normalized.isEmpty) return;

    for (final t in _targets.values) {
      final out = applyNmeaFormat(
        normalized,
        t.config.sendFormat,
        sourceId: t.config.tagSourceId ?? t.config.name,
      );
      if (out.isNotEmpty) await t.send(out);
    }
    onLog(normalized, flag, feedName);
  }
}

class _TargetConnection {
  final TargetConfig config;
  final LogCallback onLog;

  RawDatagramSocket? _udp;
  Socket? _tcp;
  ServerSocket? _server;
  final List<Socket> _clients = [];

  _TargetConnection(this.config, this.onLog);

  Future<void> connect() async {
    switch (config.protocol) {
      case ForwardProtocol.udpServer || ForwardProtocol.udpClient:
        _udp = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      case ForwardProtocol.tcpClient:
        _tcp = await Socket.connect(config.host, config.port);
      case ForwardProtocol.tcpServer:
        _server = await ServerSocket.bind(InternetAddress.anyIPv4, config.port);
        onLog(
          'Target ${config.name}: TCP server listening on port ${config.port}',
          null,
          null,
        );
        _server!.listen((client) {
          _clients.add(client);
          onLog(
            'Target ${config.name}: client connected '
            '${client.remoteAddress.address}:${client.remotePort}',
            null,
            null,
          );
          client.listen(
            (_) {},
            onDone: () {
              _clients.remove(client);
              onLog('Target ${config.name}: client disconnected', null, null);
            },
            onError: (e) =>
                onLog('Target ${config.name}: client error $e', null, null),
          );
        });
    }
  }

  Future<void> send(String line) async {
    try {
      switch (config.protocol) {
        case ForwardProtocol.udpServer || ForwardProtocol.udpClient:
          _udp?.send(
            line.codeUnits,
            InternetAddress(config.host),
            config.port,
          );
        case ForwardProtocol.tcpClient:
          _tcp?.write('$line\n');
          await _tcp?.flush();
        case ForwardProtocol.tcpServer:
          for (var client in List<Socket>.of(_clients)) {
            client.write('$line\n');
            await client.flush();
          }
      }
    } catch (e) {
      onLog('Target ${config.name} send error: $e', null, null);
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
  final ValueNotifier<FeedStatus> statusNotifier =
      ValueNotifier(const FeedStatus(connecting: true));
  Completer<void> _closedCompleter = Completer<void>();
  Socket? _socket;
  StreamSubscription<List<int>>? _subscription;
  bool _disposed = false;

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
        return;
      }
      if (header != null) {
        _socket!.write(header!);
      }
      _setStatus(const FeedStatus(connected: true));
      _subscription = _socket!.listen(
        (data) {
          _buffer.write(String.fromCharCodes(data));
          final lines = _buffer.toString().split('\n');
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
        onError: (e) {
          if (_disposed) return;
          _setStatus(status.copyWith(connected: false, error: '$e'));
          _completeClosed();
          onData(name, flag, "Error: $e");
        },
        onDone: () {
          if (_disposed) return;
          _setStatus(
            status.copyWith(connected: false, error: 'Feed disconnected'),
          );
          _completeClosed();
          onData(name, flag, "Feed disconnected");
        },
      );
    } catch (e) {
      _setStatus(status.copyWith(connecting: false, error: '$e'));
      rethrow;
    }
  }

  void _setStatus(FeedStatus next) {
    statusNotifier.value = next;
  }

  void _completeClosed() {
    if (!_closedCompleter.isCompleted) {
      _closedCompleter.complete();
    }
  }

  Future<void> disconnect() async {
    _disposed = true;
    await _subscription?.cancel();
    _socket?.destroy();
    _socket = null;
    _subscription = null;
    _buffer.clear();
    _completeClosed();
  }
}
