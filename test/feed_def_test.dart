import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/feed_def.dart';

void main() {
  group('FeedDef json roundtrip', () {
    test('network feed', () {
      const feed = FeedDef(
        key: 'feed',
        displayName: 'My feed',
        host: 'example.com',
        port: 1234,
        header: '?WATCH',
      );
      final restored = FeedDef.fromJson(feed.toJson());
      expect(restored.type, FeedType.network);
      expect(restored.key, 'feed');
      expect(restored.host, 'example.com');
      expect(restored.port, 1234);
      expect(restored.header, '?WATCH');
    });

    test('file feed', () {
      final feed = FeedDef(
        key: 'log',
        displayName: 'Log',
        type: FeedType.file,
        path: r'C:\logs\export.txt',
        intervalMs: 250,
        loop: false,
      );
      final restored = FeedDef.fromJson(feed.toJson());
      expect(restored.type, FeedType.file);
      expect(restored.path, r'C:\logs\export.txt');
      expect(restored.intervalMs, 250);
      expect(restored.loop, false);
    });

    test('legacy json without type defaults to network', () {
      final restored = FeedDef.fromJson({
        'key': 'old',
        'displayName': 'Legacy',
        'host': 'host',
        'port': 1,
      });
      expect(restored.type, FeedType.network);
      expect(restored.host, 'host');
      expect(restored.port, 1);
    });

    test('file feed defaults', () {
      final restored = FeedDef.fromJson({
        'key': 'f',
        'displayName': 'F',
        'type': 'file',
      });
      expect(restored.type, FeedType.file);
      expect(restored.intervalMs, 1000);
      expect(restored.loop, isTrue);
    });
  });
}
