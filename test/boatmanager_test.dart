import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/encoder/ais_payload_encoder.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/ais/src/nmea/nmea_sentence.dart';
import 'package:kik_ais/boat.dart';
import 'package:kik_ais/boatmanager.dart';

String _checksum(String body) {
  int xor = 0;
  for (final c in body.codeUnits) {
    xor ^= c;
  }
  return xor.toRadixString(16).padLeft(2, '0').toUpperCase();
}

String _fragment(String binary, int index, int total, int seq) {
  final payload = encodeBinaryToAis(binary);
  final fill = index == total - 1 ? (6 - (binary.length % 6)) % 6 : 0;
  final body = 'AIVDM,$total,${index + 1},$seq,B,$payload,$fill';
  return '!$body*${_checksum(body)}';
}

void main() {
  test(
    'BoatManager decodes a type 1 position report via the decoder isolate',
    () async {
      final manager = BoatManager();
      await manager.startDecoder();

      final sentence = encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      );

      await manager.processMessage(sentence);

      Boat? boat;
      for (var i = 0; i < 50 && boat == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        for (final b in manager.boats) {
          if (b.mmsi == '226545000') boat = b;
        }
      }

      expect(boat, isNotNull);
      expect(boat?.lat, closeTo(48.85, 0.000001));
      expect(boat?.lon, closeTo(1.05, 0.000001));
      expect(boat?.sog, closeTo(12.0, 0.0001));
      expect(boat?.cog, closeTo(250.0, 0.0001));
      expect(boat?.heading, closeTo(90.0, 0.0001));
      expect(boat?.navigationStatus, isNotEmpty);

      // Let any pending throttled notification timer fire before disposing.
      await Future<void>.delayed(const Duration(milliseconds: 250));
      manager.dispose();
    },
  );

  test('decoded messages are recorded in the stats with their feed', () async {
    final manager = BoatManager();
    await manager.startDecoder();

    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    await manager.processMessage(sentence, feed: 'US');

    for (var i = 0; i < 50; i++) {
      if (manager.stats.totalDecoded > 0) break;
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    expect(manager.stats.totalDecoded, greaterThanOrEqualTo(1));
    expect(manager.stats.byFeedDecoded['US'], greaterThanOrEqualTo(1));
    expect(manager.stats.byType[1], greaterThanOrEqualTo(1));

    // Let any pending throttled notification timer fire before disposing.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    manager.dispose();
  });

  test('purgeStaleBoats removes vessels not updated recently', () async {
    final manager = BoatManager();
    final message = PositionMessage(
      messageType: 1,
      mmsi: 123456,
      repeatIndicator: 0,
      navigationStatus: 'Under way using engine',
      latitude: 10.0,
      longitude: 20.0,
      speedOverGround: 5.0,
      courseOverGround: 90.0,
      maneuverIndicator: '',
      rateOfTurn: 0,
      heading: 90,
      timestamp: 30,
      raimEnabled: 0,
    );

    manager.updateFromMessage(message);
    expect(manager.boats, hasLength(1));

    manager.boats.single.lastUpdate = DateTime.now().subtract(
      const Duration(hours: 1),
    );
    manager.purgeStaleBoats();
    expect(manager.boats, isEmpty);

    manager.updateFromMessage(message);
    manager.purgeStaleBoats();
    expect(manager.boats, hasLength(1));

    manager.dispose();
  });

  test('updateFromMessage stores the raw frame in the boat log', () async {
    final manager = BoatManager();
    final message = PositionMessage(
      messageType: 1,
      mmsi: 123456,
      repeatIndicator: 0,
      navigationStatus: 'Under way using engine',
      latitude: 10.0,
      longitude: 20.0,
      speedOverGround: 5.0,
      courseOverGround: 90.0,
      maneuverIndicator: '',
      rateOfTurn: 0,
      heading: 90,
      timestamp: 30,
      raimEnabled: 0,
    );

    manager.updateFromMessage(
      message,
      feed: 'US',
      rawLines: ['!AIVDM,1,1,,B,15NpfN@P00GJq?bE`FepT@3n00Sa,0*6C'],
    );

    final boat = manager.boats.single;
    expect(boat.frameLog, hasLength(1));
    expect(
      boat.frameLog.single.raw,
      '!AIVDM,1,1,,B,15NpfN@P00GJq?bE`FepT@3n00Sa,0*6C',
    );
    expect(boat.frameLog.single.feed, 'US');
    expect(boat.frameLog.single.type, 1);

    manager.dispose();
  });

  test(
    'the decoder isolate sends the raw frame back to the boat log',
    () async {
      final manager = BoatManager();
      await manager.startDecoder();

      final sentence = encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      );
      await manager.processMessage(sentence, feed: 'US');

      Boat? boat;
      for (var i = 0; i < 50 && (boat?.frameLog.isEmpty ?? true); i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        for (final b in manager.boats) {
          if (b.mmsi == '226545000') boat = b;
        }
      }

      expect(boat, isNotNull);
      expect(boat?.frameLog, hasLength(1));
      expect(boat?.frameLog.single.raw, sentence);
      expect(boat?.frameLog.single.feed, 'US');

      await Future<void>.delayed(const Duration(milliseconds: 250));
      manager.dispose();
    },
  );

  test(
    'all fragments of a multi-part message are added to the boat log',
    () async {
      final manager = BoatManager();
      await manager.startDecoder();

      final full = NmeaSentence.tryParse(
        encodePositionReport(
          mmsi: 226545000,
          latitude: 48.85,
          longitude: 1.05,
          sog: 12.0,
          cog: 250.0,
          heading: 90.0,
        ),
      )!.binaryPayload;

      final part1 = _fragment(full.substring(0, 144), 0, 2, 3);
      final part2 = _fragment(full.substring(144), 1, 2, 3);

      await manager.processMessage(part1, feed: 'US');
      await manager.processMessage(part2, feed: 'US');

      Boat? boat;
      for (var i = 0; i < 50 && (boat?.frameLog.length ?? 0) < 2; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        for (final b in manager.boats) {
          if (b.mmsi == '226545000') boat = b;
        }
      }

      expect(boat, isNotNull);
      expect(boat?.frameLog, hasLength(2));
      expect(boat?.frameLog[0].raw, part1);
      expect(boat?.frameLog[1].raw, part2);
      expect(boat?.frameLog[0].feed, 'US');
      expect(boat?.frameLog[1].feed, 'US');

      await Future<void>.delayed(const Duration(milliseconds: 250));
      manager.dispose();
    },
  );

  test('boat frame log is capped at maxFrameLog entries', () async {
    final manager = BoatManager();
    final message = PositionMessage(
      messageType: 1,
      mmsi: 123456,
      repeatIndicator: 0,
      navigationStatus: 'Under way using engine',
      latitude: 10.0,
      longitude: 20.0,
      speedOverGround: 5.0,
      courseOverGround: 90.0,
      maneuverIndicator: '',
      rateOfTurn: 0,
      heading: 90,
      timestamp: 30,
      raimEnabled: 0,
    );

    for (var i = 0; i < Boat.maxFrameLog + 5; i++) {
      manager.updateFromMessage(message, rawLines: ['frame-$i']);
    }

    final boat = manager.boats.single;
    expect(boat.frameLog, hasLength(Boat.maxFrameLog));
    expect(boat.frameLog.first.raw, 'frame-5');
    expect(boat.frameLog.last.raw, 'frame-${Boat.maxFrameLog + 4}');

    manager.dispose();
  });

  test('clearBoats removes every tracked vessel', () async {
    final manager = BoatManager();
    final message = PositionMessage(
      messageType: 1,
      mmsi: 123456,
      repeatIndicator: 0,
      navigationStatus: 'Under way using engine',
      latitude: 10.0,
      longitude: 20.0,
      speedOverGround: 5.0,
      courseOverGround: 90.0,
      maneuverIndicator: '',
      rateOfTurn: 0,
      heading: 90,
      timestamp: 30,
      raimEnabled: 0,
    );
    manager.updateFromMessage(message);
    manager.updateFromMessage(
      PositionMessage(
        messageType: 1,
        mmsi: 654321,
        repeatIndicator: 0,
        navigationStatus: 'Under way using engine',
        latitude: 11.0,
        longitude: 21.0,
        speedOverGround: 4.0,
        courseOverGround: 180.0,
        maneuverIndicator: '',
        rateOfTurn: 0,
        heading: 180,
        timestamp: 30,
        raimEnabled: 0,
      ),
    );
    expect(manager.boats, hasLength(2));

    final versionBefore = manager.boatsVersion;
    manager.clearBoats();
    expect(manager.boats, isEmpty);
    expect(manager.boatsVersion, greaterThan(versionBefore));

    // New messages repopulate the map after a clear.
    manager.updateFromMessage(message);
    expect(manager.boats, hasLength(1));

    manager.dispose();
  });

  test('decoder isolate processes a 2000-frame burst without loss', () async {
    final manager = BoatManager();
    await manager.startDecoder();
    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final stopwatch = Stopwatch()..start();

    for (var i = 0; i < 2000; i++) {
      await manager.processMessage(sentence, feed: 'load');
    }
    for (var i = 0; i < 100 && manager.stats.totalDecoded < 2000; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    stopwatch.stop();

    expect(manager.stats.totalDecoded, 2000);
    expect(manager.stats.byFeedDecoded['load'], 2000);
    debugPrint('2000-frame isolate burst: ${stopwatch.elapsedMilliseconds}ms');
    manager.dispose();
  });
}
