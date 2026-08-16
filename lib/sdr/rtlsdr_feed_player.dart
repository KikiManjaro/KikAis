import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'dsp/ais_demodulator.dart';
import 'rtlsdr_device.dart';
import '../forwarder_service.dart';

/// Settings for an RTL-SDR feed: which dongle, gain, sample rate and which of
/// the two VHF AIS channels to decode.
class RtlSdrFeedConfig {
  final int deviceIndex;
  final int? gainDb;
  final bool autoGain;
  final bool agc;
  final int sampleRate;
  final bool useChannel1;
  final bool useChannel2;
  final int chunkBytes;

  const RtlSdrFeedConfig({
    this.deviceIndex = 0,
    this.gainDb,
    this.autoGain = true,
    this.agc = true,
    this.sampleRate = 1024000,
    this.useChannel1 = true,
    this.useChannel2 = true,
    this.chunkBytes = 65536,
  });

  Map<String, Object?> toIsolateMap() => {
        'deviceIndex': deviceIndex,
        'gainDb': gainDb,
        'autoGain': autoGain,
        'agc': agc,
        'sampleRate': sampleRate,
        'useChannel1': useChannel1,
        'useChannel2': useChannel2,
        'chunkBytes': chunkBytes,
      };

  factory RtlSdrFeedConfig.fromIsolateMap(Map<Object?, Object?> m) =>
      RtlSdrFeedConfig(
        deviceIndex: m['deviceIndex'] as int? ?? 0,
        gainDb: m['gainDb'] as int?,
        autoGain: m['autoGain'] as bool? ?? true,
        agc: m['agc'] as bool? ?? true,
        sampleRate: m['sampleRate'] as int? ?? 1024000,
        useChannel1: m['useChannel1'] as bool? ?? true,
        useChannel2: m['useChannel2'] as bool? ?? true,
        chunkBytes: m['chunkBytes'] as int? ?? 65536,
      );
}

/// Produces NMEA AIVDM sentences from an RTL-SDR source. The real
/// implementation spawns a DSP isolate; tests inject a fake.
abstract class RtlSdrSentenceSource {
  Stream<String> get sentences;
  Future<void> start();
  Future<void> stop();
  void dispose();
}

/// Spawns the DSP isolate that owns the RTL-SDR dongle, demodulates the IQ
/// stream and reports decoded sentences back to the main isolate.
class _IsolateSentenceSource implements RtlSdrSentenceSource {
  final RtlSdrFeedConfig config;
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  final ReceivePort _reply = ReceivePort();
  SendPort? _control;
  bool _started = false;

  _IsolateSentenceSource(this.config) {
    _reply.listen(_onMessage);
  }

  @override
  Stream<String> get sentences => _controller.stream;

  void _onMessage(dynamic message) {
    if (message is SendPort) {
      _control = message;
    } else if (message is List && message.isNotEmpty && message[0] == 'error') {
      _controller.addError(StateError('${message[1]}'));
    } else if (message is String && message == 'done') {
      _controller.close();
    } else if (message is String && message != 'done') {
      _controller.add(message);
    }
  }

  @override
  Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await Isolate.spawn(_rtlSdrDspEntry, _reply.sendPort);
      // Wait for the isolate to send its control port.
      final deadline = DateTime.now().add(const Duration(seconds: 5));
      while (_control == null && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      if (_control == null) {
        _controller.addError(StateError('RTL-SDR worker failed to start'));
        return;
      }
      _control!.send(['start', config.toIsolateMap()]);
    } catch (e) {
      _controller.addError(e);
    }
  }

  @override
  Future<void> stop() async {
    if (_control != null) {
      _control!.send('stop');
    }
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }

  @override
  void dispose() {
    stop();
    _reply.close();
    _controller.close();
  }
}

/// The DSP isolate entry: opens the dongle, streams IQ through the AIS
/// demodulator and forwards the decoded sentences to [reply].
@pragma('vm:entry-point')
void _rtlSdrDspEntry(SendPort reply) {
  final command = ReceivePort();
  reply.send(command.sendPort);

  RtlSdrDevice? device;
  var running = false;

  Future<void> run(Map<Object?, Object?> raw) async {
    final config = RtlSdrFeedConfig.fromIsolateMap(raw);
    final dev = RtlsdrFfiDevice();
    device = dev;
    try {
      await dev.openAndConfigure(
        config.deviceIndex,
        sampleRate: config.sampleRate,
        gainDb: config.gainDb,
        autoGain: config.autoGain,
        agc: config.agc,
      );
    } catch (e) {
      reply.send(['error', '$e']);
      device = null;
      command.close();
      return;
    }
    running = true;
    final demod = AisDemodulator()
      ..useChannel1 = config.useChannel1
      ..useChannel2 = config.useChannel2;
    while (running) {
      final chunk = await dev.readChunk(config.chunkBytes);
      if (chunk == null) break; // device closed or read error
      if (chunk.isEmpty) continue; // USB hiccup / timeout: keep going
      for (final sentence in demod.process(chunk)) {
        reply.send(sentence);
      }
      // Yield so the 'stop' command is processed.
      await Future<void>.delayed(Duration.zero);
    }
    await dev.close();
    device = null;
    reply.send('done');
    command.close();
  }

  command.listen((message) {
    if (message is List &&
        message.isNotEmpty &&
        message[0] == 'start') {
      unawaited(run((message[1] as Map).cast<Object?, Object?>()));
    } else if (message == 'stop') {
      running = false;
      device?.close();
    }
  });
}

/// Reads raw NMEA sentences from an RTL-SDR dongle and forwards them through
/// the forwarding / decoding pipeline, mirroring [SerialFeedPlayer].
class RtlSdrFeedPlayer extends ChangeNotifier {
  final RtlSdrFeedConfig config;

  bool isRunning = false;
  int emittedCount = 0;
  DateTime? lastEmitAt;
  String? error;

  Future<void> Function(String nmea)? onSentence;

  /// Emits lifecycle status messages (opening, connected, error, stream
  /// closed, disconnected) so the reception log reports the dongle like the
  /// network feeds do.
  void Function(LogMessage message)? onStatus;

  final RtlSdrSentenceSource? _injectedSource;
  RtlSdrSentenceSource? _source;
  StreamSubscription<String>? _subscription;

  RtlSdrFeedPlayer({
    required this.config,
    RtlSdrSentenceSource? source,
  }) : _injectedSource = source;

  /// Human-friendly label of the configured dongle, falling back to a generic
  /// "#index" tag when no device is enumerated (tests, missing drivers). The
  /// log templates prefix "RTL-SDR", so the fallback must not repeat it.
  String get deviceLabel {
    final devices = listRtlSdrDevices();
    if (config.deviceIndex >= 0 && config.deviceIndex < devices.length) {
      return devices[config.deviceIndex].label;
    }
    return '#${config.deviceIndex}';
  }

  String get _gainText =>
      config.autoGain ? 'auto' : '${config.gainDb} dB';
  String get _channelsText => config.useChannel1 && config.useChannel2
      ? 'A + B'
      : (config.useChannel1 ? 'A' : 'B');

  void _status(LogMessage m) => onStatus?.call(m);

  /// Opens the dongle and starts streaming. On failure the [error] is set
  /// (surfaced as a red feed status) and nothing is emitted.
  Future<void> connect() async {
    error = null;
    _status(LogMessage(
      'rtlSdrOpening',
      {'device': deviceLabel},
      'Opening RTL-SDR dongle $deviceLabel...',
    ));
    try {
      final source = _source ??= (_injectedSource ??
          _IsolateSentenceSource(config));
      await source.start();
      _status(LogMessage(
        'rtlSdrConnected',
        {
          'device': deviceLabel,
          'freq': '162.000 MHz',
          'rate': '${(config.sampleRate / 1000000).toStringAsFixed(3)} MHz',
          'gain': _gainText,
          'channels': _channelsText,
        },
        'RTL-SDR $deviceLabel connected (162.000 MHz, '
            '${(config.sampleRate / 1000000).toStringAsFixed(3)} MHz sample '
            'rate, $_gainText gain, channels $_channelsText).',
      ));
      _subscription = source.sentences.listen(
        _onSentence,
        onError: (Object e) {
          if (isRunning) {
            error = '$e';
            isRunning = false;
            _status(LogMessage(
              'rtlSdrError',
              {'device': deviceLabel, 'error': '$e'},
              'RTL-SDR $deviceLabel error: $e',
            ));
            notifyListeners();
          }
        },
        onDone: () {
          if (isRunning) {
            error = 'RTL-SDR stream closed';
            isRunning = false;
            _status(LogMessage(
              'rtlSdrStreamClosed',
              {'device': deviceLabel},
              'RTL-SDR $deviceLabel stream closed.',
            ));
            notifyListeners();
          }
        },
      );
      isRunning = true;
    } catch (e) {
      error = '$e';
      isRunning = false;
      _status(LogMessage(
        'rtlSdrError',
        {'device': deviceLabel, 'error': '$e'},
        'RTL-SDR $deviceLabel error: $e',
      ));
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
        {'device': deviceLabel},
        'RTL-SDR $deviceLabel disconnected.',
      ));
    }
    isRunning = false;
    await _subscription?.cancel();
    _subscription = null;
    await _source?.stop();
    notifyListeners();
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
    _subscription?.cancel();
    _source?.dispose();
    super.dispose();
  }
}
