import 'dart:math' as math;

import 'ais/src/encoder/ais_message_encoder.dart';
import 'ais/src/nmea/nmea_format.dart' show buildTagBlock, msSinceUtcMidnight, wrapNmea4;

const double kKmPerDegLat = 111.0;

/// How many ticks between two type 5 (static & voyage) emissions per vessel.
const int kStaticEveryTicks = 5;

/// NMEA 4.0 AIS talker IDs selectable for transmission.
const List<String> kSimTalkers = [
  'AI',
  'AB',
  'AD',
  'AN',
  'AR',
  'AS',
  'AT',
  'AX',
  'BS',
  'SA',
];

/// A few realistic ITU-R M.1371 ship types used to vary the fleet.
const List<(int, String)> kSimVesselTypes = [  (70, 'Cargo'),
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
  8: 'Weather broadcast (8)',
  11: 'UTC/date response (11)',
  12: 'Safety addressed (12)',
  14: 'Safety broadcast (14)',
  22: 'Channel management (22)',
  23: 'Group assignment (23)',
  24: 'Class B static (24)',
};

/// Realistic safety texts cycled by the safety broadcast / addressed boats.
const List<String> kSimSafetyTexts = [
  'MAN OVERBOARD',
  'FIRE ON BOARD',
  'CONTAINERS ADRIFT REPORTED',
  'ENGINE FAILURE NEED ASSISTANCE',
  'NAVIGATION OBSTRUCTION REPORTED',
  'TAKING WATER PROCEEDING TO HARBOR',
  'VESSEL DRIFTING NEAR SHIPPING LANE',
  'MEDICAL EMERGENCY ON BOARD',
  'GROUNDING IN PROGRESS',
  'MAIN ENGINE RESTARTED RESUMING PASSAGE',
];

/// Realistic vessel names per ITU-R M.1371 ship type, used when
/// [SimFleetConfig.realisticNames] is enabled.
const Map<int, List<String>> kSimNamesByType = {
  70: ['NORDKAP', 'ELBE STAR', 'ATLANTIC MERCHANT', 'MSC ATHENA', 'SEABRIDGE', 'BALTIC TRADER', 'NORTHERN LIGHT'],
  80: ['BRITISH MERIDIAN', 'EVER TOP', 'ALINE III', 'MAERSK TITAN', 'GUARDIAN ANGEL', 'PACIFIC VOYAGER'],
  30: ['SAINT PIERRE', 'LA FLEUR DE LYS', 'PETIT BATEAU', 'LE STELLA', 'ARMORIQUE II', 'ROZ PENS'],
  36: ["VENT D'EST", 'BLUE DOLPHIN', 'SV WINDROSE', 'OCEAN PEARL', 'LA MOUETTE'],
  60: ['VIKING SKY', 'NORMANDIE EXPRESS', 'CORSAIRE DE BRETAGNE', 'PONT AVEN', 'ARMORIQUE'],
  52: ['ABEILLE LIBERTE', 'SD VANGUARD', 'CAP AUSTRAL', 'MORGLAS', 'VOS PRIDE'],
  40: ['TURBOJET', 'FAST FERRY III', 'CATLANTIC', 'NGV ATHOS'],
  90: ['SEA EXPLORER', 'OCEAN SCOUT', 'MERIDIEN', 'GRAND LARGE'],
};

/// Realistic destinations cycled when [SimFleetConfig.realisticNames] is on.
const List<String> kSimDestinations = [
  'ROTTERDAM', 'LE HAVRE', 'BREST', 'VALENCIA', 'HAMBURG', 'GENOA',
  'FOS SUR MER', 'ANTWERPEN', 'DOVER', 'SHANGHAI', 'LISBOA', 'PORTSMOUTH',
];

/// Country prefixes used to build plausible call signs.
const List<String> _kSimCallSignPrefixes = [
  'F', '9H', 'PB', 'SP', 'CQ', 'V2', '3V', 'T2', 'LA', 'DK',
];

String _callSignForIndex(int index) {
  final prefix = _kSimCallSignPrefixes[index % _kSimCallSignPrefixes.length];
  return '$prefix${(index % 90) + 100}';
}

/// Shape of the simulated navigation zone around the center.
enum SimZoneShape { circle, rectangle }

/// Maritime Identification Digits (MID) per country for the searchable MMSI
/// selector. Several countries have more than one allocated MID.
const Map<int, String> kSimMids = {
  201: 'Albania',
  605: 'Algeria',
  603: 'Angola',
  304: 'Antigua & Barbuda',
  305: 'Antigua & Barbuda',
  701: 'Argentina',
  503: 'Australia',
  203: 'Austria',
  423: 'Azerbaijan',
  308: 'Bahamas',
  309: 'Bahamas',
  311: 'Bahamas',
  408: 'Bahrain',
  405: 'Bangladesh',
  303: 'Barbados',
  314: 'Barbados',
  206: 'Belarus',
  205: 'Belgium',
  312: 'Belize',
  720: 'Bolivia',
  710: 'Brazil',
  508: 'Brunei',
  207: 'Bulgaria',
  514: 'Cambodia',
  515: 'Cambodia',
  613: 'Cameroon',
  316: 'Canada',
  617: 'Cape Verde',
  319: 'Cayman Islands',
  725: 'Chile',
  412: 'China',
  413: 'China',
  414: 'China',
  730: 'Colombia',
  616: 'Comoros',
  620: 'Comoros',
  615: 'Congo',
  518: 'Cook Islands',
  321: 'Costa Rica',
  238: 'Croatia',
  323: 'Cuba',
  306: 'Curaçao',
  209: 'Cyprus',
  210: 'Cyprus',
  212: 'Cyprus',
  270: 'Czech Republic',
  219: 'Denmark',
  220: 'Denmark',
  621: 'Djibouti',
  325: 'Dominica',
  327: 'Dominican Republic',
  735: 'Ecuador',
  622: 'Egypt',
  359: 'El Salvador',
  631: 'Equatorial Guinea',
  625: 'Eritrea',
  276: 'Estonia',
  624: 'Ethiopia',
  231: 'Faroe Islands',
  520: 'Fiji',
  230: 'Finland',
  226: 'France',
  227: 'France',
  228: 'France',
  626: 'Gabon',
  629: 'Gambia',
  213: 'Georgia',
  211: 'Germany',
  218: 'Germany',
  627: 'Ghana',
  236: 'Gibraltar',
  237: 'Greece',
  239: 'Greece',
  240: 'Greece',
  241: 'Greece',
  331: 'Greenland',
  330: 'Grenada',
  332: 'Guatemala',
  632: 'Guinea',
  630: 'Guinea-Bissau',
  750: 'Guyana',
  336: 'Haiti',
  334: 'Honduras',
  477: 'Hong Kong',
  243: 'Hungary',
  251: 'Iceland',
  419: 'India',
  525: 'Indonesia',
  422: 'Iran',
  425: 'Iraq',
  250: 'Ireland',
  428: 'Israel',
  247: 'Italy',
  619: 'Ivory Coast',
  339: 'Jamaica',
  431: 'Japan',
  432: 'Japan',
  438: 'Jordan',
  436: 'Kazakhstan',
  634: 'Kenya',
  529: 'Kiribati',
  447: 'Kuwait',
  275: 'Latvia',
  450: 'Lebanon',
  636: 'Liberia',
  642: 'Libya',
  277: 'Lithuania',
  253: 'Luxembourg',
  647: 'Madagascar',
  533: 'Malaysia',
  455: 'Maldives',
  215: 'Malta',
  229: 'Malta',
  248: 'Malta',
  249: 'Malta',
  538: 'Marshall Islands',
  654: 'Mauritania',
  645: 'Mauritius',
  345: 'Mexico',
  214: 'Moldova',
  254: 'Monaco',
  457: 'Mongolia',
  262: 'Montenegro',
  242: 'Morocco',
  650: 'Mozambique',
  506: 'Myanmar',
  659: 'Namibia',
  544: 'Nauru',
  244: 'Netherlands',
  245: 'Netherlands',
  246: 'Netherlands',
  540: 'New Caledonia',
  512: 'New Zealand',
  350: 'Nicaragua',
  657: 'Nigeria',
  257: 'Norway',
  258: 'Norway',
  259: 'Norway',
  461: 'Oman',
  463: 'Pakistan',
  511: 'Palau',
  443: 'Palestine',
  351: 'Panama',
  352: 'Panama',
  353: 'Panama',
  354: 'Panama',
  355: 'Panama',
  356: 'Panama',
  357: 'Panama',
  370: 'Panama',
  371: 'Panama',
  372: 'Panama',
  373: 'Panama',
  374: 'Panama',
  553: 'Papua New Guinea',
  755: 'Paraguay',
  760: 'Peru',
  548: 'Philippines',
  261: 'Poland',
  263: 'Portugal',
  466: 'Qatar',
  264: 'Romania',
  273: 'Russia',
  661: 'Rwanda',
  341: 'Saint Kitts & Nevis',
  343: 'Saint Lucia',
  375: 'Saint Vincent',
  376: 'Saint Vincent',
  377: 'Saint Vincent',
  561: 'Samoa',
  668: 'São Tomé & Príncipe',
  403: 'Saudi Arabia',
  663: 'Senegal',
  279: 'Serbia',
  664: 'Seychelles',
  667: 'Sierra Leone',
  563: 'Singapore',
  564: 'Singapore',
  565: 'Singapore',
  566: 'Singapore',
  267: 'Slovakia',
  278: 'Slovenia',
  557: 'Solomon Islands',
  637: 'Somalia',
  601: 'South Africa',
  440: 'South Korea',
  441: 'South Korea',
  224: 'Spain',
  225: 'Spain',
  417: 'Sri Lanka',
  662: 'Sudan',
  765: 'Suriname',
  265: 'Sweden',
  266: 'Sweden',
  269: 'Switzerland',
  437: 'Syria',
  416: 'Taiwan',
  674: 'Tanzania',
  567: 'Thailand',
  671: 'Togo',
  570: 'Tonga',
  362: 'Trinidad & Tobago',
  672: 'Tunisia',
  271: 'Turkey',
  434: 'Turkmenistan',
  572: 'Tuvalu',
  470: 'United Arab Emirates',
  471: 'United Arab Emirates',
  472: 'United Arab Emirates',
  272: 'Ukraine',
  232: 'United Kingdom',
  233: 'United Kingdom',
  234: 'United Kingdom',
  235: 'United Kingdom',
  770: 'Uruguay',
  338: 'USA',
  366: 'USA',
  367: 'USA',
  368: 'USA',
  369: 'USA',
  576: 'Vanuatu',
  775: 'Venezuela',
  574: 'Vietnam',
  473: 'Yemen',
  678: 'Zambia',
  679: 'Zimbabwe',
};

/// Quick location presets (name -> lat/lon) for the searchable zone selector.
const Map<String, (double, double)> kSimLocationPresets = {
  'Paris': (48.85, 2.35),
  'Brest': (48.39, -4.49),
  'Le Havre': (49.49, 0.10),
  'Saint-Malo': (48.65, -2.02),
  'Cherbourg': (49.65, -1.62),
  'Lorient': (47.75, -3.37),
  'Saint-Nazaire': (47.27, -2.20),
  'La Rochelle': (46.15, -1.15),
  'Bordeaux': (44.87, -0.56),
  'Calais': (50.97, 1.85),
  'Dunkerque': (51.05, 2.37),
  'Marseille': (43.30, 5.37),
  'Toulon': (43.12, 5.92),
  'Nice': (43.70, 7.28),
  'Sète': (43.40, 3.70),
  'Ajaccio': (41.92, 8.74),
  'Antwerpen': (51.22, 4.40),
  'Rotterdam': (51.92, 4.48),
  'Amsterdam': (52.37, 4.90),
  'Dover': (51.13, 1.32),
  'Southampton': (50.90, -1.40),
  'Falmouth': (50.15, -5.07),
  'Bilbao': (43.34, -3.05),
  'Barcelona': (41.33, 2.17),
  'Valencia': (39.45, -0.32),
  'Gibraltar': (36.14, -5.35),
  'Lisbon': (38.71, -9.14),
  'Genoa': (44.40, 8.93),
  'Naples': (40.84, 14.27),
  'Piraeus': (37.94, 23.63),
  'Istanbul': (41.02, 28.96),
  'Hamburg': (53.55, 9.97),
  'Bremen': (53.08, 8.80),
  'Copenhagen': (55.68, 12.60),
  'Oslo': (59.91, 10.73),
  'Gothenburg': (57.70, 11.96),
  'Helsinki': (60.16, 24.95),
  'Tallinn': (59.44, 24.75),
  'Gdansk': (54.36, 18.65),
  'Casablanca': (33.61, -7.62),
  'Tunis': (36.80, 10.18),
  'New York': (40.71, -74.01),
  'Singapore': (1.29, 103.85),
  'Hong Kong': (22.32, 114.17),
  'Shanghai': (31.23, 121.47),
  'Tokyo': (35.67, 139.77),
  'Panama Canal': (8.95, -79.57),
  'Suez Canal': (29.96, 32.56),
};

int _validMid(int mid) => (mid >= 100 && mid <= 999) ? mid : 247;

/// Broad role of a simulated emitter, used to pick an icon in the UI.
enum SimBoatKind { vessel, aircraft, baseStation, aton, safety, weather }

/// Maps an AIS message type to the role that emits it.
SimBoatKind simBoatKind(int emitType) => switch (emitType) {
      4 || 11 || 22 || 23 => SimBoatKind.baseStation,
      9 => SimBoatKind.aircraft,
      21 => SimBoatKind.aton,
      12 || 14 => SimBoatKind.safety,
      8 => SimBoatKind.weather,
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

/// Plausible dimensions (bow, stern, port, starboard, draught) for a ship
/// type, used when [SimFleetConfig.realisticDimensions] is enabled.
(int, int, int, int, double) _dimsForType(
  int vesselType,
  math.Random random,
) {
  switch (vesselType) {
    case 70:
      return (20 + random.nextInt(30), 100 + random.nextInt(100),
          10 + random.nextInt(15), 10 + random.nextInt(15),
          8 + random.nextDouble() * 6);
    case 80:
      return (20 + random.nextInt(40), 150 + random.nextInt(150),
          12 + random.nextInt(20), 12 + random.nextInt(20),
          10 + random.nextDouble() * 10);
    case 30:
      return (3 + random.nextInt(5), 10 + random.nextInt(10),
          2 + random.nextInt(3), 2 + random.nextInt(3),
          2 + random.nextDouble() * 2);
    case 36:
      return (2 + random.nextInt(4), 8 + random.nextInt(5),
          1 + random.nextInt(2), 1 + random.nextInt(2),
          1 + random.nextDouble() * 2);
    case 60:
      return (10 + random.nextInt(20), 80 + random.nextInt(120),
          8 + random.nextInt(15), 8 + random.nextInt(15),
          5 + random.nextDouble() * 4);
    case 52:
      return (2 + random.nextInt(5), 15 + random.nextInt(10),
          3 + random.nextInt(3), 3 + random.nextInt(3),
          3 + random.nextDouble() * 2);
    case 40:
      return (3 + random.nextInt(5), 15 + random.nextInt(15),
          2 + random.nextInt(4), 2 + random.nextInt(4),
          1 + random.nextDouble() * 2);
    default:
      return (5 + random.nextInt(10), 20 + random.nextInt(40),
          3 + random.nextInt(7), 3 + random.nextInt(7),
          2 + random.nextDouble() * 4);
  }
}

/// Base station MMSI for the fleet, derived from [SimFleetConfig.mmsiMid].
int _baseMmsi(SimFleetConfig config, [int index = 0]) {
  final mid = _validMid(config.mmsiMid);
  return config.realisticMmsi
      ? mid * 10000 + index
      : mid * 1000000 + 900000 + index;
}

/// AtoN MMSI derived from [SimFleetConfig.mmsiMid].
int _atonMmsi(SimFleetConfig config, int index) {
  final mid = _validMid(config.mmsiMid);
  return config.realisticMmsi
      ? 99 * 10000000 + mid * 10000 + index
      : mid * 1000000 + 800000 + index;
}

/// Vessel MMSI derived from [SimFleetConfig.mmsiMid] and its emit type.
int _vesselMmsi(SimFleetConfig config, int emitType, int i) {
  final mid = _validMid(config.mmsiMid);
  if (config.realisticMmsi) {
    if (emitType == 18 || emitType == 19) {
      return 98 * 10000000 + mid * 10000 + (i % 10000);
    }
    if (emitType == 9) {
      return 111 * 1000000 + mid * 1000 + i;
    }
  }
  return mid * 1000000 + i;
}

/// MMSI for safety / weather emitters.
int _extraMmsi(SimFleetConfig config, int suffix, int index) =>
    _validMid(config.mmsiMid) * 1000000 + suffix + index;

/// Speed range per ship type, used when [SimFleetConfig.speedByType] is on.
(double, double) _speedForType(int vesselType) => switch (vesselType) {
      70 => (10, 18),
      80 => (8, 16),
      30 => (2, 8),
      36 => (2, 8),
      60 => (8, 18),
      52 => (3, 8),
      40 => (12, 35),
      _ => (5, 14),
    };

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

  /// The ITU-R M.1371 ship types the fleet can use (see [kSimVesselTypes]).
  Set<int> vesselTypes;

  /// When true, vessels get realistic names, call signs and destinations
  /// instead of the "SIM-" placeholders.
  bool realisticNames;

  /// Share (0-100) of vessels left anchored / moored instead of moving.
  int anchoredPercent;

  /// When true, vessel dimensions and draught are scaled by ship type.
  bool realisticDimensions;

  /// When true, speed drifts gently over time within the configured range.
  bool varySpeed;

  /// Max per-vessel position report interval in ticks (1 = report every tick).
  int reportIntervalMax;

  /// How many fixed base stations to create when network messages are enabled.
  int baseStationCount;

  /// How many fixed AtoN to create when type 21 is enabled.
  int atonCount;

  /// When true, some emitted sentences are corrupted or duplicated.
  bool injectErrors;

  /// Probability (0-1) of corrupting / duplicating each emitted sentence.
  double errorRate;

  /// Maritime Identification Digits (3-digit country code) for the MMSIs.
  int mmsiMid;

  /// When true, MMSIs follow the ITU structure per category instead of the
  /// flat mid*1e6 + suffix scheme.
  bool realisticMmsi;

  /// Prefix used for placeholder vessel names ("SIM-" by default).
  String namePrefix;

  /// Safety broadcast / addressed texts (falls back to [kSimSafetyTexts]).
  List<String> safetyTexts;

  /// Destination pool used with realistic names (falls back to
  /// [kSimDestinations]).
  List<String> destinations;

  /// Shape of the navigation zone around the center.
  SimZoneShape zoneShape;

  /// Share (0-100) of vessels crossing the zone on straight transit routes.
  int transitPercent;

  /// When true, the fleet regenerates periodically to simulate changing
  /// traffic.
  bool autoRegenerate;

  /// Regenerate the fleet every N ticks when [autoRegenerate] is on.
  int regenEveryTicks;

  /// Strength of the random heading wander (0-3, 1 = default).
  double wanderStrength;

  /// When true, speed is picked per ship type instead of a uniform range.
  bool speedByType;

  /// Share (0-100) of Class B vs Class A position reports when both are
  /// enabled.
  int classBPercent;

  /// When true, position reports carry the "high accuracy" bit.
  bool accuratePosition;

  /// When true, position reports carry a rate of turn derived from heading.
  bool realisticRot;

  /// NMEA 4.0 talker ID used when emitting (AI, AB, AN, ...). 'AI' keeps the
  /// classic !AIVDM/!AIVDO form.
  String nmeaTalker;

  /// When true, every emitted frame is prefixed with a NMEA 4.0 tag block
  /// (source "SIM" and a timestamp).
  bool nmea4Tags;

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
    Set<int>? vesselTypes,
    this.realisticNames = false,
    this.anchoredPercent = 0,
    this.realisticDimensions = false,
    this.varySpeed = false,
    this.reportIntervalMax = 1,
    this.baseStationCount = 1,
    this.atonCount = 3,
    this.injectErrors = false,
    this.errorRate = 0.05,
    this.mmsiMid = 247,
    this.realisticMmsi = false,
    this.namePrefix = 'SIM',
    List<String>? safetyTexts,
    List<String>? destinations,
    this.zoneShape = SimZoneShape.circle,
    this.transitPercent = 0,
    this.autoRegenerate = false,
    this.regenEveryTicks = 300,
    this.wanderStrength = 1.0,
    this.speedByType = false,
    this.classBPercent = 50,
    this.accuratePosition = false,
    this.realisticRot = false,
    this.nmeaTalker = 'AI',
    this.nmea4Tags = false,
  })  : messageTypes = messageTypes ?? {1, 5},
        vesselTypes = vesselTypes ?? {
            70, 80, 30, 36, 60, 52, 40, 90,
          },
        safetyTexts = safetyTexts ?? List.of(kSimSafetyTexts),
        destinations = destinations ?? List.of(kSimDestinations);

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
    Set<int>? vesselTypes,
    bool? realisticNames,
    int? anchoredPercent,
    bool? realisticDimensions,
    bool? varySpeed,
    int? reportIntervalMax,
    int? baseStationCount,
    int? atonCount,
    bool? injectErrors,
    double? errorRate,
    int? mmsiMid,
    bool? realisticMmsi,
    String? namePrefix,
    List<String>? safetyTexts,
    List<String>? destinations,
    SimZoneShape? zoneShape,
    int? transitPercent,
    bool? autoRegenerate,
    int? regenEveryTicks,
    double? wanderStrength,
    bool? speedByType,
    int? classBPercent,
    bool? accuratePosition,
    bool? realisticRot,
    String? nmeaTalker,
    bool? nmea4Tags,
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
        vesselTypes: vesselTypes ?? Set.of(this.vesselTypes),
        realisticNames: realisticNames ?? this.realisticNames,
        anchoredPercent: anchoredPercent ?? this.anchoredPercent,
        realisticDimensions: realisticDimensions ?? this.realisticDimensions,
        varySpeed: varySpeed ?? this.varySpeed,
        reportIntervalMax: reportIntervalMax ?? this.reportIntervalMax,
        baseStationCount: baseStationCount ?? this.baseStationCount,
        atonCount: atonCount ?? this.atonCount,
        injectErrors: injectErrors ?? this.injectErrors,
        errorRate: errorRate ?? this.errorRate,
        mmsiMid: mmsiMid ?? this.mmsiMid,
        realisticMmsi: realisticMmsi ?? this.realisticMmsi,
        namePrefix: namePrefix ?? this.namePrefix,
        safetyTexts: safetyTexts ?? List.of(this.safetyTexts),
        destinations: destinations ?? List.of(this.destinations),
        zoneShape: zoneShape ?? this.zoneShape,
        transitPercent: transitPercent ?? this.transitPercent,
        autoRegenerate: autoRegenerate ?? this.autoRegenerate,
        regenEveryTicks: regenEveryTicks ?? this.regenEveryTicks,
        wanderStrength: wanderStrength ?? this.wanderStrength,
        speedByType: speedByType ?? this.speedByType,
        classBPercent: classBPercent ?? this.classBPercent,
        accuratePosition: accuratePosition ?? this.accuratePosition,
        realisticRot: realisticRot ?? this.realisticRot,
        nmeaTalker: nmeaTalker ?? this.nmeaTalker,
        nmea4Tags: nmea4Tags ?? this.nmea4Tags,
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
        'vesselTypes': vesselTypes.toList(),
        'realisticNames': realisticNames,
        'anchoredPercent': anchoredPercent,
        'realisticDimensions': realisticDimensions,
        'varySpeed': varySpeed,
        'reportIntervalMax': reportIntervalMax,
        'baseStationCount': baseStationCount,
        'atonCount': atonCount,
        'injectErrors': injectErrors,
        'errorRate': errorRate,
        'mmsiMid': mmsiMid,
        'realisticMmsi': realisticMmsi,
        'namePrefix': namePrefix,
        'safetyTexts': safetyTexts,
        'destinations': destinations,
        'zoneShape': zoneShape.name,
        'transitPercent': transitPercent,
        'autoRegenerate': autoRegenerate,
        'regenEveryTicks': regenEveryTicks,
        'wanderStrength': wanderStrength,
        'speedByType': speedByType,
        'classBPercent': classBPercent,
        'accuratePosition': accuratePosition,
        'realisticRot': realisticRot,
        'nmeaTalker': nmeaTalker,
        'nmea4Tags': nmea4Tags,
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
        vesselTypes: ((json['vesselTypes'] as List?) ??
                [70, 80, 30, 36, 60, 52, 40, 90])
            .map((e) => e as int)
            .toSet(),
        realisticNames: json['realisticNames'] as bool? ?? false,
        anchoredPercent: json['anchoredPercent'] as int? ?? 0,
        realisticDimensions: json['realisticDimensions'] as bool? ?? false,
        varySpeed: json['varySpeed'] as bool? ?? false,
        reportIntervalMax: json['reportIntervalMax'] as int? ?? 1,
        baseStationCount: json['baseStationCount'] as int? ?? 1,
        atonCount: json['atonCount'] as int? ?? 3,
        injectErrors: json['injectErrors'] as bool? ?? false,
        errorRate: (json['errorRate'] as num?)?.toDouble() ?? 0.05,
        mmsiMid: json['mmsiMid'] as int? ?? 247,
        realisticMmsi: json['realisticMmsi'] as bool? ?? false,
        namePrefix: json['namePrefix'] as String? ?? 'SIM',
        safetyTexts: ((json['safetyTexts'] as List?) ?? kSimSafetyTexts)
            .map((e) => e as String)
            .toList(),
        destinations: ((json['destinations'] as List?) ?? kSimDestinations)
            .map((e) => e as String)
            .toList(),
        zoneShape: SimZoneShape.values.asNameMap()[json['zoneShape']] ??
            SimZoneShape.circle,
        transitPercent: json['transitPercent'] as int? ?? 0,
        autoRegenerate: json['autoRegenerate'] as bool? ?? false,
        regenEveryTicks: json['regenEveryTicks'] as int? ?? 300,
        wanderStrength: (json['wanderStrength'] as num?)?.toDouble() ?? 1.0,
        speedByType: json['speedByType'] as bool? ?? false,
        classBPercent: json['classBPercent'] as int? ?? 50,
        accuratePosition: json['accuratePosition'] as bool? ?? false,
        realisticRot: json['realisticRot'] as bool? ?? false,
        nmeaTalker: json['nmeaTalker'] as String? ?? 'AI',
        nmea4Tags: json['nmea4Tags'] as bool? ?? false,
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

  /// AIS navigation status (0 under way, 1 at anchor, 5 moored, ...).
  int navigationStatus;

  /// Position reports every N ticks (1 = every tick).
  int reportEvery;

  /// IMO number carried in type 5 static messages (0 = none).
  int imoNumber;

  /// When true, the vessel crosses the zone on a straight transit route.
  bool transit;

  /// Current rate of turn (AIS signed value) reported in type 1/2/3 messages.
  int rot;

  double _drift = 0;

  /// Advances each emission, used to cycle safety texts and weather payloads.
  int _emissionCounter = 0;

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
    this.navigationStatus = 0,
    this.reportEvery = 1,
    this.imoNumber = 0,
    this.transit = false,
    this.rot = 0,
  });

  /// Advances the vessel along its course, applying a little heading drift and
  /// steering gently back toward the zone centre when it gets too far.
  void update({
    required double dt,
    required SimFleetConfig config,
    required math.Random random,
  }) {
    if (fixed) return;
    if (sog <= 0.01) return;

    if (config.varySpeed) {
      sog = (sog + (random.nextDouble() - 0.5) * 0.8)
          .clamp(config.sogMin, config.sogMax);
    }

    final dKm = sog * 1.852 * (dt / 3600);
    final rad = cog * math.pi / 180;
    final newLat = lat + math.cos(rad) * dKm / kKmPerDegLat;
    final lonDegKm = kKmPerDegLat * math.cos(lat * math.pi / 180);
    final newLon =
        lon + math.sin(rad) * dKm / (lonDegKm == 0 ? kKmPerDegLat : lonDegKm);

    if (transit) {
      if (_outsideZone(config, newLat, newLon)) {
        _respawnTransit(config, random);
      } else {
        lat = newLat;
        lon = newLon;
      }
      return;
    }

    _drift += (random.nextDouble() - 0.5) * 4 * config.wanderStrength;
    var newCog = (cog + _drift * 0.15) % 360;
    if (newCog < 0) newCog += 360;

    if (_outsideZone(config, newLat, newLon)) {
      newCog = _bearingDeg(newLat, newLon, config.centerLat, config.centerLon);
      _drift = 0;
    }

    if (config.realisticRot) {
      rot = _rotFromHeading(cog, newCog, dt);
    }

    lat = newLat;
    lon = newLon;
    cog = newCog;
    heading = newCog;
  }

  bool _outsideZone(SimFleetConfig config, double lat, double lon) {
    if (config.zoneShape == SimZoneShape.rectangle) {
      final latR = config.radiusKm / kKmPerDegLat;
      final lonDegKm = kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
      final lonR = config.radiusKm / (lonDegKm == 0 ? kKmPerDegLat : lonDegKm);
      return (lat - config.centerLat).abs() > latR ||
          (lon - config.centerLon).abs() > lonR;
    }
    return _distanceKm(lat, lon, config.centerLat, config.centerLon) >
        config.radiusKm;
  }

  /// Places a transit vessel back on the zone edge heading roughly across.
  void _respawnTransit(SimFleetConfig config, math.Random random) {
    final ang = random.nextDouble() * 2 * math.pi;
    final r = config.radiusKm;
    final dLat = math.cos(ang) * r / kKmPerDegLat;
    final lonDegKm =
        kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
    final dLon = math.sin(ang) * r / (lonDegKm == 0 ? kKmPerDegLat : lonDegKm);
    lat = config.centerLat + dLat;
    lon = config.centerLon + dLon;
    cog = (ang * 180 / math.pi + 180 + (random.nextDouble() - 0.5) * 60) % 360;
    if (cog < 0) cog += 360;
    heading = cog;
    _drift = 0;
  }

  /// Maps a heading change into an AIS rate of turn value.
  int _rotFromHeading(double from, double to, double dt) {
    var delta = (to - from) % 360;
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    if (delta.abs() < 1) return 0;
    final degPerMin = (delta / dt) * 60;
    final v = (4.733 * math.sqrt(degPerMin.abs())).round().clamp(1, 127);
    return degPerMin < 0 ? -v : v;
  }

  /// Builds the periodic report for this vessel, or null when the configured
  /// message types no longer include its emit type.
  String? positionSentence(SimFleetConfig config) {
    if (!config.messageTypes.contains(emitType)) return null;
    final now = DateTime.now();
    _emissionCounter++;
    final texts = config.safetyTexts.isEmpty ? kSimSafetyTexts : config.safetyTexts;
    final safetyText = texts[_emissionCounter % texts.length];
    final accuracy = config.accuratePosition ? 1 : 0;
    return switch (emitType) {
      1 || 2 || 3 => encodePositionReport(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
          heading: heading,
          navigationStatus: navigationStatus,
          positionAccuracy: accuracy,
          rot: rot,
        ),
      18 => encodeClassBPosition(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
          heading: heading,
          positionAccuracy: accuracy,
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
          positionAccuracy: accuracy,
        ),
      27 => encodeLongRangeBroadcast(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          sog: sog,
          cog: cog,
          navigationStatus: navigationStatus,
        ),
      9 => encodeSarAircraftPosition(
          mmsi: mmsi,
          latitude: lat,
          longitude: lon,
          cog: cog,
          altitude: altitude,
          sog: sog.round(),
          positionAccuracy: accuracy,
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
      12 => encodeAddressedSafety(
          mmsi: mmsi,
          destinationMmsi: _baseMmsi(config),
          text: safetyText,
        ),
      14 => encodeSafetyBroadcast(
          mmsi: mmsi,
          text: safetyText,
        ),
      8 => encodeBinaryBroadcast(
          mmsi: mmsi,
          dac: 1,
          fid: 11,
          data: _weatherBytes(_emissionCounter),
        ),
      _ => null,
    };
  }

  /// Synthetic IMO weather report payload (DAC 1, FID 11) that varies per
  /// emission; surfaced as hex bytes in the decoder.
  List<int> _weatherBytes(int counter) {
    final seed = counter * 7 + 13;
    return List.generate(12, (i) => (seed * (i + 3) + i * 11) % 256);
  }

  /// Extra network messages broadcast by a fixed base station (UTC/date
  /// response, channel management, group assignment) on a tick cadence.
  List<String> baseStationExtras(SimFleetConfig config, int tick) {
    if (!fixed || emitType != 4) return const [];
    final now = DateTime.now();
    final out = <String>[];
    if (config.messageTypes.contains(11) && tick % 5 == 0) {
      out.add(encodeUtcDateResponse(
        mmsi: mmsi,
        year: now.year,
        month: now.month,
        day: now.day,
        hour: now.hour,
        minute: now.minute,
        second: now.second,
        latitude: lat,
        longitude: lon,
      ));
    }
    final neLat = _zoneLatOffset(config);
    final neLon = _zoneLonOffset(config);
    if (config.messageTypes.contains(22) && tick % 7 == 0) {
      out.add(encodeChannelManagement(
        mmsi: mmsi,
        channelA: 2087,
        channelB: 2088,
        txrxMode: 0,
        neLatitude: config.centerLat + neLat,
        neLongitude: config.centerLon + neLon,
        swLatitude: config.centerLat - neLat,
        swLongitude: config.centerLon - neLon,
      ));
    }
    if (config.messageTypes.contains(23) && tick % 11 == 0) {
      out.add(encodeGroupAssignment(
        mmsi: mmsi,
        neLatitude: config.centerLat + neLat,
        neLongitude: config.centerLon + neLon,
        swLatitude: config.centerLat - neLat,
        swLongitude: config.centerLon - neLon,
      ));
    }
    return out;
  }

  double _zoneLatOffset(SimFleetConfig config) =>
      (config.radiusKm * 0.5) / kKmPerDegLat;

  double _zoneLonOffset(SimFleetConfig config) {
    final lonDegKm = kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
    return (config.radiusKm * 0.5) / (lonDegKm == 0 ? kKmPerDegLat : lonDegKm);
  }

  /// Static data report (type 24) emitted by Class B vessels: part A (name)
  /// followed by part B (ship data).
  List<String> classBStaticSentences() => [
        encodeStaticDataReportPartA(mmsi: mmsi, name: name),
        encodeStaticDataReportPartB(
          mmsi: mmsi,
          shipType: vesselType,
          callSign: callSign,
          dimensionBow: dimensionBow,
          dimensionStern: dimensionStern,
          dimensionPort: dimensionPort,
          dimensionStarboard: dimensionStarboard,
        ),
      ];

  String staticSentence() => encodeStaticAndVoyage(
        mmsi: mmsi,
        name: name,
        callSign: callSign,
        imoNumber: imoNumber,
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

  void generate(SimFleetConfig config, {int? seed}) {    boats.clear();
    final random = math.Random(seed ?? config.seed);
    final posTypes = config.enabledPositionTypes;
    final classAPosTypes = posTypes
        .where((t) => t == 1 || t == 2 || t == 3 || t == 9 || t == 27)
        .toList();
    final classBPosTypes =
        posTypes.where((t) => t == 18 || t == 19).toList();
    var vesselTypes = kSimVesselTypes
        .where((vt) => config.vesselTypes.contains(vt.$1))
        .toList();
    if (vesselTypes.isEmpty) vesselTypes = kSimVesselTypes;
    final reportMax = math.max(1, config.reportIntervalMax);
    final prefix =
        config.namePrefix.trim().isEmpty ? 'SIM' : config.namePrefix.trim();
    final destPool =
        config.destinations.isEmpty ? kSimDestinations : config.destinations;
    final transitShare = config.transitPercent.clamp(0, 100);
    var nextIndex = 0;

    for (var i = 0; i < config.boatCount; i++) {
      final vt = vesselTypes[random.nextInt(vesselTypes.length)];
      final (lat, lon) = _randomPoint(config, random);
      var sog =
          config.sogMin + random.nextDouble() * (config.sogMax - config.sogMin);
      if (config.speedByType) {
        final (sMin, sMax) = _speedForType(vt.$1);
        sog = (sMin + random.nextDouble() * (sMax - sMin))
            .clamp(config.sogMin, config.sogMax);
      }
      final cog = random.nextDouble() * 360;
      var navStatus = 0;
      if (config.anchoredPercent > 0 &&
          random.nextInt(100) < config.anchoredPercent) {
        sog = 0;
        navStatus = random.nextInt(2) == 0 ? 1 : 5;
      }
      final transit =
          transitShare > 0 && random.nextInt(100) < transitShare;
      final emitType = _pickEmitType(
          config, classAPosTypes, classBPosTypes, posTypes, i, random);
      final namePool = kSimNamesByType[vt.$1];
      final name = config.realisticNames && namePool != null && namePool.isNotEmpty
          ? namePool[i % namePool.length]
          : '$prefix-${i + 1}';
      final callSign = config.realisticNames
          ? _callSignForIndex(i)
          : '$prefix${(i + 1).toString().padLeft(3, '0')}';
      final destination = config.realisticNames
          ? destPool[i % destPool.length]
          : 'SIM PORT';
      final (bow, stern, port, stbd, draught) = config.realisticDimensions
          ? _dimsForType(vt.$1, random)
          : (10, 20, 5, 5, 4.0);
      final imo = (vt.$1 == 70 || vt.$1 == 80 || vt.$1 == 60)
          ? 9000000 + (i % 999999)
          : 0;
      boats.add(
        SimBoat(
          index: nextIndex++,
          mmsi: _vesselMmsi(config, emitType, i),
          name: name,
          vesselType: vt.$1,
          lat: lat,
          lon: lon,
          sog: sog,
          cog: cog,
          heading: cog,
          emitType: emitType,
          dimensionBow: bow,
          dimensionStern: stern,
          dimensionPort: port,
          dimensionStarboard: stbd,
          draught: draught,
          navigationStatus: navStatus,
          reportEvery: 1 + random.nextInt(reportMax),
          callSign: callSign,
          destination: destination,
          imoNumber: imo,
          transit: transit,
        ),
      );
    }

    if (config.messageTypes.intersection(const {4, 11, 22, 23}).isNotEmpty) {
      for (var i = 0; i < config.baseStationCount; i++) {
        boats.add(
          SimBoat(
            index: nextIndex++,
            mmsi: _baseMmsi(config, i),
            name: i == 0 ? 'SIM BASE' : 'SIM BASE ${i + 1}',
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
    }
    if (config.messageTypes.contains(21)) {
      for (var i = 0; i < config.atonCount; i++) {
        final (lat, lon) = _randomPoint(config, random);
        boats.add(
          SimBoat(
            index: nextIndex++,
            mmsi: _atonMmsi(config, i),
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
    if (config.messageTypes.contains(14)) {
      boats.add(_extraBoat(
        config,
        random,
        index: nextIndex++,
        mmsi: _extraMmsi(config, 700000, 0),
        name: 'SIM SAFETY',
        emitType: 14,
      ));
    }
    if (config.messageTypes.contains(12)) {
      boats.add(_extraBoat(
        config,
        random,
        index: nextIndex++,
        mmsi: _extraMmsi(config, 700000, 1),
        name: 'SIM DISTRESS',
        emitType: 12,
      ));
    }
    if (config.messageTypes.contains(8)) {
      boats.add(_extraBoat(
        config,
        random,
        index: nextIndex++,
        mmsi: _extraMmsi(config, 600000, 0),
        name: 'SIM METEO',
        emitType: 8,
      ));
    }
  }

  /// Picks a position emit type, weighting Class A vs Class B by
  /// [SimFleetConfig.classBPercent] when both are enabled.
  int _pickEmitType(
    SimFleetConfig config,
    List<int> classA,
    List<int> classB,
    List<int> posTypes,
    int i,
    math.Random random,
  ) {
    if (classA.isNotEmpty && classB.isNotEmpty) {
      final pool = random.nextInt(100) < config.classBPercent.clamp(0, 100)
          ? classB
          : classA;
      return pool[i % pool.length];
    }
    return posTypes.isEmpty ? 1 : posTypes[i % posTypes.length];
  }

  /// A slow moving emitter for non-position message types (safety, weather).
  SimBoat _extraBoat(
    SimFleetConfig config,
    math.Random random, {
    required int index,
    required int mmsi,
    required String name,
    required int emitType,
  }) {
    final (lat, lon) = _randomPoint(config, random);
    final sog = 1 + random.nextDouble() * 3;
    final cog = random.nextDouble() * 360;
    return SimBoat(
      index: index,
      mmsi: mmsi,
      name: name,
      vesselType: 90,
      lat: lat,
      lon: lon,
      sog: sog,
      cog: cog,
      heading: cog,
      emitType: emitType,
      callSign: 'SIM${index.toString().padLeft(3, '0')}',
    );
  }

  /// Advances every vessel and returns the NMEA sentences to emit for this
  /// tick (position reports + periodic static data + base station extras).
  List<String> advanceAndCollect(SimFleetConfig config, int tick) {
    final random = math.Random();
    final out = <String>[];
    for (final b in boats) {
      b.update(
        dt: config.emitIntervalSec.toDouble(),
        config: config,
        random: random,
      );
      if ((tick + b.index) % b.reportEvery == 0) {
        final pos = b.positionSentence(config);
        if (pos != null) out.add(pos);
      }
      out.addAll(b.baseStationExtras(config, tick));
      if (!b.fixed && SimFleetConfig.positionTypes.contains(b.emitType)) {
        final isClassB = b.emitType == 18 || b.emitType == 19;
        final emitStatic = isClassB
            ? config.messageTypes.contains(24) ||
                config.messageTypes.contains(5)
            : config.messageTypes.contains(5);
        if (emitStatic && (tick + b.index) % kStaticEveryTicks == 0) {
          if (isClassB && config.messageTypes.contains(24)) {
            out.addAll(b.classBStaticSentences());
          } else {
            out.add(b.staticSentence());
          }
        }
      }
    }
    var result = out;
    if (config.nmeaTalker != 'AI' || config.nmea4Tags) {
      final tag = config.nmea4Tags
          ? buildTagBlock(
              sourceId: 'SIM',
              timeMs: msSinceUtcMidnight(DateTime.now()),
            )
          : null;
      result = [
        for (final s in out)
          wrapNmea4(s, talker: config.nmeaTalker, tagBlock: tag),
      ];
    }
    if (config.injectErrors && result.isNotEmpty) {
      return _injectErrors(result, config.errorRate, random);
    }
    return result;
  }

  /// Corrupts the checksum of, or duplicates, a random share of sentences to
  /// exercise the receiver error handling.
  List<String> _injectErrors(
    List<String> sentences,
    double rate,
    math.Random random,
  ) {
    final result = <String>[];
    for (final s in sentences) {
      if (random.nextDouble() < rate) {
        result.add(_corruptChecksum(s));
      } else {
        result.add(s);
      }
      if (random.nextDouble() < rate) {
        result.add(s);
      }
    }
    return result;
  }

  /// Returns a copy of an NMEA sentence whose trailing checksum is wrong.
  String _corruptChecksum(String sentence) {
    final star = sentence.lastIndexOf('*');
    if (star < 0 || star > sentence.length - 3) return sentence;
    final current = int.tryParse(sentence.substring(star + 1), radix: 16) ?? 0;
    final wrong = ((current + 1) % 256)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase();
    return '${sentence.substring(0, star + 1)}$wrong';
  }

  (double, double) _randomPoint(SimFleetConfig config, math.Random random) {
    if (config.zoneShape == SimZoneShape.rectangle) {
      final latR = config.radiusKm / kKmPerDegLat;
      final lonDegKm =
          kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
      final lonR = config.radiusKm / (lonDegKm == 0 ? kKmPerDegLat : lonDegKm);
      return (
        config.centerLat + (random.nextDouble() * 2 - 1) * latR,
        config.centerLon + (random.nextDouble() * 2 - 1) * lonR,
      );
    }
    final ang = random.nextDouble() * 2 * math.pi;
    final r = config.radiusKm * math.sqrt(random.nextDouble());
    final dLat = math.cos(ang) * r / kKmPerDegLat;
    final lonDegKm = kKmPerDegLat * math.cos(config.centerLat * math.pi / 180);
    final dLon = math.sin(ang) * r / lonDegKm;
    return (config.centerLat + dLat, config.centerLon + dLon);
  }
}

/// A plain, isolate-safe snapshot of the parameters needed to generate a fleet
/// (both classes carry only primitive / collection fields).
class SimFleetGenerationArgs {
  final SimFleetConfig config;
  final int seed;

  const SimFleetGenerationArgs(this.config, this.seed);
}

/// Top-level entry point used by `compute` to generate a fleet off the UI
/// thread. Building a fresh [SimFleet] keeps the (mutable) in-flight boats list
/// of the service untouched until the result is ready.
List<SimBoat> generateFleetIsolate(SimFleetGenerationArgs args) {
  final fleet = SimFleet();
  fleet.generate(args.config, seed: args.seed);
  return fleet.boats;
}
