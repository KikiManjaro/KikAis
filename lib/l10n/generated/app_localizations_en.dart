// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageSystem => 'Auto (system)';

  @override
  String get languageEn => 'English';

  @override
  String get languageFr => 'Français';

  @override
  String get languageEs => 'Español';

  @override
  String get languageDe => 'Deutsch';

  @override
  String get languagePt => 'Português';

  @override
  String get languageIt => 'Italiano';

  @override
  String get languageNl => 'Nederlands';

  @override
  String get languageZh => '中文';

  @override
  String get languageJa => '日本語';

  @override
  String get languageRu => 'Русский';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themeHighContrast => 'High contrast';

  @override
  String get tabReception => 'Reception';

  @override
  String get tabSend => 'Send';

  @override
  String get tabMap => 'Map';

  @override
  String get tabEditor => 'Editor';

  @override
  String get tabTools => 'Tools';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabSimulation => 'Simulation';

  @override
  String get tabDocs => 'Docs';

  @override
  String get protocolUdpServer => 'UDP Server';

  @override
  String get protocolUdpClient => 'UDP Client';

  @override
  String get protocolTcpClient => 'TCP Client';

  @override
  String get protocolTcpServer => 'TCP Server';

  @override
  String get formatPassthrough => 'Pass-through';

  @override
  String get formatStrip => 'Strip tag blocks';

  @override
  String get formatTag => 'Add tag block';

  @override
  String get sendAddDestination => 'Add destination';

  @override
  String get sendEditDestination => 'Edit destination';

  @override
  String get sendFormat => 'Send format';

  @override
  String get sendSave => 'Save';

  @override
  String get sendLockedBanner =>
      'Forwarder is running — destinations are locked.';

  @override
  String get sendEmpty =>
      'No destination yet. Add one to forward received AIS frames.';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldProtocol => 'Protocol';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldTagSourceId => 'Tag source ID';

  @override
  String get fieldFile => 'File';

  @override
  String get fieldCancel => 'Cancel';

  @override
  String get fieldAdd => 'Add';

  @override
  String get receptionFeeds => 'Feeds';

  @override
  String get receptionValidateChecksums => 'Validate NMEA checksums';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sentences dropped',
      one: '1 sentence dropped',
      zero: 'No sentence dropped',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Import frame format';

  @override
  String get receptionStart => 'Start';

  @override
  String get receptionStop => 'Stop';

  @override
  String get receptionLogs => 'Logs';

  @override
  String get receptionFrameCopied => 'Frame copied';

  @override
  String get receptionAddSource => 'Add source';

  @override
  String get receptionNetwork => 'Network';

  @override
  String get receptionFile => 'File';

  @override
  String get receptionSerial => 'Serial';

  @override
  String get receptionHeaderOptional => 'Header (optional)';

  @override
  String get receptionPathOrBrowse => 'Path or Browse…';

  @override
  String get receptionIntervalMs => 'Interval between frames (ms)';

  @override
  String get receptionReplayTimestamps => 'Replay using file timestamps';

  @override
  String get receptionReplayTimestampsHint =>
      'Follows the recorded times (tag block t: or timestamp prefix) instead of a fixed interval';

  @override
  String get receptionSpeed => 'Speed';

  @override
  String get receptionReplayLoop => 'Loop (replay from the start)';

  @override
  String get receptionSerialPort => 'Serial port';

  @override
  String get receptionSerialPortHint => 'e.g. COM3 or /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Baud rate';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'RTL-SDR device';

  @override
  String get tooltipReceptionRtlSdrDevices =>
      'Refresh the list of RTL-SDR dongles';

  @override
  String get receptionRtlSdrNoDevice =>
      'No RTL-SDR device found. Install the RTL-SDR drivers (Zadig / WinUSB on Windows) and plug in the dongle.';

  @override
  String get receptionRtlSdrAutoGain => 'Automatic gain (recommended)';

  @override
  String get receptionRtlSdrGainDb => 'Tuner gain (dB)';

  @override
  String get receptionRtlSdrSampleRate => 'Sample rate';

  @override
  String get receptionRtlSdrChannels => 'Channels';

  @override
  String get msgType1 => 'Position Report Class A';

  @override
  String get msgType2 => 'Position Report Class A (assigned)';

  @override
  String get msgType3 => 'Position Report Class A (response)';

  @override
  String get msgType4 => 'Base Station';

  @override
  String get msgType5 => 'Static and Voyage Related Data';

  @override
  String get msgType6 => 'Binary Addressed Message';

  @override
  String get msgType7 => 'Binary Acknowledge';

  @override
  String get msgType8 => 'Binary Broadcast Message';

  @override
  String get msgType9 => 'Standard SAR Aircraft Position Report';

  @override
  String get msgType10 => 'UTC/Date Inquiry';

  @override
  String get msgType11 => 'UTC/Date Response';

  @override
  String get msgType12 => 'Addressed Safety Related Message';

  @override
  String get msgType13 => 'Safety Acknowledgement';

  @override
  String get msgType14 => 'Safety Broadcast Message';

  @override
  String get msgType15 => 'Interrogation';

  @override
  String get msgType16 => 'Assignment Mode Command';

  @override
  String get msgType17 => 'DGNSS Binary Broadcast Message';

  @override
  String get msgType18 => 'Standard Class B CS Position Report';

  @override
  String get msgType19 => 'Extended Class B Equipment Position Report';

  @override
  String get msgType20 => 'Data Link Management Message';

  @override
  String get msgType21 => 'Aid-to-Navigation Report';

  @override
  String get msgType22 => 'Channel Management';

  @override
  String get msgType23 => 'Group Assignment Command';

  @override
  String get msgType24 => 'Static Data Report';

  @override
  String get msgType25 => 'Single Slot Binary Message';

  @override
  String get msgType26 => 'Multiple Slot Binary Message';

  @override
  String get msgType27 => 'Position Report for Long-Range Applications';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsFeed => 'Feed';

  @override
  String get statsAllFeeds => 'All feeds';

  @override
  String get statsReceived => 'Received';

  @override
  String get statsDecoded => 'Decoded';

  @override
  String get statsInvalidChecksums => 'Invalid checksums';

  @override
  String get statsDroppedFragments => 'Dropped fragments';

  @override
  String get statsParseErrors => 'Parse errors';

  @override
  String get statsPendingFragments => 'Pending fragments';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(all feeds)';

  @override
  String get statsReceivedVsDecoded => 'Received vs Decoded (last 60 s)';

  @override
  String get statsPerSecondLabel => 'per second';

  @override
  String get statsAccounting => 'Accounting';

  @override
  String get statsMultiPartParts => 'Multi-part parts';

  @override
  String get statsPending => 'Pending';

  @override
  String get statsDropped => 'Dropped';

  @override
  String get statsReconcile => 'Received and decoded reconcile.';

  @override
  String get statsGapPaused =>
      'Gap includes sentences received while decoding was paused.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Received $received = $sum';
  }

  @override
  String get statsByMessageType => 'By message type';

  @override
  String get statsNoDecodedYet => 'No decoded messages yet';

  @override
  String statsTypeFallback(Object type) {
    return 'Type $type';
  }

  @override
  String get statsByFeed => 'By feed';

  @override
  String statsFeedFilter(Object filter) {
    return 'Feed: $filter';
  }

  @override
  String get statsNoActivityYet => 'No feed activity yet';

  @override
  String get statsCollecting => 'collecting…';

  @override
  String get simVesselCargo => 'Cargo';

  @override
  String get simVesselTanker => 'Tanker';

  @override
  String get simVesselFishing => 'Fishing';

  @override
  String get simVesselSailing => 'Sailing';

  @override
  String get simVesselPassenger => 'Passenger';

  @override
  String get simVesselTug => 'Tug';

  @override
  String get simVesselHsc => 'High speed craft';

  @override
  String get simVesselOther => 'Other';

  @override
  String get simType1 => 'Position report (1/2/3)';

  @override
  String get simType5 => 'Static & Voyage (5)';

  @override
  String get simType9 => 'SAR aircraft (9)';

  @override
  String get simType18 => 'Class B position (18)';

  @override
  String get simType19 => 'Class B extended (19)';

  @override
  String get simType27 => 'Long range (27)';

  @override
  String get simType4 => 'Base station (4)';

  @override
  String get simType21 => 'Aid to navigation (21)';

  @override
  String get simType8 => 'Weather broadcast (8)';

  @override
  String get simType11 => 'UTC/date response (11)';

  @override
  String get simType12 => 'Safety addressed (12)';

  @override
  String get simType14 => 'Safety broadcast (14)';

  @override
  String get simType22 => 'Channel management (22)';

  @override
  String get simType23 => 'Group assignment (23)';

  @override
  String get simType24 => 'Class B static (24)';

  @override
  String get simTitle => 'Simulation';

  @override
  String get simInfoBanner =>
      'The fleet is emitted when the \"Simulation\" feed is enabled on the Reception tab and the forwarder is running.';

  @override
  String get simOpenReception => 'Open Reception';

  @override
  String get simFleetSection => 'Fleet';

  @override
  String get simRadiusKm => 'Radius (km)';

  @override
  String get simVessels => 'Vessels';

  @override
  String get simSpeedMinKn => 'Speed min (kn)';

  @override
  String get simSpeedMaxKn => 'Speed max (kn)';

  @override
  String get simIntervalS => 'Interval (s)';

  @override
  String get simSeed => 'Seed';

  @override
  String get simAnchoredPct => 'Anchored (%)';

  @override
  String get simNamePrefix => 'Name prefix';

  @override
  String get simMmsiMid => 'MMSI country / MID';

  @override
  String get simSearchMmid => 'Search a country or type a 3-digit MID';

  @override
  String get simCustom => 'Custom';

  @override
  String get simVesselTypes => 'Vessel types';

  @override
  String get simRealisticNames => 'Realistic names';

  @override
  String get simRealisticDimensions => 'Realistic dimensions';

  @override
  String get simRealisticMmsi => 'Realistic ITU MMSI';

  @override
  String get simZoneSection => 'Zone & traffic';

  @override
  String get simLocationPreset => 'Location preset';

  @override
  String get simSearchPort => 'Search a port…';

  @override
  String get simCenterLat => 'Center latitude';

  @override
  String get simCenterLon => 'Center longitude';

  @override
  String get simZoneShape => 'Zone shape';

  @override
  String get simTransitPct => 'Transit (%)';

  @override
  String get simRegeneratePeriodically => 'Regenerate periodically';

  @override
  String get simRegenerateTicks => 'Regenerate (ticks)';

  @override
  String get simPresetHint =>
      'Pick a preset to fill the coordinates, or type Center latitude / longitude directly.';

  @override
  String get simMovementSection => 'Movement & emission';

  @override
  String get simVarySpeed => 'Vary speed over time';

  @override
  String get simReportIntervalTicks => 'Report interval (ticks)';

  @override
  String get simWander => 'Wander (0-3)';

  @override
  String get simSpeedByType => 'Speed by vessel type';

  @override
  String get simClassBSharePct => 'Class B share (%)';

  @override
  String get simHighAccuracy => 'High accuracy';

  @override
  String get simRealisticRot => 'Realistic rate of turn';

  @override
  String get simContentSection => 'Content';

  @override
  String get simSafetyTexts => 'Safety texts (one per line)';

  @override
  String get simDestinations => 'Destinations (one per line)';

  @override
  String get simStationsSection => 'Stations';

  @override
  String get simBaseStations => 'Base stations';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => 'Transmission quality';

  @override
  String get simInjectErrors => 'Inject errors';

  @override
  String get simErrorRatePct => 'Error rate (%)';

  @override
  String get simTalkerId => 'Talker ID';

  @override
  String get simNmea4Tag => 'NMEA 4.0 tag block';

  @override
  String get simMessagesSection => 'Messages';

  @override
  String get simApplyFleet => 'Apply fleet';

  @override
  String get simRegenerateFleet => 'Regenerate fleet';

  @override
  String get simGenerating => 'Generating…';

  @override
  String get simLiveFleet => 'Live fleet';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats boats · $frames frames emitted';
  }

  @override
  String get mapSearchVessels => 'Search vessels';

  @override
  String get mapSearchHint => 'Name, MMSI or IMO';

  @override
  String get mapNoResults => 'No results';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'Filters';

  @override
  String mapAllLabel(Object label) {
    return 'All $label';
  }

  @override
  String get mapVesselType => 'Vessel type';

  @override
  String get mapNavigationStatus => 'Navigation status';

  @override
  String get mapCountry => 'Country';

  @override
  String get mapMinSog => 'Min SOG (kn)';

  @override
  String get mapMaxSog => 'Max SOG (kn)';

  @override
  String get mapOnlyNamed => 'Only vessels with a name';

  @override
  String get mapReset => 'Reset';

  @override
  String get mapApply => 'Apply';

  @override
  String get mapAutoBasemap => 'Auto (follow theme)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Following $mmsi';
  }

  @override
  String mapMmsiHover(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapMmsiFallback(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String get basemapVoyagerLight => 'Voyager (light)';

  @override
  String get basemapPositronLight => 'Positron (light minimal)';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Esri Satellite';

  @override
  String get basemapEsriStreets => 'Esri World Street Map';

  @override
  String get decoderInputLabel =>
      'Paste or write one or more NMEA AIS sentences';

  @override
  String get decoderValidateChecksums => 'Validate checksums';

  @override
  String get decoderDecode => 'Decode';

  @override
  String get decoderDecoded => 'Decoded';

  @override
  String decoderDecodedN(Object n) {
    return 'Decoded ($n sentences)';
  }

  @override
  String get decoderInvalidChecksum => 'Invalid checksum';

  @override
  String get decoderParseError => 'Parse error';

  @override
  String get decoderWaitingFragments => 'Waiting for more fragments…';

  @override
  String decoderTagSource(Object id) {
    return 'source $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Tag block · $content';
  }

  @override
  String get toolDecoder => 'NMEA Decoder';

  @override
  String get toolDecoderSub => 'Decode AIS sentences';

  @override
  String get toolChecksum => 'Checksum';

  @override
  String get toolChecksumSub => 'Compute NMEA XOR checksums';

  @override
  String get toolMmsi => 'MMSI lookup';

  @override
  String get toolMmsiSub => 'Validate and identify an MMSI';

  @override
  String get toolSpeed => 'Speed converter';

  @override
  String get toolSpeedSub => 'kn · km/h · m/s · mph';

  @override
  String get toolBinary => 'Binary inspector';

  @override
  String get toolBinarySub => 'Payload down to the bits';

  @override
  String get toolEta => 'ETA calculator';

  @override
  String get toolEtaSub => 'ETA as AIS type-5 fields';

  @override
  String get toolRadio => 'Radio range';

  @override
  String get toolRadioSub => 'VHF-AIS radio horizon';

  @override
  String get toolTextToBinary => 'Text to binary';

  @override
  String get toolTextToBinarySub => '6-bit ASCII to hex/bits';

  @override
  String get checksumInputLabel => 'Paste one or more NMEA sentences';

  @override
  String get checksumComputed => 'Computed';

  @override
  String get checksumDeclared => 'Declared';

  @override
  String get checksumValid => 'Checksum valid';

  @override
  String get checksumInvalid => 'Checksum mismatch';

  @override
  String get checksumFix => 'Fix checksum';

  @override
  String get mmsiInputLabel => 'MMSI (9 digits)';

  @override
  String get mmsiValid => 'Valid MMSI';

  @override
  String get mmsiInvalid => 'Not a valid 9-digit MMSI';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'Country';

  @override
  String get mmsiCountryUnknown => 'Unknown MID';

  @override
  String get mmsiType => 'Station type';

  @override
  String get mmsiGroupCall => 'Group call';

  @override
  String get mmsiSarAircraft => 'SAR aircraft';

  @override
  String get mmsiCoastStation => 'Coast station';

  @override
  String get mmsiShipStation => 'Ship station';

  @override
  String get mmsiHandheldVhf => 'Handheld VHF';

  @override
  String get mmsiAton => 'Aid to navigation (AtoN)';

  @override
  String get mmsiSar => 'SAR unit';

  @override
  String get mmsiOther => 'Other';

  @override
  String get speedValue => 'Value';

  @override
  String get speedUnit => 'Unit';

  @override
  String get binaryInputLabel => 'NMEA sentence or raw 6-bit payload';

  @override
  String get binaryPayload => 'Payload';

  @override
  String get binaryBits => 'Bits';

  @override
  String get binaryBinary => 'Binary';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Hex bytes';

  @override
  String get binarySixBit => '6-bit characters';

  @override
  String get etaDistance => 'Distance';

  @override
  String get etaUnitNm => 'nautical miles';

  @override
  String get etaUnitKm => 'kilometres';

  @override
  String get etaSpeed => 'Speed';

  @override
  String get etaDuration => 'Duration';

  @override
  String get etaEtaLocal => 'ETA (local)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'AIS type-5 ETA fields';

  @override
  String get etaMonth => 'Month';

  @override
  String get etaDay => 'Day';

  @override
  String get etaHour => 'Hour';

  @override
  String get etaMinute => 'Minute';

  @override
  String get etaCombined => 'MM/DD HH:MM';

  @override
  String get radioHeight1 => 'Antenna height 1';

  @override
  String get radioHeight2 => 'Antenna height 2';

  @override
  String get radioHorizon => 'Radio horizon';

  @override
  String get radioHorizonKm => 'Radio horizon (km)';

  @override
  String get radioFrequencies => 'AIS channels';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Type some text (AIS 6-bit alphabet)';

  @override
  String get t2bCharTable => 'Character · value · 6-bit';

  @override
  String get t2bBinary => 'Binary';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Bytes (editor format)';

  @override
  String get t2bPayload => 'Armored payload';

  @override
  String get t2bNote =>
      'The byte list can be pasted into the Editor\'s “Data bytes” field of a type 6/8/25/26 message; the armored payload is the exact NMEA payload field.';

  @override
  String editorAsmDetected(Object name) {
    return 'Application Specific Message — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Fields of the matched ASM. The raw “Data bytes” field still overrides them when filled.';

  @override
  String get fMessageType => 'Message type';

  @override
  String get editorAsmPreset => 'ASM preset';

  @override
  String get editorAsmPresetManual => 'Custom — enter DAC/FID manually';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'ASM fields';

  @override
  String get asmStateInForce => 'in force';

  @override
  String get asmStateDeprecated => 'deprecated';

  @override
  String get asmStateReplaced => 'replaced';

  @override
  String get asmStateDiscontinued => 'discontinued';

  @override
  String get asmStateDraft => 'draft';

  @override
  String get asmStateProposal => 'proposal';

  @override
  String get asmStateTesting => 'testing';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Deprecated since $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'No bit layout is documented for $name — edit the raw Data bytes.';
  }

  @override
  String get docChapterAsm => 'Application Specific Messages';

  @override
  String get docAsmIntro =>
      'Not every AIS payload is a standard position report. Message types 6, 8, 25 and 26 carry application-specific binary data (an ASM) whose meaning is defined by two numbers: a Designated Area Code (DAC) and a Function Identifier (FID).';

  @override
  String get docAsmWhatTitle => 'What is an ASM?';

  @override
  String get docAsmWhat =>
      'An Application Specific Message is a structured payload published by an organisation (IMO, IALA, national administrations, manufacturers) for a specific use: meteo and hydrographic data, aid-to-navigation monitoring, DGPS corrections, port services and more. Types 6/8 carry the DAC/FID header; 25/26 repeat the same DAC/FID layout inside the slot messages.';

  @override
  String get docAsmDacFidTitle => 'DAC and FID';

  @override
  String get docAsmDacFid1 =>
      'The DAC is a 10-bit code identifying the issuing organisation or country (e.g. 001 = IMO, 002 = IALA). The FID is a 6-bit function code inside that DAC\'s namespace (e.g. 001/11 = IMO meteo & hydrographic data).';

  @override
  String get docAsmDacFid2 =>
      'The data bytes that follow the DAC/FID header are decoded according to the matching application standard. Different DAC/FID pairs can lay out the same bytes completely differently, so the pair must always be known first.';

  @override
  String get docAsmWhereTitle => 'Where to find the definitions';

  @override
  String get docAsmWhere1 =>
      'IMO circulars and ITU-R M.1371 (Annexes) — the authoritative source for IMO DAC 001.';

  @override
  String get docAsmWhere2 =>
      'IALA guidelines (e.g. G1139) and national administrations — for regional DACs.';

  @override
  String get docAsmWhere3 =>
      'The gpsd AIVDM documentation — an open, machine-readable catalogue of the most common DAC/FID layouts.';

  @override
  String get docAsmInKikaisTitle => 'In KikAis';

  @override
  String get docAsmInKikais =>
      'The Editor understands a curated set of well-known ASMs: when the DAC/FID of a 6/8/25/26 message matches one of them, the data field is shown as named sub-fields that are packed automatically. The raw “Data bytes” field always overrides the ASM when it is filled in. The list lives in asm_formats.dart and is easy to extend.';

  @override
  String get docAsmExampleTitle => 'Example: IMO Meteo & Hydrographic (001/11)';

  @override
  String get docAsmExample =>
      'Set the Editor to type 8, DAC=1 and FID=11 to build an IMO meteo message: wind, air and water temperature, pressure, visibility, currents and waves are then edited field by field instead of as a byte blob.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Repeat indicator';

  @override
  String get fNavStatus => 'Navigation status';

  @override
  String get fLatitude => 'Latitude';

  @override
  String get fLongitude => 'Longitude';

  @override
  String get fSogKn => 'SOG (kn)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Heading (°)';

  @override
  String get fRateOfTurn => 'Rate of turn';

  @override
  String get fManeuver => 'Maneuver';

  @override
  String get fTimestamp => 'Timestamp';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Accuracy';

  @override
  String get fEpfdFixType => 'EPFD fix type';

  @override
  String get fSyncState => 'Sync state';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Call sign';

  @override
  String get fVesselName => 'Vessel name';

  @override
  String get fShipType => 'Ship type';

  @override
  String get fShipTypeText => 'Ship type (text)';

  @override
  String get fDims => 'Bow/Stern/Port/Starboard (m)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Draught (m)';

  @override
  String get fDestination => 'Destination';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'Destination MMSI';

  @override
  String get fSeqNumber => 'Sequence number';

  @override
  String get fRetransmit => 'Retransmit';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Data';

  @override
  String get fAltitudeM => 'Altitude (m)';

  @override
  String get fAssignedMode => 'Assigned mode';

  @override
  String get fRegionalReserved => 'Regional reserved';

  @override
  String get fText => 'Text';

  @override
  String fStationN(Object n) {
    return 'Station $n';
  }

  @override
  String fSlotN(Object n) {
    return 'Slot $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return 'offset $offset · number $number · timeout $timeout · inc $increment';
  }

  @override
  String get fAidType => 'Aid type';

  @override
  String get fAidTypeCode => 'Aid type (code)';

  @override
  String get fName => 'Name';

  @override
  String get fNameExt => 'Name extension';

  @override
  String get fVirtualAid => 'Virtual aid';

  @override
  String get fOffPosition => 'Off position';

  @override
  String get fSecond => 'Second';

  @override
  String get fChannelA => 'Channel A';

  @override
  String get fChannelB => 'Channel B';

  @override
  String get fTxRxMode => 'TX/RX mode';

  @override
  String get fPower => 'Power';

  @override
  String get fZone => 'Zone';

  @override
  String get fAddressed => 'Addressed';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Band A';

  @override
  String get fBandB => 'Band B';

  @override
  String get fZoneSize => 'Zone size';

  @override
  String get fStationType => 'Station type';

  @override
  String get fReportInterval => 'Report interval';

  @override
  String get fQuietTime => 'Quiet time';

  @override
  String get fPart => 'Part';

  @override
  String get fVendorId => 'Vendor ID';

  @override
  String get fUnitModel => 'Unit model';

  @override
  String get fSerialNumber => 'Serial number';

  @override
  String get fMothershipMmsi => 'Mothership MMSI';

  @override
  String get fRadioStatus => 'Radio status';

  @override
  String get fGnssStatus => 'GNSS position status';

  @override
  String fDestN(Object n) {
    return 'Destination $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => 'Destination indicator';

  @override
  String get fBinaryDataFlag => 'Binary data flag';

  @override
  String get fApplicationId => 'Application ID';

  @override
  String get fPowerHigh => 'High';

  @override
  String get fPowerLow => 'Low';

  @override
  String get fPartA => 'A (name)';

  @override
  String get fPartB => 'B (ship data)';

  @override
  String get editorTitle => 'AIS Message Editor';

  @override
  String get editorCompose => 'Compose message';

  @override
  String get editorMessageType => 'Message type';

  @override
  String get editorAddTagBlock => 'Add NMEA 4.0 tag block';

  @override
  String get editorSourceId => 'Source ID';

  @override
  String get editorInjectToMap => 'Inject to map';

  @override
  String get editorSendToTarget => 'Send to target';

  @override
  String get editorPreview => 'NMEA preview';

  @override
  String get editorNmeaCopied => 'NMEA copied';

  @override
  String get editorInjected => 'Message injected';

  @override
  String get editorSentToTarget => 'Message sent to target';

  @override
  String get editorNavStatus0_15 => 'Nav status (0-15)';

  @override
  String get editorYear => 'Year';

  @override
  String get editorMonth => 'Month';

  @override
  String get editorDay => 'Day';

  @override
  String get editorHour => 'Hour';

  @override
  String get editorMinute => 'Minute';

  @override
  String get editorSecond => 'Second';

  @override
  String get editorImoNumber => 'IMO number';

  @override
  String get editorBowM => 'Bow (m)';

  @override
  String get editorSternM => 'Stern (m)';

  @override
  String get editorPortM => 'Port (m)';

  @override
  String get editorStarboardM => 'Starboard (m)';

  @override
  String get editorEtaMonth => 'ETA month';

  @override
  String get editorEtaDay => 'ETA day';

  @override
  String get editorEtaHour => 'ETA hour';

  @override
  String get editorEtaMinute => 'ETA minute';

  @override
  String get editorSequence0_3 => 'Sequence (0-3)';

  @override
  String get editorDataBytes => 'Data bytes (hex or 1,2,3)';

  @override
  String get editorDestMmsisComma => 'Dest. MMSIs (comma)';

  @override
  String get editorSequencesComma => 'Sequences (comma)';

  @override
  String get editorInterrogatedMmsi => 'Interrogated MMSI';

  @override
  String get editorType1 => 'Type 1';

  @override
  String get editorOffset1 => 'Offset 1';

  @override
  String get editorTargetMmsi => 'Target MMSI';

  @override
  String get editorOffset => 'Offset';

  @override
  String get editorIncrement => 'Increment';

  @override
  String get editorNumber => 'Number';

  @override
  String get editorTimeout => 'Timeout';

  @override
  String get editorAidType0_31 => 'Aid type (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Virtual aid (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Tx/Rx mode (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Tx/Rx mode (0-3)';

  @override
  String get editorNeLat => 'NE latitude';

  @override
  String get editorNeLon => 'NE longitude';

  @override
  String get editorSwLat => 'SW latitude';

  @override
  String get editorSwLon => 'SW longitude';

  @override
  String get editorInterval0_15 => 'Interval (0-15)';

  @override
  String get editorPart => 'Part (0 = A name, 1 = B static)';

  @override
  String get editorDestMmsiEmpty => 'Destination MMSI (empty = broadcast)';

  @override
  String get editorAppDacEmpty => 'App DAC (empty = none)';

  @override
  String get editorAppFidEmpty => 'App FID (empty = none)';

  @override
  String get nmeaTalker => 'Talker';

  @override
  String get nmeaFragments => 'Fragments';

  @override
  String get nmeaFragmentN => 'Fragment #';

  @override
  String get nmeaMessageId => 'Message ID';

  @override
  String get nmeaChannel => 'Channel';

  @override
  String get nmeaPayload => 'Payload';

  @override
  String get nmeaFillBits => 'Fill bits';

  @override
  String get nmeaTagBlock => 'Tag block';

  @override
  String get nmeaChecksum => 'Checksum';

  @override
  String get nmeaEmpty => '(empty)';

  @override
  String get bubbleKindVessel => 'Vessel';

  @override
  String get bubbleKindAircraft => 'SAR Aircraft';

  @override
  String get bubbleKindAton => 'Aid to Navigation';

  @override
  String get bubbleKindStation => 'Base Station';

  @override
  String get bubbleGeneralInfo => 'General Information';

  @override
  String get bubbleKind => 'Kind';

  @override
  String get bubbleAidType => 'Aid Type';

  @override
  String get bubbleVirtual => 'Virtual';

  @override
  String get bubbleAltitude => 'Altitude';

  @override
  String get bubbleCallSign => 'Call Sign';

  @override
  String get bubblePosNav => 'Position & Navigation';

  @override
  String get bubbleHeading => 'Heading';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Vessel Details';

  @override
  String get bubbleType => 'Type';

  @override
  String get bubbleTypeInt => 'Type (Int)';

  @override
  String get bubbleDimsBowStern => 'Dimensions Bow/Stern';

  @override
  String get bubbleDimsPortStarboard => 'Dimensions Port/Starboard';

  @override
  String get bubbleSpare => 'Spare';

  @override
  String get bubbleDraught => 'Draught';

  @override
  String bubbleFrames(Object n) {
    return 'Frames ($n)';
  }

  @override
  String get bubbleNoFrames => 'No frames yet';

  @override
  String get copied => 'Copied';

  @override
  String get textFiles => 'Text Files';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Target $name connected ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Failed to connect target $name: $error';
  }

  @override
  String get logStopping => 'Stopping forwarder...';

  @override
  String get logStopped => 'Forwarder stopped.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Feed added: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Feed removed: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Feed $name connected.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Feed $name disconnected. Reconnecting in 5s...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Failed to connect feed $name: $error. Retrying in 5s...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Target $name: TCP server listening on port $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Target $name: client connected $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Target $name: client disconnected';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Target $name: client error $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Target $name send error: $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'Opening RTL-SDR dongle $device...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device connected ($freq, $rate sample rate, $gain gain, channels $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device error: $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'RTL-SDR $device stream closed.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device disconnected.';
  }

  @override
  String get docNavStatus0 => 'Under way using engine';

  @override
  String get docNavStatus1 => 'At anchor';

  @override
  String get docNavStatus2 => 'Not under command';

  @override
  String get docNavStatus3 => 'Restricted manoeuvrability';

  @override
  String get docNavStatus4 => 'Constrained by her draught';

  @override
  String get docNavStatus5 => 'Moored';

  @override
  String get docNavStatus6 => 'Aground';

  @override
  String get docNavStatus7 => 'Engaged in fishing';

  @override
  String get docNavStatus8 => 'Under way sailing';

  @override
  String get docNavStatus9 => 'Reserved (HSC)';

  @override
  String get docNavStatus10 => 'Reserved (WIG)';

  @override
  String get docNavStatus11 => 'Towing astern (regional)';

  @override
  String get docNavStatus12 => 'Pushing ahead / towing alongside (regional)';

  @override
  String get docNavStatus13 => 'Reserved for future use';

  @override
  String get docNavStatus14 => 'AIS-SART active';

  @override
  String get docNavStatus15 => 'Undefined (default)';

  @override
  String get docEpfd0 => 'Undefined (default)';

  @override
  String get docEpfd1 => 'GPS';

  @override
  String get docEpfd2 => 'GLONASS';

  @override
  String get docEpfd3 => 'GPS + GLONASS';

  @override
  String get docEpfd4 => 'Loran-C';

  @override
  String get docEpfd5 => 'Chayka';

  @override
  String get docEpfd6 => 'Integrated navigation system';

  @override
  String get docEpfd7 => 'Surveyed (fixed)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'Internal GNSS';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · bits $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields fields · $bits bits total · tap a segment';
  }

  @override
  String get docTextToEncode => 'Text to encode';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Each character is one 6-bit value (\"@\" = 0, space = 32, \"A\" = 1…). Lowercase letters are not encodable and are usually sent as uppercase.';

  @override
  String get docChecksumBody => 'Body (without leading ! and trailing *XX)';

  @override
  String get docChecksumExplanation =>
      'The NMEA checksum is the XOR of every byte between the \"!\" and the \"*\".';

  @override
  String get docLatitude => 'Latitude';

  @override
  String get docLongitude => 'Longitude';

  @override
  String get docLatitudeInvalid => 'Latitude: enter a number';

  @override
  String get docLongitudeInvalid => 'Longitude: enter a number';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Latitude → $value (27-bit signed, deg = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Longitude → $value (28-bit signed, deg = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Coordinates are stored in 1/10 000 of a minute: divide by 600 000 to recover degrees.';

  @override
  String get docSearchShipTypes => 'Search ship types';

  @override
  String get docShipCat0_19 => '0-19 · Reserved';

  @override
  String get docShipCat20_29 => '20-29 · Wing in ground (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Fishing';

  @override
  String get docShipCat40_49 => '40-49 · High-speed craft';

  @override
  String get docShipCat50_59 => '50-59 · Special craft';

  @override
  String get docShipCat60_69 => '60-69 · Passenger';

  @override
  String get docShipCat70_79 => '70-79 · Cargo';

  @override
  String get docShipCat80_89 => '80-89 · Tanker';

  @override
  String get docShipCat90_99 => '90-99 · Other';

  @override
  String get docSearchGlossary => 'Search glossary';

  @override
  String get docNoMatchingTerms => 'No matching terms.';

  @override
  String get docAspect => 'Aspect';

  @override
  String get docClassA => 'Class A';

  @override
  String get docClassB => 'Class B';

  @override
  String get docCheatRadio => 'Radio';

  @override
  String get docCheatFrequencies => 'Frequencies';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulation';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bits/s';

  @override
  String get docCheatRange => 'Range';

  @override
  String get docCheatRangeValue => '~10-20 NM ship-to-ship, line of sight';

  @override
  String get docCheatReportingRates => 'Reporting rates';

  @override
  String get docCheatClassAPos1 => 'Class A position (1)';

  @override
  String get docCheatClassAPos1Value => 'Every 2-10 s underway, 3 min anchored';

  @override
  String get docCheatStatic5 => 'Static (5)';

  @override
  String get docCheatStatic5Value => 'Every 6 min';

  @override
  String get docCheatClassBPos18 => 'Class B position (18)';

  @override
  String get docCheatClassBPos18Value => '~Every 30 s';

  @override
  String get docCheatAtoN21 => 'Aid to navigation (21)';

  @override
  String get docCheatAtoN21Value => 'Every 3 min';

  @override
  String get docCheatNavStatus0_15 => 'Navigation status (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'Under way using engine';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'At anchor';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Restricted manoeuvrability';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Moored';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'Aground';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Fishing';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'Under way sailing';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART active';

  @override
  String get docCheatMmsiFormats => 'MMSI formats';

  @override
  String get docCheatFixTypes => 'Fix types (EPFD)';

  @override
  String get docCheatEpfd1 => '1';

  @override
  String get docCheatEpfd1Value => 'GPS';

  @override
  String get docCheatEpfd2 => '2';

  @override
  String get docCheatEpfd2Value => 'GLONASS';

  @override
  String get docCheatEpfd3 => '3';

  @override
  String get docCheatEpfd3Value => 'GPS + GLONASS';

  @override
  String get docCheatEpfd8 => '8';

  @override
  String get docCheatEpfd8Value => 'Galileo';

  @override
  String get docCheatEpfd15 => '15';

  @override
  String get docCheatEpfd15Value => 'Internal GNSS';

  @override
  String get docCheatFooter =>
      'KikAis ships a full interactive reference on every tab — the Editor can build any message, the Decoder reads them back.';

  @override
  String get docMmsiFmtDiversRadio => 'Diver\'s radio';

  @override
  String get docMmsiFmtShip => 'Ship';

  @override
  String get docMmsiFmtGroupShips =>
      'Group of ships (e.g. a fleet or the USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Coastal / shore station';

  @override
  String get docMmsiFmtSarAircraft => 'SAR aircraft';

  @override
  String get docMmsiFmtAuxCraft =>
      'Auxiliary craft associated with a parent ship';

  @override
  String get docMmsiFmtAtoN => 'Aid to navigation';

  @override
  String get docMmsiFmtSart => 'AIS-SART (search & rescue transmitter)';

  @override
  String get docMmsiFmtMob => 'MOB (man overboard) device';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB (emergency beacon)';

  @override
  String get docVesselCat0_9 => 'Reserved / future use';

  @override
  String get docVesselCat10_19 => 'Reserved for future use';

  @override
  String get docVesselCat20_29 => 'Wing in ground (WIG) craft';

  @override
  String get docVesselCat30_39 => 'Fishing';

  @override
  String get docVesselCat40_49 => 'High-speed craft';

  @override
  String get docVesselCat50_59 => 'Special craft (pilot, tugs, dredgers…)';

  @override
  String get docVesselCat60_69 => 'Passenger ships';

  @override
  String get docVesselCat70_79 => 'Cargo ships';

  @override
  String get docVesselCat80_89 => 'Tankers';

  @override
  String get docVesselCat90_99 => 'Other types';

  @override
  String get docTalkerAB => 'Base AIS station';

  @override
  String get docTalkerAD => 'Dependent AIS base station';

  @override
  String get docTalkerAI => 'Mobile AIS station';

  @override
  String get docTalkerAN => 'Aid-to-navigation AIS station';

  @override
  String get docTalkerAR => 'AIS receiving station';

  @override
  String get docTalkerAS => 'Limited base station';

  @override
  String get docTalkerAT => 'AIS transmitting station';

  @override
  String get docTalkerAX => 'AIS repeater station';

  @override
  String get docTalkerBS => 'Base AIS station (deprecated)';

  @override
  String get docTalkerSA => 'Physical shore AIS station';

  @override
  String get docType1Name => 'Position Report Class A';

  @override
  String get docType1Family => 'Position reports';

  @override
  String get docType1Summary =>
      'The workhorse of the system: a Class A transponder broadcasting its position, course, speed, heading and navigation status.';

  @override
  String get docType1EmittedBy => 'Class A transponders (SOLAS vessels)';

  @override
  String get docType1Cadence =>
      'Every 2-10 s while underway, every 3 min at anchor';

  @override
  String get docType2Name => 'Position Report Class A (assigned)';

  @override
  String get docType2Family => 'Position reports';

  @override
  String get docType2Summary =>
      'Identical to type 1, but sent on a slot schedule assigned to the vessel by a base station (assignment mode).';

  @override
  String get docType2EmittedBy => 'Class A transponders under assignment';

  @override
  String get docType2Cadence => 'Assigned schedule';

  @override
  String get docType3Name => 'Position Report Class A (response)';

  @override
  String get docType3Family => 'Position reports';

  @override
  String get docType3Summary =>
      'Identical to type 1, sent as the response to an interrogation (type 15).';

  @override
  String get docType3EmittedBy =>
      'Class A transponders answering an interrogation';

  @override
  String get docType3Cadence => 'On interrogation';

  @override
  String get docType4Name => 'Base Station Report';

  @override
  String get docType4Family => 'Base station & network';

  @override
  String get docType4Summary =>
      'The periodic report of a fixed shore station: its position plus the UTC date and time reference.';

  @override
  String get docType4EmittedBy => 'Fixed base stations';

  @override
  String get docType4Cadence => 'Every 10 s';

  @override
  String get docType5Name => 'Static and Voyage Related Data';

  @override
  String get docType5Family => 'Static & voyage data';

  @override
  String get docType5Summary =>
      'The \"identity card\" of a ship: name, call sign, IMO number, ship type, dimensions, draught, ETA and destination.';

  @override
  String get docType5EmittedBy => 'Class A transponders';

  @override
  String get docType5Cadence => 'Every 6 min and on change of data';

  @override
  String get docType6Name => 'Binary Addressed Message';

  @override
  String get docType6Family => 'Binary data';

  @override
  String get docType6Summary =>
      'A structured binary payload sent to one specific destination MMSI (e.g. a requested meteo report).';

  @override
  String get docType6EmittedBy => 'Any station';

  @override
  String get docType6Cadence => 'On demand';

  @override
  String get docType7Name => 'Binary Acknowledge';

  @override
  String get docType7Family => 'Binary data';

  @override
  String get docType7Summary =>
      'The acknowledgement sent in reply to a type 6 binary addressed message.';

  @override
  String get docType7EmittedBy => 'Any station that received a type 6';

  @override
  String get docType7Cadence => 'On reply';

  @override
  String get docType8Name => 'Binary Broadcast Message';

  @override
  String get docType8Family => 'Binary data';

  @override
  String get docType8Summary =>
      'A structured binary payload broadcast to all — weather and hydrographic reports, regional data, or private/encrypted messages.';

  @override
  String get docType8EmittedBy => 'Any station';

  @override
  String get docType8Cadence => 'On demand';

  @override
  String get docType9Name => 'Standard SAR Aircraft Position Report';

  @override
  String get docType9Family => 'Position reports';

  @override
  String get docType9Summary =>
      'A position report used by search-and-rescue aircraft to be visible to ships. Carries altitude and a special MMSI range (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'SAR aircraft';

  @override
  String get docType9Cadence => 'Every 10 s while on station';

  @override
  String get docType10Name => 'UTC and Date Inquiry';

  @override
  String get docType10Family => 'Base station & network';

  @override
  String get docType10Summary =>
      'A small request asking a specific station for its UTC date and time.';

  @override
  String get docType10EmittedBy => 'Any station';

  @override
  String get docType10Cadence => 'On demand';

  @override
  String get docType11Name => 'UTC and Date Response';

  @override
  String get docType11Family => 'Base station & network';

  @override
  String get docType11Summary =>
      'Identical in structure to type 4, sent as the answer to a type 10 UTC/date inquiry.';

  @override
  String get docType11EmittedBy => 'Base stations';

  @override
  String get docType11Cadence => 'On inquiry';

  @override
  String get docType12Name => 'Addressed Safety-Related Message';

  @override
  String get docType12Family => 'Safety & text';

  @override
  String get docType12Summary =>
      'A free-text safety message sent to a single destination MMSI (e.g. a distress message to the nearest base station).';

  @override
  String get docType12EmittedBy => 'Any station';

  @override
  String get docType12Cadence => 'On demand';

  @override
  String get docType13Name => 'Safety-Related Acknowledgement';

  @override
  String get docType13Family => 'Safety & text';

  @override
  String get docType13Summary =>
      'The acknowledgement sent in reply to a type 12 addressed safety message.';

  @override
  String get docType13EmittedBy => 'Any station that received a type 12';

  @override
  String get docType13Cadence => 'On reply';

  @override
  String get docType14Name => 'Safety-Related Broadcast Message';

  @override
  String get docType14Family => 'Safety & text';

  @override
  String get docType14Summary =>
      'A free-text broadcast addressed to everyone in range — navigational warnings, distress or traffic announcements.';

  @override
  String get docType14EmittedBy => 'Any station (often base stations / VTS)';

  @override
  String get docType14Cadence => 'On demand';

  @override
  String get docType15Name => 'Interrogation';

  @override
  String get docType15Family => 'Base station & network';

  @override
  String get docType15Summary =>
      'A request asking one or two specific stations to send a particular message type (usually type 3 or 5).';

  @override
  String get docType15EmittedBy => 'Base stations';

  @override
  String get docType15Cadence => 'On demand';

  @override
  String get docType16Name => 'Assignment Mode Command';

  @override
  String get docType16Family => 'Base station & network';

  @override
  String get docType16Summary =>
      'Instructs up to two vessels to transmit on a specific slot allocation (assignment mode).';

  @override
  String get docType16EmittedBy => 'Base stations';

  @override
  String get docType16Cadence => 'On demand';

  @override
  String get docType17Name => 'DGNSS Binary Broadcast Message';

  @override
  String get docType17Family => 'Binary data';

  @override
  String get docType17Summary =>
      'Differential GNSS correction data broadcast by shore stations to improve positioning accuracy in the covered area.';

  @override
  String get docType17EmittedBy => 'DGNSS reference stations';

  @override
  String get docType17Cadence => 'Periodic';

  @override
  String get docType18Name => 'Standard Class B CS Position Report';

  @override
  String get docType18Family => 'Position reports';

  @override
  String get docType18Summary =>
      'The standard Class B position report. Lighter than Class A: no navigation status or rate of turn, but works with CSTDMA.';

  @override
  String get docType18EmittedBy => 'Class B transponders';

  @override
  String get docType18Cadence => 'Every 30 s (or less in some regions)';

  @override
  String get docType19Name => 'Extended Class B Equipment Position Report';

  @override
  String get docType19Family => 'Position reports';

  @override
  String get docType19Summary =>
      'A larger Class B position report that also carries the vessel name, ship type and dimensions — a one-shot static+position hybrid.';

  @override
  String get docType19EmittedBy => 'Extended Class B transponders';

  @override
  String get docType19Cadence => 'Every 30 s';

  @override
  String get docType20Name => 'Data Link Management';

  @override
  String get docType20Family => 'Base station & network';

  @override
  String get docType20Summary =>
      'A network housekeeping message used to allocate and reserve TDMA time slots in an area.';

  @override
  String get docType20EmittedBy => 'Base stations';

  @override
  String get docType20Cadence => 'Network management';

  @override
  String get docType21Name => 'Aid-to-Navigation Report';

  @override
  String get docType21Family => 'Aid to navigation';

  @override
  String get docType21Summary =>
      'Broadcasts the position, name and status of an aid to navigation — buoys, beacons, lighthouses, or virtual aids. Often sent from a virtual position.';

  @override
  String get docType21EmittedBy => 'AtoN stations (real or virtual)';

  @override
  String get docType21Cadence => 'Every 3 min (or on event)';

  @override
  String get docType22Name => 'Channel Management';

  @override
  String get docType22Family => 'Base station & network';

  @override
  String get docType22Summary =>
      'Used by a base station to switch stations to different VHF channels within a geographic zone.';

  @override
  String get docType22EmittedBy => 'Base stations';

  @override
  String get docType22Cadence => 'On demand';

  @override
  String get docType23Name => 'Group Assignment Command';

  @override
  String get docType23Family => 'Base station & network';

  @override
  String get docType23Summary =>
      'A command sent by a base station to a group of vessels within a zone, setting reporting intervals and transmission mode.';

  @override
  String get docType23EmittedBy => 'Base stations';

  @override
  String get docType23Cadence => 'On demand';

  @override
  String get docType24Name => 'Static Data Report';

  @override
  String get docType24Family => 'Static & voyage data';

  @override
  String get docType24Summary =>
      'The Class B equivalent of type 5, split into Part A (name) and Part B (ship type, call sign, dimensions).';

  @override
  String get docType24EmittedBy => 'Class B transponders';

  @override
  String get docType24Cadence => 'Every 6 min';

  @override
  String get docType25Name => 'Single Slot Binary Message';

  @override
  String get docType25Family => 'Binary data';

  @override
  String get docType25Summary =>
      'A short binary message fitting in a single TDMA slot, with an optional destination and application ID.';

  @override
  String get docType25EmittedBy => 'Any station';

  @override
  String get docType25Cadence => 'On demand';

  @override
  String get docType26Name => 'Multiple Slot Binary Message';

  @override
  String get docType26Family => 'Binary data';

  @override
  String get docType26Summary =>
      'A longer binary message spread over several TDMA slots, carrying radio-status information.';

  @override
  String get docType26EmittedBy => 'Any station';

  @override
  String get docType26Cadence => 'On demand';

  @override
  String get docType27Name => 'Position Report for Long-Range Applications';

  @override
  String get docType27Family => 'Position reports';

  @override
  String get docType27Summary =>
      'A very compact position report designed for reception by satellite over long ranges, with reduced resolution.';

  @override
  String get docType27EmittedBy => 'Vessels in long-range (satellite) mode';

  @override
  String get docType27Cadence => 'Every 3 min (long-range mode)';

  @override
  String get docTimeline1990sTitle => 'A Swedish invention';

  @override
  String get docTimeline1990sText =>
      'The concept is born in Sweden: a VHF system where every ship announces itself so that others \"see and be seen\", even in fog and behind islands. It is presented to the IMO and becomes the seed of AIS.';

  @override
  String get docTimeline1998Title => 'Standardisation begins';

  @override
  String get docTimeline1998Text =>
      'The ITU and IEC start turning the concept into a radio standard with precise bit-level formats, based on TDMA over two VHF channels.';

  @override
  String get docTimeline2001Title => 'ITU-R M.1371 published';

  @override
  String get docTimeline2001Text =>
      'Recommendation ITU-R M.1371 \"Technical characteristics for a universal shipborne automatic identification system\" defines the 27 message types and their bit layout.';

  @override
  String get docTimeline2002Title => 'SOLAS mandate';

  @override
  String get docTimeline2002Text =>
      'The IMO makes AIS mandatory for all international vessels over 300 gross tons and all passenger ships — roughly 100,000 vessels. AIS becomes a standard anti-collision aid alongside radar.';

  @override
  String get docTimeline2006Title => 'Class B arrives';

  @override
  String get docTimeline2006Text =>
      'The Class B standard is published, opening the door to cheap, simpler transponders. The same year, the TacSat-2 satellite becomes the first to capture AIS signals from space (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Satellite constellations';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire and others deploy AIS receivers in low-Earth orbit, extending coverage far beyond the VHF horizon and enabling near-global vessel tracking.';

  @override
  String get docTimeline2010Title => 'AIS-SART in GMDSS';

  @override
  String get docTimeline2010Text =>
      'The AIS search-and-rescue transmitter (AIS-SART, IEC 61097-14) joins the Global Maritime Distress and Safety System, letting lifeboats broadcast distress positions over AIS.';

  @override
  String get docTimeline2014Title => 'Fisheries & inland fleets';

  @override
  String get docTimeline2014Text =>
      'European rules require Class A AIS on all EU fishing vessels over 15 m; inland-waterways AIS is widely deployed on European rivers.';

  @override
  String get docTimeline2021Title => '1.6 million ships';

  @override
  String get docTimeline2021Text =>
      'More than 1.6 million vessels are fitted with AIS, feeding terrestrial and satellite networks that power ship tracking, fisheries control and maritime security worldwide.';

  @override
  String get docTimelineVdesTitle => 'VDES — the successor';

  @override
  String get docTimelineVdesText =>
      'The VHF Data Exchange System (ITU-R M.2092) is being rolled out to relieve congested areas, adding far more bandwidth and secure e-navigation services.';

  @override
  String get docAppTitle => 'Documentation';

  @override
  String get docSearchChapters => 'Search chapters';

  @override
  String get docChapterOverview => 'Overview';

  @override
  String get docChapterHistory => 'History & regulation';

  @override
  String get docChapterHowItWorks => 'How it works';

  @override
  String get docChapterRadio => 'Radio & TDMA';

  @override
  String get docChapterClasses => 'Classes & equipment';

  @override
  String get docChapterMmsi => 'MMSI & identity';

  @override
  String get docChapterShipTypes => 'Ship types';

  @override
  String get docChapterMessages => 'The 27 messages';

  @override
  String get docChapterNmea => 'NMEA & AIVDM';

  @override
  String get docChapterPayload => 'Inside the payload';

  @override
  String get docChapterSecurity => 'Security & limits';

  @override
  String get docChapterFieldNotes => 'Field notes';

  @override
  String get docChapterKikais => 'AIS in KikAis';

  @override
  String get docChapterGlossary => 'Glossary';

  @override
  String get docChapterCheatSheet => 'Cheat sheet';

  @override
  String get docChapterSources => 'Sources';

  @override
  String get docOverviewTitle => 'What is AIS?';

  @override
  String get docOverviewIntro =>
      'The Automatic Identification System (AIS) is a tracking system used on ships and by vessel traffic services (VTS). Every equipped vessel continuously broadcasts its identity, position, course and speed over VHF radio, so that every other ship and shore station in range can \"see\" it — the concept of \"see and be seen\".';

  @override
  String get docOverviewRadar =>
      'AIS does not replace marine radar. Radar independently detects any object, but tells you little about who it is. AIS tells you exactly who, where and where they are going — but it trusts what the sender declares. The two systems complement each other.';

  @override
  String get docOverviewAdsBTitle => 'Think of it as the maritime ADS-B';

  @override
  String get docOverviewAdsBText =>
      'Just as ADS-B lets aircraft announce themselves to air traffic control, AIS lets ships announce themselves to each other and to shore. Ships view surrounding traffic on a chartplotter or on a radar-like display; port authorities monitor movements and fisheries.';

  @override
  String get docOverviewTransponder => 'What a transponder broadcasts';

  @override
  String get docOverviewBullet1 =>
      'Unique identity: a 9-digit MMSI number (whose first three digits identify the issuing country).';

  @override
  String get docOverviewBullet2 =>
      'Dynamic data: position, speed over ground (SOG), course over ground (COG), true heading, rate of turn, navigation status.';

  @override
  String get docOverviewBullet3 =>
      'Static & voyage data: name, call sign, IMO number, ship type, dimensions, draught, destination, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Safety and binary messages: distress texts, weather reports, network commands.';

  @override
  String get docOverviewWho => 'Who must carry it';

  @override
  String get docOverviewImo =>
      'The IMO (SOLAS convention) mandates AIS on international vessels over 300 gross tons and on all passenger ships. Regional rules extend this to fishing fleets, inland waterways and increasingly to recreational craft via low-cost Class B transponders.';

  @override
  String get docOverviewLimits => 'Limits at a glance';

  @override
  String get docOverviewLimit1 =>
      'Range is roughly line of sight: about 10-20 nautical miles for ship-to-ship, more from coast stations and satellites.';

  @override
  String get docOverviewLimit2 =>
      'AIS has no authentication: anyone can broadcast any identity (spoofing) or jam the channel.';

  @override
  String get docOverviewLimit3 =>
      'Accuracy depends on the sender\'s GNSS fix and on the honesty of the data it declares.';

  @override
  String get docHistoryIntro =>
      'AIS grew from a Swedish idea into a worldwide mandatory safety system. Tap any milestone on the timeline for details.';

  @override
  String get docHistoryStandards => 'The governing standards';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — Technical characteristics for a universal shipborne AIS (defines the 27 message types and their bit layout).';

  @override
  String get docHistoryStd2 =>
      'IALA guidelines — clarifications and implementation guidance.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — the NMEA sentence framing and Class B/CSTDMA requirements.';

  @override
  String get docHistoryStd4 =>
      'IEC 61097-14 — the AIS-SART distress transmitter.';

  @override
  String get docHowIntro =>
      'AIS is a VHF radio system. Each transponder listens to the traffic around it and transmits its own reports in reserved time slots, avoiding collisions with the other ships in range.';

  @override
  String get docHowRadioLink => 'The radio link';

  @override
  String get docHowRadioLink1 =>
      'Two dedicated VHF channels: AIS 1 at 161.975 MHz (87B) and AIS 2 at 162.025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'Digital narrow-band FM, at 9 600 bits per second.';

  @override
  String get docHowRadioLink3 =>
      'Messages are organised into TDMA frames of 2250 time slots (1 minute).';

  @override
  String get docHowSlots => 'How slots are shared';

  @override
  String get docHowSotdma =>
      'Class A transponders use SOTDMA (Self-Organizing Time Division Multiple Access): each unit reserves a repeating slot and re-reserves when the picture changes, so ships continuously coordinate without a central controller.';

  @override
  String get docHowCstdma =>
      'Class B transponders use the simpler CSTDMA (Carrier Sense TDMA): they listen for a free slot and grab it, which is why Class B reports are less frequent and can be lost in very dense traffic.';

  @override
  String get docHowRates => 'Reporting rates';

  @override
  String get docHowRates1 =>
      'Class A position report (type 1): every 2-10 seconds while underway, every 3 minutes at anchor.';

  @override
  String get docHowRates2 => 'Static & voyage data (type 5): every 6 minutes.';

  @override
  String get docHowRates3 =>
      'Class B position (type 18): roughly every 30 seconds.';

  @override
  String get docHowRates4 => 'Aid to navigation (type 21): every 3 minutes.';

  @override
  String get docHowTerrestrial => 'Terrestrial and satellite';

  @override
  String get docHowTerrestrialText =>
      'On the surface, AIS range is limited by the VHF horizon (T-AIS). Since the mid-2000s, satellites in low-Earth orbit (S-AIS) receive the same signals, giving near-global coverage — satellites augment rather than replace the terrestrial network.';

  @override
  String get docRadioIntro =>
      'Beneath the messages lies a small, efficient radio system. AIS transmits at 9 600 bits per second on two VHF channels, using Gaussian minimum-shift keying (GMSK) and HDLC-style framing.';

  @override
  String get docRadioPhysical => 'The physical link';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 at 161.975 MHz and AIS 2 at 162.025 MHz (VHF channels 87B and 88B).';

  @override
  String get docRadioPhysical2 =>
      'GMSK modulation at 9 600 baud — narrow enough to fit the maritime VHF band.';

  @override
  String get docRadioPhysical3 =>
      'HDLC framing with bit stuffing, and NRZI line coding, inherited from the packet-radio world.';

  @override
  String get docRadioFrames => 'TDMA frames and slots';

  @override
  String get docRadioFrames1 =>
      'Each channel is split into frames of exactly 1 minute, divided into 2 250 time slots of ~26.7 ms each.';

  @override
  String get docRadioFrames2 =>
      'A slot carries one AIS message (256 bits with ramp-up/down and guard time).';

  @override
  String get docRadioFrames3 =>
      'Stations reuse the same slots every frame so they broadcast periodically without colliding.';

  @override
  String get docRadioCode =>
      '2250 slots/frame · 1 frame = 60 s · slot ≈ 26.7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — how Class A self-organises';

  @override
  String get docRadioSotdmaText =>
      'Each Class A transponder listens to the slots around it, picks a free one and announces in its radio-status field when it will transmit next. Stations continuously re-reserve as the traffic picture changes, so no central coordinator is needed.';

  @override
  String get docRadioCstdma => 'CSTDMA — how Class B joins in';

  @override
  String get docRadioCstdmaText =>
      'Class B units are simpler: they listen for a slot that is currently free and transmit once in it. This is cheaper, but Class B reports can be lost in very dense traffic where a slot is always busy.';

  @override
  String get docRadioVdes => 'VDES — the future';

  @override
  String get docRadioVdesText =>
      'The VHF Data Exchange System (ITU-R M.2092) is rolling out to relieve congested waters: it adds new frequencies, far more bandwidth and secure two-way data for e-navigation, alongside the existing AIS service.';

  @override
  String get docClassesIntro =>
      'AIS hardware comes in different classes and roles. The two you will meet most often are the full Class A transponder and the cheap Class B unit.';

  @override
  String get docClassesComparison => 'Class A vs Class B';

  @override
  String get docClassesReceivers => 'Receivers and transponders';

  @override
  String get docClassesReceiversText =>
      'Transponders both receive and transmit. Many shore stations and hobbyists run receivers only, so they can watch traffic without appearing on it.';

  @override
  String get docClassesAton => 'Aids to navigation';

  @override
  String get docClassesAtonText =>
      'AtoN stations (type 21) broadcast buoys, beacons and lighthouses. They can also transmit a virtual aid — a marker that exists only on charts, useful to warn of a new hazard.';

  @override
  String get docClassesDistress => 'Distress & safety devices';

  @override
  String get docClassesDistressIntro =>
      'Beyond regular ships, AIS carries distress transmitters that every receiver should be able to spot:';

  @override
  String get docClassesSartNote =>
      'A SART in action also sets navigation status 14 (\"AIS-SART active\") on its position report.';

  @override
  String get docShipTypesIntro =>
      'Type 5 and 24 static messages carry an 8-bit ship-type code (0-99) that describes what the vessel is — cargo, tanker, fishing boat, pleasure craft and so on. The full table is shown below.';

  @override
  String get docShipTypesCategories => 'Categories at a glance';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle => 'Field notes & real-world quirks';

  @override
  String get docFieldNotesIntro =>
      'Real AIS traffic does not always match the theory. Knowing these quirks helps you trust what the decoder shows you — and what it rejects.';

  @override
  String get docGlossaryIntro =>
      'A searchable dictionary of the acronyms and terms used throughout this guide and by the AIS community.';

  @override
  String get docCheatSheetIntro =>
      'The essential numbers and codes at a glance — frequencies, reporting rates, status codes and formats.';

  @override
  String get docMmsiIntro =>
      'The Maritime Mobile Service Identity (MMSI) is a unique 9-digit number identifying a ship\'s radio equipment, like a phone number for the vessel. Its first three digits are the MID — the Maritime Identification Digits that identify the country that issued it.';

  @override
  String get docMmsiFormats => 'Number formats';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Look up an MMSI';

  @override
  String get docMmsiLookupHint =>
      'Enter a 9-digit MMSI below to see its class and the country of the issuing authority.';

  @override
  String get docMmsiMidHeading => 'Country codes (MID)';

  @override
  String get docMmsiMidText =>
      'The full MID table is bundled with KikAis and used everywhere an MMSI is displayed.';

  @override
  String get docMessagesTitle => 'The 27 message types';

  @override
  String get docMessagesIntro =>
      'Every AIS payload begins with a 6-bit message type (1 to 27). The catalog below groups them by family. Each card shows a real NMEA sentence generated by KikAis\' own encoder, its decoded fields, and a button to open it in the Decoder.';

  @override
  String get docNmeaTitle => 'NMEA & AIVDM framing';

  @override
  String get docNmeaIntro =>
      'On the wire, AIS messages travel as NMEA 0183 sentences starting with !AIVDM (other ships) or !AIVDO (your own ship). The payload is an ASCII-armored bit vector.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Sentence fields';

  @override
  String get docNmeaField1 =>
      'Talker & formatter — !AIVDM or !AIVDO (see talker IDs below).';

  @override
  String get docNmeaField2 =>
      'Fragment count — how many sentences make up the full message (NMEA limits each line to ~82 characters).';

  @override
  String get docNmeaField3 => 'Fragment number — which part this is (1-based).';

  @override
  String get docNmeaField4 =>
      'Sequential message ID — ties fragments of the same message together.';

  @override
  String get docNmeaField5 => 'Radio channel — A or B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Data payload — the six-bit armoured AIS payload.';

  @override
  String get docNmeaField7 =>
      'Fill bits — how many pad bits were added to the last 6-bit group (0-5).';

  @override
  String get docNmeaField8 =>
      'Checksum — the XOR of all bytes before the *, in hexadecimal.';

  @override
  String get docNmeaMulti => 'Multi-fragment messages';

  @override
  String get docNmeaMultiText =>
      'Messages longer than one line (such as type 5 static data) are split: the first sentence reports a fragment count of 2 and the second completes it with the same message ID.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Six-bit armoring';

  @override
  String get docNmeaArmoringText =>
      'Each payload character holds 6 bits. Subtract 48 from the ASCII code, then subtract another 8 if the result is above 40.';

  @override
  String get docNmeaTalkers => 'Talker IDs';

  @override
  String get docNmeaTalkersIntro =>
      'Different NMEA 4.0 talker IDs identify the type of AIS station:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Checksum';

  @override
  String get docNmeaChecksumText =>
      'The trailing checksum is the XOR of every byte between the \"!\" and the \"*\". Calculate your own below:';

  @override
  String get docNmeaInspectorTitle => 'Try it: sentence inspector';

  @override
  String get docNmeaInspectorText =>
      'Paste any AIVDM/AIVDO sentence (or use a sample above) to see its fields broken down and the decoded values.';

  @override
  String get docPayloadIntro =>
      'Once the six-bit armoring is undone, an AIS payload is a sequence of bit fields. The first six bits are the message type; the next two are the repeat indicator; then come 30 bits of MMSI.';

  @override
  String get docPayloadCnb => 'The Common Navigation Block (types 1-3)';

  @override
  String get docPayloadCnbText =>
      'The most important layout is shared by the Class A position reports. Use the selector to browse the main message layouts, and click a segment to read what it encodes.';

  @override
  String get docPayloadCoords => 'Coordinates';

  @override
  String get docPayloadCoordsText =>
      'Latitude and longitude are stored in 1/10 000 of a minute. Divide by 600 000 to get degrees: 60 minutes in a degree, and 10 000 units per minute. East/North are positive.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert => 'Convert your own coordinates below:';

  @override
  String get docPayloadSpeed => 'Speed, course, heading';

  @override
  String get docPayloadSpeed1 =>
      'SOG — speed over ground in tenths of a knot (0-102.2 kn); 1023 means \"not available\".';

  @override
  String get docPayloadSpeed2 =>
      'COG — course over ground in tenths of a degree, relative to true north.';

  @override
  String get docPayloadSpeed3 =>
      'Heading — true heading in whole degrees; 511 means \"not available\".';

  @override
  String get docPayloadSpeed4 =>
      'ROT — rate of turn: value ≈ 4.733 × √(turning rate in °/min), signed (positive = right).';

  @override
  String get docPayloadNavStatus => 'Navigation status';

  @override
  String get docPayloadEpfd => 'Position fix type (EPFD)';

  @override
  String get docPayloadText => 'Six-bit text';

  @override
  String get docPayloadTextIntro =>
      'Names, call signs and destinations use the same six-bit alphabet as the payload itself. Lowercase letters cannot be encoded, which is why AIS names are usually uppercase.';

  @override
  String get docSecurityTitle => 'Security & data quality';

  @override
  String get docSecurityIntro =>
      'AIS is designed for cooperation, not security. The radio channel is open and unencrypted, and there is no authentication of who is broadcasting.';

  @override
  String get docSecurityThreats => 'Threats';

  @override
  String get docSecurityThreat1 =>
      'Spoofing — transmitting a fake MMSI, position or identity (phantom ships, sanctions evasion).';

  @override
  String get docSecurityThreat2 =>
      'Jamming — flooding the two VHF channels so real traffic cannot be received.';

  @override
  String get docSecurityThreat3 =>
      'Meaconing — replaying real signals from elsewhere to confuse receivers.';

  @override
  String get docSecurityQuality => 'Data quality';

  @override
  String get docSecurityQuality1 =>
      'The position accuracy bit distinguishes an unaugmented GNSS fix (> 10 m) from a DGPS-quality fix (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'Receivers should sanity-check positions, speeds and timestamps; about 0.3% of real-world messages have a bad payload length.';

  @override
  String get docSecurityQuality3 =>
      'Satellite AIS occasionally suffers collisions because the satellite footprint is much larger than a TDMA cell — one more reason to correlate with radar and other sources.';

  @override
  String get docKikaisIntro =>
      'KikAis is a full AIS lab: receive live or simulated traffic, decode it, inspect and send your own messages, and build fleets. Here is how each tab maps to what you just read.';

  @override
  String get docTabReceptionText =>
      'Choose feeds (file, serial, simulation), start the forwarder and watch the raw NMEA stream and the decoded boats.';

  @override
  String get docTabSendText =>
      'Forward the received sentences to one or more TCP/UDP targets — how a shore station would distribute traffic.';

  @override
  String get docTabMapText =>
      'See decoded vessels plotted from their type 1/2/3, 18, 19 and 27 position reports.';

  @override
  String get docTabEditorText =>
      'Build any of the 27 message types by hand from a friendly form and send it — the best way to learn the fields.';

  @override
  String get docTabDecoderText =>
      'Paste any sentence and get the decoded fields, checksum and fragment handling — the practical companion to this guide.';

  @override
  String get docTabStatsText =>
      'Message counters, rates per feed and decoder health (invalid checksums, dropped fragments).';

  @override
  String get docTabSimulationText =>
      'Generate a whole fleet around any location — every message type, MMSI scheme, zone shape and even error injection.';

  @override
  String get docSourcesIntro =>
      'This guide synthesizes publicly available, authoritative documentation:';

  @override
  String get docSources1 =>
      'gpsd — AIVDM/AIVDO protocol decoding, by Eric S. Raymond (the de-facto technical bible for the sentence format and payload bit fields).';

  @override
  String get docSources2 =>
      'Wikipedia — Automatic Identification System (overview, history, applications, security).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — AIS pages.';

  @override
  String get docSources4 =>
      'ITU-R Recommendation M.1371 — the governing AIS standard.';

  @override
  String get docSources5 => 'IALA — clarifications of ITU-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA framing, Class B and AIS-SART.';

  @override
  String get docSourcesLearn => 'How to learn more';

  @override
  String get docSourcesLearnText =>
      'The best way to understand AIS is to experiment: use the Editor to build messages, the Decoder to read them back, and the Simulation tab to watch a whole fleet. Everything in this guide is generated by KikAis\' own encoder and decoder.';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return 'Type $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits bits · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return 'Emitted by: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Open in Decoder';

  @override
  String get docInspectorNmeaLabel => 'NMEA sentence';

  @override
  String get docInspectorInspect => 'Inspect';

  @override
  String get docInspectorInvalidChecksum => 'Invalid checksum';

  @override
  String get docInspectorCouldNotDecode => 'Could not decode';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Decoded: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Type $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 digits)';

  @override
  String get docMmsiLookupButton => 'Look up';

  @override
  String get docMmsiLookupError => 'Enter a 9-digit MMSI (digits only).';

  @override
  String get docMmsiLookupClassGroup => 'Group of ships (group call)';

  @override
  String get docMmsiUnknownCountry => 'unknown country';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Open';

  @override
  String get updateCheckForUpdates => 'Check for updates';

  @override
  String get updateChecking => 'Checking for updates.';

  @override
  String updateNewVersion(Object version) {
    return 'New version $version';
  }

  @override
  String get updateUpToDate => 'You\'re up to date.';

  @override
  String get updateCheckFailed => 'Update check failed.';

  @override
  String get tooltipLanguage =>
      'Defines the interface language. All ten languages are fully translated; choose \"Auto\" to follow the operating system language.';

  @override
  String get tooltipTheme =>
      'Defines the color theme: dark, light or high contrast. High contrast improves readability.';

  @override
  String get tooltipUpdate =>
      'Checks for a new version. A green badge appears next to the version number when an update is available.';

  @override
  String get tooltipMapSearch =>
      'Searches for a vessel by name, MMSI or IMO number, then centers and follows it on the map.';

  @override
  String get tooltipMapFilters =>
      'Filters the displayed vessels by type, navigation status, country (MID), speed or name.';

  @override
  String get tooltipMapCluster =>
      'Enables or disables vessel clustering. When enabled, nearby vessels are grouped into one marker with a count.';

  @override
  String get tooltipMapTrails =>
      'Enables or disables the trails. When enabled, each vessel draws its recent path on the map.';

  @override
  String get tooltipMapVectors =>
      'Enables or disables the heading vectors. When enabled, each vessel shows an arrow along its course.';

  @override
  String get tooltipMapSendToMap =>
      'Enables or disables sending decoded vessels to the map. When enabled, every decoded vessel appears as a marker.';

  @override
  String get tooltipMapClear => 'Clears all vessels currently on the map.';

  @override
  String get tooltipMapBasemap =>
      'Defines the map background. \"Auto\" follows the current theme.';

  @override
  String get tooltipSendAdd =>
      'Adds a new send destination (UDP or TCP, client or server). Incoming AIS frames are forwarded to every enabled destination.';

  @override
  String get tooltipSendEdit =>
      'Edits this destination\'s name, protocol, host, port and frame format.';

  @override
  String get tooltipSendDelete =>
      'Deletes this destination. This action cannot be undone.';

  @override
  String get tooltipSendToggle =>
      'Enables or disables forwarding to this destination.';

  @override
  String get tooltipSendLocked =>
      'Destinations are locked while the forwarder is running. Stop the feed on the Reception tab to edit them.';

  @override
  String get tooltipReceptionAddSource =>
      'Adds a data source: a network feed (UDP/TCP/gpsd), a file of recorded NMEA sentences, or a serial port.';

  @override
  String get tooltipReceptionStart =>
      'Starts receiving and forwarding AIS frames from all enabled sources.';

  @override
  String get tooltipReceptionStop =>
      'Stops receiving and forwarding AIS frames.';

  @override
  String get tooltipReceptionFeed => 'Enables or disables this AIS source.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Saves the connection log to a text file.';

  @override
  String get tooltipReceptionClearLogs => 'Clears the connection log.';

  @override
  String get tooltipReceptionRemoveSource => 'Removes this AIS source.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Rejects frames with an invalid NMEA checksum when enabled.';

  @override
  String get tooltipReceptionImportFormat =>
      'Defines how received frames are normalized before decoding.';

  @override
  String get tooltipReceptionLoop =>
      'Restarts the file replay from the beginning when the end is reached.';

  @override
  String get tooltipReceptionSpeed =>
      'Defines the replay speed multiplier (1x = real time).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Refreshes the list of available serial ports.';

  @override
  String get tooltipSimApply =>
      'Applies the current settings and generates the fleet. Large fleets are generated in the background.';

  @override
  String get tooltipSimGenerate =>
      'Generates a new random fleet with a fresh seed, then applies it.';

  @override
  String get tooltipSimOpenReception =>
      'Opens the Reception tab to start the Simulation feed.';

  @override
  String get tooltipSimRadius =>
      'Radius of the navigation zone around the center, in kilometers.';

  @override
  String get tooltipSimVessels => 'Number of vessels to generate in the fleet.';

  @override
  String get tooltipSimSpeedMin =>
      'Minimum vessel speed over ground, in knots.';

  @override
  String get tooltipSimSpeedMax =>
      'Maximum vessel speed over ground, in knots.';

  @override
  String get tooltipSimInterval =>
      'Delay between two emission ticks, in seconds.';

  @override
  String get tooltipSimSeed =>
      'Random seed. The same seed always produces the same fleet.';

  @override
  String get tooltipSimAnchored =>
      'Percentage of vessels left anchored or moored instead of moving.';

  @override
  String get tooltipSimNamePrefix =>
      'Prefix used for the generated vessel names.';

  @override
  String get tooltipSimMmsiMid =>
      'Maritime Identification Digits (3-digit country code) used to build the MMSIs.';

  @override
  String get tooltipSimCenterLat => 'Latitude of the navigation zone center.';

  @override
  String get tooltipSimCenterLon => 'Longitude of the navigation zone center.';

  @override
  String get tooltipSimTransit =>
      'Percentage of vessels crossing the zone on a straight transit route.';

  @override
  String get tooltipSimRegenEvery =>
      'Regenerate the fleet every N ticks when periodic regeneration is enabled.';

  @override
  String get tooltipSimReportInterval =>
      'Maximum position-report interval per vessel, in ticks.';

  @override
  String get tooltipSimWander =>
      'Strength of the random heading wander (0 = straight lines).';

  @override
  String get tooltipSimClassBShare =>
      'Percentage of Class B versus Class A position reports when both are enabled.';

  @override
  String get tooltipSimErrorRate =>
      'Probability of corrupting or duplicating each emitted sentence.';

  @override
  String get tooltipSimBaseStations =>
      'Number of fixed base stations to generate.';

  @override
  String get tooltipSimAtoN =>
      'Number of fixed Aids to Navigation (beacons) to generate.';

  @override
  String get tooltipSimRealisticNames =>
      'Use realistic vessel names, call signs and destinations.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Scale vessel dimensions and draught by ship type.';

  @override
  String get tooltipSimRealisticMmsi =>
      'Build MMSIs that follow the ITU structure per vessel category.';

  @override
  String get tooltipSimVarySpeed =>
      'Let vessel speed drift gently within the configured range.';

  @override
  String get tooltipSimSpeedByType =>
      'Pick the speed from the typical range of each ship type.';

  @override
  String get tooltipSimHighAccuracy =>
      'Set the high-accuracy position flag on emitted reports.';

  @override
  String get tooltipSimRealisticRot =>
      'Emit a rate of turn derived from the heading change.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Automatically regenerate the fleet every N ticks to simulate changing traffic.';

  @override
  String get tooltipSimInjectErrors =>
      'Corrupt or duplicate some emitted sentences to test error handling.';

  @override
  String get tooltipSimNmea4Tag =>
      'Prefix every emitted frame with an NMEA 4.0 tag block.';

  @override
  String get tooltipSimVesselType => 'Include this ship type in the fleet.';

  @override
  String get tooltipSimMessageType => 'Emit this AIS message type.';

  @override
  String get tooltipDecoderClear => 'Clears the decoder input and results.';

  @override
  String get tooltipStatsDecode =>
      'Pauses or resumes decoding of incoming AIS frames.';

  @override
  String get tooltipStatsReset => 'Resets all statistics counters to zero.';

  @override
  String get tooltipDocOpenTab => 'Opens this section in its own tab.';

  @override
  String get tooltipEditorInject =>
      'Injects the composed message into the decoder as if it had been received.';

  @override
  String get tooltipEditorSend =>
      'Sends the composed message to every enabled send destination.';

  @override
  String get tooltipCopy => 'Copies the selection to the clipboard.';

  @override
  String get tooltipClose => 'Closes this panel.';

  @override
  String get tooltipBrowse => 'Opens a file browser to choose a file.';

  @override
  String get tooltipFeedName =>
      'A label identifying this source in the feeds list.';

  @override
  String get tooltipFeedHost =>
      'The server address that streams AIS sentences.';

  @override
  String get tooltipFeedPort => 'The TCP or UDP port used to reach the server.';

  @override
  String get tooltipFeedHeader =>
      'Optional bytes sent on connect, before reading (e.g. a gpsd request).';

  @override
  String get tooltipFeedFile =>
      'Path to a text file of recorded NMEA sentences.';

  @override
  String get tooltipFeedInterval =>
      'Delay between two frames when replaying the file.';

  @override
  String get tooltipFeedLoop =>
      'Restarts the file replay from the beginning when the end is reached.';

  @override
  String get tooltipFeedSpeed =>
      'Defines the replay speed multiplier (1x = real time).';

  @override
  String get tooltipFeedSerialPort =>
      'The serial port of the AIS receiver (e.g. COM3 or /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Baud rate used to talk to the serial AIS receiver.';

  @override
  String get tooltipFeedRtlDevice =>
      'The RTL-SDR dongle used to receive AIS on VHF.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Lets the tuner adjust its gain automatically. Recommended for most setups.';

  @override
  String get tooltipFeedRtlGain =>
      'Fixed tuner gain in decibels, used when automatic gain is off.';

  @override
  String get tooltipFeedRtlChannels =>
      'Which VHF AIS channels to decode: A (161.975 MHz), B (162.025 MHz) or both.';

  @override
  String get aisCatcherNotFound =>
      'AIS-catcher is required for RTL-SDR reception but was not found. You can download it automatically, or point to your existing installation.';

  @override
  String get aisCatcherDownload => 'Download automatically';

  @override
  String get aisCatcherChoosePath => 'Choose path...';

  @override
  String get aisCatcherCancel => 'Cancel';

  @override
  String get aisCatcherManualDownload => 'Download manually';

  @override
  String get aisCatcherDownloading => 'Downloading AIS-catcher...';

  @override
  String get aisCatcherInvalidPath =>
      'Invalid AIS-catcher executable. Please select ais-catcher.exe.';
}
