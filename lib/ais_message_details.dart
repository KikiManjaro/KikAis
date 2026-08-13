import 'dart:typed_data';

import 'package:kik_ais/ais/ais_decoder.dart';

import 'ais_editor_specs.dart' show editorMessageTypeLabel;
import 'l10n/generated/app_localizations.dart';
import 'value_labels.dart';

/// A labelled field shown in the message details view.
typedef MessageField = (String label, String value);

/// Builds a labelled field list describing every meaningful field of a
/// decoded AIS message (used by the "Decoder" page).
List<MessageField> describeMessage(AISMessage message, AppLocalizations l10n) {
  final fields = <MessageField>[
    (
      l10n.fMessageType,
      'T${message.messageType} · '
          '${editorMessageTypeLabel(message.messageType, l10n)}',
    ),
    (l10n.fMmsi, '${message.mmsi}'),
    (l10n.fRepeatIndicator, '${message.repeatIndicator}'),
  ];

  switch (message.messageType) {
    case 1 || 2 || 3:
      final m = message as PositionMessage;
      _add(fields, l10n.fNavStatus, valueLabel(l10n, m.navigationStatus));
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fSogKn, m.speedOverGround);
      _add(fields, l10n.fCogDeg, m.courseOverGround);
      _add(fields, l10n.fHeadingDeg, m.heading);
      _add(fields, l10n.fRateOfTurn, _isNa(m.rateOfTurn) ? null : m.rateOfTurn);
      _add(fields, l10n.fManeuver, valueLabel(l10n, m.maneuverIndicator));
      _add(fields, l10n.fTimestamp, m.timestamp);
      _add(fields, l10n.fRaim, m.raimEnabled);
    case 4:
      final m = message as BaseStationReport;
      _add(fields, l10n.fUtc, _utc(m.year, m.month, m.day, m.hour, m.minute, m.second));
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fAccuracy, m.accuracy);
      _add(fields, l10n.fEpfdFixType, valueLabel(l10n, m.epfdFixType));
      _add(fields, l10n.fRaim, m.raim);
      _add(fields, l10n.fSyncState, m.sotdmaState);
    case 5:
      final m = message as StaticAndVoyageRelatedData;
      _add(fields, l10n.fImo, m.imoNumber == 0 ? null : m.imoNumber);
      _add(fields, l10n.fCallSign, _text(m.callSign));
      _add(fields, l10n.fVesselName, _text(m.vesselName));
      _add(fields, l10n.fShipType, m.vesselTypeInt);
      _add(fields, l10n.fShipTypeText, valueLabel(l10n, m.vesselType));
      _add(fields, l10n.fDims,
          _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
      _add(fields, l10n.fEpfdFixType, valueLabel(l10n, m.epfdFixType));
      _add(fields, l10n.fEta, _eta(m.etaMonth, m.etaDay, m.etaHour, m.etaMinute));
      _add(fields, l10n.fDraughtM, m.draught);
      _add(fields, l10n.fDestination, _text(m.destination));
      _add(fields, l10n.fDte, m.dte);
    case 6:
      final m = message as BinaryAddressedMessage;
      _add(fields, l10n.fDestMmsi, m.destinationMMSI);
      _add(fields, l10n.fSeqNumber, m.sequenceNumber);
      _add(fields, l10n.fRetransmit, m.retransmit);
      _add(fields, l10n.fDac, m.dac);
      _add(fields, l10n.fFid, m.fid);
      _add(fields, l10n.fData, _hex(m.data));
    case 7:
      final m = message as BinaryAcknowledge;
      _ackFields(fields, l10n, m.mmsi1, m.mmsiSeq1, m.mmsi2, m.mmsiSeq2, m.mmsi3,
          m.mmsiSeq3, m.mmsi4, m.mmsiSeq4);
    case 8:
      final m = message as BinaryBroadcastMessage;
      _add(fields, l10n.fDac, m.dac);
      _add(fields, l10n.fFid, m.fid);
      _add(fields, l10n.fData, _hex(m.data));
    case 9:
      final m = message as SarAircraftPositionReport;
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fAltitudeM, m.altitude);
      _add(fields, l10n.fSogKn, m.speedOverGround);
      _add(fields, l10n.fCogDeg, m.courseOverGround);
      _add(fields, l10n.fAccuracy, m.positionAccuracy);
      _add(fields, l10n.fTimestamp, m.timestamp);
      _add(fields, l10n.fDte, m.dte);
      _add(fields, l10n.fAssignedMode, m.assignedMode);
      _add(fields, l10n.fRaim, m.raimEnabled);
      _add(fields, l10n.fRegionalReserved, m.regionalReserved);
    case 10:
      final m = message as UtcDateInquiry;
      _add(fields, l10n.fDestMmsi, m.destinationMmsi);
    case 11:
      final m = message as UtcDateResponse;
      _add(fields, l10n.fUtc, _utc(m.year, m.month, m.day, m.hour, m.minute, m.second));
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fAccuracy, m.accuracy);
      _add(fields, l10n.fEpfdFixType, valueLabel(l10n, m.epfdFixType));
      _add(fields, l10n.fRaim, m.raim);
      _add(fields, l10n.fSyncState, m.sotdmaState);
    case 12:
      final m = message as AddressedSafetyRelatedMessage;
      _add(fields, l10n.fDestMmsi, m.destinationMmsi);
      _add(fields, l10n.fSeqNumber, m.sequenceNumber);
      _add(fields, l10n.fRetransmit, m.retransmit);
      _add(fields, l10n.fText, _text(m.text));
    case 13:
      final m = message as SafetyRelatedAcknowledgement;
      _ackFields(fields, l10n, m.mmsi1, m.mmsiSeq1, m.mmsi2, m.mmsiSeq2, m.mmsi3,
          m.mmsiSeq3, m.mmsi4, m.mmsiSeq4);
    case 14:
      final m = message as SafetyRelatedBroadcastMessage;
      _add(fields, l10n.fText, _text(m.text));
    case 15:
      final m = message as InterrogationMessage;
      _add(fields, l10n.fStationN('1'), '${m.mmsi1} · T${m.type1_1}@${m.offset1_1}'
          '${m.type1_2 != null ? ' · T${m.type1_2}@${m.offset1_2}' : ''}');
      if (m.mmsi2 != null) {
        _add(fields, l10n.fStationN('2'), '${m.mmsi2} · T${m.type2_1}@${m.offset2_1}');
      }
    case 16:
      final m = message as AssignmentModeCommand;
      _add(fields, l10n.fStationN('1'), '${m.mmsi1} · ${m.offset1}+${m.increment1}');
      if (m.mmsi2 != null) {
        _add(fields, l10n.fStationN('2'), '${m.mmsi2} · ${m.offset2}+${m.increment2}');
      }
    case 17:
      final m = message as DgnssBroadcastBinaryMessage;
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fData, _hex(m.data));
    case 18:
      final m = message as StandardClassBCSPositionReport;
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fSogKn, m.speedOverGround);
      _add(fields, l10n.fCogDeg, m.courseOverGround);
      _add(fields, l10n.fHeadingDeg, m.heading);
      _add(fields, l10n.fAccuracy, m.positionAccuracy);
      _add(fields, l10n.fTimestamp, m.timestamp);
      _add(fields, l10n.fRaim, m.raimFlag);
    case 19:
      final m = message as ExtendedClassBCSPositionReport;
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fSogKn, m.speedOverGround);
      _add(fields, l10n.fCogDeg, m.courseOverGround);
      _add(fields, l10n.fHeadingDeg, m.heading);
      _add(fields, l10n.fVesselName, _text(m.vesselName));
      _add(fields, l10n.fShipType, m.vesselTypeInt);
      _add(fields, l10n.fShipTypeText, valueLabel(l10n, m.vesselType));
      _add(fields, l10n.fDims,
          _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
      _add(fields, l10n.fEpfdFixType, valueLabel(l10n, m.epfdFixType));
      _add(fields, l10n.fAccuracy, m.positionAccuracy);
      _add(fields, l10n.fTimestamp, m.timestamp);
      _add(fields, l10n.fDte, m.dte);
      _add(fields, l10n.fAssignedMode, m.assignedMode);
      _add(fields, l10n.fRaim, m.raimFlag);
      _add(fields, l10n.fRegionalReserved, m.regionalReserved);
    case 20:
      final m = message as DataLinkManagementMessage;
      for (var i = 1; i <= 4; i++) {
        final off = _slotValue(m, 'offset$i');
        final num = _slotValue(m, 'number$i');
        final timeout = _slotValue(m, 'timeout$i');
        final inc = _slotValue(m, 'increment$i');
        if (off != null && num != null) {
          _add(fields, l10n.fSlotN('$i'),
              l10n.fSlotDetail('$off', '$num', '$timeout', '$inc'));
        }
      }
    case 21:
      final m = message as AidToNavigationReport;
      _add(fields, l10n.fAidType, valueLabel(l10n, m.aidType));
      _add(fields, l10n.fAidTypeCode, m.aidTypeInt);
      _add(fields, l10n.fName, _text(m.name));
      _add(fields, l10n.fNameExt, _text(m.nameExtension));
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fDims,
          _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
      _add(fields, l10n.fEpfdFixType, valueLabel(l10n, m.epfdFixType));
      _add(fields, l10n.fVirtualAid, m.virtualAid);
      _add(fields, l10n.fOffPosition, m.offPosition);
      _add(fields, l10n.fSecond, m.second);
      _add(fields, l10n.fAccuracy, m.positionAccuracy);
      _add(fields, l10n.fRaim, m.raimFlag);
      _add(fields, l10n.fAssignedMode, m.assignedMode);
    case 22:
      final m = message as ChannelManagementMessage;
      _add(fields, l10n.fChannelA, m.channelA);
      _add(fields, l10n.fChannelB, m.channelB);
      _add(fields, l10n.fTxRxMode, valueLabel(l10n, m.txrxMode));
      _add(fields, l10n.fPower, m.power == 1 ? l10n.fPowerHigh : l10n.fPowerLow);
      _add(fields, l10n.fZone, '${_coord(m.swLatitude)} ${_coord(m.swLongitude)} → ${_coord(m.neLatitude)} ${_coord(m.neLongitude)}');
      _add(fields, l10n.fAddressed, m.addressed);
      _add(fields, l10n.fMmsi1, m.mmsi1);
      _add(fields, l10n.fMmsi2, m.mmsi2);
      _add(fields, l10n.fBandA, m.bandA);
      _add(fields, l10n.fBandB, m.bandB);
      _add(fields, l10n.fZoneSize, m.zoneSize);
    case 23:
      final m = message as GroupAssignmentCommand;
      _add(fields, l10n.fZone, '${_coord(m.swLatitude)} ${_coord(m.swLongitude)} → ${_coord(m.neLatitude)} ${_coord(m.neLongitude)}');
      _add(fields, l10n.fStationType, valueLabel(l10n, m.stationType));
      _add(fields, l10n.fShipType, valueLabel(l10n, m.shipType));
      _add(fields, l10n.fTxRxMode, valueLabel(l10n, m.txrxMode));
      _add(fields, l10n.fReportInterval, valueLabel(l10n, m.intervalInfo));
      _add(fields, l10n.fQuietTime, m.quietTime);
    case 24:
      if (message is StaticDataReportA) {
        _add(fields, l10n.fPart, l10n.fPartA);
        _add(fields, l10n.fVesselName, _text(message.vesselName));
      } else {
        final m = message as StaticDataReportB;
        _add(fields, l10n.fPart, l10n.fPartB);
        _add(fields, l10n.fShipType, m.vesselTypeInt);
        _add(fields, l10n.fShipTypeText, _text(m.vesselType));
        _add(fields, l10n.fVendorId, _text(m.vendorId));
        _add(fields, l10n.fUnitModel, m.unitModel);
        _add(fields, l10n.fSerialNumber, m.serialNumber);
        _add(fields, l10n.fCallSign, _text(m.callSign));
        _add(fields, l10n.fDims,
            _dims(m.dimensionBow, m.dimensionStern, m.dimensionPort, m.dimensionStarboard));
        _add(fields, l10n.fMothershipMmsi, m.mothershipMMSI == 0 ? null : m.mothershipMMSI);
      }
    case 25:
      final m = message as SingleSlotBinaryMessage;
      _binaryFields(fields, l10n, m.destinationIndicator, m.binaryDataFlag,
          m.destinationMmsi, m.applicationId, m.dac, m.fid, m.data);
    case 26:
      final m = message as MultipleSlotBinaryMessage;
      _binaryFields(fields, l10n, m.destinationIndicator, m.binaryDataFlag,
          m.destinationMmsi, m.applicationId, m.dac, m.fid, m.data);
      _add(fields, l10n.fRadioStatus, m.radioStatus);
    case 27:
      final m = message as LongRangeAISBroadcastMessage;
      _add(fields, l10n.fNavStatus, valueLabel(l10n, m.navigationStatus));
      _add(fields, l10n.fLatitude, _coord(m.latitude));
      _add(fields, l10n.fLongitude, _coord(m.longitude));
      _add(fields, l10n.fSogKn, m.speedOverGround);
      _add(fields, l10n.fCogDeg, m.courseOverGround);
      _add(fields, l10n.fGnssStatus, m.gnssPositionStatus);
      _add(fields, l10n.fRaim, m.raimEnabled);
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

void _ackFields(List<MessageField> fields, AppLocalizations l10n, int mmsi1,
    int seq1, int? mmsi2, int? seq2, int? mmsi3, int? seq3, int? mmsi4,
    int? seq4) {
  _add(fields, l10n.fDestN('1'), l10n.fDestDetail('$mmsi1', '$seq1'));
  if (mmsi2 != null) _add(fields, l10n.fDestN('2'), l10n.fDestDetail('$mmsi2', '$seq2'));
  if (mmsi3 != null) _add(fields, l10n.fDestN('3'), l10n.fDestDetail('$mmsi3', '$seq3'));
  if (mmsi4 != null) _add(fields, l10n.fDestN('4'), l10n.fDestDetail('$mmsi4', '$seq4'));
}

void _binaryFields(
  List<MessageField> fields,
  AppLocalizations l10n,
  int? destinationIndicator,
  int? binaryDataFlag,
  int? destinationMmsi,
  int? applicationId,
  int? dac,
  int? fid,
  Uint8List? data,
) {
  _add(fields, l10n.fDestIndicator, destinationIndicator);
  _add(fields, l10n.fBinaryDataFlag, binaryDataFlag);
  _add(fields, l10n.fDestMmsi, destinationMmsi);
  _add(fields, l10n.fApplicationId, applicationId);
  _add(fields, l10n.fDac, dac);
  _add(fields, l10n.fFid, fid);
  _add(fields, l10n.fData, _hex(data));
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
