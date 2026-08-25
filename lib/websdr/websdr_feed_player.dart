import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../forwarder_service.dart';
import '../sdr/ais_catcher_process.dart';
import 'kiwi_iq_bridge.dart';
import 'websdr_audio_bridge.dart';
import 'websdr_server.dart';

/// Reads NMEA sentences produced by ais-catcher connected to a remote WebSDR
/// / KiwiSDR server and forwards them through the forwarding / decoding
/// pipeline, mirroring [AisCatcherFeedPlayer]. The subprocess, executable
/// discovery and lifecycle are all handled by [AisCatcherProcess]; this class
/// only binds the UDP socket and adapts WebSDR-specific status messages.
class WebsdrFeedPlayer extends ChangeNotifier {
  final String host;
  final int port;
  final WebSdrType type;
  final String displayName;
  final int udpPort;

  bool isRunning = false;
  int emittedCount = 0;
  DateTime? lastEmitAt;
  String? error;

  Future<void> Function(String nmea)? onSentence;
  void Function(LogMessage message)? onStatus;

  AisCatcherProcess? _process;
  RawDatagramSocket? _udpSocket;
  KiwiIqBridge? _kiwi;
  WebsdrAudioBridge? _audio;

  WebsdrFeedPlayer({
    required this.host,
    required this.port,
    this.type = WebSdrType.webSdr,
    this.displayName = 'WebSDR',
    this.udpPort = 10110,
  });

  /// The ais-catcher input source for this server: KiwiSDR servers expose an
  /// RTL-TCP stream, classic WebSDR servers a text (NMEA) stream.
  String get source => switch (type) {
        WebSdrType.kiwiSdr => 'rtltcp://$host:$port',
        _ => 'txt://$host:$port',
      };

  void _status(LogMessage m) => onStatus?.call(m);

  /// Spawns ais-catcher (RTL-TCP) or a Kiwi IQ bridge and binds the
  /// appropriate transport to receive NMEA sentences.
  Future<void> connect() async {
    error = null;

    // Plan A: Kiwi IQ native — Dart WebSocket → AisDemodulator.
    if (type == WebSdrType.kiwiSdr) {
      _status(LogMessage(
        'websdrOpening',
        {'server': displayName},
        'Opening KiwiSDR IQ bridge for $displayName ($host:$port) — 162 MHz…',
      ));
      try {
        final bridge = KiwiIqBridge();
        bridge.onSentence = _onSentence;
        bridge.onLog = (msg) => _status(LogMessage('websdrKiwiLog', {'msg': msg}, msg));
        bridge.onError = (e) {
          error = '$e';
          _status(LogMessage('websdrError', {'server': displayName, 'error': '$e'}, 'Kiwi $displayName error: $e'));
          notifyListeners();
        };
        _kiwi = bridge;
        await bridge.connect(host, port);
        isRunning = true;
        _status(LogMessage('websdrConnected', {'server': displayName}, 'Kiwi IQ bridge connected to $displayName — demodulating AIS…'));
        notifyListeners();
        return;
      } catch (e) {
        error = '$e';
        isRunning = false;
        _status(LogMessage('websdrError', {'server': displayName, 'error': '$e'}, 'Kiwi $displayName error: $e'));
        await _cleanup();
        notifyListeners();
        return;
      }
    }

    // WebSDR classic PA3FWM — audio a-law 12kHz → CU8 1.024M isolate (expérimental, opt-in via carte)
    if (type == WebSdrType.webSdr || type == WebSdrType.custom) {
      _status(LogMessage(
        'websdrOpening',
        {'server': displayName},
        'Opening WebSDR audio bridge for $displayName ($host:$port) — NFM 162 MHz (a-law)…',
      ));
      try {
        final bridge = WebsdrAudioBridge();
        bridge.onSentence = _onSentence;
        bridge.onLog = (msg) => _status(LogMessage('websdrLog', {'msg': msg}, msg));
        bridge.onError = (e) {
          error = '$e';
          _status(LogMessage('websdrError', {'server': displayName, 'error': '$e'}, 'WebSDR $displayName error: $e'));
          notifyListeners();
        };
        _audio = bridge;
        await bridge.connect(host, port);
        isRunning = true;
        _status(LogMessage('websdrConnected', {'server': displayName}, 'WebSDR audio bridge connected to $displayName — demodulating AIS…'));
        notifyListeners();
        return;
      } catch (e) {
        error = '$e';
        isRunning = false;
        _status(LogMessage('websdrError', {'server': displayName, 'error': '$e'}, 'WebSDR $displayName error: $e'));
        await _cleanup();
        notifyListeners();
        return;
      }
    }

    _status(LogMessage(
      'websdrOpening',
      {'server': displayName},
      'Starting AIS-catcher for WebSDR $displayName...',
    ));

    try {
      // Bind UDP socket BEFORE starting ais-catcher so it can connect.
      _udpSocket = await RawDatagramSocket.bind(
        InternetAddress.loopbackIPv4,
        udpPort,
        reuseAddress: true,
      );

      _process = AisCatcherProcess(udpPort: udpPort);
      await _process!.start(source: source);

      _status(LogMessage(
        'websdrConnected',
        {'server': displayName, 'host': host, 'port': '$port'},
        'AIS-catcher connected to WebSDR $displayName ($host:$port).',
      ));

      isRunning = true;

      // Each UDP datagram is a complete NMEA sentence.
      _udpSocket!.listen(
        (event) {
          final datagram = _udpSocket?.receive();
          if (datagram == null) return;
          final data = datagram.data;
          if (data.isEmpty) return;
          final line = String.fromCharCodes(data).trim();
          if (line.isEmpty) return;
          _onSentence(line);
        },
        onError: (Object e) {
          if (isRunning) {
            error = '$e';
            isRunning = false;
            _status(LogMessage(
              'websdrError',
              {'server': displayName, 'error': '$e'},
              'WebSDR $displayName error: $e',
            ));
            notifyListeners();
          }
        },
        onDone: () {
          if (isRunning) {
            error = 'UDP socket closed';
            isRunning = false;
            _status(LogMessage(
              'websdrStreamClosed',
              {'server': displayName},
              'WebSDR $displayName UDP socket closed.',
            ));
            notifyListeners();
          }
        },
      );
    } catch (e) {
      error = '$e';
      isRunning = false;
      _status(LogMessage(
        'websdrError',
        {'server': displayName, 'error': '$e'},
        'WebSDR $displayName error: $e',
      ));
      await _cleanup();
    }
    notifyListeners();
  }

  void _onSentence(String sentence) {
    emittedCount++;
    lastEmitAt = DateTime.now();
    notifyListeners();
    unawaited(onSentence?.call(sentence));
  }

  Future<void> disconnect() async {
    if (isRunning) {
      _status(LogMessage(
        'websdrDisconnected',
        {'server': displayName},
        'WebSDR $displayName disconnected.',
      ));
    }
    isRunning = false;
    await _cleanup();
    notifyListeners();
  }

  Future<void> _cleanup() async {
    _udpSocket?.close();
    _udpSocket = null;
    await _process?.stop();
    _process = null;
    try {
      await _kiwi?.disconnect();
    } catch (_) {}
    _kiwi = null;
    try {
      await _audio?.disconnect();
    } catch (_) {}
    _audio = null;
  }

  /// Status reported to the reception page, reusing the network feeds' dot
  /// semantics (green while receiving, red on errors).
  FeedStatus get status {
    if (error != null) {
      return const FeedStatus().copyWith(connected: false, error: error);
    }
    if (!isRunning) return const FeedStatus();
    return FeedStatus(
      connected: true,
      messageCount: emittedCount,
      lastMessageAt: lastEmitAt,
    );
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}
