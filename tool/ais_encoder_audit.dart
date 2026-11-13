import 'dart:convert';
import 'dart:io';

import 'package:kik_ais/ais/src/encoder/ais_message_encoder.dart';
import 'package:kik_ais/ais/src/encoder/ais_payload_encoder.dart';
import 'package:kik_ais/ais/src/nmea/ais_decoder.dart';
import 'package:kik_ais/ais/src/utils/convert_char_to_bin.dart';

/// Audits every AIS encoder against the wire format rules that a real
/// receiver enforces (NMEA 0183 length, fragmenting, fill bits, payload
/// alphabet) and against the expected bit length of each message type.
///
/// Outputs a human report on stdout and a JSONL file (one decoded expectation
/// per case) that [tool/ais_encoder_audit.py] re-checks with pyais.
///
///   dart run tool/ais_encoder_audit.dart [out.jsonl]
///
/// JSONL path defaults to build/encoder_audit.jsonl.

/// Bit-length range of a message type, excluding any data/text payload that
/// the type declares variable (min = shortest legal message).
const Map<int, (int, int)> kTypeBitRange = {
  1: (168, 168),
  2: (168, 168),
  3: (168, 168),
  4: (168, 168),
  5: (424, 424),
  6: (88, 1008),
  7: (72, 168),
  8: (56, 1008),
  9: (168, 168),
  10: (72, 72),
  11: (168, 168),
  12: (72, 1008),
  13: (72, 168),
  14: (40, 1008),
  15: (88, 160),
  16: (96, 144),
  17: (80, 816),
  18: (168, 168),
  19: (312, 312),
  20: (72, 160),
  21: (271, 360),
  22: (168, 168),
  23: (160, 160),
  24: (160, 168),
  25: (40, 168),
  26: (60, 1064),
  27: (96, 96),
};

/// Maximum NMEA 0183 sentence length, `!` and checksum included.
const int kMaxSentence = 82;

/// Maximum payload characters per NMEA fragment.
const int kMaxFragmentPayload = 62;

class AuditCase {
  final String label;
  final int type;
  final String sentence;
  final Map<String, Object?> expect;

  /// Longest legitimate message for this case. Anything above means the
  /// encoder padded the payload with zero bits that carry no information.
  final int? maxBits;

  const AuditCase(
    this.label,
    this.type,
    this.sentence, [
    this.expect = const {},
    this.maxBits,
  ]);
}

class Fragment {
  final int count;
  final int number;
  final String sequentialId;
  final String channel;
  final String payload;
  final int fill;

  const Fragment({
    required this.count,
    required this.number,
    required this.sequentialId,
    required this.channel,
    required this.payload,
    required this.fill,
  });
}

Fragment? _parse(String line) {
  if (!line.startsWith('!')) return null;
  final star = line.lastIndexOf('*');
  if (star < 0) return null;
  final body = line.substring(1, star);
  final commas = <int>[];
  for (var i = 0; i < body.length; i++) {
    if (body[i] == ',') commas.add(i);
  }
  if (commas.length != 6) return null;
  final count = int.tryParse(body.substring(commas[0] + 1, commas[1]));
  final number = int.tryParse(body.substring(commas[1] + 1, commas[2]));
  final fill = int.tryParse(body.substring(commas[5] + 1));
  if (count == null || number == null || fill == null) return null;
  return Fragment(
    count: count,
    number: number,
    sequentialId: body.substring(commas[2] + 1, commas[3]),
    channel: body.substring(commas[3] + 1, commas[4]),
    payload: body.substring(commas[4] + 1, commas[5]),
    fill: fill,
  );
}

String _checksumOf(String line) {
  final star = line.lastIndexOf('*');
  final body = line.substring(1, star);
  return computeNmeaChecksum(body);
}

List<String> _audit(AuditCase c) {
  final issues = <String>[];
  final lines = c.sentence.trim().split('\n');
  final fragments = <Fragment>[];

  for (final line in lines) {
    if (line.length > kMaxSentence) {
      issues.add('NMEA length ${line.length} > $kMaxSentence');
    }
    final star = line.lastIndexOf('*');
    if (star < 0 || star != line.length - 3) {
      issues.add('missing/misplaced checksum block');
    } else if (_checksumOf(line) != line.substring(star + 1).toUpperCase()) {
      issues.add('bad checksum');
    }
    final fragment = _parse(line);
    if (fragment == null) {
      issues.add('unparsable sentence');
      continue;
    }
    fragments.add(fragment);
    if (fragment.payload.isEmpty) issues.add('empty payload');
    for (final ch in fragment.payload.split('')) {
      if (!aisPayloadChars.contains(ch)) {
        issues.add('payload char "$ch" outside AIS alphabet');
        break;
      }
    }
    if (fragment.fill > 5) issues.add('fill ${fragment.fill} > 5');
  }

  if (fragments.isEmpty) return issues;

  final declared = fragments.first.count;
  if (declared != fragments.length) {
    issues.add('header says $declared fragment(s), got ${fragments.length}');
  }
  for (var i = 0; i < fragments.length; i++) {
    if (fragments[i].number != i + 1) {
      issues.add('fragment ${i + 1} numbered ${fragments[i].number}');
    }
    if (fragments[i].count != declared) {
      issues.add('fragment ${i + 1} count ${fragments[i].count} != $declared');
    }
    if (fragments[i].sequentialId != fragments.first.sequentialId) {
      issues.add('sequential id differs across fragments');
    }
    if (fragments[i].payload.length > kMaxFragmentPayload) {
      issues.add(
        'fragment ${i + 1} payload ${fragments[i].payload.length} chars '
        '> $kMaxFragmentPayload',
      );
    }
    if (i < fragments.length - 1 && fragments[i].fill != 0) {
      issues.add(
        'non-final fragment ${i + 1} declares fill ${fragments[i].fill}',
      );
    }
  }
  if (declared > 1 && fragments.first.sequentialId.isEmpty) {
    issues.add('multi-fragment message without sequential message id');
  }

  final totalChars = fragments.fold<int>(0, (s, f) => s + f.payload.length);
  final fill = fragments.last.fill;
  final bits = totalChars * 6 - fill;
  final needed = (totalChars / kMaxFragmentPayload).ceil();
  if (declared < needed) {
    issues.add(
      'needs $needed fragment(s) for $totalChars payload chars, declares $declared',
    );
  }
  if (fill > 0) {
    final lastValue = aisCharToValue(fragments.last.payload.split('').last);
    if (lastValue & ((1 << fill) - 1) != 0) {
      issues.add('last payload char carries non-zero fill bits');
    }
  }

  final range = kTypeBitRange[c.type];
  if (range == null) {
    issues.add('no reference bit range for type ${c.type}');
  } else if (bits < range.$1 || bits > range.$2) {
    issues.add('bit length $bits outside ${range.$1}-${range.$2}');
  }
  if (c.maxBits != null && bits > c.maxBits!) {
    issues.add('zero-padded: $bits bits, armouring needs ${c.maxBits}');
  }

  final decoder = AisNmeaDecoder();
  var decoded = decoder.decode(lines.first);
  for (var i = 1; i < lines.length; i++) {
    decoded = decoder.decode(lines[i]);
  }
  if (declared == 1 && decoded == null) {
    issues.add('project decoder rejected the sentence');
  } else if (decoded != null) {
    if (decoded.messageType != c.type) {
      issues.add('decoder reports type ${decoded.messageType}');
    }
    final mmsi = c.expect['mmsi'];
    if (mmsi is int && decoded.mmsi != mmsi) {
      issues.add('decoder reports mmsi ${decoded.mmsi} != $mmsi');
    }
  }

  return issues;
}

void main(List<String> args) {
  final outPath = args.isNotEmpty ? args.first : 'build/encoder_audit.jsonl';
  final cases = _buildCases();
  final out = <Map<String, Object?>>[];
  final byType = <int, int>{};

  for (final c in cases) {
    final issues = _audit(c);
    final line = c.sentence.split('\n').first;
    final totalChars = c.sentence
        .split('\n')
        .where((l) => l.contains(','))
        .map((l) => _parse(l)?.payload.length ?? 0)
        .fold<int>(0, (s, v) => s + v);
    if (issues.isNotEmpty) byType[c.type] = (byType[c.type] ?? 0) + 1;
    stdout.writeln(
      '${issues.isEmpty ? 'ok  ' : 'FAIL'} '
      'type ${c.type.toString().padLeft(2)} '
      'chars ${totalChars.toString().padLeft(3)} '
      'line ${line.length.toString().padLeft(3)} '
      '${c.label}'
      '${issues.isEmpty ? '' : '\n       -> ${issues.join('\n       -> ')}'}',
    );
    final parsed = _parse(line);
    out.add({
      'label': c.label,
      'type': c.type,
      'lines': c.sentence.trim().split('\n'),
      'bits': totalChars * 6 - (parsed?.fill ?? 0),
      'length': line.length,
      'fragments': parsed?.count ?? 0,
      'issues': issues,
      'expect': c.expect,
    });
  }

  final file = File(outPath);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(out.map((e) => jsonEncode(e)).join('\n'));

  stdout.writeln(
    '\n${cases.length} cases, '
    '${out.where((e) => (e['issues'] as List).isNotEmpty).length} with issues',
  );
  if (byType.isNotEmpty) {
    final summary = byType.entries.toList()..sort((a, b) => a.key - b.key);
    stdout.writeln(
      'types with issues: ${summary.map((e) => '${e.key}(${e.value})').join(' ')}',
    );
  }
  stdout.writeln('JSONL -> $outPath');
}

List<AuditCase> _buildCases() {
  const mmsi = 226545000;
  final scenarios = <AuditCase>[
    // Types 1-3: Class A position reports.
    AuditCase(
      'position type 1',
      1,
      encodePositionReport(
        mmsi: mmsi,
        latitude: 48.85,
        longitude: -4.5,
        sog: 12.3,
        cog: 87.6,
        heading: 88,
        type: 1,
      ),
      const {'mmsi': mmsi, 'lat': 48.85, 'lon': -4.5},
    ),
    AuditCase(
      'position type 2 negative lon',
      2,
      encodePositionReport(
        mmsi: mmsi,
        latitude: -33.9,
        longitude: -170.2,
        sog: 0.1,
        cog: 0,
        heading: 0,
        type: 2,
      ),
      const {'mmsi': mmsi, 'lat': -33.9, 'lon': -170.2},
    ),
    AuditCase(
      'position type 3',
      3,
      encodePositionReport(
        mmsi: mmsi,
        latitude: 0,
        longitude: 0,
        sog: 102.2,
        cog: 359.9,
        heading: 359,
        type: 3,
      ),
      const {'mmsi': mmsi},
    ),

    // Type 4 / 11: base station.
    AuditCase(
      'base station',
      4,
      encodeBaseStationReport(
        mmsi: 226000000,
        year: 2026,
        month: 8,
        day: 6,
        hour: 12,
        minute: 30,
        second: 15,
        latitude: 47.5,
        longitude: -3.2,
      ),
      const {'mmsi': 226000000, 'year': 2026, 'lat': 47.5, 'lon': -3.2},
    ),
    AuditCase(
      'utc date response',
      11,
      encodeUtcDateResponse(
        mmsi: 226000000,
        year: 2026,
        month: 12,
        day: 31,
        hour: 23,
        minute: 59,
        second: 59,
        latitude: -47.5,
        longitude: 3.2,
      ),
      const {'mmsi': 226000000},
    ),

    // Type 5: 424 bits, always > 82 chars in one sentence.
    AuditCase(
      'static and voyage',
      5,
      encodeStaticAndVoyage(
        mmsi: mmsi,
        name: 'KIKAIS',
        callSign: 'FLO21',
        imoNumber: 1234567,
        vesselType: 70,
        dimensionBow: 10,
        dimensionStern: 20,
        dimensionPort: 5,
        dimensionStarboard: 5,
        etaMonth: 8,
        etaDay: 6,
        etaHour: 12,
        etaMinute: 30,
        draught: 4.5,
        destination: 'BREST',
      ),
      const {'mmsi': mmsi, 'name': 'KIKAIS', 'ship_type': 70},
    ),
    AuditCase(
      'static and voyage max text',
      5,
      encodeStaticAndVoyage(
        mmsi: mmsi,
        name: 'ABCDEFGHIJKLMNOPQRST',
        callSign: 'ABCDEFGH',
        destination: 'ABCDEFGHIJKLMNOPQRST',
      ),
      const {'mmsi': mmsi, 'name': 'ABCDEFGHIJKLMNOPQRST'},
    ),

    // Type 6 / 8: binary payloads, variable length per spec.
    AuditCase(
      'binary addressed 4 bytes',
      6,
      encodeBinaryAddressed(
        mmsi: mmsi,
        destinationMmsi: 227000000,
        dac: 200,
        fid: 50,
        data: const [1, 2, 3, 255],
      ),
      const {'mmsi': mmsi, 'dest_mmsi': 227000000, 'dac': 200, 'fid': 50},
    ),
    AuditCase(
      'binary addressed empty data',
      6,
      encodeBinaryAddressed(mmsi: mmsi, destinationMmsi: 227000000),
      const {'mmsi': mmsi},
    ),
    AuditCase(
      'binary broadcast 3 bytes',
      8,
      encodeBinaryBroadcast(mmsi: mmsi, dac: 1, fid: 31, data: const [9, 8, 7]),
      const {'mmsi': mmsi, 'dac': 1, 'fid': 31},
    ),
    AuditCase(
      'binary broadcast 115 bytes',
      8,
      encodeBinaryBroadcast(
        mmsi: mmsi,
        dac: 1,
        fid: 31,
        data: List<int>.generate(115, (i) => i & 0xFF),
      ),
      const {'mmsi': mmsi},
    ),

    // Type 7 / 13: acknowledgements.
    AuditCase(
      'binary ack 2 targets',
      7,
      encodeBinaryAcknowledge(
        mmsi: mmsi,
        destinationMmsis: const [227000000, 227000001],
        sequenceNumbers: const [1, 2],
      ),
      const {'mmsi': mmsi},
    ),
    AuditCase(
      'safety ack 1 target',
      13,
      encodeSafetyAck(
        mmsi: mmsi,
        destinationMmsis: const [227000000],
        sequenceNumbers: const [3],
      ),
      const {'mmsi': mmsi},
    ),

    // Type 9 / 18 / 19 / 27: other position reports.
    AuditCase(
      'sar aircraft',
      9,
      encodeSarAircraftPosition(
        mmsi: 111234567,
        latitude: 48.5,
        longitude: -4.5,
        sog: 120,
        cog: 200,
        altitude: 500,
      ),
      const {'mmsi': 111234567, 'lat': 48.5, 'lon': -4.5},
    ),
    AuditCase(
      'class B position',
      18,
      encodeClassBPosition(
        mmsi: mmsi,
        latitude: 45.5,
        longitude: -1.5,
        sog: 6.5,
        cog: 90,
        heading: 92,
      ),
      const {'mmsi': mmsi, 'lat': 45.5, 'lon': -1.5},
    ),
    AuditCase(
      'class B extended',
      19,
      encodeClassBExtended(
        mmsi: mmsi,
        latitude: 44,
        longitude: -2,
        sog: 3,
        cog: 180,
        heading: 185,
        name: 'CLASSB',
        vesselType: 52,
      ),
      const {'mmsi': mmsi, 'name': 'CLASSB'},
    ),
    AuditCase(
      'long range',
      27,
      encodeLongRangeBroadcast(
        mmsi: mmsi,
        latitude: 41.5,
        longitude: 8.5,
        sog: 3.4,
        cog: 12.3,
      ),
      const {'mmsi': mmsi},
    ),

    // Type 10 / 12 / 14 / 15 / 16: inquiries and safety text.
    AuditCase(
      'utc date inquiry',
      10,
      encodeUtcDateInquiry(mmsi: mmsi, destinationMmsi: 227000000),
      const {'mmsi': mmsi, 'dest_mmsi': 227000000},
    ),
    AuditCase(
      'addressed safety',
      12,
      encodeAddressedSafety(
        mmsi: mmsi,
        destinationMmsi: 227000000,
        text: 'HELLO WORLD',
      ),
      const {'mmsi': mmsi, 'text': 'HELLO WORLD'},
    ),
    AuditCase(
      'safety broadcast',
      14,
      encodeSafetyBroadcast(mmsi: mmsi, text: 'WARNING'),
      const {'mmsi': mmsi, 'text': 'WARNING'},
    ),
    AuditCase(
      'interrogation',
      15,
      encodeInterrogation(
        mmsi: mmsi,
        mmsi1: 227000000,
        type1_1: 5,
        offset1_1: 100,
      ),
      const {'mmsi': mmsi},
    ),
    AuditCase(
      'assignment mode',
      16,
      encodeAssignmentMode(
        mmsi: mmsi,
        mmsi1: 227000000,
        offset1: 10,
        increment1: 3,
      ),
      const {'mmsi': mmsi},
    ),

    // Type 17 / 20 / 21 / 22 / 23 / 24: network and static data.
    AuditCase(
      'dgnss broadcast',
      17,
      encodeDgnssBroadcast(
        mmsi: mmsi,
        latitude: 47.5,
        longitude: -3.2,
        data: const [1, 2, 3],
      ),
      const {'mmsi': mmsi},
    ),
    AuditCase(
      'data link management',
      20,
      encodeDataLinkManagement(
        mmsi: mmsi,
        offset1: 10,
        number1: 2,
        timeout1: 3,
        increment1: 20,
      ),
      const {'mmsi': mmsi},
    ),
    AuditCase(
      'aid to navigation',
      21,
      encodeAidToNavigation(
        mmsi: 992262000,
        name: 'BUOY1',
        aidType: 1,
        latitude: 46.5,
        longitude: -3.5,
      ),
      const {'mmsi': 992262000, 'name': 'BUOY1'},
    ),
    AuditCase(
      'channel management',
      22,
      encodeChannelManagement(
        mmsi: 226000000,
        channelA: 2087,
        channelB: 2088,
        txrxMode: 0,
        neLatitude: 47.5,
        neLongitude: -3,
        swLatitude: 46.5,
        swLongitude: -4,
      ),
      const {'mmsi': 226000000},
    ),
    AuditCase(
      'group assignment',
      23,
      encodeGroupAssignment(
        mmsi: 226000000,
        neLatitude: 47.5,
        neLongitude: -3,
        swLatitude: 46.5,
        swLongitude: -4,
        stationType: 1,
        shipType: 70,
        txrxMode: 0,
        interval: 9,
      ),
      const {
        'mmsi': 226000000,
        'station_type': 1,
        'ship_type': 70,
        'interval': 9,
        '_raw_type23': true,
      },
    ),
    AuditCase(
      'group assignment ship type 200',
      23,
      encodeGroupAssignment(
        mmsi: 226000000,
        neLatitude: 47.5,
        neLongitude: -3,
        swLatitude: 46.5,
        swLongitude: -4,
        stationType: 2,
        shipType: 200,
        quietTime: 5,
      ),
      const {
        'mmsi': 226000000,
        'station_type': 2,
        'ship_type': 200,
        'quiet': 5,
        '_raw_type23': true,
      },
    ),
    AuditCase(
      'static data part A',
      24,
      encodeStaticDataReportPartA(mmsi: mmsi, name: 'KIKAIS'),
      const {'mmsi': mmsi, 'partno': 0},
    ),
    AuditCase(
      'static data part B',
      24,
      encodeStaticDataReportPartB(
        mmsi: mmsi,
        shipType: 70,
        callSign: 'FLO21',
        dimensionBow: 10,
        dimensionStern: 20,
      ),
      const {'mmsi': mmsi, 'partno': 1, 'ship_type': 70},
    ),

    // Type 25 / 26: binary slots.
    AuditCase(
      'single slot binary',
      25,
      encodeSingleSlotBinary(
        mmsi: mmsi,
        data: const [1, 2, 3, 4],
        destinationMmsi: 227000000,
        applicationId: (1, 31),
      ),
      const {'mmsi': mmsi, 'dest_mmsi': 227000000},
    ),
    AuditCase(
      'multiple slot binary',
      26,
      encodeMultipleSlotBinary(
        mmsi: mmsi,
        data: const [1, 2, 3, 4],
        destinationMmsi: 227000000,
        applicationId: (1, 31),
      ),
      const {'mmsi': mmsi, 'dest_mmsi': 227000000},
    ),

    // Defensive checks: values that must not corrupt the bit stream.
    AuditCase(
      'position longitude out of range',
      1,
      encodePositionReport(
        mmsi: mmsi,
        latitude: 0,
        longitude: 400,
        sog: 0,
        cog: 0,
        heading: 0,
      ),
      const {'mmsi': mmsi},
    ),
    AuditCase(
      'mmsi beyond 30 bits (expected: wrapped)',
      1,
      encodePositionReport(
        mmsi: 1111111111,
        latitude: 0,
        longitude: 0,
        sog: 0,
        cog: 0,
        heading: 0,
      ),
      const {},
    ),
  ];
  return scenarios;
}
