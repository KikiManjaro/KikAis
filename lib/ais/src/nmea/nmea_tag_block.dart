import '../encoder/ais_payload_encoder.dart';

/// A NMEA 4.0 tag block: a `\...\` metadata prefix carried in front of a
/// sentence (e.g. `\s:DF176387,c:16F9\!AIVDM,...`).
///
/// Tag blocks identify the source and timing of a frame. Per IEC 61162-1 /
/// NMEA 4.0 the tags are comma-separated `key:value` pairs; the optional
/// `c:` field is the XOR checksum of the block content.
class NmeaTagBlock {
  /// `s:` — source identification (receiver / station id).
  final String? sourceId;

  /// `d:` — destination identification.
  final String? destination;

  /// `g:` — group of sentences (group id).
  final String? group;

  /// `n:` — line count in the group.
  final int? lineCount;

  /// `r:` — relative time in seconds.
  final double? relativeTime;

  /// `t:` — time in milliseconds since UTC midnight.
  final int? timeMs;

  /// `x:` — arbitrary text.
  final String? text;

  /// `c:` — the tag-block checksum as declared by the sender.
  final String? checksum;

  /// The whole block including the surrounding backslashes.
  final String raw;

  const NmeaTagBlock({
    this.sourceId,
    this.destination,
    this.group,
    this.lineCount,
    this.relativeTime,
    this.timeMs,
    this.text,
    this.checksum,
    required this.raw,
  });

  /// Parses a `\...\` block. Returns null when [rawBlock] is not a block.
  static NmeaTagBlock? tryParse(String rawBlock) {
    final trimmed = rawBlock.trim();
    if (trimmed.length < 2 || !trimmed.startsWith('\\')) return null;
    final inner = trimmed.substring(1, trimmed.length - 1);
    return NmeaTagBlock._fromTags(inner, trimmed);
  }

  /// Splits a raw line into an optional leading tag block and the sentence
  /// that follows it.
  static (NmeaTagBlock?, String) split(String line) {
    final trimmed = line.trim();
    if (!trimmed.startsWith('\\')) return (null, trimmed);
    final close = trimmed.indexOf('\\', 1);
    if (close == -1) return (null, trimmed);
    final blockRaw = trimmed.substring(0, close + 1);
    final block = NmeaTagBlock.tryParse(blockRaw);
    return (block, trimmed.substring(close + 1).trim());
  }

  static NmeaTagBlock? _fromTags(String inner, String raw) {
    if (inner.isEmpty) return null;
    String? source, dest, group, text;
    int? lineCount;
    double? relativeTime;
    int? timeMs;
    String? checksum;
    for (final pair in inner.split(',')) {
      final idx = pair.indexOf(':');
      if (idx < 0) continue;
      final key = pair.substring(0, idx);
      final value = pair.substring(idx + 1);
      switch (key) {
        case 's':
          source = value;
        case 'd':
          dest = value;
        case 'g':
          group = value;
        case 'n':
          lineCount = int.tryParse(value);
        case 'r':
          relativeTime = double.tryParse(value);
        case 't':
          timeMs = int.tryParse(value);
        case 'x':
          text = value;
        case 'c':
          checksum = value.toUpperCase();
      }
    }
    return NmeaTagBlock(
      sourceId: source,
      destination: dest,
      group: group,
      lineCount: lineCount,
      relativeTime: relativeTime,
      timeMs: timeMs,
      text: text,
      checksum: checksum,
      raw: raw,
    );
  }

  /// Whether the declared `c:` checksum matches the block content. Returns
  /// true when no checksum was declared (it is optional).
  bool get checksumValid {
    if (checksum == null) return true;
    final inner = raw.substring(1, raw.length - 1);
    // The c: field is excluded from the XOR.
    final cIndex = inner.indexOf(',c:');
    final content = cIndex >= 0
        ? inner.substring(0, cIndex)
        : inner.replaceAll('c:$checksum', '');
    return computeNmeaChecksum(content) == checksum;
  }

  @override
  String toString() => raw;
}
