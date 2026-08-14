import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'sim_fleet.dart';

/// Drives the simulation: advances the fleet on a timer and pushes the
/// generated NMEA sentences through an [onSentence] callback (wired by the
/// page to the forwarding / decoding pipeline).
class SimulatorService extends ChangeNotifier {
  SimFleetConfig config;
  final SimFleet fleet = SimFleet();

  bool isRunning = false;
  int emittedCount = 0;

  /// When the last frame was emitted (null until the sim has run).
  DateTime? lastEmitAt;

  Future<void> Function(String nmea)? onSentence;

  Timer? _timer;
  int _tick = 0;

  /// True while a background fleet generation is in flight.
  bool generating = false;

  /// Below this fleet size, generation is done synchronously: building a few
  /// hundred vessels costs well under a frame, so an isolate round-trip would
  /// only add latency. Larger fleets are generated off the UI thread.
  static const int _syncGenerationThreshold = 1000;

  SimulatorService({SimFleetConfig? config}) : config = config ?? SimFleetConfig() {
    fleet.generate(this.config);
  }

  Future<void> setConfig(SimFleetConfig next) async {
    config = next;
    await _generateInBackground(next);
    if (isRunning) {
      _restartTimer();
    }
    notifyListeners();
  }

  Future<void> regenerate() async {
    await _generateInBackground(config);
    notifyListeners();
  }

  Future<void> _generateInBackground(SimFleetConfig next, {int? seed}) async {
    if (generating) return;
    if (next.boatCount <= _syncGenerationThreshold) {
      fleet.generate(next, seed: seed ?? next.seed);
      return;
    }
    generating = true;
    try {
      final boats = await compute(
        generateFleetIsolate,
        SimFleetGenerationArgs(next, seed ?? next.seed),
      );
      fleet.boats
        ..clear()
        ..addAll(boats);
    } finally {
      generating = false;
    }
  }

  void start() {
    if (isRunning) return;
    isRunning = true;
    _tick = 0;
    _timer = Timer.periodic(
      Duration(seconds: config.emitIntervalSec),
      (_) => _tickEmit(),
    );
    notifyListeners();
  }

  void stop() {
    if (!isRunning) return;
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  Future<void> _tickEmit() async {
    _tick++;
    if (config.autoRegenerate &&
        config.regenEveryTicks > 0 &&
        _tick % config.regenEveryTicks == 0) {
      fleet.generate(config, seed: math.Random().nextInt(100000));
    }
    final sentences = fleet.advanceAndCollect(config, _tick);
    for (final sentence in sentences) {
      emittedCount++;
      await onSentence?.call(sentence);
    }
    lastEmitAt = DateTime.now();
    notifyListeners();
  }

  void _restartTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: config.emitIntervalSec),
      (_) => _tickEmit(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
