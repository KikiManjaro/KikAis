import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/src/messages/position/position_message.dart';
import 'package:kik_ais/ais/src/nmea/ais_decoder.dart';
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
      final d = _distanceKm(boat.lat, boat.lon, config.centerLat, config.centerLon);
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
    );
    final c2 = SimFleetConfig.fromJson(c.toJson());
    expect(c2.centerLat, 10);
    expect(c2.centerLon, 20);
    expect(c2.radiusKm, 5);
    expect(c2.boatCount, 3);
    expect(c2.seed, 99);
    expect(c2.messageTypes, {1, 18, 5});
  });

  test('simBoatKind maps message types to roles', () {
    expect(simBoatKind(1), SimBoatKind.vessel);
    expect(simBoatKind(2), SimBoatKind.vessel);
    expect(simBoatKind(18), SimBoatKind.vessel);
    expect(simBoatKind(27), SimBoatKind.vessel);
    expect(simBoatKind(9), SimBoatKind.aircraft);
    expect(simBoatKind(4), SimBoatKind.baseStation);
    expect(simBoatKind(21), SimBoatKind.aton);
  });

  test('fleet and boats json round-trips', () {
    final config = SimFleetConfig(messageTypes: {1, 5, 4, 21});
    final fleet = SimFleet();
    fleet.generate(config);

    final restored = SimFleet.fromJson(fleet.toJson());
    expect(restored.boats.length, fleet.boats.length);
    for (var i = 0; i < fleet.boats.length; i++) {
      final a = fleet.boats[i];
      final b = restored.boats[i];
      expect(b.index, a.index);
      expect(b.mmsi, a.mmsi);
      expect(b.name, a.name);
      expect(b.lat, a.lat);
      expect(b.lon, a.lon);
      expect(b.sog, a.sog);
      expect(b.cog, a.cog);
      expect(b.emitType, a.emitType);
      expect(b.fixed, a.fixed);
    }
  });

  test('restoreFrom deep-copies the saved fleet', () {
    final config = SimFleetConfig(seed: 5);
    final fleet = SimFleet();
    fleet.generate(config);
    final saved = fleet.boats.toList();

    final restored = SimFleet();
    restored.restoreFrom(saved);
    expect(restored.boats.length, saved.length);
    expect(restored.boats.first.lat, saved.first.lat);

    // Mutating the restored fleet must not affect the saved snapshot.
    restored.boats.first.lat += 10;
    expect(saved.first.lat, isNot(restored.boats.first.lat));
  });
}
