import 'dart:math' as math;

import 'ais/src/encoder/ais_message_encoder.dart';

const double kKmPerDegLat = 111.0;

/// How many ticks between two type 5 (static & voyage) emissions per vessel.
const int kStaticEveryTicks = 5;

/// A few realistic ITU-R M.1371 ship types used to vary the fleet.
const List<(int, String)> kSimVesselTypes = [
  (70, 'Cargo'),
  (80, 'Tanker'),
  (30, 'Fishing'),
  (36, 'Sailing'),
  (60, 'Passenger'),
  (52, 'Tug'),
  (40, 'High speed craft'),
  (90, 'Other'),
];

/// Message types the fleet can emit, with their label shown in the UI.
const Map<int, String> kSimTypeLabels = {
  1: 'Position report (1/2/3)',
  5: 'Static & Voyage (5)',
  9: 'SAR aircraft (9)',
  18: 'Class B position (18)',
  19: 'Class B extended (19)',
  27: 'Long range (27)',
  4: 'Base station (4)',
  21: 'Aid to navigation (21)',
};

/// Broad role of a simulated emitter, used to pick an icon in the UI.
enum SimBoatKind { vessel, aircraft, baseStation, aton }

/// Maps an AIS message type to the role that emits it.
SimBoatKind simBoatKind(int emitType) => switch (emitType) {
      4 => SimBoatKind.baseStation,
      9 => SimBoatKind.aircraft,
      21 => SimBoatKind.aton,
      _ => SimBoatKind.vessel,
    };

double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
  final dLat = (lat2 - lat1) * kKmPerDegLat;
  final dLon = (lon2 - lon1) * kKmPerDegLat * math.cos(lat1 * math.pi / 180);
  return math.sqrt(dLat * dLat + dLon * dLon);
}

double _bearingDeg(double lat1, double lon1, double lat2, double lon2) {
  final dLon = (lon2 - lon1) * math.pi / 180;
  final l1 = lat1 * math.pi / 180;
  final l2 = lat2 * math.pi / 180;
  final y = math.sin(dLon) * math.cos(l2);
  final x = math.cos(l1) * math.sin(l2) -
      math.sin(l1) * math.cos(l2) * math.cos(dLon);
  return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
}

/// Configuration of the simulation, persisted in [AppSettings].
class SimFleetConfig {
  double centerLat;
  double centerLon;
  double radiusKm;
  int boatCount;
  double sogMin;
  double sogMax;
  int emitIntervalSec;
  int seed;

  /// The AIS message types the fleet emits (see [kSimTypeLabels]).
  Set<int> messageTypes;

  SimFleetConfig({
    this.centerLat = 48.85,
    this.centerLon = 2.35,
    this.radiusKm = 25,
    this.boatCount = 10,
    this.sogMin = 3,
    this.sogMax = 18,
    this.emitIntervalSec = 2,
    this.seed = 42,
    Set<int>? messageTypes,
  }) : messageTypes = messageTypes ?? {1, 5};

  SimFleetConfig copyWith({
    double? centerLat,
    double? centerLon,
    double? radiusKm,
    int? boatCount,
    double? sogMin,
    double? sogMax,
    int? emitIntervalSec,
    int? seed,
    Set<int>? messageTypes,
  }) =>
      SimFleetConfig(
        centerLat: centerLat ?? this.centerLat,
        centerLon: centerLon ?? this.centerLon,
        radiusKm: radiusKm ?? this.radiusKm,
        boatCount: boatCount ?? this.boatCount,
        sogMin: sogMin ?? this.sogMin,
        sogMax: sogMax ?? this.sogMax,
        emitIntervalSec: emitIntervalSec ?? this.emitIntervalSec,
        seed: seed ?? this.seed,
        messageTypes: messageTypes ?? Set.of(this.messageTypes),
      );

  Map<String, dynamic> toJson() => {
        'centerLat': centerLat,
        'centerLon': centerLon,
        'radiusKm': radiusKm,
        'boatCount': boatCount,
        'sogMin': sogMin,
        'sogMax': sogMax,
        'emitIntervalSec': emitIntervalSec,
        'seed': seed,
        'messageTypes': messageTypes.toList(),
      };

  factory SimFleetConfig.fromJson(Map<String, dynamic> json) =>
      SimFleetConfig(
        centerLat: (json['centerLat'] as num?)?.toDouble() ?? 48.85,
        centerLon: (json['centerLon'] as num?)?.toDouble() ?? 2.35,
        radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 25,
        boatCount: json['boatCount'] as int? ?? 10,
        sogMin: (json['sogMin'] as num?)?.toDouble() ?? 3,
        sogMax: (json['sogMax'] as num?)?.toDouble() ?? 18,
        emitIntervalSec: json['emitIntervalSec'] as int? ?? 2,
        seed: json['seed'] as int? ?? 42,
        messageTypes: ((json['messageTypes'] as List?) ?? [1, 5])
            .map((e) => e as int)
            .toSet(),
      );

  /// Types that produce a moving position report.
  static const Set<int> positionTypes = {1, 2, 3, 9, 18, 19, 27};

  List<int> get enabledPositionTypes =>
      positionTypes.where(messageTypes.contains).toList();
}

/// A single simulated vessel (or a fixed station like a base station / AtoN).
class SimBoat {
  final int index;
  int mmsi;
  String name;
  int vesselType;
  double lat;
  double lon;
  double sog;
  double cog;
  double heading;
  int altitude;
  int dimensionBow;
  int dimensionStern;
  int dimensionPort;
  int dimensionStarboard;
  double draught;
  String callSign;
  String destination;

  /// The AIS message type emitted each tick (one of the position types, or
  /// 4/21 for fixed stations).
  int emitType;

  /// Fixed stations stay in place.
  bool fixed;

  double _drift = 0;

  SimBoat({
    required this.index,
    required this.mmsi,
    required this.name,
    required this.vesselType,
    required this.lat,
    required this.lon,
    required this.sog,
    required this.cog,
    required this.heading,
    required this.emitType,
    this.altitude = 300,
    this.dimensionBow = 10,
    this.dimensionStern = 20,
    this.dimensionPort = 5,
    this.dimensionStarboard = 5,
    this.draught = 4,
    this.callSign = '',
    this.destination = '',
    this.fixed = false,
  });

  /// Advances the vessel along its course, applying a little heading drift and
  /// steering gently back toward the zone centre when it gets too far.
  void update({
    required double dt,
    required SimFleetConfig config,
    required math.Random random,
  }) {
    if (fixed) return;
    final dKm = sog * 1.852 * (dt / 3600);
    final rad = cog * math.pi / 180;
    final newLat = lat + math.cos(rad) * dKm / kKmPerDegLat;
    final lonDegKm = kKmPerDegLat * math.cos(lat * math.pi / 180);
    final newLon = lon + math.sin(rad) * dKm / (lonDegKm == 0 ? kKmPerDegLat : lonDegKm);

    _drift += (random.nextDouble() - 0.5) * 4;
    var newCog = (cog + _drift * 0.15) % 360;
    if (newCog < 0) newCog += 360;

    if (_distanceKm(newLat, newLon, config.centerLat, config.centerLon) >
        config.radiusKm) {
      newCog = _bearingDeg(newLat, newLon, config.centerLat, config.centerLon);
      _drift = 0;
    }

    lat = newLat;
    lon = newLon;
    cog = newCog;
    heading = newCog;
  }

  /// Builds the periodic report for this vessel, or null when the configured
  /// message types no longer include its emit type.
  String? positionSentence(SimFleetConfig config) {
    if (!config.messageTypes.contains(emitType)) return null;
    final now = DateTime.now();
    return switch (emitType) {
      1 || 2 || 3 => encodePositionReport(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
          heading: heading,
        ),
      18 => encodeClassBPosition(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
          heading: heading,
        ),
      19 => encodeClassBExtended(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
          heading: heading,
          name: name,
          vesselType: vesselType,
          dimensionBow: dimensionBow,
          dimensionStern: dimensionStern,
          dimensionPort: dimensionPort,
          dimensionStarboard: dimensionStarboard,
        ),
      27 => encodeLongRangeBroadcast(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
        ),
      9 => encodeSarAircraftPosition(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          cog: cog,
          altitude: altitude,
          sog: sog.round(),
        ),
      4 => encodeBaseStationReport(
          mmsi: mmsi,
          year: now.year,
          month: now.month,
          day: now.day,
          hour: now.hour,
          minute: now.minute,
          second: now.second,
          latitude: lat,
          longitude: lon,
        ),
      21 => encodeAidToNavigation(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          name: name,
        ),
      _ => null,
    };
  }

  String staticSentence() => encodeStaticAndVoyage(
        mmsi: mmsi,
        name: name,
        callSign: callSign,
        vesselType: vesselType,
        dimensionBow: dimensionBow,
        dimensionStern: dimensionStern,
        dimensionPort: dimensionPort,
        dimensionStarboard: dimensionStarboard,
        draught: draught,
        destination: destination,
      );
}

/// The simulated fleet: generated vessels plus a couple of fixed stations.
class SimFleet {
  final List<SimBoat> boats = [];

  void generate(SimFleetConfig config) {
    boats.clear();
    final random = math.Random(config.seed);
    final posTypes = config.enabledPositionTypes;

    for (var i = 0; i < config.boatCount; i++) {
      final vt = kSimVesselTypes[random.nextInt(kSimVesselTypes.length)];
      final (lat, lon) = _randomPoint(config, random);
      final sog =
          config.sogMin + random.nextDouble() * (config.sogMax - config.sogMin);
      final cog = random.nextDouble() * 360;
      boats.add(
        SimBoat(
          index: i,
          mmsi: 247000000 + i,
          name: 'SIM-${i + 1}',
          vesselType: vt.$1,
          lat: lat,
          lon: lon,
          sog: sog,
          cog: cog,
          heading: cog,
          emitType: posTypes.isEmpty ? 1 : posTypes[i % posTypes.length],
          callSign: 'SIM${(i + 1).toString().padLeft(3, '0')}',
          destination: 'SIM PORT',
        ),
      );
    }

    if (config.messageTypes.contains(4)) {
      boats.add(
        SimBoat(
          index: config.boatCount,
          mmsi: 247900000,
          name: 'SIM BASE',
          vesselType: 4,
          lat: config.centerLat,
          lon: config.centerLon,
          sog: 0,
          cog: 0,
          heading: 0,
          emitType: 4,
          fixed: true,
        ),
      );
    }
    if (config.messageTypes.contains(21)) {
      for (var i = 0; i < 3; i++) {
        final (lat, lon) = _randomPoint(config, random);
        boats.add(
          SimBoat(
            index: config.boatCount + 1 + i,
            mmsi: 247800000 + i,
            name: 'SIM ATON ${i + 1}',
            vesselType: 21,
            lat: lat,
            lon: lon,
            sog: 0,
            cog: 0,
            heading: 0,
            emitType: 21,
            fixed: true,
          ),
        );
      }
    }
  }

  /// Advances every vessel and returns the NMEA sentences to emit for this
  /// tick (position reports + periodic static data).
  List<String> advanceAndCollect(SimFleetConfig config, int tick) {
    final random = math.Random();
    final out = <String>[];
    for (final b in boats) {
      b.update(
        dt: config.emitIntervalSec.toDouble(),
        config: config,
        random: random,
      );
      final pos = b.positionSentence(config);
      if (pos != null) out.add(pos);
      if (config.messageTypes.contains(5) &&
          !b.fixed &&
          (tick + b.index) % kStaticEveryTicks == 0) {
        out.add(b.staticSentence());
      }
    }
    return out;
  }

  (double, double) _randomPoint(SimFleetConfig config, math.Random random) {
    final ang = random.nextDouble() * 2 * math.pi;
    final r = config.radiusKm * math.sqrt(random.nextDouble());
    final dLat = math.cos(ang) * r / kKmPerDegLat;
    final lonDegKm = kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
    final dLon = math.sin(ang) * r / lonDegKm;
    return (config.centerLat + dLat, config.centerLon + dLon);
  }
}
