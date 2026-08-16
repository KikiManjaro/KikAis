import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'ais/src/messages/base/ais_message.dart';
import 'ais/src/messages/position/class_b_position.dart';
import 'ais/src/messages/position/extended_class_b.dart';
import 'ais/src/messages/position/long_range_broadcast.dart';
import 'ais/src/messages/position/position_message.dart';
import 'ais/src/messages/position/sar_aircraft_position_report.dart';
import 'ais/src/messages/specialized/aid_to_navigation.dart';
import 'ais/src/messages/specialized/basestation_report.dart';
import 'ais/src/messages/static_data/static_data_report.dart';
import 'ais/src/messages/static_data/static_voyage_data.dart';
import 'ais/src/nmea/ais_decoder.dart';
import 'boat.dart';
import 'message_stats.dart';

class BoatManager extends ChangeNotifier {
  static const Duration boatTtl = Duration(minutes: 30);
  static const Duration purgeInterval = Duration(minutes: 1);
  static const Duration notifyThrottle = Duration(milliseconds: 200);

  final Map<int, Boat> _boats = {};
  final MessageStats stats;
  bool sendToMap = false;
  bool decodeEnabled = true;
  bool validateChecksum = true;

  /// Incremented whenever the set of boats or their positions change. The map
  /// page uses it to memoize the visible-boat list so that unrelated rebuilds
  /// (button clicks, settings toggles) don't re-sync every animated boat.
  int boatsVersion = 0;

  int invalidChecksumCount = 0;
  int droppedFragmentCount = 0;
  int parseErrorCount = 0;
  int pendingFragmentCount = 0;
  int fragmentsSeen = 0;
  int multiPartCompleted = 0;

  Isolate? _decoderIsolate;
  SendPort? _decoderSendPort;
  final ReceivePort _decoderControl = ReceivePort();
  final AisNmeaDecoder _fallbackDecoder = AisNmeaDecoder();

  DateTime _lastNotify = DateTime.fromMillisecondsSinceEpoch(0);
  bool _pendingNotify = false;
  bool _disposed = false;
  Timer? _throttleTimer;
  Timer? _purgeTimer;

  List<Boat> get boats => _boats.values.toList();

  BoatManager({MessageStats? stats}) : stats = stats ?? MessageStats() {
    _purgeTimer = Timer.periodic(purgeInterval, (_) => purgeStaleBoats());
  }

  @override
  void dispose() {
    _disposed = true;
    _purgeTimer?.cancel();
    _throttleTimer?.cancel();
    _decoderControl.close();
    _decoderIsolate?.kill(priority: Isolate.immediate);
    super.dispose();
  }

  /// Removes every tracked vessel. New AIS messages will repopulate the map.
  void clearBoats() {
    if (_boats.isEmpty) return;
    _boats.clear();
    boatsVersion++;
    notifyListeners();
  }

  void setSendToMap(bool value) {
    if (sendToMap == value) return;
    sendToMap = value;
    notifyListeners();
  }

  void setDecodeEnabled(bool value) {
    if (decodeEnabled == value) return;
    decodeEnabled = value;
    notifyListeners();
  }

  void setValidateChecksum(bool value) {
    if (validateChecksum == value) return;
    validateChecksum = value;
    _fallbackDecoder.validateChecksum = value;
    _decoderSendPort?.send(value);
    notifyListeners();
  }

  /// Spawns a dedicated isolate used to decode AIS messages so that the UI
  /// thread never blocks, even on high-volume streams.
  Future<void> startDecoder() async {
    if (_decoderIsolate != null) return;

    _decoderControl.listen((message) {
      if (message is SendPort) {
        _decoderSendPort = message;
        _decoderSendPort?.send(validateChecksum);
      } else if (message is _DecodedWithFeed) {
        updateFromMessage(
          message.message,
          feed: message.feed,
          rawLines: message.rawLines,
        );
      } else if (message is DecoderReport) {
        _applyReport(message);
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
    final decoder = AisNmeaDecoder();
    commandPort.listen((message) {
      if (message is bool) {
        decoder.validateChecksum = message;
        return;
      }
      if (message is String) {
        if (message == 'reset') {
          decoder.reset();
        }
        control.send(decoder.report());
        return;
      }
      if (message is List) {
        final feed = message[0] as String?;
        final line = message[1] as String;
        final decoded = decoder.decode(line);
        if (decoded != null) {
          control.send(_DecodedWithFeed(decoded, feed, decoder.lastRawSentences));
        }
        control.send(decoder.report());
      }
    });
  }

  Future<void> processMessage(String msg, {String? feed}) async {
    if (_decoderSendPort != null) {
      _decoderSendPort!.send([feed, msg]);
      return;
    }
    final decoded = _fallbackDecoder.decode(msg);
    if (decoded != null) {
      updateFromMessage(
        decoded,
        feed: feed,
        rawLines: _fallbackDecoder.lastRawSentences,
      );
    }
    _applyReport(_fallbackDecoder.report());
  }

  void _applyReport(DecoderReport report) {
    final changed = invalidChecksumCount != report.invalidChecksums ||
        droppedFragmentCount != report.droppedFragments ||
        parseErrorCount != report.parseErrors ||
        pendingFragmentCount != report.pendingFragments ||
        fragmentsSeen != report.fragmentsSeen ||
        multiPartCompleted != report.multiPartCompleted;
    if (!changed) return;
    invalidChecksumCount = report.invalidChecksums;
    droppedFragmentCount = report.droppedFragments;
    parseErrorCount = report.parseErrors;
    pendingFragmentCount = report.pendingFragments;
    fragmentsSeen = report.fragmentsSeen;
    multiPartCompleted = report.multiPartCompleted;
    notifyListeners();
  }

  void resetCounters() {
    _fallbackDecoder.reset();
    _applyReport(_fallbackDecoder.report());
    _decoderSendPort?.send('reset');
    invalidChecksumCount = 0;
    droppedFragmentCount = 0;
    parseErrorCount = 0;
    pendingFragmentCount = 0;
    fragmentsSeen = 0;
    multiPartCompleted = 0;
    notifyListeners();
  }

  void updateFromMessage(
    AISMessage message, {
    String? feed,
    List<String>? rawLines,
  }) {
    stats.recordDecoded(message.messageType, feed: feed);
    final boat = _boats.putIfAbsent(
      message.mmsi,
      () => Boat(mmsi: message.mmsi.toString()),
    );
    boat.lastUpdate = DateTime.now();
    if (rawLines != null) {
      for (final raw in rawLines) {
        boat.addFrame(
          BoatFrame(
            raw: raw,
            feed: feed,
            time: DateTime.now(),
            type: message.messageType,
          ),
        );
      }
    }

    if (message is PositionMessage) {
      boat.kind = BoatKind.vessel;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.navigationStatus = message.navigationStatus;
    } else if (message is ExtendedClassBCSPositionReport) {
      boat.kind = BoatKind.vessel;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.name = message.vesselName.trim();
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
      boat.kind = BoatKind.vessel;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.heading = message.heading;
      boat.timestamp = message.timestamp;
      boat.raimFlag = message.raimFlag;
    } else if (message is LongRangeAISBroadcastMessage) {
      boat.kind = BoatKind.vessel;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround;
      boat.cog = message.courseOverGround;
      boat.navigationStatus = message.navigationStatus;
      boat.raimFlag = message.raimEnabled;
    } else if (message is BaseStationReport) {
      boat.kind = BoatKind.station;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.epfdFixType = message.epfdFixType;
      boat.raimFlag = message.raim;
      boat.spare = message.spare;
    } else if (message is SarAircraftPositionReport) {
      boat.kind = BoatKind.aircraft;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.sog = message.speedOverGround?.toDouble();
      boat.cog = message.courseOverGround;
      boat.altitude = message.altitude;
      boat.raimFlag = message.raimEnabled;
      boat.timestamp = message.timestamp;
    } else if (message is AidToNavigationReport) {
      boat.kind = BoatKind.aton;
      boat.lat = message.latitude;
      boat.lon = message.longitude;
      boat.name = message.name?.trim();
      boat.aidType = message.aidType;
      boat.virtualAid = message.virtualAid;
      boat.dimensionBow = message.dimensionBow;
      boat.dimensionStern = message.dimensionStern;
      boat.dimensionPort = message.dimensionPort;
      boat.dimensionStarboard = message.dimensionStarboard;
      boat.epfdFixType = message.epfdFixType;
      boat.raimFlag = message.raimFlag;
    } else if (message is StaticAndVoyageRelatedData) {
      boat.kind = BoatKind.vessel;
      boat.name = message.vesselName.trim();
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
      boat.callSign = message.callSign.trim();
    } else if (message is StaticDataReportA) {
      boat.kind = BoatKind.vessel;
      if (message.vesselName.trim().isNotEmpty) {
        boat.name = message.vesselName.trim();
      }
    } else if (message is StaticDataReportB) {
      boat.kind = BoatKind.vessel;
      boat.vesselTypeInt = message.vesselTypeInt;
      boat.vesselType = message.vesselType;
      boat.dimensionBow = message.dimensionBow;
      boat.dimensionStern = message.dimensionStern;
      boat.dimensionPort = message.dimensionPort;
      boat.dimensionStarboard = message.dimensionStarboard;
      boat.callSign = message.callSign.trim();
    }

    boatsVersion++;
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
      _throttleTimer?.cancel();
      _throttleTimer = Timer(remaining, () {
        _throttleTimer = null;
        _pendingNotify = false;
        _lastNotify = DateTime.now();
        if (_disposed) return;
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
      boatsVersion++;
      notifyListeners();
    }
  }
}

/// Simple, isolate-safe wrapper carrying a decoded AIS message together with
/// the feed and raw sentences it originated from (used by the decoder isolate
/// protocol).
class _DecodedWithFeed {
  final AISMessage message;
  final String? feed;
  final List<String>? rawLines;

  const _DecodedWithFeed(this.message, this.feed, [this.rawLines]);
}
