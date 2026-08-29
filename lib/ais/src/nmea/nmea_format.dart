import '../encoder/ais_payload_encoder.dart';
import 'nmea_tag_block.dart';

/// How an NMEA line is (re)formatted before being logged, decoded or sent.
enum NmeaFormat {
  /// Keep the line exactly as received (tag block included if present).
  passthrough,

  /// Remove the tag block and emit a plain `!...` sentence.
  strip,

  /// Add (or replace) a tag block carrying a source id and a timestamp.
  tag,
}

String nmeaFormatLabel(NmeaFormat f) => switch (f) {
  NmeaFormat.passthrough => 'Pass-through',
  NmeaFormat.strip => 'Strip tag blocks',
  NmeaFormat.tag => 'Add tag block',
};

/// Builds a NMEA 4.0 tag block (`\s:...,t:...,c:XX\`) from its fields.
/// A `c:` checksum is always computed over the tag content.
String buildTagBlock({
  String? sourceId,
  String? destination,
  String? group,
  int? lineCount,
  double? relativeTime,
  int? timeMs,
  String? text,
}) {
  final tags = <String>[];
  if (sourceId != null && sourceId.isNotEmpty) tags.add('s:$sourceId');
  if (destination != null && destination.isNotEmpty) tags.add('d:$destination');
  if (group != null && group.isNotEmpty) tags.add('g:$group');
  if (lineCount != null) tags.add('n:$lineCount');
  if (relativeTime != null) tags.add('r:${relativeTime.toStringAsFixed(2)}');
  if (timeMs != null) tags.add('t:$timeMs');
  if (text != null && text.isNotEmpty) tags.add('x:$text');
  final content = tags.join(',');
  final checksum = computeNmeaChecksum(content);
  return '\\${content.isEmpty ? '' : '$content,'}c:$checksum\\';
}

/// Milliseconds since UTC midnight (the `t:` tag value).
int msSinceUtcMidnight(DateTime now) =>
    now.difference(DateTime.utc(now.year, now.month, now.day)).inMilliseconds;

/// Rewrites a frame according to [format]: passes it through, strips its tag
/// block, or tags it with [sourceId] and the current time. Returns an empty
/// string when the line contains no usable AIS sentence.
String applyNmeaFormat(String line, NmeaFormat format, {String? sourceId}) {
  final trimmed = line.trim();
  final (_, sentencePart) = NmeaTagBlock.split(trimmed);
  var sentence = sentencePart;
  if (!sentence.startsWith('!')) {
    final idx = sentence.indexOf('!');
    if (idx == -1) return '';
    sentence = sentence.substring(idx);
  }
  return switch (format) {
    // Keep the line as received when it is a clean NMEA 4.0 line (sentence
    // or tag block); otherwise fall back to the extracted sentence so
    // timestamp-prefixed lines are not lost.
    NmeaFormat.passthrough =>
      (trimmed.startsWith('\\') || trimmed.startsWith('!'))
          ? trimmed
          : sentence,
    NmeaFormat.strip => sentence,
    NmeaFormat.tag =>
      buildTagBlock(
            sourceId: sourceId,
            timeMs: msSinceUtcMidnight(DateTime.now()),
          ) +
          sentence,
  };
}

/// Rewrites an encoded sentence to use [talker] (NMEA 4.0 talker ID) and
/// optionally prefix a tag block, recomputing the checksum. The original
/// checksum stays valid because the checksum is recalculated.
String wrapNmea4(String sentence, {String talker = 'AI', String? tagBlock}) {
  final (_, base) = NmeaTagBlock.split(sentence);
  if (!base.startsWith('!')) return sentence;
  final star = base.lastIndexOf('*');
  final body = star > 0 ? base.substring(1, star) : base.substring(1);
  final comma = body.indexOf(',');
  if (comma <= 0) return sentence;
  final head = body.substring(0, comma); // e.g. AIVDM / AIVDO
  if (head.length < 5) return sentence;
  final newHead = '$talker${head.substring(2)}';
  final newBody = '$newHead${body.substring(comma)}';
  final framed = '!$newBody*${computeNmeaChecksum(newBody)}';
  return tagBlock == null ? framed : '$tagBlock$framed';
}
