/// Speed units convertible by the speed converter tool.
enum SpeedUnit {
  knots,
  kmh,
  ms,
  mph;

  /// Factor that converts one [this] to knots.
  double get toKnots => switch (this) {
        SpeedUnit.knots => 1,
        SpeedUnit.kmh => 1 / 1.852,
        SpeedUnit.ms => 1 / 0.514444,
        SpeedUnit.mph => 1 / 1.15077945,
      };
}

/// Converts [value] expressed in [from] into every supported unit.
Map<SpeedUnit, double> convertSpeed(double value, SpeedUnit from) {
  final knots = value * from.toKnots;
  return {
    SpeedUnit.knots: knots,
    SpeedUnit.kmh: knots * 1.852,
    SpeedUnit.ms: knots * 0.514444,
    SpeedUnit.mph: knots * 1.15077945,
  };
}
