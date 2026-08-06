enum BoatKind { vessel, aircraft, aton, station }

/// A raw NMEA sentence that decoded into a message for a [Boat].
class BoatFrame {
  final String raw;
  final String? feed;
  final DateTime time;
  final int? type;

  const BoatFrame({
    required this.raw,
    this.feed,
    required this.time,
    this.type,
  });
}

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

  static const int maxFrameLog = 200;

  /// Raw NMEA frames that decoded into messages for this boat, oldest first.
  final List<BoatFrame> frameLog = [];

  Boat({required this.mmsi});

  void addFrame(BoatFrame frame) {
    frameLog.add(frame);
    if (frameLog.length > maxFrameLog) {
      frameLog.removeRange(0, frameLog.length - maxFrameLog);
    }
  }
}
