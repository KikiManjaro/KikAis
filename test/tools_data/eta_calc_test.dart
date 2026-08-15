import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/tools_data/eta_calc.dart';

void main() {
  test('computes the AIS type-5 ETA fields from distance and speed', () {
    final start = DateTime.utc(2026, 8, 15, 12, 0);
    // 60 nm at 15 kn = 4 hours -> 16:00 UTC on the same day.
    final eta = computeEta(distanceNm: 60, speedKn: 15, now: start);
    expect(eta.month, 8);
    expect(eta.day, 15);
    expect(eta.hour, 16);
    expect(eta.minute, 0);
    expect(eta.utc.hour, 16);
  });

  test('crosses a day boundary', () {
    final start = DateTime.utc(2026, 8, 15, 22, 0);
    final eta = computeEta(distanceNm: 60, speedKn: 15, now: start);
    expect(eta.day, 16);
    expect(eta.hour, 2);
    expect(eta.minute, 0);
  });

  test('zero speed produces zero duration', () {
    final start = DateTime.utc(2026, 8, 15, 12, 0);
    final eta = computeEta(distanceNm: 60, speedKn: 0, now: start);
    expect(eta.hour, 12);
    expect(eta.minute, 0);
  });

  test('formatDuration renders h and min', () {
    expect(formatDuration(3.75), '3h 45min');
    expect(formatDuration(2), '2h');
    expect(formatDuration(0.5), '30min');
    expect(formatDuration(0), '0min');
  });
}
