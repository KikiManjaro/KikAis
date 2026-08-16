import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/sdr/rtlsdr_device.dart';

void main() {
  test('listRtlSdrDevices never throws when the native lib is absent', () {
    // Under `flutter test` there is no rtlsdr.dll, so the enumeration must
    // degrade to an empty list instead of crashing.
    expect(listRtlSdrDevices(), isA<List<RtlSdrDeviceInfo>>());
  });

  test('error codes map to human readable messages', () {
    expect(RtlsdrFfiDevice.errorFor(-1), 'Generic error');
    expect(RtlsdrFfiDevice.errorFor(-3), 'Device not found');
    expect(RtlsdrFfiDevice.errorFor(-4), 'Busy');
    expect(RtlsdrFfiDevice.errorFor(0), 'error 0');
  });

  test('device info label falls back gracefully', () {
    const info = RtlSdrDeviceInfo(
      index: 2,
      name: 'Generic RTL2832U',
      manufacturer: 'Realtek',
      product: 'RTL2838',
      serial: '00000001',
    );
    expect(info.label, 'Generic RTL2832U');
    expect(
      const RtlSdrDeviceInfo(
        index: 0,
        name: '',
        manufacturer: 'Realtek',
        product: 'RTL2838',
        serial: '',
      ).label,
      'Realtek RTL2838',
    );
    expect(
      const RtlSdrDeviceInfo(
        index: 3,
        name: '',
        manufacturer: '',
        product: '',
        serial: '',
      ).label,
      'RTL-SDR #3',
    );
  });
}
