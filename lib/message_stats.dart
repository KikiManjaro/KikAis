import 'dart:async';

import 'package:flutter/foundation.dart';

import 'perf_probe.dart';

/// Aggregates statistics about received and decoded AIS messages.
///
/// [recordReceived] / [recordDecoded] are cheap and do NOT notify listeners;
/// a 1-second sampler computes the message rate (global and per feed) and
/// triggers a single notification so UI rebuilds stay bounded.
class MessageStats extends ChangeNotifier {
  final Map<int, int> byType = {};
  final Map<String, int> byFeed = {};
  final Map<String, int> byFeedDecoded = {};
  final Map<String, Map<int, int>> byTypePerFeed = {};
  final Map<String, int> byChannel = {};
  int totalReceived = 0;
  int totalDecoded = 0;
  double messagesPerSecond = 0;
  Map<String, double> rateByFeed = {};
  Map<String, double> rateByChannel = {};

  /// Last samples of the global rate (for charts), oldest first.
  final List<double> rateHistory = [];

  /// Last samples of the decoded rate (decoded messages per second).
  final List<double> decodedHistory = [];

  int _lastCount = 0;
  int _lastDecodedCount = 0;
  Map<String, int> _lastByFeedCount = {};
  Map<String, int> _lastByChannelCount = {};
  Timer? _sampler;

  MessageStats() {
    _sampler = Timer.periodic(const Duration(seconds: 1), (_) => _sample());
  }

  void _sample() {
    messagesPerSecond = (totalReceived - _lastCount).toDouble();
    _lastCount = totalReceived;
    rateHistory.add(messagesPerSecond);
    if (rateHistory.length > 60) rateHistory.removeAt(0);

    decodedHistory.add((totalDecoded - _lastDecodedCount).toDouble());
    _lastDecodedCount = totalDecoded;
    if (decodedHistory.length > 60) decodedHistory.removeAt(0);

    final next = <String, double>{};
    for (final entry in byFeed.entries) {
      final previous = _lastByFeedCount[entry.key] ?? 0;
      next[entry.key] = (entry.value - previous).toDouble();
    }
    rateByFeed = next;
    _lastByFeedCount = Map.of(byFeed);

    final nextChannel = <String, double>{};
    for (final entry in byChannel.entries) {
      final previous = _lastByChannelCount[entry.key] ?? 0;
      nextChannel[entry.key] = (entry.value - previous).toDouble();
    }
    rateByChannel = nextChannel;
    _lastByChannelCount = Map.of(byChannel);

    final hCount = PerfProbe.handleDataCount;
    if (hCount > 0 || PerfProbe.chunkCount > 0) {
      final hAvg = hCount > 0 ? PerfProbe.handleDataTotalUs / hCount : 0;
      final fCount = PerfProbe.tcpFlushCount;
      final fAvg = fCount > 0 ? PerfProbe.tcpFlushTotalUs / fCount : 0;
      final isoAvg = PerfProbe.isolateRecv > 0
          ? PerfProbe.isolateTotalUs / PerfProbe.isolateRecv
          : 0;
      debugPrint(
        "[PERF] rate=${messagesPerSecond.toStringAsFixed(0)}/s handleData avg=${hAvg.toStringAsFixed(0)}us max=${PerfProbe.handleDataMaxUs}us n=$hCount tcpFlush avg=${fAvg.toStringAsFixed(0)}us max=${PerfProbe.tcpFlushMaxUs}us n=$fCount chunk n=${PerfProbe.chunkCount} bytes=${PerfProbe.chunkBytes} lines=${PerfProbe.chunkLines} backlog=${PerfProbe.backlogEvents} pending=${PerfProbe.pendingHandleData} isolate avg=${isoAvg.toStringAsFixed(0)}us max=${PerfProbe.isolateMaxUs}us sent=${PerfProbe.isolateSent} recv=${PerfProbe.isolateRecv} pending=${PerfProbe.isolatePending}",
      );
    }
    PerfProbe.resetSample();

    notifyListeners();
  }

  void recordReceived(String? feed, {String? channel}) {
    totalReceived++;
    if (feed != null) {
      byFeed[feed] = (byFeed[feed] ?? 0) + 1;
    }
    if (channel != null) {
      byChannel[channel] = (byChannel[channel] ?? 0) + 1;
    }
  }

  void recordDecoded(int type, {String? feed}) {
    totalDecoded++;
    byType[type] = (byType[type] ?? 0) + 1;
    if (feed != null) {
      byFeedDecoded[feed] = (byFeedDecoded[feed] ?? 0) + 1;
      byTypePerFeed.putIfAbsent(feed, () => {})[type] =
          (byTypePerFeed[feed]?[type] ?? 0) + 1;
    }
  }

  void reset() {
    byType.clear();
    byFeed.clear();
    byFeedDecoded.clear();
    byTypePerFeed.clear();
    byChannel.clear();
    rateByFeed = {};
    rateByChannel = {};
    rateHistory.clear();
    decodedHistory.clear();
    totalReceived = 0;
    totalDecoded = 0;
    messagesPerSecond = 0;
    _lastCount = 0;
    _lastDecodedCount = 0;
    _lastByFeedCount = {};
    _lastByChannelCount = {};
    notifyListeners();
  }

  @override
  void dispose() {
    _sampler?.cancel();
    super.dispose();
  }
}
