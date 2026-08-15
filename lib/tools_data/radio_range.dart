import 'dart:math' as math;

/// Combined VHF radio horizon between two antennas, in nautical miles.
///
/// Rule of thumb: `2.22 · (√h1 + √h2)` with heights in metres (≈ the standard
/// `4.12 · (√h1 + √h2)` in kilometres converted to nautical miles).
double radioHorizonNm(double height1Meters, double height2Meters) {
  final h1 = math.max(0, height1Meters);
  final h2 = math.max(0, height2Meters);
  return 2.22 * (math.sqrt(h1) + math.sqrt(h2));
}

/// Combined VHF radio horizon in kilometres.
double radioHorizonKm(double height1Meters, double height2Meters) {
  return radioHorizonNm(height1Meters, height2Meters) * 1.852;
}
