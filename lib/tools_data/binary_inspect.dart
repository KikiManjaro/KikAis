import '../ais/ais_decoder.dart';
import '../ais/src/utils/convert_char_to_bin.dart';

/// Result of inspecting a payload or a full NMEA sentence.
class BinaryInspection {
  /// Parsed sentence, null when the input was a bare payload.
  final NmeaSentence? sentence;

  /// The 6-bit payload characters.
  final String payload;

  /// Concatenated 6-bit binary of every payload character.
  final String binary;

  /// Decimal 6-bit value of each payload character.
  final List<int> sixBitValues;

  /// Binary grouped in 8-bit chunks (last chunk zero-padded), for display.
  final String binaryGrouped;

  /// Uppercase hex nibbles of [binary] (zero-padded to a nibble boundary).
  final String hex;

  /// Hex bytes (8-bit groups) of the payload.
  final String hexBytes;

  const BinaryInspection({
    this.sentence,
    required this.payload,
    required this.binary,
    required this.sixBitValues,
    required this.binaryGrouped,
    required this.hex,
    required this.hexBytes,
  });
}

/// Analyses [input]: either a full NMEA AIS sentence (`!...`) whose payload is
/// extracted, or a bare 6-bit payload.
BinaryInspection? inspectBinary(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;

  NmeaSentence? sentence;
  String payload;
  if (trimmed.startsWith('!')) {
    sentence = NmeaSentence.tryParse(trimmed);
    if (sentence == null) return null;
    payload = sentence.payload;
  } else {
    payload = trimmed;
  }

  final sixBitValues = payload.split('').map(aisCharToValue).toList();
  final binary = payload.split('').map(convertCharToBinary).join();

  final nibblePadded = binary.padRight(((binary.length + 3) ~/ 4) * 4, '0');
  final hex = StringBuffer();
  for (var i = 0; i < nibblePadded.length; i += 4) {
    hex.write(
      int.parse(nibblePadded.substring(i, i + 4), radix: 2).toRadixString(16),
    );
  }

  final bytePadded = binary.padRight(((binary.length + 7) ~/ 8) * 8, '0');
  final bytes = <int>[];
  final grouped = StringBuffer();
  for (var i = 0; i < bytePadded.length; i += 8) {
    final chunk = bytePadded.substring(i, i + 8);
    bytes.add(int.parse(chunk, radix: 2));
    if (i > 0) grouped.write(' ');
    grouped.write(chunk);
  }
  final hexBytes = bytes
      .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
      .join(' ');

  return BinaryInspection(
    sentence: sentence,
    payload: payload,
    binary: binary,
    sixBitValues: sixBitValues,
    binaryGrouped: grouped.toString(),
    hex: hex.toString().toUpperCase(),
    hexBytes: hexBytes,
  );
}
