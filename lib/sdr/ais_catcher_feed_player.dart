import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../forwarder_service.dart';
import 'ais_catcher_process.dart';

/// Settings for an RTL-SDR feed backed by ais-catcher. The field names match
/// the existing [RtlSdrFeedConfig] so the UI can be rewired with minimal
/// changes.
class AisCatcherFeedConfig {
  final int deviceIndex;
  final int? gainDb;
  final bool autoGain;
  final int sampleRate;
  final bool useChannel1;
  final bool useChannel2;

  const AisCatcherFeedConfig({
    this.deviceIndex = 0,
    this.gainDb,
    this.autoGain = true,
    this.sampleRate = 1024000,
    this.useChannel1 = true,
    this.useChannel2 = true,
  });
}

/// Reads NMEA sentences produced by ais-catcher.exe and forwards them through
/// the forwarding / decoding pipeline, mirroring [RtlSdrFeedPlayer].
class AisCatcherFeedPlayer extends ChangeNotifier {
  final AisCatcherFeedConfig config;
  final int udpPort;

  bool isRunning = false;
  int emittedCount = 0;
  DateTime? lastEmitAt;
  String? error;

  Future<void> Function(String nmea)? onSentence;
  void Function(LogMessage message)? onStatus;

  AisCatcherProcess? _process;
  RawDatagramSocket? _udpSocket;

  AisCatcherFeedPlayer({
    required this.config,
    this.udpPort = 12345,
  });

  String get _gainText =>
      config.autoGain ? 'auto' : '${config.gainDb} dB';
  String get _channelsText => config.useChannel1 && config.useChannel2
      ? 'A + B'
      : (config.useChannel1 ? 'A' : 'B');

  void _status(LogMessage m) => onStatus?.call(m);

  /// Spawns ais-catcher and binds the UDP socket to receive NMEA sentences.
  Future<void> connect() async {
    error = null;
    _status(LogMessage(
      'rtlSdrOpening',
      {'device': '#${config.deviceIndex}'},
      'Starting AIS-catcher for RTL-SDR #${config.deviceIndex}...',
    ));

    try {
      // Bind UDP socket BEFORE starting ais-catcher so it can connect.
      _udpSocket = await RawDatagramSocket.bind(
        InternetAddress.loopbackIPv4,
        udpPort,
        reuseAddress: true,
      );

      _process = AisCatcherProcess(udpPort: udpPort);
      await _process!.start(
        deviceIndex: config.deviceIndex,
        autoGain: config.autoGain,
        gainDb: config.gainDb,
        sampleRate: config.sampleRate,
        useChannel1: config.useChannel1,
        useChannel2: config.useChannel2,
      );

      _status(LogMessage(
        'rtlSdrConnected',
        {
          'device': '#${config.deviceIndex}',
          'freq': '162.000 MHz',
          'rate': '${config.sampleRate / 1000000} MHz',
          'gain': _gainText,
          'channels': _channelsText,
        },
        'AIS-catcher connected (RTL-SDR #${config.deviceIndex}, '
            '162.000 MHz, $_channelsText channels, gain $_gainText).',
      ));

      isRunning = true;

      // Listen for UDP packets — each line is a complete NMEA sentence.
      _udpSocket!.listen(
        (event) {
          final datagram = _udpSocket!.receive();
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
              'rtlSdrError',
              {'device': '#${config.deviceIndex}', 'error': '$e'},
              'AIS-catcher RTL-SDR #${config.deviceIndex} error: $e',
            ));
            notifyListeners();
          }
        },
        onDone: () {
          if (isRunning) {
            error = 'UDP socket closed';
            isRunning = false;
            _status(LogMessage(
              'rtlSdrStreamClosed',
              {'device': '#${config.deviceIndex}'},
              'AIS-catcher UDP socket closed.',
            ));
            notifyListeners();
          }
        },
      );

      // Also listen for process-level errors forwarded through the sentence
      // stream (ais-catcher stderr messages).
      _process!.sentences.listen(
        (sentence) {
          // Regular sentence — already handled by UDP; ignore here.
        },
        onError: (Object e) {
          if (isRunning && e is StateError) {
            _status(LogMessage(
              'rtlSdrError',
              {'device': '#${config.deviceIndex}', 'error': '$e'},
              'AIS-catcher: $e',
            ));
          }
        },
      );
    } catch (e) {
      error = '$e';
      isRunning = false;
      _status(LogMessage(
        'rtlSdrError',
        {'device': '#${config.deviceIndex}', 'error': '$e'},
        'AIS-catcher RTL-SDR #${config.deviceIndex} error: $e',
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
        'rtlSdrDisconnected',
        {'device': '#${config.deviceIndex}'},
        'AIS-catcher RTL-SDR #${config.deviceIndex} disconnected.',
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
