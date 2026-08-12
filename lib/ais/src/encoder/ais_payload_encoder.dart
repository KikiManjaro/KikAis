import '../nmea/nmea_tag_block.dart';
import '../utils/convert_char_to_bin.dart';

String _bits(int value, int width) => value.toRadixString(2).padLeft(width, '0');

/// Converts a binary string to AIS 6-bit payload characters, padding the
/// final character with zero bits.
String encodeBinaryToAis(String binary) {
  final padded = binary.padRight(((binary.length + 5) ~/ 6) * 6, '0');
  final sb = StringBuffer();
  for (var i = 0; i < padded.length; i += 6) {
    sb.write(aisValueToChar(int.parse(padded.substring(i, i + 6), radix: 2)));
  }
  return sb.toString();
}

/// Encodes free text (e.g. vessel name / call sign) into the AIS 6-bit
/// binary data-field alphabet, right-padded with `@` (six-bit zero) so
/// decoders can strip the padding.
String encodeAisText(String text, int bitWidth) {
  final sb = StringBuffer();
  for (final c in text.toUpperCase().split('')) {
    final v = aisDataChars.indexOf(c);
    sb.write(_bits(v < 0 ? 32 : v, 6)); // 32 == space
  }
  final padded = sb.toString().padRight(bitWidth, _bits(0, 6));
  return padded.substring(0, bitWidth);
}

/// Computes the NMEA XOR checksum (two uppercase hex digits) of [body].
String computeNmeaChecksum(String body) {
  int xor = 0;
  for (final c in body.codeUnits) {
    xor ^= c;
  }
  return xor.toRadixString(16).padLeft(2, '0').toUpperCase();
}

String _computeChecksum(String body) => computeNmeaChecksum(body);

/// Builds a full NMEA sentence from a raw binary payload.
String buildNmeaSentence(
  String binary, {
  String channel = 'A',
  String talker = 'AI',
  NmeaTagBlock? tagBlock,
}) {
  final payload = encodeBinaryToAis(binary);
  final fill = binary.length % 6 == 0 ? 0 : 6 - (binary.length % 6);
  final body = '${talker}VDM,1,1,,$channel,$payload,$fill';
  final framed = '!$body*${_computeChecksum(body)}';
  return tagBlock == null ? framed : '${tagBlock.raw}$framed';
}
