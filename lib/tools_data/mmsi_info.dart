import '../mid_countries.dart';

/// Kind of station identified by the first digit(s) of an MMSI, per ITU-R
/// M.585 / the widely used registration conventions.
enum MmsiStationType {
  groupCall,
  sarAircraft,
  coastStation,
  shipStation,
  handheldVhf,
  aton,
  sar,
  other,
}

/// Result of analysing an MMSI string.
class MmsiInfo {
  final bool valid;

  /// The 9 digits with whitespace trimmed, or the raw input when invalid.
  final String mmsi;

  /// First three digits (Maritime Identification Digits), null when invalid.
  final String? mid;

  /// Issuing country name, null when the MID is unknown or invalid.
  final String? country;

  final MmsiStationType stationType;

  const MmsiInfo({
    required this.valid,
    required this.mmsi,
    required this.mid,
    required this.country,
    required this.stationType,
  });
}

/// Validates and analyses an MMSI (Maritime Mobile Service Identity).
MmsiInfo inspectMmsi(String input) {
  final mmsi = input.trim();
  final valid = RegExp(r'^\d{9}$').hasMatch(mmsi);
  if (!valid) {
    return MmsiInfo(
      valid: false,
      mmsi: mmsi,
      mid: null,
      country: null,
      stationType: MmsiStationType.other,
    );
  }
  final mid = mmsi.substring(0, 3);
  final country = midCountryOf(mmsi);
  final type = _stationType(mmsi);
  return MmsiInfo(
    valid: true,
    mmsi: mmsi,
    mid: mid,
    country: country,
    stationType: type,
  );
}

MmsiStationType _stationType(String mmsi) {
  if (mmsi.startsWith('111')) return MmsiStationType.sarAircraft;
  if (mmsi.startsWith('98')) return MmsiStationType.aton;
  if (mmsi.startsWith('970')) return MmsiStationType.sar;
  return switch (mmsi[0]) {
    '0' => MmsiStationType.groupCall,
    '1' => MmsiStationType.sarAircraft,
    '2' => MmsiStationType.coastStation,
    '3' => MmsiStationType.shipStation,
    '4' => MmsiStationType.handheldVhf,
    '8' => MmsiStationType.aton,
    '9' => MmsiStationType.sar,
    '5' || '6' || '7' => MmsiStationType.shipStation,
    _ => MmsiStationType.other,
  };
}
