import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/tools_data/mmsi_info.dart';

void main() {
  test('valid ship MMSI is recognised with its country', () {
    final info = inspectMmsi('226545000');
    expect(info.valid, isTrue);
    expect(info.mid, '226');
    expect(info.country, 'France');
    expect(info.stationType, MmsiStationType.coastStation);
  });

  test('a 3-prefixed MMSI is a ship station', () {
    final info = inspectMmsi('366111111');
    expect(info.valid, isTrue);
    expect(info.stationType, MmsiStationType.shipStation);
    expect(info.country, 'United States');
  });

  test('leading/trailing whitespace is tolerated', () {
    final info = inspectMmsi(' 227006789 ');
    expect(info.valid, isTrue);
    expect(info.mmsi, '227006789');
  });

  test('invalid MMSI values are rejected', () {
    expect(inspectMmsi('').valid, isFalse);
    expect(inspectMmsi('12345').valid, isFalse);
    expect(inspectMmsi('1234567890').valid, isFalse);
    expect(inspectMmsi('22654500A').valid, isFalse);
  });

  test('station types follow the first-digit convention', () {
    expect(inspectMmsi('000000001').stationType, MmsiStationType.groupCall);
    expect(inspectMmsi('111226789').stationType, MmsiStationType.sarAircraft);
    expect(inspectMmsi('366111111').stationType, MmsiStationType.shipStation);
    expect(inspectMmsi('227111111').stationType, MmsiStationType.coastStation);
    expect(inspectMmsi('400000001').stationType, MmsiStationType.handheldVhf);
    expect(inspectMmsi('800000001').stationType, MmsiStationType.aton);
    expect(inspectMmsi('970000001').stationType, MmsiStationType.sar);
    expect(inspectMmsi('980000001').stationType, MmsiStationType.aton);
  });

  test('unknown MID still yields a type but no country', () {
    final info = inspectMmsi('999111222');
    expect(info.valid, isTrue);
    expect(info.country, isNull);
    expect(info.stationType, MmsiStationType.sar);
  });
}
