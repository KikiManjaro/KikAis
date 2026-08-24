import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'websdr_server.dart';

/// Connection state for a WebSDR-backed AIS feed.
enum WebSdrConnectionState { disconnected, connecting, connected, error }

/// Manages the lifecycle of an AIS-catcher subprocess connected to a
/// remote WebSDR / KiwiSDR server.
///
/// Protocol mapping (as specified):
/// - [WebSdrType.kiwiSdr]  → `AIS-catcher -t rtltcp://host:port`
/// - [WebSdrType.webSdr]   → `AIS-catcher -t txt://host:port`
/// - other types           → `AIS-catcher -t txt://host:port` fallback
///
/// The process is started via [Process.start], its stdout is parsed for NMEA
/// sentences and optionally a UDP socket is bound so the forwarder can
/// ingest sentences. Callers can listen to [sentences] or register
/// [onSentence].
class WebsdrConnection {
  WebSdrServer? _server;
  WebSdrConnectionState _state = WebSdrConnectionState.disconnected;
  String? _error;
  Process? _process;
  RawDatagramSocket? _udpSocket;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;
  StreamSubscription<RawSocketEvent>? _udpSub;

  final StreamController<String> _sentences =
      StreamController<String>.broadcast();

  /// Last resolved AIS-catcher executable path.
  String? _exePath;

  WebSdrServer? get server => _server;
  WebSdrConnectionState get state => _state;
  String? get error => _error;
  Stream<String> get sentences => _sentences.stream;
  bool get isConnected => _state == WebSdrConnectionState.connected;
  bool get isConnecting => _state == WebSdrConnectionState.connecting;

  /// Optional callback invoked for each NMEA sentence.
  void Function(String sentence)? onSentence;

  /// Optional status callback (mirrors ForwarderService LogMessage pattern
  /// but kept simple for standalone use).
  void Function(String message)? onStatus;

  static const int _defaultUdpPort = 10110;

  // ---------------------------------------------------------------------------
  // Executable discovery — reuse logic from AisCatcherProcess when available,
  // otherwise local fallback.
  // ---------------------------------------------------------------------------

  String? _findExecutable() {
    if (_exePath != null && File(_exePath!).existsSync()) return _exePath;

    final candidates = <String>[
      if (Platform.isWindows)
        '${Directory.current.path}\\tools\\ais-catcher\\ais-catcher.exe'
      else
        '${Directory.current.path}/tools/ais-catcher/ais-catcher',
      if (Platform.isWindows)
        '${Directory.current.path}\\build\\windows\\x64\\runner\\Release\\ais-catcher.exe',
      'ais-catcher',
      'AIS-catcher',
      if (Platform.isWindows) 'ais-catcher.exe',
    ];

    for (final p in candidates) {
      if (File(p).existsSync()) {
        _exePath = p;
        return p;
      }
    }

    // Search PATH
    final which = Platform.isWindows ? 'where' : 'which';
    try {
      final name = Platform.isWindows ? 'ais-catcher.exe' : 'ais-catcher';
      final result = Process.runSync(which, [name]);
      if (result.exitCode == 0) {
        final first = (result.stdout as String)
            .split(RegExp(r'\r?\n'))
            .firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
        if (first.isNotEmpty && File(first.trim()).existsSync()) {
          _exePath = first.trim();
          return _exePath;
        }
        // `which` may return path even if File check fails on some setups
        if (first.trim().isNotEmpty) {
          _exePath = first.trim();
          return _exePath;
        }
      }
    } catch (_) {}

    // Also try dynamic import of AisCatcherProcess if available
    try {
      // best-effort: ais-catcher might be on PATH without absolute check
      final alt = Platform.isWindows ? 'ais-catcher.exe' : 'ais-catcher';
      final r = Process.runSync(alt, ['-h']);
      // If it ran (exit 0 or 1 with help) we consider it available by name
      if (r.exitCode == 0 || r.stdout.toString().contains('AIS-catcher')) {
        _exePath = alt;
        return alt;
      }
    } catch (_) {}

    return null;
  }

  List<String> _buildArgs(WebSdrServer server, {int udpPort = _defaultUdpPort}) {
    final input = switch (server.type) {
      WebSdrType.kiwiSdr => 'rtltcp://${server.host}:${server.port}',
      WebSdrType.webSdr => 'txt://${server.host}:${server.port}',
      _ => 'txt://${server.host}:${server.port}',
    };

    // Minimal flags: input + UDP output to localhost + quiet.
    // Additional AIS-catcher flags (gain, channel, etc.) are left at defaults
    // since WebSDR IQ is already demodulated server-side for txt:// feeds.
    return [
      '-t',
      input,
      '-u',
      '127.0.0.1',
      '$udpPort',
      '-q',
    ];
  }

  /// Connect to [server] by spawning AIS-catcher.
  ///
  /// If a previous connection is active it is stopped first.
  /// [udpPort] can be overridden; 0 disables UDP and uses stdout only.
  Future<void> connect(WebSdrServer server, {int udpPort = _defaultUdpPort}) async {
    if (_state == WebSdrConnectionState.connecting) return;

    await disconnect();

    _server = server;
    _state = WebSdrConnectionState.connecting;
    _error = null;
    onStatus?.call('Connecting to ${server.name} (${server.host}:${server.port})...');

    final exe = _findExecutable();
    if (exe == null) {
      _state = WebSdrConnectionState.error;
      _error = 'AIS-catcher not found. Install from https://github.com/jvde-github/AIS-catcher/releases';
      onStatus?.call(_error!);
      return;
    }

    // Bind UDP socket before starting process so packets are not lost.
    if (udpPort != 0) {
      try {
        _udpSocket = await RawDatagramSocket.bind(
          InternetAddress.loopbackIPv4,
          udpPort,
          reuseAddress: true,
        );
        _udpSub = _udpSocket!.listen((event) {
          if (event == RawSocketEvent.read) {
            final dg = _udpSocket?.receive();
            if (dg == null) return;
            final text = utf8.decode(dg.data, allowMalformed: true).trim();
            if (text.isEmpty) return;
            // UDP may contain multiple lines
            for (final line in text.split('\n')) {
              final t = line.trim();
              if (t.isNotEmpty) _emitSentence(t);
            }
          }
        }, onError: (Object e) {
          // UDP errors are non-fatal; sentences may still arrive via stdout
        });
      } catch (e) {
        // Non-fatal: continue with stdout only
        _udpSocket = null;
        _udpSub = null;
      }
    }

    final args = _buildArgs(server, udpPort: udpPort);
    try {
      _process = await Process.start(exe, args);
      _state = WebSdrConnectionState.connected;
      onStatus?.call('AIS-catcher started (PID ${_process!.pid}) for ${server.name}');

      _stdoutSub = _process!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        final t = line.trim();
        if (t.startsWith('!AIVDM') || t.startsWith('!AIVDO') || t.startsWith(r'$')) {
          _emitSentence(t);
        }
      });

      _stderrSub = _process!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        final lower = line.toLowerCase();
        if (lower.contains('error') ||
            lower.contains('failed') ||
            lower.contains('fatal') ||
            lower.contains('cannot') ||
            lower.contains('unable')) {
          _error = line.trim();
          onStatus?.call(_error!);
        }
      });

      _process!.exitCode.then((code) {
        // If process exited unexpectedly while we thought we were connected
        if (_state == WebSdrConnectionState.connected ||
            _state == WebSdrConnectionState.connecting) {
          if (code != 0) {
            _state = WebSdrConnectionState.error;
            _error = 'AIS-catcher exited with code $code';
            onStatus?.call(_error!);
          } else {
            _state = WebSdrConnectionState.disconnected;
            onStatus?.call('AIS-catcher stopped.');
          }
          _cleanupProcess();
        }
      });
    } catch (e) {
      _state = WebSdrConnectionState.error;
      _error = 'Failed to start AIS-catcher: $e';
      onStatus?.call(_error!);
      await _cleanupProcess();
    }
  }

  void _emitSentence(String s) {
    if (!_sentences.isClosed) _sentences.add(s);
    onSentence?.call(s);
  }

  /// Stop the current AIS-catcher process and close UDP socket.
  Future<void> disconnect() async {
    if (_process == null && _state == WebSdrConnectionState.disconnected) {
      await _cleanupProcess();
      return;
    }
    final proc = _process;
    if (proc != null) {
      try {
        proc.kill(ProcessSignal.sigterm);
        await proc.exitCode.timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            proc.kill(ProcessSignal.sigkill);
            return -1;
          },
        );
      } catch (_) {
        try {
          proc.kill(ProcessSignal.sigkill);
        } catch (_) {}
      }
    }
    _state = WebSdrConnectionState.disconnected;
    _error = null;
    _server = null;
    onStatus?.call('Disconnected.');
    await _cleanupProcess();
  }

  /// Alias for [disconnect] that can be awaited to restart.
  Future<void> restart() async {
    final s = _server;
    if (s == null) return;
    await disconnect();
    await connect(s);
  }

  Future<void> _cleanupProcess() async {
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _udpSub?.cancel();
    _stdoutSub = null;
    _stderrSub = null;
    _udpSub = null;
    _udpSocket?.close();
    _udpSocket = null;
    _process = null;
  }

  /// Release resources. Call when the owner widget is disposed.
  Future<void> dispose() async {
    await disconnect();
    await _sentences.close();
  }
}
