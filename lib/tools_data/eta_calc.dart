/// Estimated Time of Arrival expressed in the AIS Type 5 field layout.
///
/// AIS static data stores ETA as four fields: month (1-12, 0 = unavailable),
/// day (1-31, 0 = unavailable), hour (0-23, 24 = unavailable) and minute
/// (0-59, 60 = unavailable).
class AisEta {
  final int month;
  final int day;
  final int hour;
  final int minute;

  /// The concrete UTC date/time this ETA refers to.
  final DateTime utc;

  const AisEta({
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.utc,
  });
}

/// Computes the ETA of a transit of [distanceNm] nautical miles at [speedKn]
/// starting from [now] (defaults to the current time).
AisEta computeEta({
  required double distanceNm,
  required double speedKn,
  DateTime? now,
}) {
  final start = now ?? DateTime.now();
  final minutes = speedKn > 0 ? (distanceNm / speedKn * 60).round() : 0;
  final eta = start.toUtc().add(Duration(minutes: minutes));
  return AisEta(
    month: eta.month,
    day: eta.day,
    hour: eta.hour,
    minute: eta.minute,
    utc: eta,
  );
}

/// Formats a duration for display (e.g. "3h 45min").
String formatDuration(double hours) {
  final totalMinutes = (hours * 60).round();
  final h = totalMinutes ~/ 60;
  final m = totalMinutes % 60;
  if (h == 0) return '${m}min';
  return m == 0 ? '${h}h' : '${h}h ${m}min';
}
