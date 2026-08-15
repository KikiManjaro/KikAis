import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/tools_data/radio_range.dart';

void main() {
  test('sea-level station to a 9 m mast is about 6.7 nm', () {
    // 2.22 * (sqrt(0) + sqrt(9)) = 6.66
    final nm = radioHorizonNm(0, 9);
    expect(nm, closeTo(6.66, 0.01));
  });

  test('two masts at 4 m each', () {
    // 2.22 * (2 + 2) = 8.88
    final nm = radioHorizonNm(4, 4);
    expect(nm, closeTo(8.88, 0.01));
  });

  test('km conversion uses 1.852', () {
    final km = radioHorizonKm(0, 9);
    expect(km, closeTo(6.66 * 1.852, 0.01));
  });

  test('negative heights clamp to zero', () {
    expect(radioHorizonNm(-5, 9), closeTo(6.66, 0.01));
  });
}
