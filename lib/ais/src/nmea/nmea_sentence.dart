import '../utils/convert_char_to_bin.dart';
import 'nmea_tag_block.dart';

/// Parsed representation of a single NMEA 0183 AIS sentence
/// (e.g. `!AIVDM,1,1,,A,<payload>,0*<checksum>`).
class NmeaSentence {
  final String talker;
  final int fragmentCount;
  final int fragmentNumber;
  final int sequentialId;
  final String channel;
  final String payload;
  final int fillBits;
  final String? checksum;

  /// Optional NMEA 4.0 tag block carried in front of the sentence.
  final NmeaTagBlock? tagBlock;

  /// The original line exactly as received (tag block included).
  final String raw;

  /// The sentence part (`!...`) without any tag block.
  final String sentenceRaw;

  const NmeaSentence({
    required this.talker,
    required this.fragmentCount,
    required this.fragmentNumber,
    required this.sequentialId,
    required this.channel,
    required this.payload,
    required this.fillBits,
    required this.checksum,
    required this.tagBlock,
    required this.raw,
    required this.sentenceRaw,
  });

  static NmeaSentence? tryParse(String rawLine) {
    final (tagBlock, sentencePart) = NmeaTagBlock.split(rawLine);
    final line = sentencePart;
    if (!line.startsWith('!')) return null;

    final star = line.lastIndexOf('*');
    final body = star > 0 ? line.substring(1, star) : line.substring(1);
    final checksum = star > 0 ? line.substring(star + 1) : null;

    // The payload field may itself contain commas, so we cannot split on
    // ','. Instead: the first five commas delimit the header, the last
    // comma separates the payload from the fill-bits field.
    final commas = <int>[];
    for (var i = 0; i < body.length; i++) {
      if (body[i] == ',') commas.add(i);
    }
    if (commas.length < 6) return null;

    final total = int.tryParse(body.substring(commas[0] + 1, commas[1]));
    final fragment = int.tryParse(body.substring(commas[1] + 1, commas[2]));
    final seqRaw = body.substring(commas[2] + 1, commas[3]);
    final seq = int.tryParse(seqRaw.isEmpty ? '0' : seqRaw);
    final fill = int.tryParse(body.substring(commas.last + 1));
    if (total == null || fragment == null || fill == null) return null;

    return NmeaSentence(
      talker: body.substring(0, commas[0]),
      fragmentCount: total,
      fragmentNumber: fragment,
      sequentialId: seq ?? 0,
      channel: body.substring(commas[3] + 1, commas[4]),
      payload: body.substring(commas[4] + 1, commas.last),
      fillBits: fill,
      checksum: checksum,
      tagBlock: tagBlock,
      raw: rawLine.trim(),
      sentenceRaw: line,
    );
  }

  /// XOR of all characters between `!` and `*`, compared to the trailing
  /// two-hex-digit checksum. A leading tag block is not part of the checksum.
  bool get isChecksumValid {
    if (checksum == null) return true;
    final body = sentenceRaw.substring(1, sentenceRaw.lastIndexOf('*'));
    int xor = 0;
    for (final c in body.codeUnits) {
      xor ^= c;
    }
    final computed = xor.toRadixString(16).padLeft(2, '0').toUpperCase();
    return computed == checksum!.toUpperCase();
  }

  /// Converts the 6-bit AIS payload characters to their raw binary string.
  String get binaryPayload {
    final sb = StringBuffer();
    for (final c in payload.split('')) {
      sb.write(convertCharToBinary(c));
    }
    return sb.toString();
  }
}
