import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'ais/src/messages/base/ais_message.dart';
import 'ais/src/messages/position/class_b_position.dart';
import 'ais/src/messages/position/extended_class_b.dart';
import 'ais/src/messages/position/long_range_broadcast.dart';
import 'ais/src/messages/position/position_message.dart';
import 'ais/src/messages/specialized/basestation_report.dart';
import 'ais/src/messages/static/static_voyage_data.dart';
import 'boat.dart';

class BoatManager extends ChangeNotifier {
  static const Duration boatTtl = Duration(minutes: 30);
  static const Duration purgeInterval = Duration(minutes: 1);
  static const Duration notifyThrottle = Duration(milliseconds: 200);

  final Map<int, Boat> _boats = {};
  bool sendToMap = false;

  Isolate? _decoderIsolate;
  SendPort? _decoderSendPort;
  final ReceivePort _decoderControl = ReceivePort();

  DateTime _lastNotify = DateTime.fromMillisecondsSinceEpoch(0);
  bool _pendingNotify = false;
  Timer? _purgeTimer;

  List<Boat> get boats => _boats.values.toList();

  BoatManager() {
    _purgeTimer = Timer.periodic(purgeInterval, (_) => purgeStaleBoats());
  }

  @override
  void dispose() {
    _purgeTimer?.cancel();
    _decoderControl.close();
    _decoderIsolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  void setSendToMap(bool value) {
    if (sendToMap == value) return;
    sendToMap = value;
    notifyListeners();
  }

  /// Spawns a dedicated isolate used to decode AIS messages so that the UI
  /// thread never blocks, even on high-volume streams.
  Future<void> startDecoder() async {
    if (_decoderIsolate != null) return;

    _decoderControl.listen((message) {
      if (message is SendPort) {
        _decoderSendPort = message;
      } else if (message is AISMessage) {
        updateFromMessage(message);
      }
    });

    try {
      _decoderIsolate = await Isolate.spawn(
        _decoderEntry,
        _decoderControl.sendPort,
      );
    } catch (e) {
      debugPrint('Failed to start AIS decoder isolate: $e');
    }
  }

  static void _decoderEntry(SendPort control) {
    final ReceivePort commandPort = ReceivePort();
    control.send(commandPort.sendPort);
    commandPort.listen((message) {
      try {
        final decoded = AISMessage.fromString(message as String);
        control.send(decoded);
      } catch (_) {
        // Malformed or unsupported sentences are silently ignored.
      }
    });
  }

  Future<void> processMessage(String msg) async {
    if (_decoderSendPort != null) {
      _decoderSendPort!.send(msg);
      return;
    }
    try {
      updateFromMessage(AISMessage.fromString(msg));
    } catch (e) {
      debugPrint('Error processing message: $e');
    }
  }

  void updateFromMessage(AISMessage message) {
    final boat = _boats.putIfAbsent(
      message.mmsi,
      () => Boat(mmsi: message.mmsi.toString()),
    );
    boat.lastUpdate = DateTime.now();

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
    } else if (message is LongRangeAISBroadcastMessage) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.navigationStatus = message.navigationStatus;
      boat.raimFlag = message.raimEnabled;
    } else if (message is BaseStationReport) {
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.epfdFixType = message.epfdFixType;
      boat.raimFlag = message.raim;
      boat.spare = message.spare;
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

    _notifyThrottled();
  }

  void _notifyThrottled() {
    final now = DateTime.now();
    if (now.difference(_lastNotify) >= notifyThrottle) {
      _lastNotify = now;
      notifyListeners();
    } else if (!_pendingNotify) {
      _pendingNotify = true;
      final remaining = notifyThrottle - now.difference(_lastNotify);
      Timer(remaining, () {
        _pendingNotify = false;
        _lastNotify = DateTime.now();
        notifyListeners();
      });
    }
  }

  void purgeStaleBoats() {
    if (_boats.isEmpty) return;
    final cutoff = DateTime.now().subtract(boatTtl);
    final before = _boats.length;
    _boats.removeWhere((_, boat) {
      final last = boat.lastUpdate;
      return last == null || last.isBefore(cutoff);
    });
    if (_boats.length != before) {
      notifyListeners();
    }
  }
}
