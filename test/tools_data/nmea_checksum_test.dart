import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais/ais_decoder.dart';
import 'package:kik_ais/tools_data/nmea_checksum.dart';

void main() {
  test('computeNmeaChecksum matches a documented AIVDM sentence', () {
    // Real sentence from the gpsd AIVDM documentation.
    const body = 'AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0';
    expect(computeNmeaChecksum(body), '5C');
    final info = inspectChecksum('!$body*5C');
    expect(info, isNotNull);
    expect(info!.valid, isTrue);
  });

  test('inspectChecksum validates a correct sentence', () {
    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final info = inspectChecksum(sentence);
    expect(info, isNotNull);
    expect(info!.parsed, isTrue);
    expect(info.valid, isTrue);
    expect(info.declared, info.computed);
  });

  test('inspectChecksum flags a corrupted sentence', () {
    final sentence = encodePositionReport(
      mmsi: 226545000,
      latitude: 48.85,
      longitude: 1.05,
      sog: 12.0,
      cog: 250.0,
      heading: 90.0,
    );
    final bad = sentence.replaceFirst(RegExp(r'\*..$'), '*00');
    final info = inspectChecksum(bad);
    expect(info, isNotNull);
    expect(info!.valid, isFalse);
    expect(info.declared, '00');
    expect(info.computed, isNot('00'));
  });

  test('inspectChecksum computes when no checksum is declared', () {
    final parsed = NmeaSentence.tryParse(
      encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      ),
    )!;
    final body = parsed.sentenceRaw.substring(
      1,
      parsed.sentenceRaw.lastIndexOf('*'),
    );
    final noChecksum = '!$body';
    final info = inspectChecksum(noChecksum);
    expect(info, isNotNull);
    expect(info!.declared, isNull);
    expect(info.computed, computeNmeaChecksum(body));
  });

  test('inspectChecksum returns null for non-NMEA input', () {
    expect(inspectChecksum('hello world'), isNull);
  });

  test('fixChecksum repairs a broken sentence and keeps tag blocks', () {
    final parsed = NmeaSentence.tryParse(
      encodePositionReport(
        mmsi: 226545000,
        latitude: 48.85,
        longitude: 1.05,
        sog: 12.0,
        cog: 250.0,
        heading: 90.0,
      ),
    )!;
    final body = parsed.sentenceRaw.substring(
      1,
      parsed.sentenceRaw.lastIndexOf('*'),
    );
    final tagged = '\\s:MYSTATION\\!$body*00';
    final fixed = fixChecksum(tagged);
    expect(fixed, startsWith('\\s:MYSTATION\\'));
    expect(fixed, endsWith('*${computeNmeaChecksum(body)}'));
  });
}
