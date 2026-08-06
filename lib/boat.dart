enum BoatKind { vessel, aircraft, aton, station }

class Boat {
  final String mmsi;
  DateTime? lastUpdate;
  BoatKind kind = BoatKind.vessel;
  String? name;
  double? lat;
  double? lon;
  double? cog;
  double? sog;
  double? heading;
  int? altitude;
  String? navigationStatus;
  String? aidType;
  int? virtualAid;
  int? timestamp;
  double? regionalReserved;
  int? vesselTypeInt;
  String? vesselType;
  int? dimensionBow;
  int? dimensionStern;
  int? dimensionPort;
  int? dimensionStarboard;
  String? epfdFixType;
  int? raimFlag;
  int? dte;
  int? assignedMode;
  int? spare;
  int? etaMonth;
  int? etaDay;
  int? etaHour;
  int? etaMinute;
  double? draught;
  String? destination;
  int? imoNumber;
  String? callSign;

  Boat({required this.mmsi});
}
