import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/tools_data/speed_units.dart';

void main() {
  test('1 knot converts to canonical values', () {
    final v = convertSpeed(1, SpeedUnit.knots);
    expect(v[SpeedUnit.knots]!, closeTo(1, 1e-9));
    expect(v[SpeedUnit.kmh]!, closeTo(1.852, 1e-3));
    expect(v[SpeedUnit.ms]!, closeTo(0.514444, 1e-3));
    expect(v[SpeedUnit.mph]!, closeTo(1.15077945, 1e-3));
  });

  test('10 knots is about 18.5 km/h', () {
    final v = convertSpeed(10, SpeedUnit.knots);
    expect(v[SpeedUnit.kmh]!, closeTo(18.52, 0.01));
  });

  test('conversion is reversible from any unit', () {
    for (final from in SpeedUnit.values) {
      final toKnots = convertSpeed(5, from)[SpeedUnit.knots]!;
      final back = convertSpeed(toKnots, SpeedUnit.knots)[from]!;
      expect(back, closeTo(5, 1e-6));
    }
  });

  test('zero stays zero', () {
    final v = convertSpeed(0, SpeedUnit.kmh);
    for (final u in SpeedUnit.values) {
      expect(v[u]!, 0);
    }
  });
}
