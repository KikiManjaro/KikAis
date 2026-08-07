import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'forwarder_service.dart';

/// Replays a text file containing raw NMEA sentences (one per line, e.g. a
/// KikAis log export) at a fixed rate, mimicking a live feed. Used by the
/// "file" feed source. Lines are pushed through an [onSentence] callback
/// (wired by the page to the forwarding / decoding pipeline).
class FileFeedPlayer extends ChangeNotifier {
  final String path;

  /// Delay between two emitted frames, in milliseconds.
  int intervalMs;

  /// When the file reaches its end, restart from the first line.
  bool loop;

  bool isRunning = false;
  int emittedCount = 0;
  DateTime? lastEmitAt;
  String? error;

  Future<void> Function(String nmea)? onSentence;

  Timer? _timer;
  List<String> _lines = [];
  int _index = 0;
  bool _loaded = false;

  FileFeedPlayer({
    required this.path,
    this.intervalMs = 1000,
    this.loop = true,
  });

  /// Number of non-empty lines loaded from the file.
  int get totalFrames => _lines.length;

  bool get isLoaded => _loaded;

  /// Reads the file and splits it into non-empty lines. On failure the
  /// [error] is set (surfaced as a red feed status) and nothing is emitted.
  Future<void> load() async {
    _loaded = false;
    error = null;
    try {
      final content = await File(path).readAsString();
      _lines = content
          .split(RegExp(r'\r?\n'))
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();
      _loaded = true;
    } catch (e) {
      error = '$e';
      _lines = [];
    }
    notifyListeners();
  }

  void start() {
    if (isRunning || !_loaded || _lines.isEmpty) return;
    isRunning = true;
    _index = 0;
    _timer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (_) => _tick(),
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

  Future<void> _tick() async {
    if (!isRunning) return;
    if (_index >= _lines.length) {
      if (loop) {
        _index = 0;
      } else {
        stop();
        return;
      }
    }
    final line = _lines[_index++];
    emittedCount++;
    lastEmitAt = DateTime.now();
    notifyListeners();
    await onSentence?.call(line);
  }

  /// Status reported to the reception page, reusing the network feeds' dot
  /// semantics (green while emitting, orange when idle, red on load errors).
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
    _timer?.cancel();
    super.dispose();
  }
}
