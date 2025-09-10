import 'package:flutter/material.dart';

import 'ais/src/messages/base/ais_message.dart';
import 'ais/src/messages/position/class_b_position.dart';
import 'ais/src/messages/position/extended_class_b.dart';
import 'ais/src/messages/position/position_message.dart';
import 'ais/src/messages/static/static_voyage_data.dart';
import 'boat.dart';

class BoatManager extends ChangeNotifier {
  final Map<int, Boat> _boats = {};
  bool createMarkers = true;

  List<Boat> get boats => _boats.values.toList();

  Future<void> processMessage(String msg) async {
    await Future(() {
      try {
        AISMessage message = AISMessage.fromString(msg);

        _boats.putIfAbsent(
          message.mmsi,
              () => Boat(mmsi: message.mmsi.toString()),
        );

        updateFromMessage(_boats[message.mmsi]!, message);
      } catch (e, stack) {
        print("Error processing message: $e\n$stack");
      }
    });
  }

  void updateFromMessage(Boat boat, AISMessage message) {
    if (message is PositionMessage) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.navigationStatus = message.navigationStatus;
    } else if (message is ExtendedClassBCSPositionReport) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.name = message.vesselName;
      boat.vesselTypeInt = message.vesselTypeInt;
      boat.vesselType = message.vesselType;
      boat.dimensionBow = message.dimensionBow;
      boat.dimensionStern = message.dimensionStern;
      boat.dimensionPort = message.dimensionPort;
      boat.dimensionStarboard = message.dimensionStarboard;
      boat.epfdFixType = message.epfdFixType;
      boat.raimFlag = message.raimFlag;
      boat.dte = message.dte;
      boat.assignedMode = message.assignedMode;
      boat.spare = message.spare;
      boat.timestamp = message.timestamp;
      boat.regionalReserved = message.regionalReserved;
    } else if (message is StandardClassBCSPositionReport) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.timestamp = message.timestamp;
      boat.raimFlag = message.raimFlag;
    } else if (message is StandardClassBCSPositionReport) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.timestamp = message.timestamp;
      boat.raimFlag = message.raimFlag;
    } else if (message is StaticAndVoyageRelatedData) {
      boat.name = message.vesselName;
      boat.vesselTypeInt = message.vesselTypeInt;
      boat.vesselType = message.vesselType;
      boat.dimensionBow = message.dimensionBow;
      boat.dimensionStern = message.dimensionStern;
      boat.dimensionPort = message.dimensionPort;
      boat.dimensionStarboard = message.dimensionStarboard;
      boat.epfdFixType = message.epfdFixType;
      boat.etaMonth = message.etaMonth;
      boat.etaDay = message.etaDay;
      boat.etaHour = message.etaHour;
      boat.etaMinute = message.etaMinute;
      boat.draught = message.draught;
      boat.destination = message.destination;
      boat.dte = message.dte;
      boat.spare = message.spare;
      boat.imoNumber = message.imoNumber;
      boat.callSign = message.callSign;
    }
    notifyListeners();
  }
}
