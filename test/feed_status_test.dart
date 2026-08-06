import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/forwarder_ui.dart';

void main() {
  final now = DateTime(2026, 1, 1, 12, 0, 0);

  test('null status is grey', () {
    expect(feedDotColor(null, now), FeedDotColor.grey);
  });

  test('error is red', () {
    const s = FeedStatus(connected: true, error: 'boom');
    expect(feedDotColor(s, now), FeedDotColor.red);
  });

  test('connecting is orange', () {
    const s = FeedStatus(connecting: true);
    expect(feedDotColor(s, now), FeedDotColor.orange);
  });

  test('connected with a fresh frame is green', () {
    final s = FeedStatus(
      connected: true,
      lastMessageAt: now.subtract(const Duration(seconds: 2)),
    );
    expect(feedDotColor(s, now), FeedDotColor.green);
  });

  test('connected but never received a frame is orange', () {
    const s = FeedStatus(connected: true);
    expect(feedDotColor(s, now), FeedDotColor.orange);
  });

  test('connected with a stale frame is orange', () {
    final s = FeedStatus(
      connected: true,
      lastMessageAt: now.subtract(const Duration(seconds: 30)),
    );
    expect(feedDotColor(s, now), FeedDotColor.orange);
  });

  test('disconnected and not connecting is grey', () {
    const s = FeedStatus();
    expect(feedDotColor(s, now), FeedDotColor.grey);
  });
}
