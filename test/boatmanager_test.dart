import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/boat.dart';
import 'package:kik_ais/boatmanager.dart';

String _bin(int value, int bits) => value.toRadixString(2).padLeft(bits, '0');

void main() {
  test('BoatManager decodes a type 1 position report via the decoder isolate',
      () async {
    final manager = BoatManager();
    await manager.startDecoder();

    final sb = StringBuffer();
    sb.write(_bin(1, 6)); // message type
    sb.write(_bin(0, 2)); // repeat indicator
    sb.write(_bin(226545000, 30)); // mmsi
    sb.write(_bin(0, 4)); // navigation status
    sb.write(_bin(0, 8)); // rate of turn
    sb.write(_bin(120, 10)); // SOG 12.0 kn
    sb.write(_bin(0, 1)); // position accuracy
    sb.write(_bin(630000, 28)); // longitude 1.05 E
    sb.write(_bin(29310000, 27)); // latitude 48.85 N
    sb.write(_bin(2500, 12)); // COG 250.0
    sb.write(_bin(90, 9)); // heading
    sb.write(_bin(30, 6)); // timestamp
    sb.write(_bin(0, 2)); // maneuver indicator
    sb.write(_bin(0, 3)); // spare
    sb.write(_bin(0, 1)); // raim
    final binary = sb.toString();
    expect(binary.length, 149);

    await manager.processMessage(binary);

    Boat? boat;
    for (var i = 0; i < 50 && boat == null; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      for (final b in manager.boats) {
        if (b.mmsi == '226545000') boat = b;
      }
    }

    final found = boat;
    expect(found, isNotNull);
    expect(found?.lat, closeTo(48.85, 0.000001));
    expect(found?.lon, closeTo(1.05, 0.000001));
    expect(found?.sog, closeTo(12.0, 0.0001));
    expect(found?.cog, closeTo(250.0, 0.0001));
    expect(found?.heading, closeTo(90.0, 0.0001));
    expect(found?.navigationStatus, isNotEmpty);

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
