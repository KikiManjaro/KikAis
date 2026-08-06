import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/message_stats.dart';

void main() {
  test('recordReceived / recordDecoded track totals, feeds and types',
      () async {
    final stats = MessageStats();

    stats.recordReceived('US');
    stats.recordReceived('US');
    stats.recordReceived('NO');
    stats.recordDecoded(1, feed: 'US');
    stats.recordDecoded(1, feed: 'US');
    stats.recordDecoded(5, feed: 'NO');
    stats.recordDecoded(9);

    expect(stats.totalReceived, 3);
    expect(stats.totalDecoded, 4);
    expect(stats.byFeed, {'US': 2, 'NO': 1});
    expect(stats.byFeedDecoded, {'US': 2, 'NO': 1});
    expect(stats.byType[1], 2);
    expect(stats.byType[5], 1);
    expect(stats.byType[9], 1);
    expect(stats.byTypePerFeed['US']?[1], 2);
    expect(stats.byTypePerFeed['NO']?[5], 1);

    stats.dispose();
  });

  test('rateByFeed is computed by the sampler', () async {
    final stats = MessageStats();
    stats.recordReceived('US');
    stats.recordReceived('US');
    stats.recordReceived('NO');

    // The sampler runs every second; wait for it.
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    expect(stats.rateByFeed['US'], 2);
    expect(stats.rateByFeed['NO'], 1);

    stats.dispose();
  });

  test('decodedHistory is sampled with the decoded rate', () async {
    final stats = MessageStats();
    stats.recordDecoded(1, feed: 'US');
    stats.recordDecoded(1, feed: 'US');

    await Future<void>.delayed(const Duration(milliseconds: 1100));
    expect(stats.decodedHistory, isNotEmpty);
    expect(stats.decodedHistory.last, 2);

    stats.dispose();
  });

  test('reset clears everything', () async {
    final stats = MessageStats();
    stats.recordReceived('US');
    stats.recordDecoded(1, feed: 'US');
    stats.reset();
    expect(stats.totalReceived, 0);
    expect(stats.totalDecoded, 0);
    expect(stats.byFeed, isEmpty);
    expect(stats.byFeedDecoded, isEmpty);
    expect(stats.byType, isEmpty);
    expect(stats.byTypePerFeed, isEmpty);
    expect(stats.messagesPerSecond, 0);
    expect(stats.rateByFeed, isEmpty);
    expect(stats.rateHistory, isEmpty);
    expect(stats.decodedHistory, isEmpty);
    stats.dispose();
  });
}
