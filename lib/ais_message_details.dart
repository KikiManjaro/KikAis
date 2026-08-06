import 'dart:typed_data';

import 'package:kik_ais/ais/ais_decoder.dart';

import 'ais_editor_specs.dart' show kEditorTypeLabels;

/// A labelled field shown in the message details view.
typedef MessageField = (String label, String value);

/// Builds a labelled field list describing every meaningful field of a
/// decoded AIS message (used by the "Decoder" page).
List<MessageField> describeMessage(AISMessage message) {
  final fields = <MessageField>[
    (
      'Message type',
      'T${message.messageType} · '
          '${kEditorTypeLabels[message.messageType] ?? 'Type ${message.messageType}'}',
    ),
    ('MMSI', '${message.mmsi}'),
    ('Repeat indicator', '${message.repeatIndicator}'),
  ];

  switch (message.messageType) {
    case 1 || 2 || 3:
      final m = message as PositionMessage;
      _add(fields, 'Navigation status', m.navigationStatus.isEmpty ? null : m.navigationStatus);
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'SOG (kn)', m.speedOverGround);
      _add(fields, 'COG (°)', m.courseOverGround);
      _add(fields, 'Heading (°)', m.heading);
      _add(fields, 'Rate of turn', _isNa(m.rateOfTurn) ? null : m.rateOfTurn);
      _add(fields, 'Maneuver', m.maneuverIndicator.isEmpty ? null : m.maneuverIndicator);
      _add(fields, 'Timestamp', m.timestamp);
      _add(fields, 'RAIM', m.raimEnabled);
    case 4:
      final m = message as BaseStationReport;
      _add(fields, 'UTC', _utc(m.year, m.month, m.day, m.hour, m.minute, m.second));
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'Accuracy', m.accuracy);
      _add(fields, 'EPFD fix type', m.epfdFixType);
      _add(fields, 'RAIM', m.raim);
      _add(fields, 'Sync state', m.sotdmaState);
    case 5:
      final m = message as StaticAndVoyageRelatedData;
      _add(fields, 'IMO', m.imoNumber == 0 ? null : m.imoNumber);
      _add(fields, 'Call sign', _text(m.callSign));
      _add(fields, 'Vessel name', _text(m.vesselName));
      _add(fields, 'Ship type', m.vesselTypeInt);
      _add(fields, 'Ship type (text)', m.vesselType.isEmpty ? null : m.vesselType);
      _add(fields, 'Bow/Stern/Port/Starboard (m)',
          _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
      _add(fields, 'EPFD fix type', m.epfdFixType);
      _add(fields, 'ETA', _eta(m.etaMonth, m.etaDay, m.etaHour, m.etaMinute));
      _add(fields, 'Draught (m)', m.draught);
      _add(fields, 'Destination', _text(m.destination));
      _add(fields, 'DTE', m.dte);
    case 6:
      final m = message as BinaryAddressedMessage;
      _add(fields, 'Destination MMSI', m.destinationMMSI);
      _add(fields, 'Sequence number', m.sequenceNumber);
      _add(fields, 'Retransmit', m.retransmit);
      _add(fields, 'DAC', m.dac);
      _add(fields, 'FID', m.fid);
      _add(fields, 'Data', _hex(m.data));
    case 7:
      final m = message as BinaryAcknowledge;
      _ackFields(fields, m.mmsi1, m.mmsiSeq1, m.mmsi2, m.mmsiSeq2, m.mmsi3,
          m.mmsiSeq3, m.mmsi4, m.mmsiSeq4);
    case 8:
      final m = message as BinaryBroadcastMessage;
      _add(fields, 'DAC', m.dac);
      _add(fields, 'FID', m.fid);
      _add(fields, 'Data', _hex(m.data));
    case 9:
      final m = message as SarAircraftPositionReport;
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'Altitude (m)', m.altitude);
      _add(fields, 'SOG (kn)', m.speedOverGround);
      _add(fields, 'COG (°)', m.courseOverGround);
      _add(fields, 'Accuracy', m.positionAccuracy);
      _add(fields, 'Timestamp', m.timestamp);
      _add(fields, 'DTE', m.dte);
      _add(fields, 'Assigned mode', m.assignedMode);
      _add(fields, 'RAIM', m.raimEnabled);
      _add(fields, 'Regional reserved', m.regionalReserved);
    case 10:
      final m = message as UtcDateInquiry;
      _add(fields, 'Destination MMSI', m.destinationMmsi);
    case 11:
      final m = message as UtcDateResponse;
      _add(fields, 'UTC', _utc(m.year, m.month, m.day, m.hour, m.minute, m.second));
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'Accuracy', m.accuracy);
      _add(fields, 'EPFD fix type', m.epfdFixType);
      _add(fields, 'RAIM', m.raim);
      _add(fields, 'Sync state', m.sotdmaState);
    case 12:
      final m = message as AddressedSafetyRelatedMessage;
      _add(fields, 'Destination MMSI', m.destinationMmsi);
      _add(fields, 'Sequence number', m.sequenceNumber);
      _add(fields, 'Retransmit', m.retransmit);
      _add(fields, 'Text', _text(m.text));
    case 13:
      final m = message as SafetyRelatedAcknowledgement;
      _ackFields(fields, m.mmsi1, m.mmsiSeq1, m.mmsi2, m.mmsiSeq2, m.mmsi3,
          m.mmsiSeq3, m.mmsi4, m.mmsiSeq4);
    case 14:
      final m = message as SafetyRelatedBroadcastMessage;
      _add(fields, 'Text', _text(m.text));
    case 15:
      final m = message as InterrogationMessage;
      _add(fields, 'Station 1', '${m.mmsi1} · T${m.type1_1}@${m.offset1_1}'
          '${m.type1_2 != null ? ' · T${m.type1_2}@${m.offset1_2}' : ''}');
      if (m.mmsi2 != null) {
        _add(fields, 'Station 2', '${m.mmsi2} · T${m.type2_1}@${m.offset2_1}');
      }
    case 16:
      final m = message as AssignmentModeCommand;
      _add(fields, 'Station 1', '${m.mmsi1} · ${m.offset1}+${m.increment1}');
      if (m.mmsi2 != null) {
        _add(fields, 'Station 2', '${m.mmsi2} · ${m.offset2}+${m.increment2}');
      }
    case 17:
      final m = message as DgnssBroadcastBinaryMessage;
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'Data', _hex(m.data));
    case 18:
      final m = message as StandardClassBCSPositionReport;
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'SOG (kn)', m.speedOverGround);
      _add(fields, 'COG (°)', m.courseOverGround);
      _add(fields, 'Heading (°)', m.heading);
      _add(fields, 'Accuracy', m.positionAccuracy);
      _add(fields, 'Timestamp', m.timestamp);
      _add(fields, 'RAIM', m.raimFlag);
    case 19:
      final m = message as ExtendedClassBCSPositionReport;
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'SOG (kn)', m.speedOverGround);
      _add(fields, 'COG (°)', m.courseOverGround);
      _add(fields, 'Heading (°)', m.heading);
      _add(fields, 'Vessel name', _text(m.vesselName));
      _add(fields, 'Ship type', m.vesselTypeInt);
      _add(fields, 'Ship type (text)', m.vesselType.isEmpty ? null : m.vesselType);
      _add(fields, 'Bow/Stern/Port/Starboard (m)',
          _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
      _add(fields, 'EPFD fix type', m.epfdFixType);
      _add(fields, 'Accuracy', m.positionAccuracy);
      _add(fields, 'Timestamp', m.timestamp);
      _add(fields, 'DTE', m.dte);
      _add(fields, 'Assigned mode', m.assignedMode);
      _add(fields, 'RAIM', m.raimFlag);
      _add(fields, 'Regional reserved', m.regionalReserved);
    case 20:
      final m = message as DataLinkManagementMessage;
      for (var i = 1; i <= 4; i++) {
        final off = _slotValue(m, 'offset$i');
        final num = _slotValue(m, 'number$i');
        final timeout = _slotValue(m, 'timeout$i');
        final inc = _slotValue(m, 'increment$i');
        if (off != null && num != null) {
          _add(fields, 'Slot $i', 'offset $off · number $num · timeout $timeout · inc $inc');
        }
      }
    case 21:
      final m = message as AidToNavigationReport;
      _add(fields, 'Aid type', _text(m.aidType));
      _add(fields, 'Aid type (code)', m.aidTypeInt);
      _add(fields, 'Name', _text(m.name));
      _add(fields, 'Name extension', _text(m.nameExtension));
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'Bow/Stern/Port/Starboard (m)',
          _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
      _add(fields, 'EPFD fix type', m.epfdFixType);
      _add(fields, 'Virtual aid', m.virtualAid);
      _add(fields, 'Off position', m.offPosition);
      _add(fields, 'Second', m.second);
      _add(fields, 'Accuracy', m.positionAccuracy);
      _add(fields, 'RAIM', m.raimFlag);
      _add(fields, 'Assigned mode', m.assignedMode);
    case 22:
      final m = message as ChannelManagementMessage;
      _add(fields, 'Channel A', m.channelA);
      _add(fields, 'Channel B', m.channelB);
      _add(fields, 'TX/RX mode', _text(m.txrxMode));
      _add(fields, 'Power', m.power == 1 ? 'High' : 'Low');
      _add(fields, 'Zone', '${_coord(m.swLatitude)} ${_coord(m.swLongitude)} → ${_coord(m.neLatitude)} ${_coord(m.neLongitude)}');
      _add(fields, 'Addressed', m.addressed);
      _add(fields, 'MMSI 1', m.mmsi1);
      _add(fields, 'MMSI 2', m.mmsi2);
      _add(fields, 'Band A', m.bandA);
      _add(fields, 'Band B', m.bandB);
      _add(fields, 'Zone size', m.zoneSize);
    case 23:
      final m = message as GroupAssignmentCommand;
      _add(fields, 'Zone', '${_coord(m.swLatitude)} ${_coord(m.swLongitude)} → ${_coord(m.neLatitude)} ${_coord(m.neLongitude)}');
      _add(fields, 'Station type', _text(m.stationType));
      _add(fields, 'Ship type', _text(m.shipType));
      _add(fields, 'TX/RX mode', _text(m.txrxMode));
      _add(fields, 'Report interval', _text(m.intervalInfo));
      _add(fields, 'Quiet time', m.quietTime);
    case 24:
      if (message is StaticDataReportA) {
        _add(fields, 'Part', 'A (name)');
        _add(fields, 'Vessel name', _text(message.vesselName));
      } else {
        final m = message as StaticDataReportB;
        _add(fields, 'Part', 'B (ship data)');
        _add(fields, 'Ship type', m.vesselTypeInt);
        _add(fields, 'Ship type (text)', _text(m.vesselType));
        _add(fields, 'Vendor ID', _text(m.vendorId));
        _add(fields, 'Unit model', m.unitModel);
        _add(fields, 'Serial number', m.serialNumber);
        _add(fields, 'Call sign', _text(m.callSign));
        _add(fields, 'Bow/Stern/Port/Starboard (m)',
            _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
        _add(fields, 'Mothership MMSI', m.mothershipMMSI == 0 ? null : m.mothershipMMSI);
      }
    case 25:
      final m = message as SingleSlotBinaryMessage;
      _binaryFields(fields, m.destinationIndicator, m.binaryDataFlag,
          m.destinationMmsi, m.applicationId, m.dac, m.fid, m.data);
    case 26:
      final m = message as MultipleSlotBinaryMessage;
      _binaryFields(fields, m.destinationIndicator, m.binaryDataFlag,
          m.destinationMmsi, m.applicationId, m.dac, m.fid, m.data);
      _add(fields, 'Radio status', m.radioStatus);
    case 27:
      final m = message as LongRangeAISBroadcastMessage;
      _add(fields, 'Navigation status', m.navigationStatus.isEmpty ? null : m.navigationStatus);
      _add(fields, 'Latitude', _coord(m.latitude));
      _add(fields, 'Longitude', _coord(m.longitude));
      _add(fields, 'SOG (kn)', m.speedOverGround);
      _add(fields, 'COG (°)', m.courseOverGround);
      _add(fields, 'GNSS position status', m.gnssPositionStatus);
      _add(fields, 'RAIM', m.raimEnabled);
  }

  return fields;
}

int? _slotValue(DataLinkManagementMessage m, String name) {
  switch (name) {
    case 'offset1':
      return m.offset1;
    case 'number1':
      return m.number1;
    case 'timeout1':
      return m.timeout1;
    case 'increment1':
      return m.increment1;
    case 'offset2':
      return m.offset2;
    case 'number2':
      return m.number2;
    case 'timeout2':
      return m.timeout2;
    case 'increment2':
      return m.increment2;
    case 'offset3':
      return m.offset3;
    case 'number3':
      return m.number3;
    case 'timeout3':
      return m.timeout3;
    case 'increment3':
      return m.increment3;
    case 'offset4':
      return m.offset4;
    case 'number4':
      return m.number4;
    case 'timeout4':
      return m.timeout4;
    case 'increment4':
      return m.increment4;
  }
  return null;
}

String _coord(double? value) =>
    value == null ? '—' : value.toStringAsFixed(5);

bool _isNa(double v) => v.isNaN || v == -128.0 || v == 127.0;

void _ackFields(List<MessageField> fields, int mmsi1, int seq1, int? mmsi2,
    int? seq2, int? mmsi3, int? seq3, int? mmsi4, int? seq4) {
  _add(fields, 'Destination 1', '$mmsi1 seq $seq1');
  if (mmsi2 != null) _add(fields, 'Destination 2', '$mmsi2 seq $seq2');
  if (mmsi3 != null) _add(fields, 'Destination 3', '$mmsi3 seq $seq3');
  if (mmsi4 != null) _add(fields, 'Destination 4', '$mmsi4 seq $seq4');
}

void _binaryFields(
  List<MessageField> fields,
  int? destinationIndicator,
  int? binaryDataFlag,
  int? destinationMmsi,
  int? applicationId,
  int? dac,
  int? fid,
  Uint8List? data,
) {
  _add(fields, 'Destination indicator', destinationIndicator);
  _add(fields, 'Binary data flag', binaryDataFlag);
  _add(fields, 'Destination MMSI', destinationMmsi);
  _add(fields, 'Application ID', applicationId);
  _add(fields, 'DAC', dac);
  _add(fields, 'FID', fid);
  _add(fields, 'Data', _hex(data));
}

String _text(String? s) {
  final t = s?.trim() ?? '';
  return t.isEmpty ? '—' : t;
}

String _hex(Uint8List? data) {
  if (data == null || data.isEmpty) return '—';
  return data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
}

String _utc(int year, int month, int day, int hour, int minute, int second) {
  if (year == 0) return '—';
  return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
}

String _eta(int month, int day, int hour, int minute) {
  if (month == 0) return '—';
  final h = hour == 24 ? null : hour;
  final mi = minute == 60 ? null : minute;
  return '${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} '
      '${h == null ? '--' : h.toString().padLeft(2, '0')}:'
      '${mi == null ? '--' : mi.toString().padLeft(2, '0')}';
}

String _dims(int bow, int stern, int port, int starboard) {
  if (bow == 0 && stern == 0 && port == 0 && starboard == 0) return '—';
  return '$bow / $stern / $port / $starboard';
}

void _add(List<MessageField> fields, String label, dynamic value) {
  if (value == null) return;
  final text = '$value';
  if (text.isEmpty || text == '—' || text == 'null') return;
  fields.add((label, text));
}
