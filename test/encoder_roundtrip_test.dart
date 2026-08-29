import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/messages/binary/binary_addressed_message.dart';
import 'package:kik_ais/ais/src/messages/binary/binary_broadcast_message.dart';
import 'package:kik_ais/ais/src/messages/position/long_range_broadcast.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/ais/src/messages/position/sar_aircraft_position_report.dart';
import 'package:kik_ais/ais/src/messages/position/class_b_position.dart';
import 'package:kik_ais/ais/src/messages/position/extended_class_b.dart';
import 'package:kik_ais/ais/src/messages/safety/addressed_safety_related_message.dart';
import 'package:kik_ais/ais/src/messages/safety/safety_related_broadcast_message.dart';
import 'package:kik_ais/ais/src/messages/specialized/aid_to_navigation.dart';
import 'package:kik_ais/ais/src/messages/specialized/basestation_report.dart';
import 'package:kik_ais/ais/src/messages/static_data/static_voyage_data.dart';
import 'package:kik_ais/ais/src/nmea/ais_decoder.dart';

void main() {
  final decoder = AisNmeaDecoder();

  test('type 4 base station round-trips', () {
    final sentence = encodeBaseStationReport(
      mmsi: 226000000,
      year: 2026,
      month: 8,
      day: 6,
      hour: 12,
      minute: 30,
      second: 15,
      latitude: 47.5,
      longitude: -3.2,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<BaseStationReport>());
    final b = msg as BaseStationReport;
    expect(b.year, 2026);
    expect(b.month, 8);
    expect(b.day, 6);
    expect(b.hour, 12);
    expect(b.minute, 30);
    expect(b.latitude, closeTo(47.5, 0.00001));
    expect(b.longitude, closeTo(-3.2, 0.00001));
  });

  test('type 5 static and voyage round-trips', () {
    final sentence = encodeStaticAndVoyage(
      mmsi: 226545000,
      name: 'KIKAIS',
      callSign: 'FLO21',
      imoNumber: 1234567,
      vesselType: 70,
      dimensionBow: 10,
      dimensionStern: 20,
      dimensionPort: 5,
      dimensionStarboard: 5,
      destination: 'BREST',
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<StaticAndVoyageRelatedData>());
    final v = msg as StaticAndVoyageRelatedData;
    expect(v.vesselName.trim(), 'KIKAIS');
    expect(v.callSign.trim(), 'FLO21');
    expect(v.imoNumber, 1234567);
    expect(v.vesselTypeInt, 70);
    expect(v.dimensionBow, 10);
    expect(v.dimensionStern, 20);
    expect(v.destination.trim(), 'BREST');
  });

  test('type 6 binary addressed round-trips', () {
    final sentence = encodeBinaryAddressed(
      mmsi: 226545000,
      destinationMmsi: 227000000,
      dac: 200,
      fid: 50,
      data: [1, 2, 3, 255],
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<BinaryAddressedMessage>());
    final b = msg as BinaryAddressedMessage;
    expect(b.destinationMMSI, 227000000);
    expect(b.dac, 200);
    expect(b.fid, 50);
    expect(b.data.sublist(0, 4), [1, 2, 3, 255]);
  });

  test('type 8 binary broadcast round-trips', () {
    final sentence = encodeBinaryBroadcast(
      mmsi: 226545000,
      dac: 300,
      fid: 25,
      data: [9, 8, 7],
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<BinaryBroadcastMessage>());
    final b = msg as BinaryBroadcastMessage;
    expect(b.dac, 300);
    expect(b.fid, 25);
    expect(b.data.sublist(0, 3), [9, 8, 7]);
  });

  test('type 9 SAR aircraft round-trips', () {
    final sentence = encodeSarAircraftPosition(
      mmsi: 111234567,
      latitude: 48.5,
      longitude: -4.5,
      sog: 120,
      cog: 200.0,
      altitude: 500,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<SarAircraftPositionReport>());
    final s = msg as SarAircraftPositionReport;
    expect(s.latitude, closeTo(48.5, 0.00001));
    expect(s.longitude, closeTo(-4.5, 0.00001));
    expect(s.speedOverGround, 120);
    expect(s.courseOverGround, closeTo(200.0, 0.01));
    expect(s.altitude, 500);
  });

  test('type 12 addressed safety round-trips', () {
    final sentence = encodeAddressedSafety(
      mmsi: 226545000,
      destinationMmsi: 227000000,
      text: 'HELLO WORLD',
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<AddressedSafetyRelatedMessage>());
    final s = msg as AddressedSafetyRelatedMessage;
    expect(s.destinationMmsi, 227000000);
    expect(s.text.trim(), 'HELLO WORLD');
  });

  test('type 14 safety broadcast round-trips', () {
    final sentence = encodeSafetyBroadcast(mmsi: 226545000, text: 'WARNING');
    final msg = decoder.decode(sentence);
    expect(msg, isA<SafetyRelatedBroadcastMessage>());
    expect((msg as SafetyRelatedBroadcastMessage).text.trim(), 'WARNING');
  });

  test('type 18 class B position round-trips', () {
    final sentence = encodeClassBPosition(
      mmsi: 226545000,
      latitude: 45.5,
      longitude: -1.5,
      sog: 6.5,
      cog: 90.0,
      heading: 92.0,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<StandardClassBCSPositionReport>());
    final p = msg as StandardClassBCSPositionReport;
    expect(p.latitude, closeTo(45.5, 0.00001));
    expect(p.longitude, closeTo(-1.5, 0.00001));
    expect(p.speedOverGround, closeTo(6.5, 0.01));
    expect(p.courseOverGround, closeTo(90.0, 0.01));
    expect(p.heading, closeTo(92.0, 0.01));
  });

  test('type 19 class B extended round-trips', () {
    final sentence = encodeClassBExtended(
      mmsi: 226545000,
      latitude: 44.0,
      longitude: -2.0,
      sog: 3.0,
      cog: 180.0,
      heading: 185.0,
      name: 'CLASSB',
      vesselType: 52,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<ExtendedClassBCSPositionReport>());
    final p = msg as ExtendedClassBCSPositionReport;
    expect(p.vesselName.trim(), 'CLASSB');
    expect(p.latitude, closeTo(44.0, 0.00001));
    expect(p.vesselTypeInt, 52);
  });

  test('type 21 aid to navigation round-trips', () {
    final sentence = encodeAidToNavigation(
      mmsi: 992262000,
      name: 'BUOY1',
      aidType: 1,
      latitude: 46.5,
      longitude: -3.5,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<AidToNavigationReport>());
    final a = msg as AidToNavigationReport;
    expect(a.name?.trim(), 'BUOY1');
    expect(a.latitude, closeTo(46.5, 0.00001));
    expect(a.longitude, closeTo(-3.5, 0.00001));
  });

  test('type 27 long range round-trips', () {
    final sentence = encodeLongRangeBroadcast(
      mmsi: 226545000,
      latitude: 41.5,
      longitude: 8.5,
      sog: 3.4,
      cog: 12.3,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<LongRangeAISBroadcastMessage>());
    final l = msg as LongRangeAISBroadcastMessage;
    expect(l.latitude, closeTo(41.5, 0.01));
    expect(l.longitude, closeTo(8.5, 0.01));
    expect(l.speedOverGround, closeTo(3.4, 0.01));
    expect(l.courseOverGround, closeTo(12.3, 0.01));
  });

  test('type 1 carries a rate of turn', () {
    final sentence = encodePositionReport(
      mmsi: 247000001,
      latitude: 48.8,
      longitude: 2.3,
      sog: 12,
      cog: 90,
      heading: 95,
      rot: 127,
    );
    final msg = decoder.decode(sentence);
    expect(msg, isA<PositionMessage>());
    expect((msg as PositionMessage).rateOfTurn, greaterThan(0));
  });
}
