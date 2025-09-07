class Boat {
  final String mmsi;
  String? name;
  double? lat;
  double? lon;
  double? cog;
  double? sog;
  double? heading;
  String? navigationStatus;

  Boat({
    required this.mmsi,
  });
}
