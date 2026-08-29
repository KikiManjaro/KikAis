import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'ais/ais_decoder.dart' show NmeaTagBlock;
import 'ais/src/nmea/nmea_format.dart' show msSinceUtcMidnight;
import 'forwarder_service.dart';

final RegExp _isoTimestamp = RegExp(
  r'^(\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2})(\.\d{1,3})?[, \t]+!',
);
final RegExp _clockTimestamp = RegExp(
  r'^\[(\d{2}):(\d{2}):(\d{2})(\.\d{1,3})?\]\s*!',
);

/// Extracts a timestamp from a line, in milliseconds since UTC midnight:
/// first the NMEA 4.0 tag-block `t:` value, then a leading ISO or `[HH:MM:SS]`
/// prefix. Returns null when the line carries no recognisable timestamp.
int? timestampMsOf(String line) {
  final (tag, _) = NmeaTagBlock.split(line);
  if (tag?.timeMs != null) return tag!.timeMs;
  final iso = _isoTimestamp.firstMatch(line);
  if (iso != null) {
    final raw = '${iso.group(1)}${iso.group(2) ?? ''}';
    final dt = DateTime.tryParse(raw);
    if (dt != null) return msSinceUtcMidnight(dt);
  }
  final clock = _clockTimestamp.firstMatch(line);
  if (clock != null) {
    final h = int.parse(clock.group(1)!);
    final m = int.parse(clock.group(2)!);
    final s = int.parse(clock.group(3)!);
    final fracRaw = clock.group(4) ?? '';
    final frac = fracRaw.isEmpty ? 0 : (double.parse(fracRaw) * 1000).round();
    return h * 3600000 + m * 60000 + s * 1000 + frac;
  }
  return null;
}

/// Replays a text file containing raw NMEA sentences (one per line, e.g. a
/// KikAis log export). By default frames are emitted at a fixed rate; when
/// [useTimestamps] is on, the recorded timestamps (NMEA 4.0 tag-block `t:` or
/// a leading timestamp prefix) drive the replay so the original cadence —
/// bursts included — is preserved.
class FileFeedPlayer extends ChangeNotifier {
  final String path;

  /// Delay between two emitted frames, in milliseconds (also the fallback
  /// for lines without a timestamp).
  int intervalMs;

  /// When the file reaches its end, restart from the first line.
  bool loop;

  /// Follow the file timestamps instead of a fixed rate.
  bool useTimestamps;

  /// Speed factor applied to the recorded deltas (1 = real time).
  int speed;

  bool isRunning = false;
  int emittedCount = 0;
  DateTime? lastEmitAt;
  String? error;

  Future<void> Function(String nmea)? onSentence;

  Timer? _timer;
  List<String> _lines = [];
  List<int> _deltasMs = [];
  int _index = 0;
  bool _loaded = false;
  bool _disposed = false;
  DateTime? _replayStartedAt;
  int _scheduledElapsedMs = 0;

  FileFeedPlayer({
    required this.path,
    this.intervalMs = 1000,
    this.loop = true,
    this.useTimestamps = false,
    this.speed = 1,
  });

  /// Number of non-empty lines loaded from the file.
  int get totalFrames => _lines.length;

  bool get isLoaded => _loaded;

  /// Per-line delays (ms) used after emitting each frame, exposed for tests.
  @visibleForTesting
  List<int> get deltasMs => _deltasMs;

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
      _deltasMs = _computeDeltas();
      _loaded = true;
    } catch (e) {
      error = '$e';
      _lines = [];
      _deltasMs = [];
    }
    notifyListeners();
  }

  /// Per-line delay applied after emitting that line. The last entry is the
  /// restart gap used when looping.
  List<int> _computeDeltas() {
    final n = _lines.length;
    if (n == 0) return const [];
    if (!useTimestamps) return List<int>.filled(n, intervalMs);

    final times = [for (final l in _lines) timestampMsOf(l)];
    final hasAny = times.any((t) => t != null);
    if (!hasAny) return List<int>.filled(n, intervalMs);

    final factor = math.max(1, speed);
    return List<int>.generate(n, (i) {
      if (i == n - 1) return intervalMs; // restart gap when looping
      final prev = times[i];
      final cur = times[i + 1];
      if (prev == null || cur == null) return intervalMs;
      final raw = (cur - prev).clamp(0, 30000);
      return (raw / factor).round().clamp(0, 30000);
    });
  }

  void start() {
    if (_disposed || isRunning || !_loaded || _lines.isEmpty) return;
    isRunning = true;
    _index = 0;
    _replayStartedAt = DateTime.now();
    _scheduledElapsedMs = 0;
    _scheduleNext(0);
    if (!_disposed) notifyListeners();
  }

  void stop() {
    if (!isRunning) return;
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    if (!_disposed) notifyListeners();
  }

  void _scheduleNext(int delayMs) {
    _timer?.cancel();
    _scheduledElapsedMs += delayMs;
    final startedAt = _replayStartedAt;
    final dueIn = startedAt == null
        ? delayMs
        : _scheduledElapsedMs -
              DateTime.now().difference(startedAt).inMilliseconds;
    _timer = Timer(Duration(milliseconds: math.max(0, dueIn)), () => _tick());
  }

  Future<void> _tick() async {
    if (_disposed || !isRunning) return;
    if (_index >= _lines.length) {
      if (!loop) {
        stop();
        return;
      }
      _index = 0;
    }
    final line = _lines[_index];
    final delay = _deltasMs.isEmpty ? intervalMs : _deltasMs[_index];
    _index++;
    emittedCount++;
    lastEmitAt = DateTime.now();
    if (!_disposed) notifyListeners();
    await onSentence?.call(line);
    if (!_disposed && isRunning) _scheduleNext(delay);
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
    _disposed = true;
    isRunning = false;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
