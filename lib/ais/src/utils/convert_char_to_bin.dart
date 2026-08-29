/// AIS payload alphabet used for ENCODING (6-bit value -> character).
///
/// Per gpsd / IEC-PAS, payload armoring uses `'0'`..`'W'` for values 0-39,
/// a backtick for value 40, and `'a'`..`'w'` for values 41-63. The range
/// `'X'`..`'_'` is not used for encoding.
const String aisPayloadChars =
    '0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVW`abcdefghijklmnopqrstuvw';

/// AIS "six-bit ASCII" alphabet used to decode TEXT fields (vessel names,
/// call signs, destinations...). Per the ITU-R M.1371 / gpsd Table 3.
const String aisDataChars =
    '@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_ !"#\$%&\'()*+,-./0123456789:;<=>?';

/// Converts an AIVDM/AIVDO payload character back to its 6-bit value.
///
/// Per gpsd / IEC-PAS: subtract 48 from the ASCII value, then subtract 8 if
/// the result is greater than 40.
int aisCharToValue(String char) {
  final value = char.codeUnitAt(0) - 48;
  final result = value > 40 ? value - 8 : value;
  return result < 0 || result > 63 ? 0 : result;
}

/// Converts an AIVDM/AIVDO payload character to its 6-bit binary string.
String convertCharToBinary(String char) {
  return aisCharToValue(char).toRadixString(2).padLeft(6, '0');
}

/// Encodes a 6-bit value (0-63) to its canonical AIS payload character.
String aisValueToChar(int value) {
  if (value < 0 || value > 63) return aisPayloadChars[0];
  return aisPayloadChars[value];
}
