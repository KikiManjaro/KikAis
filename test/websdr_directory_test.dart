import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/websdr/websdr_directory.dart';
import 'package:kik_ais/websdr/websdr_server.dart';

const _sampleJs = '''
// KiwiSDR.com receiver list for dyatlov map maker
// Automatically generated from http://kiwisdr.com/public/
var kiwisdr_com =
[
	{
		"id": "a1b2c3d4e5f6",
		"name": "Malin Head Kiwi",
		"url": "http://malinheadkiwi.hopto.org:8073",
		"gps": "(55.289837, -7.262482)",
		"bands": "0-30000000",
		"users": "2",
		"users_max": "8",
		"loc": "Malin, County Donegal, Ireland",
		"sw_version": "KiwiSDR_v1.902",
		"status": "active",
		"offline": "no",
	},
	{
		"id": "0fedcba98765",
		"name": "Some Proxy Kiwi",
		"url": "http://22033.proxy.kiwisdr.com",
		"gps": "(46.59, -114.02)",
		"bands": "0-30000000",
		"users": "0",
		"users_max": "4",
		"status": "active",
		"offline": "yes",
	},
];
''';

void main() {
  group('parseJsReceiverList', () {
    test('decodes entries despite trailing commas and comments', () {
      final entries = WebSdrDirectory.parseJsReceiverList(_sampleJs);
      expect(entries.length, 2);
      expect(entries.first['name'], 'Malin Head Kiwi');
    });

    test('returns empty on malformed body', () {
      expect(WebSdrDirectory.parseJsReceiverList('garbage'), isEmpty);
      expect(WebSdrDirectory.parseJsReceiverList('var x = [];'), isEmpty);
    });
  });

  group('serverFromJsEntry', () {
    test('maps url, gps, users and status', () {
      final e = WebSdrDirectory.parseJsReceiverList(_sampleJs).first;
      final s = WebSdrDirectory.serverFromJsEntry(e, WebSdrType.kiwiSdr)!;
      expect(s.host, 'malinheadkiwi.hopto.org');
      expect(s.port, 8073);
      expect(s.lat, closeTo(55.2898, 0.001));
      expect(s.lon, closeTo(-7.2624, 0.001));
      expect(s.users, 2);
      expect(s.maxUsers, 8);
      expect(s.online, isTrue);
      expect(s.country, 'Malin, County Donegal, Ireland');
    });

    test('defaults port to 8073 when url has none and flags offline', () {
      final e = WebSdrDirectory.parseJsReceiverList(_sampleJs).last;
      final s = WebSdrDirectory.serverFromJsEntry(e, WebSdrType.kiwiSdr)!;
      expect(s.port, 8073);
      expect(s.online, isFalse);
      // Explicit remote id wins over the host:port fallback.
      expect(s.id, '0fedcba98765');
    });

    test('falls back to host:port id when entry has none', () {
      final s = WebSdrDirectory.serverFromJsEntry(
        const {'url': 'http://22033.proxy.kiwisdr.com'},
        WebSdrType.kiwiSdr,
      )!;
      expect(s.id, '22033.proxy.kiwisdr.com:8073');
    });

    test('returns null when url unusable', () {
      expect(
        WebSdrDirectory.serverFromJsEntry(
          const {'url': 'not a url'},
          WebSdrType.kiwiSdr,
        ),
        isNull,
      );
    });
  });

  group('coversAis', () {
    WebSdrServer serverWithBands(List<String> bands) => WebSdrServer(
          id: 'x',
          name: 'x',
          host: 'x',
          port: 8073,
          bands: bands,
        );

    test('HF-only range does not cover AIS', () {
      expect(serverWithBands(['0-30000000']).coversAis, isFalse);
    });

    test('VHF airband range does not cover AIS', () {
      expect(serverWithBands(['118000000-137000000']).coversAis, isFalse);
    });

    test('range overlapping marine band covers AIS', () {
      expect(serverWithBands(['150000000-165000000']).coversAis, isTrue);
      expect(serverWithBands(['156000000-163000000']).coversAis, isTrue);
    });

    test('curated textual band covers AIS', () {
      expect(serverWithBands(['AIS', 'VHF']).coversAis, isTrue);
    });
  });
}
