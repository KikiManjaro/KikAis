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

/// Returns [line] with a correct `*XX` checksum appended (or fixed), keeping
/// any leading tag block untouched. Returns [line] unchanged when it is not a
/// parseable sentence.
String fixChecksum(String line) {
  final sentence = NmeaSentence.tryParse(line);
  if (sentence == null) return line;
  final star = sentence.sentenceRaw.lastIndexOf('*');
  final body = star > 0
      ? sentence.sentenceRaw.substring(1, star)
      : sentence.sentenceRaw.substring(1);
  final base = star > 0
      ? sentence.sentenceRaw.substring(0, star)
      : sentence.sentenceRaw;
  final fixed = '$base*${computeNmeaChecksum(body)}';
  final tag = sentence.tagBlock;
  return tag == null ? fixed : '${tag.raw}$fixed';
}
