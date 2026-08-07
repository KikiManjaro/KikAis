import 'dart:async';

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

  SimulatorService({SimFleetConfig? config, List<SimBoat>? initialFleet})
      : config = config ?? SimFleetConfig() {
    if (initialFleet != null && initialFleet.isNotEmpty) {
      fleet.restoreFrom(initialFleet);
    } else {
      fleet.generate(this.config);
    }
  }

  void setConfig(SimFleetConfig next) {
    config = next;
    fleet.generate(next);
    if (isRunning) {
      _restartTimer();
    }
    notifyListeners();
  }

  void regenerate() {
    fleet.generate(config);
    notifyListeners();
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
