import 'ais/src/encoder/ais_message_encoder.dart';
import 'asm_registry.dart';
import 'l10n/generated/app_localizations.dart';

enum FieldKind { number, decimal, text, bytes, intList }

/// How the data field of a binary message (types 6/8/25/26) is built.
enum EditorDataSource {
  /// Pack the raw "Data bytes" field as typed.
  raw,

  /// Pack the matched ASM sub-fields.
  asm,
}

class FieldSpec {
  final String key;
  final String label;
  final FieldKind kind;
  final String defaultText;
  const FieldSpec(this.key, this.label, this.kind, [this.defaultText = '']);
}

/// Localized "N · `<message type name>`" used by the editor and the message
/// details view.
String editorMessageTypeLabel(int type, AppLocalizations l10n) {
  final name = switch (type) {
    1 => l10n.msgType1,
    2 => l10n.msgType2,
    3 => l10n.msgType3,
    4 => l10n.msgType4,
    5 => l10n.msgType5,
    6 => l10n.msgType6,
    7 => l10n.msgType7,
    8 => l10n.msgType8,
    9 => l10n.msgType9,
    10 => l10n.msgType10,
    11 => l10n.msgType11,
    12 => l10n.msgType12,
    13 => l10n.msgType13,
    14 => l10n.msgType14,
    15 => l10n.msgType15,
    16 => l10n.msgType16,
    17 => l10n.msgType17,
    18 => l10n.msgType18,
    19 => l10n.msgType19,
    20 => l10n.msgType20,
    21 => l10n.msgType21,
    22 => l10n.msgType22,
    23 => l10n.msgType23,
    24 => l10n.msgType24,
    25 => l10n.msgType25,
    26 => l10n.msgType26,
    27 => l10n.msgType27,
    _ => null,
  };
  if (name == null) return l10n.statsTypeFallback(type);
  return '$type · $name';
}

/// Localized label of an editor field, keyed by its English label. Falls back
/// to the English label when no translation exists.
String editorFieldLabel(AppLocalizations l10n, String english) {
  final localized = switch (english) {
    'MMSI' => l10n.fMmsi,
    'Latitude' => l10n.fLatitude,
    'Longitude' => l10n.fLongitude,
    'SOG (kn)' => l10n.fSogKn,
    'COG (°)' => l10n.fCogDeg,
    'Heading (°)' => l10n.fHeadingDeg,
    'Nav status (0-15)' => l10n.editorNavStatus0_15,
    'Year' => l10n.editorYear,
    'Month' => l10n.editorMonth,
    'Day' => l10n.editorDay,
    'Hour' => l10n.editorHour,
    'Minute' => l10n.editorMinute,
    'Second' => l10n.editorSecond,
    'Vessel name' => l10n.fVesselName,
    'Call sign' => l10n.fCallSign,
    'IMO number' => l10n.editorImoNumber,
    'Ship type' => l10n.fShipType,
    'Bow (m)' => l10n.editorBowM,
    'Stern (m)' => l10n.editorSternM,
    'Port (m)' => l10n.editorPortM,
    'Starboard (m)' => l10n.editorStarboardM,
    'ETA month' => l10n.editorEtaMonth,
    'ETA day' => l10n.editorEtaDay,
    'ETA hour' => l10n.editorEtaHour,
    'ETA minute' => l10n.editorEtaMinute,
    'Draught (m)' => l10n.fDraughtM,
    'Destination' => l10n.fDestination,
    'Destination MMSI' => l10n.fDestMmsi,
    'Sequence (0-3)' => l10n.editorSequence0_3,
    'DAC' => l10n.fDac,
    'FID' => l10n.fFid,
    'Data bytes (hex or 1,2,3)' => l10n.editorDataBytes,
    'Dest. MMSIs (comma)' => l10n.editorDestMmsisComma,
    'Sequences (comma)' => l10n.editorSequencesComma,
    'Altitude (m)' => l10n.fAltitudeM,
    'Text' => l10n.fText,
    'Interrogated MMSI' => l10n.editorInterrogatedMmsi,
    'Type 1' => l10n.editorType1,
    'Offset 1' => l10n.editorOffset1,
    'Target MMSI' => l10n.editorTargetMmsi,
    'Offset' => l10n.editorOffset,
    'Increment' => l10n.editorIncrement,
    'Number' => l10n.editorNumber,
    'Timeout' => l10n.editorTimeout,
    'Name' => l10n.fName,
    'Aid type (0-31)' => l10n.editorAidType0_31,
    'Virtual aid (0/1)' => l10n.editorVirtualAid0_1,
    'Channel A' => l10n.fChannelA,
    'Channel B' => l10n.fChannelB,
    'Tx/Rx mode (0-15)' => l10n.editorTxRxMode0_15,
    'Tx/Rx mode (0-3)' => l10n.editorTxRxMode0_3,
    'NE latitude' => l10n.editorNeLat,
    'NE longitude' => l10n.editorNeLon,
    'SW latitude' => l10n.editorSwLat,
    'SW longitude' => l10n.editorSwLon,
    'Interval (0-15)' => l10n.editorInterval0_15,
    'Part (0 = A name, 1 = B static)' => l10n.editorPart,
    'Destination MMSI (empty = broadcast)' => l10n.editorDestMmsiEmpty,
    'App DAC (empty = none)' => l10n.editorAppDacEmpty,
    'App FID (empty = none)' => l10n.editorAppFidEmpty,
    _ => english,
  };
  return localized;
}

const Map<int, String> kEditorTypeLabels = {
  1: '1 · Position Report Class A',
  2: '2 · Position Report Class A (assigned)',
  3: '3 · Position Report Class A (response)',
  4: '4 · Base Station',
  5: '5 · Static and Voyage',
  6: '6 · Binary Addressed',
  7: '7 · Binary Acknowledge',
  8: '8 · Binary Broadcast',
  9: '9 · SAR Aircraft Position',
  10: '10 · UTC/Date Inquiry',
  11: '11 · UTC/Date Response',
  12: '12 · Addressed Safety',
  13: '13 · Safety Acknowledgement',
  14: '14 · Safety Broadcast',
  15: '15 · Interrogation',
  16: '16 · Assignment Mode',
  17: '17 · DGNSS Broadcast',
  18: '18 · Class B Position',
  19: '19 · Class B Extended',
  20: '20 · Data Link Mgmt',
  21: '21 · Aid to Navigation',
  22: '22 · Channel Mgmt',
  23: '23 · Group Assignment',
  24: '24 · Static Data',
  25: '25 · Single Slot Binary',
  26: '26 · Multiple Slot Binary',
  27: '27 · Long Range Position',
};

const List<FieldSpec> _mmsi = [
  FieldSpec('mmsi', 'MMSI', FieldKind.number, '226545000'),
];

List<FieldSpec> fieldsForType(int type) {
  switch (type) {
    case 1 || 2 || 3:
      return [
        ..._mmsi,
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '48.85'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '1.05'),
        const FieldSpec('sog', 'SOG (kn)', FieldKind.decimal, '12'),
        const FieldSpec('cog', 'COG (°)', FieldKind.decimal, '250'),
        const FieldSpec('heading', 'Heading (°)', FieldKind.decimal, '90'),
        const FieldSpec(
          'navigationStatus',
          'Nav status (0-15)',
          FieldKind.number,
          '0',
        ),
      ];
    case 4 || 11:
      return [
        ..._mmsi,
        const FieldSpec('year', 'Year', FieldKind.number, '2026'),
        const FieldSpec('month', 'Month', FieldKind.number, '8'),
        const FieldSpec('day', 'Day', FieldKind.number, '6'),
        const FieldSpec('hour', 'Hour', FieldKind.number, '12'),
        const FieldSpec('minute', 'Minute', FieldKind.number, '30'),
        const FieldSpec('second', 'Second', FieldKind.number, '0'),
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '47.5'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '-3.2'),
      ];
    case 5:
      return [
        ..._mmsi,
        const FieldSpec('name', 'Vessel name', FieldKind.text, 'KIKAIS'),
        const FieldSpec('callSign', 'Call sign', FieldKind.text, 'FLO21'),
        const FieldSpec('imoNumber', 'IMO number', FieldKind.number, '0'),
        const FieldSpec('vesselType', 'Ship type', FieldKind.number, '70'),
        const FieldSpec('dimensionBow', 'Bow (m)', FieldKind.number, '0'),
        const FieldSpec('dimensionStern', 'Stern (m)', FieldKind.number, '0'),
        const FieldSpec('dimensionPort', 'Port (m)', FieldKind.number, '0'),
        const FieldSpec(
          'dimensionStarboard',
          'Starboard (m)',
          FieldKind.number,
          '0',
        ),
        const FieldSpec('etaMonth', 'ETA month', FieldKind.number, '0'),
        const FieldSpec('etaDay', 'ETA day', FieldKind.number, '0'),
        const FieldSpec('etaHour', 'ETA hour', FieldKind.number, '24'),
        const FieldSpec('etaMinute', 'ETA minute', FieldKind.number, '60'),
        const FieldSpec('draught', 'Draught (m)', FieldKind.decimal, '0'),
        const FieldSpec('destination', 'Destination', FieldKind.text, 'BREST'),
      ];
    case 6:
      return [
        ..._mmsi,
        const FieldSpec(
          'destinationMmsi',
          'Destination MMSI',
          FieldKind.number,
          '227000000',
        ),
        const FieldSpec(
          'sequenceNumber',
          'Sequence (0-3)',
          FieldKind.number,
          '0',
        ),
        const FieldSpec('dac', 'DAC', FieldKind.number, '0'),
        const FieldSpec('fid', 'FID', FieldKind.number, '0'),
        const FieldSpec(
          'data',
          'Data bytes (hex or 1,2,3)',
          FieldKind.bytes,
          '',
        ),
      ];
    case 7 || 13:
      return [
        ..._mmsi,
        const FieldSpec(
          'destinationMmsis',
          'Dest. MMSIs (comma)',
          FieldKind.intList,
          '227000000,0,0,0',
        ),
        const FieldSpec(
          'sequenceNumbers',
          'Sequences (comma)',
          FieldKind.intList,
          '0,0,0,0',
        ),
      ];
    case 8:
      return [
        ..._mmsi,
        const FieldSpec('dac', 'DAC', FieldKind.number, '0'),
        const FieldSpec('fid', 'FID', FieldKind.number, '0'),
        const FieldSpec(
          'data',
          'Data bytes (hex or 1,2,3)',
          FieldKind.bytes,
          '',
        ),
      ];
    case 9:
      return [
        ..._mmsi,
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '48.5'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '-4.5'),
        const FieldSpec('sog', 'SOG (kn)', FieldKind.number, '0'),
        const FieldSpec('cog', 'COG (°)', FieldKind.decimal, '200'),
        const FieldSpec('altitude', 'Altitude (m)', FieldKind.number, '0'),
      ];
    case 10:
      return [
        ..._mmsi,
        const FieldSpec(
          'destinationMmsi',
          'Destination MMSI',
          FieldKind.number,
          '227000000',
        ),
      ];
    case 12:
      return [
        ..._mmsi,
        const FieldSpec(
          'destinationMmsi',
          'Destination MMSI',
          FieldKind.number,
          '227000000',
        ),
        const FieldSpec(
          'sequenceNumber',
          'Sequence (0-3)',
          FieldKind.number,
          '0',
        ),
        const FieldSpec('text', 'Text', FieldKind.text, 'HELLO'),
      ];
    case 14:
      return [
        ..._mmsi,
        const FieldSpec('text', 'Text', FieldKind.text, 'WARNING'),
      ];
    case 15:
      return [
        ..._mmsi,
        const FieldSpec(
          'mmsi1',
          'Interrogated MMSI',
          FieldKind.number,
          '227000000',
        ),
        const FieldSpec('type1_1', 'Type 1', FieldKind.number, '5'),
        const FieldSpec('offset1_1', 'Offset 1', FieldKind.number, '0'),
      ];
    case 16:
      return [
        ..._mmsi,
        const FieldSpec('mmsi1', 'Target MMSI', FieldKind.number, '227000000'),
        const FieldSpec('offset1', 'Offset', FieldKind.number, '0'),
        const FieldSpec('increment1', 'Increment', FieldKind.number, '0'),
      ];
    case 17:
      return [
        ..._mmsi,
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '47.5'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '-3.2'),
        const FieldSpec(
          'data',
          'Data bytes (hex or 1,2,3)',
          FieldKind.bytes,
          '',
        ),
      ];
    case 18:
      return [
        ..._mmsi,
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '45.5'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '-1.5'),
        const FieldSpec('sog', 'SOG (kn)', FieldKind.decimal, '6.5'),
        const FieldSpec('cog', 'COG (°)', FieldKind.decimal, '90'),
        const FieldSpec('heading', 'Heading (°)', FieldKind.decimal, '92'),
      ];
    case 19:
      return [
        ..._mmsi,
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '44.0'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '-2.0'),
        const FieldSpec('sog', 'SOG (kn)', FieldKind.decimal, '3'),
        const FieldSpec('cog', 'COG (°)', FieldKind.decimal, '180'),
        const FieldSpec('heading', 'Heading (°)', FieldKind.decimal, '185'),
        const FieldSpec('name', 'Vessel name', FieldKind.text, 'CLASSB'),
        const FieldSpec('vesselType', 'Ship type', FieldKind.number, '52'),
      ];
    case 20:
      return [
        ..._mmsi,
        const FieldSpec('offset1', 'Offset', FieldKind.number, '0'),
        const FieldSpec('number1', 'Number', FieldKind.number, '0'),
        const FieldSpec('timeout1', 'Timeout', FieldKind.number, '0'),
        const FieldSpec('increment1', 'Increment', FieldKind.number, '0'),
      ];
    case 21:
      return [
        ..._mmsi,
        const FieldSpec('name', 'Name', FieldKind.text, 'BUOY1'),
        const FieldSpec('aidType', 'Aid type (0-31)', FieldKind.number, '1'),
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '46.5'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '-3.5'),
        const FieldSpec(
          'virtualAid',
          'Virtual aid (0/1)',
          FieldKind.number,
          '0',
        ),
      ];
    case 22:
      return [
        ..._mmsi,
        const FieldSpec('channelA', 'Channel A', FieldKind.number, '2087'),
        const FieldSpec('channelB', 'Channel B', FieldKind.number, '2088'),
        const FieldSpec('txrxMode', 'Tx/Rx mode (0-15)', FieldKind.number, '0'),
        const FieldSpec('neLatitude', 'NE latitude', FieldKind.decimal, '47.5'),
        const FieldSpec(
          'neLongitude',
          'NE longitude',
          FieldKind.decimal,
          '-3.0',
        ),
        const FieldSpec('swLatitude', 'SW latitude', FieldKind.decimal, '46.5'),
        const FieldSpec(
          'swLongitude',
          'SW longitude',
          FieldKind.decimal,
          '-4.0',
        ),
      ];
    case 23:
      return [
        ..._mmsi,
        const FieldSpec('neLatitude', 'NE latitude', FieldKind.decimal, '47.5'),
        const FieldSpec(
          'neLongitude',
          'NE longitude',
          FieldKind.decimal,
          '-3.0',
        ),
        const FieldSpec('swLatitude', 'SW latitude', FieldKind.decimal, '46.5'),
        const FieldSpec(
          'swLongitude',
          'SW longitude',
          FieldKind.decimal,
          '-4.0',
        ),
        const FieldSpec('txrxMode', 'Tx/Rx mode (0-3)', FieldKind.number, '0'),
        const FieldSpec('interval', 'Interval (0-15)', FieldKind.number, '0'),
      ];
    case 24:
      return [
        ..._mmsi,
        const FieldSpec(
          'part',
          'Part (0 = A name, 1 = B static)',
          FieldKind.number,
          '0',
        ),
        const FieldSpec('name', 'Vessel name', FieldKind.text, 'KIKAIS'),
        const FieldSpec('shipType', 'Ship type', FieldKind.number, '70'),
        const FieldSpec('callSign', 'Call sign', FieldKind.text, 'FLO21'),
      ];
    case 25 || 26:
      return [
        ..._mmsi,
        const FieldSpec(
          'destinationMmsi',
          'Destination MMSI (empty = broadcast)',
          FieldKind.number,
          '',
        ),
        const FieldSpec(
          'appDac',
          'App DAC (empty = none)',
          FieldKind.number,
          '',
        ),
        const FieldSpec(
          'appFid',
          'App FID (empty = none)',
          FieldKind.number,
          '',
        ),
        const FieldSpec(
          'data',
          'Data bytes (hex or 1,2,3)',
          FieldKind.bytes,
          '',
        ),
      ];
    case 27:
      return [
        ..._mmsi,
        const FieldSpec('latitude', 'Latitude', FieldKind.decimal, '41.5'),
        const FieldSpec('longitude', 'Longitude', FieldKind.decimal, '8.5'),
        const FieldSpec('sog', 'SOG (kn)', FieldKind.decimal, '3.4'),
        const FieldSpec('cog', 'COG (°)', FieldKind.decimal, '12.3'),
      ];
    default:
      return [..._mmsi];
  }
}

List<int> _parseBytes(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return const [];
  if (s.contains(',')) {
    return s.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
  }
  if (RegExp(r'^[0-9a-fA-F]+$').hasMatch(s) && s.length.isEven) {
    final out = <int>[];
    for (var i = 0; i < s.length; i += 2) {
      out.add(int.parse(s.substring(i, i + 2), radix: 16));
    }
    return out;
  }
  return s.split('').map((e) => int.tryParse(e) ?? 0).toList();
}

/// DAC that selects an ASM for binary message [type], or null when absent.
int? asmDacFor(int type, Map<String, dynamic> values) {
  if (type == 25 || type == 26) return _v(values, 'appDac', null) as int?;
  if (type == 6 || type == 8) return _v(values, 'dac', null) as int?;
  return null;
}

/// FID that selects an ASM for binary message [type], or null when absent.
int? asmFidFor(int type, Map<String, dynamic> values) {
  if (type == 25 || type == 26) return _v(values, 'appFid', null) as int?;
  if (type == 6 || type == 8) return _v(values, 'fid', null) as int?;
  return null;
}

/// The ASM matched by the current DAC/FID of a binary message, or null.
AsmFormat? asmFormatFor(int type, Map<String, dynamic> values) {
  final dac = asmDacFor(type, values);
  final fid = asmFidFor(type, values);
  if (dac == null || fid == null) return null;
  return asmForMessage(type, dac, fid);
}

/// The editor fields for the sub-fields of [format], keyed `asm.<fieldKey>`.
List<FieldSpec> asmFieldsFor(AsmFormat format) {
  return [
    for (final f in format.fields)
      FieldSpec(
        'asm.${f.key}',
        f.unit == null ? f.name : '${f.name} (${f.unit})',
        switch (f.kind) {
          AsmFieldKind.text6 || AsmFieldKind.freeText => FieldKind.text,
          AsmFieldKind.data => FieldKind.bytes,
          _ => FieldKind.number,
        },
        '',
      ),
  ];
}

/// Packs the ASM sub-fields in [values] into the message data bytes.
List<int> asmBytesFor(AsmFormat format, Map<String, dynamic> values) =>
    packAsmData(format, values);

List<int> _parseIntList(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return const [];
  return s.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
}

dynamic _parse(FieldSpec spec, String raw) {
  switch (spec.kind) {
    case FieldKind.number:
      return int.tryParse(raw.trim());
    case FieldKind.decimal:
      return double.tryParse(raw.trim());
    case FieldKind.text:
      return raw;
    case FieldKind.bytes:
      return _parseBytes(raw);
    case FieldKind.intList:
      return _parseIntList(raw);
  }
}

dynamic _v(Map<String, dynamic> values, String key, dynamic fallback) {
  return values[key] ?? fallback;
}

int _iv(Map<String, dynamic> values, String key, int fallback) {
  final v = values[key];
  return v is num ? v.toInt() : fallback;
}

double _dv(Map<String, dynamic> values, String key, double fallback) {
  final v = values[key];
  return v is num ? v.toDouble() : fallback;
}

String _sv(Map<String, dynamic> values, String key, String fallback) {
  final v = values[key];
  return v is String ? v : fallback;
}

List<int> _bv(Map<String, dynamic> values, String key) {
  final v = values[key];
  return v is List<int> ? v : const [];
}

List<int> _lv(Map<String, dynamic> values, String key) {
  final v = values[key];
  return v is List<int> ? v : const [];
}

/// Data bytes for a binary message. When [dataSource] is [EditorDataSource.asm]
/// and an ASM with a documented layout is matched by the DAC/FID, the ASM
/// sub-fields are packed; otherwise the raw "Data bytes" field is used.
List<int> _binaryData(
  Map<String, dynamic> values,
  int type,
  EditorDataSource dataSource,
) {
  final asm = asmFormatFor(type, values);
  if (dataSource == EditorDataSource.asm && asm != null && asm.hasLayout) {
    return asmBytesFor(asm, values);
  }
  return _bv(values, 'data');
}

/// Dispatches to the correct encoder for the given message type.
String encodeMessage(
  int type,
  Map<String, dynamic> values, {
  EditorDataSource dataSource = EditorDataSource.asm,
}) {
  final mmsi = _iv(values, 'mmsi', 226545000);
  switch (type) {
    case 1 || 2 || 3:
      return encodePositionReport(
        type: type,
        mmsi: mmsi,
        latitude: _dv(values, 'latitude', 48.85),
        longitude: _dv(values, 'longitude', 1.05),
        sog: _dv(values, 'sog', 0),
        cog: _dv(values, 'cog', 0),
        heading: _dv(values, 'heading', 0),
        navigationStatus: _iv(values, 'navigationStatus', 0),
      );
    case 4:
      return encodeBaseStationReport(
        mmsi: mmsi,
        year: _iv(values, 'year', 2026),
        month: _iv(values, 'month', 1),
        day: _iv(values, 'day', 1),
        hour: _iv(values, 'hour', 0),
        minute: _iv(values, 'minute', 0),
        second: _iv(values, 'second', 0),
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
      );
    case 5:
      return encodeStaticAndVoyage(
        mmsi: mmsi,
        name: _sv(values, 'name', ''),
        callSign: _sv(values, 'callSign', ''),
        imoNumber: _iv(values, 'imoNumber', 0),
        vesselType: _iv(values, 'vesselType', 70),
        dimensionBow: _iv(values, 'dimensionBow', 0),
        dimensionStern: _iv(values, 'dimensionStern', 0),
        dimensionPort: _iv(values, 'dimensionPort', 0),
        dimensionStarboard: _iv(values, 'dimensionStarboard', 0),
        etaMonth: _iv(values, 'etaMonth', 0),
        etaDay: _iv(values, 'etaDay', 0),
        etaHour: _iv(values, 'etaHour', 24),
        etaMinute: _iv(values, 'etaMinute', 60),
        draught: _dv(values, 'draught', 0),
        destination: _sv(values, 'destination', ''),
      );
    case 6:
      return encodeBinaryAddressed(
        mmsi: mmsi,
        destinationMmsi: _iv(values, 'destinationMmsi', 0),
        sequenceNumber: _iv(values, 'sequenceNumber', 0),
        dac: _iv(values, 'dac', 0),
        fid: _iv(values, 'fid', 0),
        data: _binaryData(values, type, dataSource),
      );
    case 7:
      return encodeBinaryAcknowledge(
        mmsi: mmsi,
        destinationMmsis: _lv(values, 'destinationMmsis'),
        sequenceNumbers: _lv(values, 'sequenceNumbers'),
      );
    case 8:
      return encodeBinaryBroadcast(
        mmsi: mmsi,
        dac: _iv(values, 'dac', 0),
        fid: _iv(values, 'fid', 0),
        data: _binaryData(values, type, dataSource),
      );
    case 9:
      return encodeSarAircraftPosition(
        mmsi: mmsi,
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
        cog: _dv(values, 'cog', 0),
        sog: _iv(values, 'sog', 0),
        altitude: _iv(values, 'altitude', 0),
      );
    case 10:
      return encodeUtcDateInquiry(
        mmsi: mmsi,
        destinationMmsi: _iv(values, 'destinationMmsi', 0),
      );
    case 11:
      return encodeUtcDateResponse(
        mmsi: mmsi,
        year: _iv(values, 'year', 2026),
        month: _iv(values, 'month', 1),
        day: _iv(values, 'day', 1),
        hour: _iv(values, 'hour', 0),
        minute: _iv(values, 'minute', 0),
        second: _iv(values, 'second', 0),
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
      );
    case 12:
      return encodeAddressedSafety(
        mmsi: mmsi,
        destinationMmsi: _iv(values, 'destinationMmsi', 0),
        sequenceNumber: _iv(values, 'sequenceNumber', 0),
        text: _sv(values, 'text', ''),
      );
    case 13:
      return encodeSafetyAck(
        mmsi: mmsi,
        destinationMmsis: _lv(values, 'destinationMmsis'),
        sequenceNumbers: _lv(values, 'sequenceNumbers'),
      );
    case 14:
      return encodeSafetyBroadcast(mmsi: mmsi, text: _sv(values, 'text', ''));
    case 15:
      return encodeInterrogation(
        mmsi: mmsi,
        mmsi1: _iv(values, 'mmsi1', 0),
        type1_1: _iv(values, 'type1_1', 0),
        offset1_1: _iv(values, 'offset1_1', 0),
      );
    case 16:
      return encodeAssignmentMode(
        mmsi: mmsi,
        mmsi1: _iv(values, 'mmsi1', 0),
        offset1: _iv(values, 'offset1', 0),
        increment1: _iv(values, 'increment1', 0),
      );
    case 17:
      return encodeDgnssBroadcast(
        mmsi: mmsi,
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
        data: _binaryData(values, type, dataSource),
      );
    case 18:
      return encodeClassBPosition(
        mmsi: mmsi,
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
        sog: _dv(values, 'sog', 0),
        cog: _dv(values, 'cog', 0),
        heading: _dv(values, 'heading', 0),
      );
    case 19:
      return encodeClassBExtended(
        mmsi: mmsi,
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
        sog: _dv(values, 'sog', 0),
        cog: _dv(values, 'cog', 0),
        heading: _dv(values, 'heading', 0),
        name: _sv(values, 'name', ''),
        vesselType: _iv(values, 'vesselType', 0),
      );
    case 20:
      return encodeDataLinkManagement(
        mmsi: mmsi,
        offset1: _iv(values, 'offset1', 0),
        number1: _iv(values, 'number1', 0),
        timeout1: _iv(values, 'timeout1', 0),
        increment1: _iv(values, 'increment1', 0),
      );
    case 21:
      return encodeAidToNavigation(
        mmsi: mmsi,
        name: _sv(values, 'name', ''),
        aidType: _iv(values, 'aidType', 0),
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
        virtualAid: _iv(values, 'virtualAid', 0),
      );
    case 22:
      return encodeChannelManagement(
        mmsi: mmsi,
        channelA: _iv(values, 'channelA', 2087),
        channelB: _iv(values, 'channelB', 2088),
        txrxMode: _iv(values, 'txrxMode', 0),
        neLatitude: _dv(values, 'neLatitude', 0),
        neLongitude: _dv(values, 'neLongitude', 0),
        swLatitude: _dv(values, 'swLatitude', 0),
        swLongitude: _dv(values, 'swLongitude', 0),
      );
    case 23:
      return encodeGroupAssignment(
        mmsi: mmsi,
        neLatitude: _dv(values, 'neLatitude', 0),
        neLongitude: _dv(values, 'neLongitude', 0),
        swLatitude: _dv(values, 'swLatitude', 0),
        swLongitude: _dv(values, 'swLongitude', 0),
        txrxMode: _iv(values, 'txrxMode', 0),
        interval: _iv(values, 'interval', 0),
      );
    case 24:
      return _iv(values, 'part', 0) == 1
          ? encodeStaticDataReportPartB(
              mmsi: mmsi,
              shipType: _iv(values, 'shipType', 70),
              callSign: _sv(values, 'callSign', ''),
            )
          : encodeStaticDataReportPartA(
              mmsi: mmsi,
              name: _sv(values, 'name', ''),
            );
    case 25:
      return encodeSingleSlotBinary(
        mmsi: mmsi,
        data: _binaryData(values, type, dataSource),
        destinationMmsi: _v(values, 'destinationMmsi', null) as int?,
        applicationId: _v(values, 'appDac', null) != null
            ? (_iv(values, 'appDac', 0), _iv(values, 'appFid', 0))
            : null,
      );
    case 26:
      return encodeMultipleSlotBinary(
        mmsi: mmsi,
        data: _binaryData(values, type, dataSource),
        destinationMmsi: _v(values, 'destinationMmsi', null) as int?,
        applicationId: _v(values, 'appDac', null) != null
            ? (_iv(values, 'appDac', 0), _iv(values, 'appFid', 0))
            : null,
      );
    case 27:
      return encodeLongRangeBroadcast(
        mmsi: mmsi,
        latitude: _dv(values, 'latitude', 0),
        longitude: _dv(values, 'longitude', 0),
        sog: _dv(values, 'sog', 0),
        cog: _dv(values, 'cog', 0),
      );
    default:
      return encodePositionReport(
        mmsi: mmsi,
        latitude: 0,
        longitude: 0,
        sog: 0,
        cog: 0,
        heading: 0,
      );
  }
}

/// Parses raw field text into a typed value, or null when empty/invalid.
dynamic parseField(FieldSpec spec, String raw) => _parse(spec, raw);
