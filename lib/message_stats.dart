import 'dart:async';

import 'package:flutter/foundation.dart';

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
  int totalReceived = 0;
  int totalDecoded = 0;
  double messagesPerSecond = 0;
  Map<String, double> rateByFeed = {};

  /// Last samples of the global rate (for charts), oldest first.
  final List<double> rateHistory = [];

  /// Last samples of the decoded rate (decoded messages per second).
  final List<double> decodedHistory = [];

  int _lastCount = 0;
  int _lastDecodedCount = 0;
  Map<String, int> _lastByFeedCount = {};

  /// Snapshot of the counters at the last [notifyListeners]. When the app is
  /// idle (no feed activity) nothing changes between samples, so no
  /// notification is emitted. This avoids rebuilding the stats UI every second
  /// for no reason.
  int _lastNotifiedReceived = 0;
  int _lastNotifiedDecoded = 0;
  Map<String, int> _lastNotifiedByFeed = {};

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

    final changed = totalReceived != _lastNotifiedReceived ||
        totalDecoded != _lastNotifiedDecoded ||
        !_sameCounts(byFeed, _lastNotifiedByFeed);
    _lastNotifiedReceived = totalReceived;
    _lastNotifiedDecoded = totalDecoded;
    _lastNotifiedByFeed = Map.of(byFeed);
    if (!changed) return;
    notifyListeners();
  }

  static bool _sameCounts(Map<String, int> a, Map<String, int> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  void recordReceived(String? feed) {
    totalReceived++;
    if (feed != null) {
      byFeed[feed] = (byFeed[feed] ?? 0) + 1;
    }
  }

  void recordDecoded(int type, {String? feed}) {
    totalDecoded++;
    byType[type] = (byType[type] ?? 0) + 1;
    if (feed != null) {
      byFeedDecoded[feed] = (byFeedDecoded[feed] ?? 0) + 1;
      byTypePerFeed
          .putIfAbsent(feed, () => {})[type] = (byTypePerFeed[feed]?[type] ?? 0) + 1;
    }
  }

  void reset() {
    byType.clear();
    byFeed.clear();
    byFeedDecoded.clear();
    byTypePerFeed.clear();
    rateByFeed = {};
    rateHistory.clear();
    decodedHistory.clear();
    totalReceived = 0;
    totalDecoded = 0;
    messagesPerSecond = 0;
    _lastCount = 0;
    _lastDecodedCount = 0;
    _lastByFeedCount = {};
    _lastNotifiedReceived = 0;
    _lastNotifiedDecoded = 0;
    _lastNotifiedByFeed = {};
    notifyListeners();
  }

  @override
  void dispose() {
    _sampler?.cancel();
    super.dispose();
  }
}
