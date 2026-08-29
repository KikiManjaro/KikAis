import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';

String _sentence() => encodePositionReport(
  mmsi: 227006789,
  latitude: 48.39,
  longitude: -4.49,
  sog: 12.5,
  cog: 245,
  heading: 250,
);

void main() {
  test('buildTagBlock produces a valid, self-checking tag block', () {
    final block = buildTagBlock(sourceId: 'SIM', timeMs: 123456);
    expect(block, startsWith('\\'));
    expect(block, endsWith('\\'));
    expect(block, contains('s:SIM'));
    expect(block, contains('t:123456'));
    expect(block, contains('c:'));

    final parsed = NmeaTagBlock.tryParse(block)!;
    expect(parsed.sourceId, 'SIM');
    expect(parsed.timeMs, 123456);
    expect(parsed.checksumValid, isTrue);
  });

  test('split extracts the tag block and the sentence', () {
    final sentence = _sentence();
    final line = '${buildTagBlock(sourceId: 'DF176387')}$sentence';
    final (tag, rest) = NmeaTagBlock.split(line);
    expect(tag, isNotNull);
    expect(tag!.sourceId, 'DF176387');
    expect(rest, sentence);
  });

  test(
    'NmeaSentence parses a tagged line and validates the sentence checksum',
    () {
      final sentence = _sentence();
      final line = '${buildTagBlock(sourceId: 'DF176387')}$sentence';
      final parsed = NmeaSentence.tryParse(line);
      expect(parsed, isNotNull);
      expect(parsed!.tagBlock, isNotNull);
      expect(parsed.sentenceRaw, sentence);
      expect(parsed.isChecksumValid, isTrue);
    },
  );

  test('a tagged line decodes to the same message', () {
    final sentence = _sentence();
    final line = '${buildTagBlock(sourceId: 'DF176387')}$sentence';
    final decoded = AisNmeaDecoder().decode(line);
    expect(decoded, isA<PositionMessage>());
    expect((decoded as PositionMessage).mmsi, 227006789);
  });

  test('NMEA 4.0 talker IDs decode (ABVDM)', () {
    final wrapped = wrapNmea4(_sentence(), talker: 'AB');
    expect(wrapped, startsWith('!ABVDM'));
    final decoded = AisNmeaDecoder().decode(wrapped);
    expect(decoded, isA<PositionMessage>());
    expect((decoded as PositionMessage).mmsi, 227006789);
  });

  test('wrapNmea4 with a tag block keeps a valid checksum', () {
    final tag = buildTagBlock(sourceId: 'SIM', timeMs: 999);
    final wrapped = wrapNmea4(_sentence(), talker: 'AN', tagBlock: tag);
    expect(wrapped, startsWith('\\'));
    expect(wrapped, contains('!ANVDM'));
    expect(AisNmeaDecoder().decode(wrapped), isA<PositionMessage>());
  });

  test('applyNmeaFormat strips, passes through or tags a frame', () {
    final sentence = _sentence();
    final tagged = '${buildTagBlock(sourceId: 'SRC')}$sentence';

    expect(applyNmeaFormat(tagged, NmeaFormat.passthrough), tagged);
    expect(applyNmeaFormat(tagged, NmeaFormat.strip), sentence);
    final retagged = applyNmeaFormat(
      sentence,
      NmeaFormat.tag,
      sourceId: 'MYSITE',
    );
    expect(retagged, startsWith('\\'));
    expect(retagged, contains('s:MYSITE'));
    expect(retagged, endsWith(sentence));
    // A line without a sentence yields nothing.
    expect(applyNmeaFormat('not an ais line', NmeaFormat.tag), '');
  });
}
