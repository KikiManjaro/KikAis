import '../ais/ais_decoder.dart' show encodeBinaryToAis;
import '../ais/src/utils/convert_char_to_bin.dart';

/// Encodes [text] into the AIS 6-bit data alphabet (`aisDataChars`): every
/// character yields one 6-bit value. Characters outside the alphabet become a
/// space (value 32), matching the encoder's behaviour for name/call-sign
/// fields.
List<int> encodeTextSixBit(String text) {
  return text.toUpperCase().split('').map((c) {
    final v = aisDataChars.indexOf(c);
    return v < 0 ? 32 : v;
  }).toList();
}

/// Concatenates [values] into a binary string (6 bits each).
String sixBitValuesToBinary(List<int> values) {
  return values.map((v) => v.toRadixString(2).padLeft(6, '0')).join();
}

/// Converts a binary string into uppercase hex, zero-padded to a nibble
/// boundary.
String binaryToHex(String bits) {
  final padded = bits.padRight(((bits.length + 3) ~/ 4) * 4, '0');
  final sb = StringBuffer();
  for (var i = 0; i < padded.length; i += 4) {
    sb.write(int.parse(padded.substring(i, i + 4), radix: 2).toRadixString(16));
  }
  return sb.toString().toUpperCase();
}

/// Groups a binary string into bytes (last byte zero-padded).
List<int> binaryToBytes(String bits) {
  final padded = bits.padRight(((bits.length + 7) ~/ 8) * 8, '0');
  final out = <int>[];
  for (var i = 0; i < padded.length; i += 8) {
    out.add(int.parse(padded.substring(i, i + 8), radix: 2));
  }
  return out;
}

/// Editor-friendly byte list, e.g. `72,69,76` for "HEL".
String bytesToEditorList(List<int> bytes) => bytes.join(',');

/// Space-separated uppercase hex pairs, e.g. `48 45 4C`.
String bytesToHexPairs(List<int> bytes) => bytes
    .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
    .join(' ');

/// Armors a binary string into AIS payload characters — the exact `payload`
/// field to embed in an NMEA sentence.
String toAisPayload(String binary) => encodeBinaryToAis(binary);
