import 'ais_payload_encoder.dart';

String _bits(int value, int width) =>
    (value & ((1 << width) - 1)).toRadixString(2).padLeft(width, '0');

int _signed(int value, int bits) => value < 0 ? value + (1 << bits) : value;

/// Scales [degrees] to the field's integer units, clamped to the signed range
/// of [bits] so an out-of-range input cannot shift the rest of the message.
String _coord(double degrees, int scale, int bits) {
  final max = (1 << (bits - 1)) - 1;
  final scaled = (degrees * scale).round().clamp(-max - 1, max);
  return _bits(scaled, bits);
}

String _bytesToBits(List<int> bytes) {
  final sb = StringBuffer();
  for (final b in bytes) {
    sb.write(_bits(b, 8));
  }
  return sb.toString();
}

/// Writes [data] as an 8-bit aligned bit string, truncated to [capacityBits]
/// so a binary message can never exceed the maximum length of its type.
String _binaryPayload(List<int> data, int capacityBits) {
  final maxBytes = capacityBits ~/ 8;
  final bytes = data.length > maxBytes ? data.sublist(0, maxBytes) : data;
  return _bytesToBits(bytes);
}

/// Encodes a free-text field that runs to the end of the message: only the
/// characters actually typed are written, so a short text yields a short
/// message instead of a payload padded with `@` up to the maximum length.
String _trailingText(String text, {int maxChars = 0}) {
  final clipped = maxChars > 0 && text.length > maxChars
      ? text.substring(0, maxChars)
      : text;
  return encodeAisText(clipped, clipped.length * 6);
}

String _head({required int type, required int mmsi}) {
  final sb = StringBuffer();
  sb.write(_bits(type, 6));
  sb.write(_bits(0, 2)); // repeat indicator
  sb.write(_bits(mmsi, 30));
  return sb.toString();
}

String _baseStationLike({
  required int type,
  required int mmsi,
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  required int second,
  required double latitude,
  required double longitude,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: type, mmsi: mmsi));
  sb.write(_bits(year.clamp(0, 16383), 14));
  sb.write(_bits(month.clamp(0, 15), 4));
  sb.write(_bits(day.clamp(0, 31), 5));
  sb.write(_bits(hour.clamp(0, 31), 5));
  sb.write(_bits(minute.clamp(0, 63), 6));
  sb.write(_bits(second.clamp(0, 63), 6));
  sb.write(_bits(0, 1)); // accuracy
  sb.write(_coord(longitude, 600000, 28));
  sb.write(_coord(latitude, 600000, 27));
  sb.write(_bits(0, 4)); // EPFD fix type
  sb.write(_bits(0, 10)); // spare
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(0, 19)); // SOTDMA state
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 1/2/3 position report sentence.
String encodePositionReport({
  required int mmsi,
  required double latitude,
  required double longitude,
  required double sog,
  required double cog,
  required double heading,
  int navigationStatus = 0,
  int positionAccuracy = 0,
  int rot = 0,
  int timestamp = 0,
  int type = 1,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: type.clamp(1, 3), mmsi: mmsi));
  sb.write(_bits(navigationStatus.clamp(0, 15), 4));
  sb.write(_bits(_signed(rot.clamp(-128, 127), 8), 8)); // rate of turn
  sb.write(_bits((sog * 10).round().clamp(0, 1023), 10));
  sb.write(_bits(positionAccuracy.clamp(0, 1), 1)); // position accuracy
  sb.write(_coord(longitude, 600000, 28));
  sb.write(_coord(latitude, 600000, 27));
  sb.write(_bits((cog * 10).round().clamp(0, 3600), 12));
  sb.write(_bits(heading.round().clamp(0, 511), 9));
  sb.write(_bits(timestamp.clamp(0, 63), 6));
  sb.write(_bits(0, 2)); // maneuver indicator
  sb.write(_bits(0, 3)); // spare
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(0, 19)); // radio
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 4 base station report sentence.
String encodeBaseStationReport({
  required int mmsi,
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  required int second,
  required double latitude,
  required double longitude,
}) => _baseStationLike(
  type: 4,
  mmsi: mmsi,
  year: year,
  month: month,
  day: day,
  hour: hour,
  minute: minute,
  second: second,
  latitude: latitude,
  longitude: longitude,
);

/// Encodes a Type 5 static and voyage related data sentence (424 bits).
String encodeStaticAndVoyage({
  required int mmsi,
  required String name,
  required String callSign,
  int imoNumber = 0,
  int vesselType = 70,
  int dimensionBow = 0,
  int dimensionStern = 0,
  int dimensionPort = 0,
  int dimensionStarboard = 0,
  int etaMonth = 0,
  int etaDay = 0,
  int etaHour = 24,
  int etaMinute = 60,
  double draught = 0,
  String destination = '',
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 5, mmsi: mmsi));
  sb.write(_bits(0, 2)); // AIS version
  sb.write(_bits(imoNumber.clamp(0, 1073741823), 30));
  sb.write(encodeAisText(callSign, 42));
  sb.write(encodeAisText(name, 120));
  sb.write(_bits(vesselType.clamp(0, 255), 8));
  sb.write(_bits(dimensionBow.clamp(0, 511), 9));
  sb.write(_bits(dimensionStern.clamp(0, 511), 9));
  sb.write(_bits(dimensionPort.clamp(0, 63), 6));
  sb.write(_bits(dimensionStarboard.clamp(0, 63), 6));
  sb.write(_bits(0, 4)); // EPFD fix type
  sb.write(_bits(etaMonth.clamp(0, 15), 4));
  sb.write(_bits(etaDay.clamp(0, 31), 5));
  sb.write(_bits(etaHour.clamp(0, 31), 5));
  sb.write(_bits(etaMinute.clamp(0, 63), 6));
  sb.write(_bits((draught * 10).round().clamp(0, 255), 8));
  sb.write(encodeAisText(destination, 120));
  sb.write(_bits(0, 1)); // DTE
  sb.write(_bits(0, 1)); // spare
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 6 binary addressed message sentence (88-1008 bits).
String encodeBinaryAddressed({
  required int mmsi,
  required int destinationMmsi,
  int sequenceNumber = 0,
  int retransmit = 0,
  int dac = 0,
  int fid = 0,
  List<int> data = const [],
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 6, mmsi: mmsi));
  sb.write(_bits(sequenceNumber.clamp(0, 3), 2));
  sb.write(_bits(destinationMmsi, 30));
  sb.write(_bits(retransmit.clamp(0, 1), 1));
  sb.write(_bits(0, 1)); // spare
  sb.write(_bits(dac.clamp(0, 1023), 10));
  sb.write(_bits(fid.clamp(0, 63), 6));
  sb.write(_binaryPayload(data, 1008 - 88));
  return buildNmeaSentence(sb.toString());
}

String _acknowledgeLike({
  required int type,
  required int mmsi,
  required List<int> destMmsis,
  required List<int> seqs,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: type, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  final pairs = destMmsis.isEmpty
      ? 1
      : (destMmsis.length > 4 ? 4 : destMmsis.length);
  for (var i = 0; i < pairs; i++) {
    final dest = i < destMmsis.length ? destMmsis[i] : 0;
    final seq = i < seqs.length ? seqs[i] : 0;
    sb.write(_bits(dest, 30));
    sb.write(_bits(seq.clamp(0, 3), 2));
  }
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 7 binary acknowledge sentence (72-168 bits).
String encodeBinaryAcknowledge({
  required int mmsi,
  List<int> destinationMmsis = const [],
  List<int> sequenceNumbers = const [],
}) => _acknowledgeLike(
  type: 7,
  mmsi: mmsi,
  destMmsis: destinationMmsis,
  seqs: sequenceNumbers,
);

/// Encodes a Type 8 binary broadcast message sentence (56-1008 bits).
String encodeBinaryBroadcast({
  required int mmsi,
  int dac = 0,
  int fid = 0,
  List<int> data = const [],
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 8, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_bits(dac.clamp(0, 1023), 10));
  sb.write(_bits(fid.clamp(0, 63), 6));
  sb.write(_binaryPayload(data, 1008 - 56));
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 9 SAR aircraft position report sentence (168 bits).
String encodeSarAircraftPosition({
  required int mmsi,
  required double latitude,
  required double longitude,
  required double cog,
  int altitude = 0,
  int sog = 0,
  int positionAccuracy = 0,
  int timestamp = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 9, mmsi: mmsi));
  sb.write(_bits(altitude.clamp(0, 4095), 12));
  sb.write(_bits(sog.clamp(0, 1023), 10));
  sb.write(_bits(positionAccuracy.clamp(0, 1), 1)); // position accuracy
  sb.write(_coord(longitude, 600000, 28));
  sb.write(_coord(latitude, 600000, 27));
  sb.write(_bits((cog * 10).round().clamp(0, 3600), 12));
  sb.write(_bits(timestamp.clamp(0, 63), 6));
  sb.write(_bits(0, 8)); // regional reserved
  sb.write(_bits(0, 1)); // DTE
  sb.write(_bits(0, 3)); // spare
  sb.write(_bits(0, 1)); // assigned mode
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(0, 20)); // radio
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 10 UTC/date inquiry sentence (72 bits).
String encodeUtcDateInquiry({required int mmsi, required int destinationMmsi}) {
  final sb = StringBuffer();
  sb.write(_head(type: 10, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_bits(destinationMmsi, 30));
  sb.write(_bits(0, 2)); // spare
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 11 UTC/date response sentence (168 bits).
String encodeUtcDateResponse({
  required int mmsi,
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  required int second,
  required double latitude,
  required double longitude,
}) => _baseStationLike(
  type: 11,
  mmsi: mmsi,
  year: year,
  month: month,
  day: day,
  hour: hour,
  minute: minute,
  second: second,
  latitude: latitude,
  longitude: longitude,
);

/// Encodes a Type 12 addressed safety related message (72-1008 bits).
String encodeAddressedSafety({
  required int mmsi,
  required int destinationMmsi,
  String text = '',
  int sequenceNumber = 0,
  int retransmit = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 12, mmsi: mmsi));
  sb.write(_bits(sequenceNumber.clamp(0, 3), 2));
  sb.write(_bits(destinationMmsi, 30));
  sb.write(_bits(retransmit.clamp(0, 1), 1));
  sb.write(_bits(0, 1)); // spare
  sb.write(_trailingText(text, maxChars: 156));
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 13 safety related acknowledgement (168 bits).
String encodeSafetyAck({
  required int mmsi,
  List<int> destinationMmsis = const [],
  List<int> sequenceNumbers = const [],
}) => _acknowledgeLike(
  type: 13,
  mmsi: mmsi,
  destMmsis: destinationMmsis,
  seqs: sequenceNumbers,
);

/// Encodes a Type 14 safety related broadcast message (40-1008 bits).
String encodeSafetyBroadcast({required int mmsi, String text = ''}) {
  final sb = StringBuffer();
  sb.write(_head(type: 14, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_trailingText(text, maxChars: 161));
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 15 interrogation sentence (88-160 bits).
String encodeInterrogation({
  required int mmsi,
  required int mmsi1,
  int type1_1 = 0,
  int offset1_1 = 0,
  int type1_2 = 0,
  int offset1_2 = 0,
  int mmsi2 = 0,
  int type2_1 = 0,
  int offset2_1 = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 15, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_bits(mmsi1, 30));
  sb.write(_bits(type1_1.clamp(0, 63), 6));
  sb.write(_bits(offset1_1.clamp(0, 4095), 12));
  if (mmsi2 != 0) {
    sb.write(_bits(0, 2)); // spare
    sb.write(_bits(type1_2.clamp(0, 63), 6));
    sb.write(_bits(offset1_2.clamp(0, 4095), 12));
    sb.write(_bits(0, 2)); // spare
    sb.write(_bits(mmsi2, 30));
    sb.write(_bits(type2_1.clamp(0, 63), 6));
    sb.write(_bits(offset2_1.clamp(0, 4095), 12));
    sb.write(_bits(0, 2)); // spare
  }
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 16 assignment mode command sentence (96-144 bits).
String encodeAssignmentMode({
  required int mmsi,
  required int mmsi1,
  int offset1 = 0,
  int increment1 = 0,
  int mmsi2 = 0,
  int offset2 = 0,
  int increment2 = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 16, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_bits(mmsi1, 30));
  sb.write(_bits(offset1.clamp(0, 4095), 12));
  sb.write(_bits(increment1.clamp(0, 1023), 10));
  if (mmsi2 != 0) {
    sb.write(_bits(mmsi2, 30));
    sb.write(_bits(offset2.clamp(0, 4095), 12));
    sb.write(_bits(increment2.clamp(0, 1023), 10));
  }
  // A single assignment is a 96-bit message: pad the 92 encoded bits.
  return buildNmeaSentence(sb.toString().padRight(96, '0'));
}

/// Encodes a Type 17 DGNSS broadcast binary message (80-816 bits).
String encodeDgnssBroadcast({
  required int mmsi,
  required double latitude,
  required double longitude,
  List<int> data = const [],
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 17, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_coord(longitude, 600, 18));
  sb.write(_coord(latitude, 600, 17));
  sb.write(_bits(0, 5)); // spare
  sb.write(_binaryPayload(data, 816 - 80));
  return buildNmeaSentence(sb.toString());
}

String _classBHead({
  required int type,
  required int mmsi,
  required double latitude,
  required double longitude,
  required double sog,
  required double cog,
  required double heading,
  required int timestamp,
  required int positionAccuracy,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: type, mmsi: mmsi));
  sb.write(_bits(0, 8)); // spare
  sb.write(_bits((sog * 10).round().clamp(0, 1023), 10));
  sb.write(_bits(positionAccuracy.clamp(0, 1), 1)); // position accuracy
  sb.write(_coord(longitude, 600000, 28));
  sb.write(_coord(latitude, 600000, 27));
  sb.write(_bits((cog * 10).round().clamp(0, 3600), 12));
  sb.write(_bits(heading.round().clamp(0, 511), 9));
  sb.write(_bits(timestamp.clamp(0, 63), 6));
  return sb.toString();
}

/// Encodes a Type 18 standard Class B position report (168 bits).
String encodeClassBPosition({
  required int mmsi,
  required double latitude,
  required double longitude,
  required double sog,
  required double cog,
  required double heading,
  int positionAccuracy = 0,
  int timestamp = 0,
}) {
  final sb = StringBuffer();
  sb.write(
    _classBHead(
      type: 18,
      mmsi: mmsi,
      latitude: latitude,
      longitude: longitude,
      sog: sog,
      cog: cog,
      heading: heading,
      timestamp: timestamp,
      positionAccuracy: positionAccuracy,
    ),
  );
  sb.write(
    _bits(0, 8),
  ); // regional / CS / display / DSC / band / msg22 / assigned
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(0, 20)); // radio
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 19 extended Class B position report (312 bits).
String encodeClassBExtended({
  required int mmsi,
  required double latitude,
  required double longitude,
  required double sog,
  required double cog,
  required double heading,
  required String name,
  int vesselType = 0,
  int dimensionBow = 0,
  int dimensionStern = 0,
  int dimensionPort = 0,
  int dimensionStarboard = 0,
  int positionAccuracy = 0,
  int timestamp = 0,
}) {
  final sb = StringBuffer();
  sb.write(
    _classBHead(
      type: 19,
      mmsi: mmsi,
      latitude: latitude,
      longitude: longitude,
      sog: sog,
      cog: cog,
      heading: heading,
      timestamp: timestamp,
      positionAccuracy: positionAccuracy,
    ),
  );
  sb.write(_bits(0, 4)); // regional reserved
  sb.write(encodeAisText(name, 120));
  sb.write(_bits(vesselType.clamp(0, 255), 8));
  sb.write(_bits(dimensionBow.clamp(0, 511), 9));
  sb.write(_bits(dimensionStern.clamp(0, 511), 9));
  sb.write(_bits(dimensionPort.clamp(0, 63), 6));
  sb.write(_bits(dimensionStarboard.clamp(0, 63), 6));
  sb.write(_bits(0, 4)); // EPFD fix type
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(0, 1)); // DTE
  sb.write(_bits(0, 1)); // assigned mode
  sb.write(_bits(0, 4)); // spare
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 20 data link management message (72-160 bits).
String encodeDataLinkManagement({
  required int mmsi,
  int offset1 = 0,
  int number1 = 0,
  int timeout1 = 0,
  int increment1 = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 20, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_bits(offset1.clamp(0, 4095), 12));
  sb.write(_bits(number1.clamp(0, 15), 4));
  sb.write(_bits(timeout1.clamp(0, 7), 3));
  sb.write(_bits(increment1.clamp(0, 2047), 11));
  // One block is 70 bits; a trailing 2-bit spare pads the message to 72.
  return buildNmeaSentence(sb.toString().padRight(72, '0'));
}

/// Encodes a Type 21 aid-to-navigation report sentence (360 bits).
String encodeAidToNavigation({
  required int mmsi,
  required double latitude,
  required double longitude,
  required String name,
  int aidType = 0,
  int positionAccuracy = 0,
  int virtualAid = 0,
  String nameExtension = '',
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 21, mmsi: mmsi));
  sb.write(_bits(aidType.clamp(0, 31), 5));
  sb.write(encodeAisText(name, 120));
  sb.write(_bits(positionAccuracy.clamp(0, 1), 1));
  sb.write(_coord(longitude, 600000, 28));
  sb.write(_coord(latitude, 600000, 27));
  sb.write(_bits(0, 9)); // dimension to bow
  sb.write(_bits(0, 9)); // dimension to stern
  sb.write(_bits(0, 6)); // dimension to port
  sb.write(_bits(0, 6)); // dimension to starboard
  sb.write(_bits(0, 4)); // EPFD fix type
  sb.write(_bits(0, 6)); // second
  sb.write(_bits(0, 1)); // off position
  sb.write(_bits(0, 8)); // regional reserved
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(virtualAid.clamp(0, 1), 1));
  sb.write(_bits(0, 1)); // assigned mode
  sb.write(encodeAisText(nameExtension, 89));
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 22 channel management message (168 bits, broadcast form).
String encodeChannelManagement({
  required int mmsi,
  required int channelA,
  required int channelB,
  required int txrxMode,
  required double neLatitude,
  required double neLongitude,
  required double swLatitude,
  required double swLongitude,
  int power = 0,
  int zoneSize = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 22, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_bits(channelA.clamp(0, 4095), 12));
  sb.write(_bits(channelB.clamp(0, 4095), 12));
  sb.write(_bits(txrxMode.clamp(0, 15), 4));
  sb.write(_bits(power.clamp(0, 1), 1));
  sb.write(_coord(neLongitude, 600, 18));
  sb.write(_coord(neLatitude, 600, 17));
  sb.write(_coord(swLongitude, 600, 18));
  sb.write(_coord(swLatitude, 600, 17));
  sb.write(_bits(0, 1)); // addressed = 0 (broadcast)
  sb.write(_bits(0, 1)); // band A
  sb.write(_bits(0, 1)); // band B
  sb.write(_bits(zoneSize.clamp(0, 7), 3));
  sb.write(_bits(0, 23)); // spare
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 23 group assignment command sentence (160 bits).
String encodeGroupAssignment({
  required int mmsi,
  required double neLatitude,
  required double neLongitude,
  required double swLatitude,
  required double swLongitude,
  int stationType = 0,
  int shipType = 0,
  int txrxMode = 0,
  int interval = 0,
  int quietTime = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 23, mmsi: mmsi));
  sb.write(_bits(0, 2)); // spare
  sb.write(_coord(neLongitude, 600, 18));
  sb.write(_coord(neLatitude, 600, 17));
  sb.write(_coord(swLongitude, 600, 18));
  sb.write(_coord(swLatitude, 600, 17));
  sb.write(_bits(stationType.clamp(0, 15), 4));
  sb.write(_bits(shipType.clamp(0, 255), 8));
  sb.write(_bits(0, 22)); // spare
  sb.write(_bits(txrxMode.clamp(0, 3), 2));
  sb.write(_bits(interval.clamp(0, 15), 4));
  sb.write(_bits(quietTime.clamp(0, 15), 4));
  sb.write(_bits(0, 6)); // spare
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 24 Part A sentence (vessel name).
String encodeStaticDataReportPartA({required int mmsi, required String name}) {
  final sb = StringBuffer();
  sb.write(_head(type: 24, mmsi: mmsi));
  sb.write(_bits(0, 2)); // part number A
  sb.write(encodeAisText(name, 120));
  sb.write(_bits(0, 8)); // spare
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 24 Part B sentence (ship type, call sign, dimensions).
String encodeStaticDataReportPartB({
  required int mmsi,
  int shipType = 70,
  required String callSign,
  int dimensionBow = 0,
  int dimensionStern = 0,
  int dimensionPort = 0,
  int dimensionStarboard = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 24, mmsi: mmsi));
  sb.write(_bits(1, 2)); // part number B
  sb.write(_bits(shipType.clamp(0, 255), 8));
  sb.write(_bits(0, 18)); // vendor id
  sb.write(_bits(0, 4)); // unit model code
  sb.write(_bits(0, 20)); // serial number
  sb.write(encodeAisText(callSign, 42));
  sb.write(_bits(dimensionBow.clamp(0, 511), 9));
  sb.write(_bits(dimensionStern.clamp(0, 511), 9));
  sb.write(_bits(dimensionPort.clamp(0, 63), 6));
  sb.write(_bits(dimensionStarboard.clamp(0, 63), 6));
  sb.write(_bits(0, 6)); // spare
  return buildNmeaSentence(sb.toString());
}

String _binarySlotHead({
  required int type,
  required int mmsi,
  required int? destinationMmsi,
  required (int, int)? applicationId,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: type, mmsi: mmsi));
  final dest = destinationMmsi != null;
  final hasAppId = applicationId != null;
  sb.write(_bits(dest ? 1 : 0, 1)); // destination indicator
  sb.write(_bits(hasAppId ? 1 : 0, 1)); // binary data flag
  if (dest) {
    sb.write(_bits(destinationMmsi, 30));
    if (hasAppId) {
      sb.write(_bits(applicationId.$1.clamp(0, 1023), 10));
      sb.write(_bits(applicationId.$2.clamp(0, 63), 6));
    }
  } else if (hasAppId) {
    sb.write(_bits(applicationId.$1.clamp(0, 1023), 10));
    sb.write(_bits(applicationId.$2.clamp(0, 63), 6));
  }
  return sb.toString();
}

/// Encodes a Type 25 single slot binary message (40-168 bits).
String encodeSingleSlotBinary({
  required int mmsi,
  required List<int> data,
  int? destinationMmsi,
  (int, int)? applicationId,
}) {
  final head = _binarySlotHead(
    type: 25,
    mmsi: mmsi,
    destinationMmsi: destinationMmsi,
    applicationId: applicationId,
  );
  final sb = StringBuffer(head);
  sb.write(_binaryPayload(data, 168 - head.length));
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 26 multiple slot binary message (60-1064 bits). The radio
/// status is the last 20 bits of the message, so it is written after the
/// data and never followed by padding.
String encodeMultipleSlotBinary({
  required int mmsi,
  required List<int> data,
  int? destinationMmsi,
  (int, int)? applicationId,
}) {
  final head = _binarySlotHead(
    type: 26,
    mmsi: mmsi,
    destinationMmsi: destinationMmsi,
    applicationId: applicationId,
  );
  final sb = StringBuffer(head);
  sb.write(_binaryPayload(data, 1064 - head.length - 20));
  sb.write(_bits(0, 20)); // radio status
  return buildNmeaSentence(sb.toString());
}

/// Encodes a Type 27 long range AIS broadcast sentence (96 bits).
String encodeLongRangeBroadcast({
  required int mmsi,
  required double latitude,
  required double longitude,
  double sog = 0,
  double cog = 0,
  int navigationStatus = 0,
}) {
  final sb = StringBuffer();
  sb.write(_head(type: 27, mmsi: mmsi));
  sb.write(_bits(0, 1)); // spare
  sb.write(_bits(0, 1)); // RAIM
  sb.write(_bits(navigationStatus.clamp(0, 15), 4));
  sb.write(_coord(longitude, 600, 18));
  sb.write(_coord(latitude, 600, 17));
  sb.write(_bits((sog * 10).round().clamp(0, 63), 6));
  sb.write(_bits((cog * 10).round().clamp(0, 511), 9));
  sb.write(_bits(0, 1)); // GNSS position status
  sb.write(_bits(0, 1)); // spare
  return buildNmeaSentence(sb.toString());
}
