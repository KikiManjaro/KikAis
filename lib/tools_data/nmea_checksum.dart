import '../ais/ais_decoder.dart';

/// The shared NMEA XOR checksum helper, re-exported for convenience.
export '../ais/ais_decoder.dart' show computeNmeaChecksum;

/// Result of validating a single NMEA sentence checksum.
class NmeaChecksumInfo {
  final bool parsed;
  final String? declared;
  final String computed;
  final bool valid;

  const NmeaChecksumInfo({
    required this.parsed,
    required this.computed,
    this.declared,
    this.valid = false,
  });
}

/// Parses [line] and computes its checksum. Returns null when [line] is not
/// an NMEA sentence (or its tag block swallows it).
NmeaChecksumInfo? inspectChecksum(String line) {
  final sentence = NmeaSentence.tryParse(line);
  if (sentence == null) return null;
  final star = sentence.sentenceRaw.lastIndexOf('*');
  final body = star > 0
      ? sentence.sentenceRaw.substring(1, star)
      : sentence.sentenceRaw.substring(1);
  final computed = computeNmeaChecksum(body);
  final declared = sentence.checksum;
  return NmeaChecksumInfo(
    parsed: true,
    computed: computed,
    declared: declared,
    valid: sentence.isChecksumValid,
  );
}

String _xorHex(String text) {
  var xor = 0;
  for (final c in text.codeUnits) {
    xor ^= c & 0xFF;
  }
  return xor.toRadixString(16).padLeft(2, '0').toUpperCase();
}

/// Computes the checksum report of any input line, for the checksum tool.
///
/// Unlike [inspectChecksum] it never returns null: a line that is not an NMEA
/// sentence still gets the XOR of its own characters, because the tool is also
/// used to checksum arbitrary payloads. Accepts `!` (AIS) and `$` (GNSS)
/// talkers, whatever their number of fields, and ignores a leading tag block.
NmeaChecksumInfo checksumReport(String line) {
  final trimmed = line.trim();
  final (_, sentence) = NmeaTagBlock.split(trimmed);
  final isSentence = sentence.startsWith('!') || sentence.startsWith(r'$');
  if (!isSentence) {
    return NmeaChecksumInfo(parsed: false, computed: _xorHex(trimmed));
  }
  final star = sentence.lastIndexOf('*');
  final body = star > 0 ? sentence.substring(1, star) : sentence.substring(1);
  final computed = _xorHex(body);
  final rawDeclared = star > 0 ? sentence.substring(star + 1).trim() : '';
  final declared = rawDeclared.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
  return NmeaChecksumInfo(
    parsed: true,
    computed: computed,
    declared: declared.isEmpty ? null : declared.toUpperCase(),
    valid: declared.isNotEmpty && computed == declared.toUpperCase(),
  );
}

/// Returns [line] with a correct `*XX` checksum appended (or fixed), keeping
/// any leading tag block untouched. Returns [line] unchanged when it is not an
/// NMEA sentence (`!` or `$`).
String fixChecksum(String line) {
  final trimmed = line.trim();
  final (tag, sentence) = NmeaTagBlock.split(trimmed);
  if (!sentence.startsWith('!') && !sentence.startsWith(r'$')) return line;
  final star = sentence.lastIndexOf('*');
  final body = star > 0 ? sentence.substring(1, star) : sentence.substring(1);
  final base = star > 0 ? sentence.substring(0, star) : sentence;
  final fixed = '$base*${_xorHex(body)}';
  return tag == null ? fixed : '${tag.raw}$fixed';
}
