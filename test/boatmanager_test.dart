import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/boat.dart';
import 'package:kik_ais/boatmanager.dart';

void main() {
  test('BoatManager decodes a type 1 position report via the decoder isolate',
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
  });

  test('decoded messages are recorded in the stats with their feed',
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

    manager.boats.single.lastUpdate =
        DateTime.now().subtract(const Duration(hours: 1));
    manager.purgeStaleBoats();
    expect(manager.boats, isEmpty);

    manager.updateFromMessage(message);
    manager.purgeStaleBoats();
    expect(manager.boats, hasLength(1));

    manager.dispose();
  });
}
