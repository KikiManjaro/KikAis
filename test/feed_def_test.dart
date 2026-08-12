import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/feed_def.dart';

void main() {
  test('FeedDef round-trips a file feed with timestamp options', () {
    const def = FeedDef(
      key: 'rec',
      displayName: 'Recording',
      type: FeedType.file,
      path: '/tmp/rec.nmea',
      intervalMs: 500,
      loop: true,
      useTimestamps: true,
      speed: 5,
    );
    final restored = FeedDef.fromJson(def.toJson());
    expect(restored.type, FeedType.file);
    expect(restored.path, '/tmp/rec.nmea');
    expect(restored.intervalMs, 500);
    expect(restored.loop, isTrue);
    expect(restored.useTimestamps, isTrue);
    expect(restored.speed, 5);
  });

  test('FeedDef keeps safe defaults for legacy JSON', () {
    final restored = FeedDef.fromJson({'key': 'k', 'displayName': 'K'});
    expect(restored.useTimestamps, isFalse);
    expect(restored.speed, 1);
  });
}
