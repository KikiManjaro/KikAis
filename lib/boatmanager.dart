import 'package:flutter/material.dart';

import 'ais/src/messages/base/ais_message.dart';
import 'ais/src/messages/position/position_message.dart';
import 'boat.dart';

class BoatManager extends ChangeNotifier {
  final Map<int, Boat> _boats = {}; // MMSI -> Boat
  bool createMarkers = true;

  List<Boat> get boats => _boats.values.toList();

  void processMessage(String msg) {
    try {
      AISMessage message = AISMessage.fromString(msg);
      if (!_boats.containsKey(message.mmsi)) {
        _boats[message.mmsi] = Boat(mmsi: message.mmsi.toString());
      }
      updateFromMessage(_boats[message.mmsi]!, message);
    } catch (e) {
      print("Error processing message: $e");
    }
  }

  void updateFromMessage(Boat boat, AISMessage message) {
    if (message is PositionMessage) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.navigationStatus = message.navigationStatus;
      notifyListeners();
    }
  }
}
