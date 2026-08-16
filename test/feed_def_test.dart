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

  test('FeedDef round-trips an RTL-SDR feed', () {
    const def = FeedDef(
      key: 'sdr',
      displayName: 'My dongle',
      type: FeedType.rtlsdr,
      deviceIndex: 1,
      gainDb: 36,
      sampleRate: 2048000,
      useChannel1: true,
      useChannel2: false,
    );
    final restored = FeedDef.fromJson(def.toJson());
    expect(restored.type, FeedType.rtlsdr);
    expect(restored.deviceIndex, 1);
    expect(restored.gainDb, 36);
    expect(restored.sampleRate, 2048000);
    expect(restored.useChannel1, isTrue);
    expect(restored.useChannel2, isFalse);
  });

  test('FeedDef RTL-SDR defaults when fields are missing', () {
    final restored = FeedDef.fromJson({
      'key': 'sdr',
      'displayName': 'S',
      'type': 'rtlsdr',
    });
    expect(restored.deviceIndex, 0);
    expect(restored.gainDb, isNull);
    expect(restored.sampleRate, 1024000);
    expect(restored.useChannel1, isTrue);
    expect(restored.useChannel2, isTrue);
  });
}
