import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/sim_fleet.dart';

double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
  final dLat = (lat2 - lat1) * kKmPerDegLat;
  final dLon = (lon2 - lon1) * kKmPerDegLat * math.cos(lat1 * math.pi / 180);
  return math.sqrt(dLat * dLat + dLon * dLon);
}

void main() {
  test('generate creates the requested boats and fixed stations', () {
    final config = SimFleetConfig(
      centerLat: 48.85,
      centerLon: 2.35,
      radiusKm: 25,
      boatCount: 20,
      seed: 7,
      messageTypes: {1, 5, 4, 21},
    );
    final fleet = SimFleet();
    fleet.generate(config);

    // 20 vessels + 1 base station + 3 AtoN.
    expect(fleet.boats.length, 24);
    final vessels = fleet.boats.where((b) => !b.fixed).toList();
    expect(vessels.length, 20);

    for (final b in vessels) {
      final d = _distanceKm(b.lat, b.lon, config.centerLat, config.centerLon);
      expect(d, lessThanOrEqualTo(config.radiusKm + 0.001));
    }
    // MMSIs are unique.
    final mmsis = fleet.boats.map((b) => b.mmsi).toSet();
    expect(mmsis.length, fleet.boats.length);
  });

  test('update moves the boat and keeps it inside the zone', () {
    final config = SimFleetConfig(radiusKm: 25, sogMin: 10, sogMax: 10);
    final fleet = SimFleet();
    fleet.generate(config);
    final boat = fleet.boats.first;
    final random = math.Random();
    final startLat = boat.lat;
    final startLon = boat.lon;
    var moved = false;
    for (var i = 0; i < 2000; i++) {
      boat.update(
        dt: config.emitIntervalSec.toDouble(),
        config: config,
        random: random,
      );
      if ((boat.lat - startLat).abs() > 0.001 ||
          (boat.lon - startLon).abs() > 0.001) {
        moved = true;
      }
      final d = _distanceKm(
        boat.lat,
        boat.lon,
        config.centerLat,
        config.centerLon,
      );
      expect(d, lessThanOrEqualTo(config.radiusKm + 0.01));
    }
    expect(moved, isTrue);
  });

  test('advanceAndCollect emits decodable position reports', () {
    final config = SimFleetConfig(messageTypes: {1});
    final fleet = SimFleet();
    fleet.generate(config);

    final sentences = fleet.advanceAndCollect(config, 1);
    expect(sentences, hasLength(greaterThanOrEqualTo(10)));

    final decoder = AisNmeaDecoder();
    final decoded = sentences
        .map((s) => decoder.decode(s))
        .whereType<PositionMessage>()
        .toList();
    expect(decoded.length, greaterThanOrEqualTo(10));

    final first = fleet.boats.first;
    final p = decoded.first;
    expect(p.mmsi, first.mmsi);
    expect(p.latitude, closeTo(first.lat, 0.00001));
    expect(p.longitude, closeTo(first.lon, 0.00001));
  });

  test('static data is emitted periodically', () {
    final config = SimFleetConfig(messageTypes: {1, 5});
    final fleet = SimFleet();
    fleet.generate(config);
    final sentences = fleet.advanceAndCollect(config, 1);
    expect(sentences.any((s) => s.contains('!AIVDM')), isTrue);
  });

  test('config json round-trips', () {
    final c = SimFleetConfig(
      centerLat: 10,
      centerLon: 20,
      radiusKm: 5,
      boatCount: 3,
      seed: 99,
      messageTypes: {1, 18, 5},
      vesselTypes: {30, 36},
      realisticNames: true,
      anchoredPercent: 40,
      realisticDimensions: true,
      varySpeed: true,
      reportIntervalMax: 4,
      baseStationCount: 2,
      atonCount: 5,
      injectErrors: true,
      errorRate: 0.2,
      mmsiMid: 205,
      realisticMmsi: true,
      namePrefix: 'KIK',
      safetyTexts: const ['TEST WARNING'],
      destinations: const ['BREST'],
      zoneShape: SimZoneShape.rectangle,
      transitPercent: 30,
      autoRegenerate: true,
      regenEveryTicks: 50,
      wanderStrength: 2.0,
      speedByType: true,
      classBPercent: 80,
      accuratePosition: true,
      realisticRot: true,
      nmeaTalker: 'AB',
      nmea4Tags: true,
    );
    final c2 = SimFleetConfig.fromJson(c.toJson());
    expect(c2.centerLat, 10);
    expect(c2.centerLon, 20);
    expect(c2.radiusKm, 5);
    expect(c2.boatCount, 3);
    expect(c2.seed, 99);
    expect(c2.messageTypes, {1, 18, 5});
    expect(c2.vesselTypes, {30, 36});
    expect(c2.realisticNames, isTrue);
    expect(c2.anchoredPercent, 40);
    expect(c2.realisticDimensions, isTrue);
    expect(c2.varySpeed, isTrue);
    expect(c2.reportIntervalMax, 4);
    expect(c2.baseStationCount, 2);
    expect(c2.atonCount, 5);
    expect(c2.injectErrors, isTrue);
    expect(c2.errorRate, 0.2);
    expect(c2.mmsiMid, 205);
    expect(c2.realisticMmsi, isTrue);
    expect(c2.namePrefix, 'KIK');
    expect(c2.safetyTexts, ['TEST WARNING']);
    expect(c2.destinations, ['BREST']);
    expect(c2.zoneShape, SimZoneShape.rectangle);
    expect(c2.transitPercent, 30);
    expect(c2.autoRegenerate, isTrue);
    expect(c2.regenEveryTicks, 50);
    expect(c2.wanderStrength, 2.0);
    expect(c2.speedByType, isTrue);
    expect(c2.classBPercent, 80);
    expect(c2.accuratePosition, isTrue);
    expect(c2.realisticRot, isTrue);
    expect(c2.nmeaTalker, 'AB');
    expect(c2.nmea4Tags, isTrue);
  });

  test('simBoatKind maps message types to roles', () {
    expect(simBoatKind(1), SimBoatKind.vessel);
    expect(simBoatKind(2), SimBoatKind.vessel);
    expect(simBoatKind(18), SimBoatKind.vessel);
    expect(simBoatKind(27), SimBoatKind.vessel);
    expect(simBoatKind(9), SimBoatKind.aircraft);
    expect(simBoatKind(4), SimBoatKind.baseStation);
    expect(simBoatKind(11), SimBoatKind.baseStation);
    expect(simBoatKind(22), SimBoatKind.baseStation);
    expect(simBoatKind(23), SimBoatKind.baseStation);
    expect(simBoatKind(21), SimBoatKind.aton);
    expect(simBoatKind(12), SimBoatKind.safety);
    expect(simBoatKind(14), SimBoatKind.safety);
    expect(simBoatKind(8), SimBoatKind.weather);
  });

  test('safety messages emit decodable broadcasts and addressed texts', () {
    final config = SimFleetConfig(messageTypes: {12, 14});
    final fleet = SimFleet();
    fleet.generate(config);
    expect(fleet.boats.where((b) => b.emitType == 12).length, 1);
    expect(fleet.boats.where((b) => b.emitType == 14).length, 1);

    final decoder = AisNmeaDecoder();
    final sentences = fleet.advanceAndCollect(config, 1);
    final safety = sentences
        .map((s) => decoder.decode(s))
        .whereType<SafetyRelatedBroadcastMessage>()
        .toList();
    expect(safety, isNotEmpty);
    expect(kSimSafetyTexts, contains(safety.first.text));

    final addressed = sentences
        .map((s) => decoder.decode(s))
        .whereType<AddressedSafetyRelatedMessage>()
        .toList();
    expect(addressed, isNotEmpty);
    expect(addressed.first.destinationMmsi, 247900000);
    expect(kSimSafetyTexts, contains(addressed.first.text));
  });

  test('weather broadcast emits a decodable binary broadcast', () {
    final config = SimFleetConfig(messageTypes: {8});
    final fleet = SimFleet();
    fleet.generate(config);
    expect(fleet.boats.where((b) => b.emitType == 8).length, 1);

    final decoder = AisNmeaDecoder();
    final sentences = fleet.advanceAndCollect(config, 1);
    final weather = sentences
        .map((s) => decoder.decode(s))
        .whereType<BinaryBroadcastMessage>()
        .toList();
    expect(weather, isNotEmpty);
    expect(weather.first.dac, 1);
    expect(weather.first.fid, 11);
    expect(weather.first.data, isNotEmpty);
  });

  test('class B vessels emit static data report 24A and 24B', () {
    final config = SimFleetConfig(messageTypes: {18, 24});
    final fleet = SimFleet();
    fleet.generate(config);

    final decoder = AisNmeaDecoder();
    final all = <AISMessage>[];
    for (var tick = 1; tick <= 10; tick++) {
      all.addAll(
        fleet
            .advanceAndCollect(config, tick)
            .map((s) => decoder.decode(s))
            .whereType<AISMessage>(),
      );
    }
    expect(all.whereType<StaticDataReportA>().length, greaterThan(0));
    expect(all.whereType<StaticDataReportB>().length, greaterThan(0));
    final partA = all.whereType<StaticDataReportA>().first;
    final partB = all.whereType<StaticDataReportB>().first;
    expect(partA.vesselName.trim(), isNotEmpty);
    expect(partB.callSign.trim(), isNotEmpty);
  });

  test('base station emits network messages 11, 22 and 23 on a cadence', () {
    final config = SimFleetConfig(messageTypes: {4, 11, 22, 23});
    final fleet = SimFleet();
    fleet.generate(config);
    expect(fleet.boats.any((b) => b.fixed && b.emitType == 4), isTrue);

    final decoder = AisNmeaDecoder();
    final all = <AISMessage>[];
    for (var tick = 1; tick <= 60; tick++) {
      all.addAll(
        fleet
            .advanceAndCollect(config, tick)
            .map((s) => decoder.decode(s))
            .whereType<AISMessage>(),
      );
    }
    expect(all.whereType<UtcDateResponse>().isNotEmpty, isTrue);
    expect(all.whereType<ChannelManagementMessage>().isNotEmpty, isTrue);
    expect(all.whereType<GroupAssignmentCommand>().isNotEmpty, isTrue);
  });

  test('generate handles a very large fleet', () {
    final config = SimFleetConfig(boatCount: 10000, seed: 1);
    final fleet = SimFleet();
    fleet.generate(config);
    expect(fleet.boats.length, 10000);
    // MMSIs stay unique even at scale.
    expect(fleet.boats.map((b) => b.mmsi).toSet().length, 10000);
  });

  test('vesselTypes filters the fleet composition', () {
    final config = SimFleetConfig(vesselTypes: {30});
    final fleet = SimFleet();
    fleet.generate(config);
    final vessels = fleet.boats.where((b) => !b.fixed).toList();
    expect(vessels.length, config.boatCount);
    expect(vessels.every((b) => b.vesselType == 30), isTrue);
  });

  test(
    'realisticNames assigns plausible names, call signs and destinations',
    () {
      final config = SimFleetConfig(realisticNames: true);
      final fleet = SimFleet();
      fleet.generate(config);
      final vessels = fleet.boats.where((b) => !b.fixed).toList();
      for (final b in vessels) {
        expect(b.name, isNot(startsWith('SIM-')));
        expect(b.callSign, isNot(startsWith('SIM')));
        expect(b.destination, isNot('SIM PORT'));
      }
    },
  );

  test('anchored vessels stay still with an anchor/moored status', () {
    final config = SimFleetConfig(anchoredPercent: 100, sogMin: 10, sogMax: 10);
    final fleet = SimFleet();
    fleet.generate(config);
    final vessels = fleet.boats.where((b) => !b.fixed).toList();
    expect(vessels.every((b) => b.sog == 0), isTrue);
    expect(
      vessels.every((b) => b.navigationStatus == 1 || b.navigationStatus == 5),
      isTrue,
    );
    final first = vessels.first;
    final startLat = first.lat;
    final random = math.Random();
    for (var i = 0; i < 50; i++) {
      first.update(dt: 2, config: config, random: random);
    }
    expect(first.lat, startLat);
  });

  test('varySpeed drifts the speed over time within the configured range', () {
    final config = SimFleetConfig(varySpeed: true, sogMin: 5, sogMax: 15);
    final fleet = SimFleet();
    fleet.generate(config);
    final boat = fleet.boats.first;
    final start = boat.sog;
    final random = math.Random();
    var changed = false;
    for (var i = 0; i < 2000; i++) {
      boat.update(dt: 2, config: config, random: random);
      if ((boat.sog - start).abs() > 0.01) changed = true;
      expect(boat.sog, inInclusiveRange(config.sogMin, config.sogMax));
    }
    expect(changed, isTrue);
  });

  test(
    'reportIntervalMax staggers emissions and every vessel reports in 2 ticks',
    () {
      final config = SimFleetConfig(reportIntervalMax: 2, seed: 5);
      final fleet = SimFleet();
      fleet.generate(config);
      final vessels = fleet.boats.where((b) => !b.fixed).toList();

      final decoder = AisNmeaDecoder();
      final mmsis = <int>{};
      for (var tick = 1; tick <= 2; tick++) {
        for (final s in fleet.advanceAndCollect(config, tick)) {
          final m = decoder.decode(s);
          if (m != null) mmsis.add(m.mmsi);
        }
      }
      for (final b in vessels) {
        expect(mmsis, contains(b.mmsi));
      }

      final tick1 = fleet
          .advanceAndCollect(config, 1)
          .map((s) => decoder.decode(s))
          .whereType<PositionMessage>()
          .map((m) => m.mmsi)
          .toSet();
      expect(tick1.length, lessThan(vessels.length));
    },
  );

  test('station counts create the requested fixed stations', () {
    final config = SimFleetConfig(
      messageTypes: {4, 21},
      baseStationCount: 2,
      atonCount: 5,
    );
    final fleet = SimFleet();
    fleet.generate(config);
    expect(fleet.boats.where((b) => b.emitType == 4).length, 2);
    expect(fleet.boats.where((b) => b.emitType == 21).length, 5);
  });

  test('injectErrors corrupts checksums that the decoder flags', () {
    final config = SimFleetConfig(
      messageTypes: {1},
      injectErrors: true,
      errorRate: 1.0,
    );
    final fleet = SimFleet();
    fleet.generate(config);
    final sentences = fleet.advanceAndCollect(config, 1);
    final decoder = AisNmeaDecoder();
    for (final s in sentences) {
      decoder.decode(s);
    }
    expect(decoder.invalidChecksums, greaterThan(0));
  });

  test('mmsiMid customises every MMSI prefix', () {
    final config = SimFleetConfig(messageTypes: {1, 4}, mmsiMid: 205);
    final fleet = SimFleet();
    fleet.generate(config);
    final vessels = fleet.boats.where((b) => !b.fixed).toList();
    expect(
      vessels.every((b) => b.mmsi >= 205000000 && b.mmsi < 206000000),
      isTrue,
    );
    expect(
      fleet.boats.any((b) => b.emitType == 4 && b.mmsi == 205900000),
      isTrue,
    );
    expect(fleet.boats.map((b) => b.mmsi).toSet().length, fleet.boats.length);
  });

  test('invalid mmsiMid falls back to 247', () {
    final config = SimFleetConfig(mmsiMid: 5);
    final fleet = SimFleet();
    fleet.generate(config);
    final first = fleet.boats.first;
    expect(first.mmsi, 247000000);
  });

  test('realisticMmsi applies ITU structures per category', () {
    final config = SimFleetConfig(
      messageTypes: {1, 18, 4, 21, 9},
      mmsiMid: 205,
      realisticMmsi: true,
      classBPercent: 50,
    );
    final fleet = SimFleet();
    fleet.generate(config);
    final mmsis = fleet.boats.map((b) => b.mmsi).toSet();
    expect(mmsis.length, fleet.boats.length);

    expect(fleet.boats.where((b) => b.emitType == 4).first.mmsi, 2050000);
    expect(
      fleet.boats
          .where((b) => b.emitType == 21)
          .every((b) => b.mmsi >= 992050000 && b.mmsi < 992060000),
      isTrue,
    );
    expect(
      fleet.boats
          .where((b) => b.emitType == 18)
          .every((b) => b.mmsi >= 982050000 && b.mmsi < 982060000),
      isTrue,
    );
    expect(
      fleet.boats
          .where((b) => b.emitType == 9)
          .every((b) => b.mmsi >= 111205000 && b.mmsi < 111206000),
      isTrue,
    );
  });

  test('namePrefix customises placeholder names', () {
    final config = SimFleetConfig(namePrefix: 'KIK');
    final fleet = SimFleet();
    fleet.generate(config);
    expect(fleet.boats.first.name, 'KIK-1');
    expect(fleet.boats.last.name, 'KIK-${config.boatCount}');
  });

  test('custom safety texts are emitted', () {
    final config = SimFleetConfig(
      messageTypes: {14},
      safetyTexts: const ['MON TEXTE'],
    );
    final fleet = SimFleet();
    fleet.generate(config);
    final sentences = fleet.advanceAndCollect(config, 1);
    final decoder = AisNmeaDecoder();
    final safety = sentences
        .map((s) => decoder.decode(s))
        .whereType<SafetyRelatedBroadcastMessage>()
        .toList();
    expect(safety, isNotEmpty);
    expect(safety.every((m) => m.text == 'MON TEXTE'), isTrue);
  });

  test('rectangle zone keeps vessels inside', () {
    final config = SimFleetConfig(zoneShape: SimZoneShape.rectangle, seed: 3);
    final fleet = SimFleet();
    fleet.generate(config);
    final random = math.Random();
    for (var i = 0; i < 2000; i++) {
      for (final b in fleet.boats) {
        b.update(dt: 2, config: config, random: random);
      }
    }
    final latR = config.radiusKm / kKmPerDegLat;
    final lonDegKm = kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
    final lonR = config.radiusKm / lonDegKm;
    for (final b in fleet.boats) {
      expect((b.lat - config.centerLat).abs(), lessThanOrEqualTo(latR + 0.01));
      expect((b.lon - config.centerLon).abs(), lessThanOrEqualTo(lonR + 0.01));
    }
  });

  test('transit vessels exist and stay near the zone', () {
    final config = SimFleetConfig(transitPercent: 100, seed: 7);
    final fleet = SimFleet();
    fleet.generate(config);
    final vessels = fleet.boats.where((b) => !b.fixed).toList();
    expect(vessels.every((b) => b.transit), isTrue);
    final random = math.Random();
    for (var i = 0; i < 2000; i++) {
      for (final b in vessels) {
        b.update(dt: 2, config: config, random: random);
      }
    }
    for (final b in vessels) {
      final d = _distanceKm(b.lat, b.lon, config.centerLat, config.centerLon);
      expect(d, lessThanOrEqualTo(config.radiusKm + 0.01));
    }
  });

  test('speedByType clamps per-type speeds to the configured range', () {
    final config = SimFleetConfig(
      speedByType: true,
      sogMin: 20,
      sogMax: 20,
      seed: 9,
    );
    final fleet = SimFleet();
    fleet.generate(config);
    final vessels = fleet.boats.where((b) => !b.fixed).toList();
    expect(vessels.every((b) => b.sog == 20), isTrue);
  });

  test('classBPercent weights Class B position reports', () {
    final zero = SimFleetConfig(messageTypes: {1, 18}, classBPercent: 0);
    final all = SimFleetConfig(messageTypes: {1, 18}, classBPercent: 100);
    final f0 = SimFleet()..generate(zero);
    final f1 = SimFleet()..generate(all);
    expect(f0.boats.where((b) => b.emitType == 18), isEmpty);
    expect(f1.boats.where((b) => b.emitType == 1), isEmpty);
  });

  test('accuratePosition and realisticRot produce decodable reports', () {
    final config = SimFleetConfig(
      messageTypes: {1},
      accuratePosition: true,
      realisticRot: true,
    );
    final fleet = SimFleet();
    fleet.generate(config);
    final decoder = AisNmeaDecoder();
    final msgs = fleet
        .advanceAndCollect(config, 1)
        .map((s) => decoder.decode(s))
        .whereType<PositionMessage>()
        .toList();
    expect(msgs, isNotEmpty);
  });

  test('NMEA 4.0 talker and tag block are applied and stay decodable', () {
    final config = SimFleetConfig(
      messageTypes: {1},
      nmeaTalker: 'AB',
      nmea4Tags: true,
    );
    final fleet = SimFleet();
    fleet.generate(config);
    final sentences = fleet.advanceAndCollect(config, 1);
    expect(sentences, isNotEmpty);
    for (final s in sentences) {
      expect(s, startsWith('\\'));
      expect(s, contains('s:SIM'));
      expect(s, contains('!ABVDM'));
      expect(AisNmeaDecoder().decode(s), isA<PositionMessage>());
    }
  });
}
