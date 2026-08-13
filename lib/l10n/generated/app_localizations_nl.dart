// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get languageSystem => 'Automatisch (systeem)';

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
  String get themeDark => 'Donker';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeHighContrast => 'Hoog contrast';

  @override
  String get tabReception => 'Ontvangst';

  @override
  String get tabSend => 'Verzenden';

  @override
  String get tabMap => 'Kaart';

  @override
  String get tabEditor => 'Editor';

  @override
  String get tabDecoder => 'Decoder';

  @override
  String get tabStats => 'Statistieken';

  @override
  String get tabSimulation => 'Simulatie';

  @override
  String get tabDocs => 'Documentatie';

  @override
  String get protocolUdpServer => 'UDP-server';

  @override
  String get protocolUdpClient => 'UDP-client';

  @override
  String get protocolTcpClient => 'TCP-client';

  @override
  String get protocolTcpServer => 'TCP-server';

  @override
  String get formatPassthrough => 'Doorvoer';

  @override
  String get formatStrip => 'Tagblokken verwijderen';

  @override
  String get formatTag => 'Tagblok toevoegen';

  @override
  String get sendAddDestination => 'Bestemming toevoegen';

  @override
  String get sendEditDestination => 'Bestemming bewerken';

  @override
  String get sendFormat => 'Verzendindeling';

  @override
  String get sendSave => 'Opslaan';

  @override
  String get sendLockedBanner =>
      'Doorstuurder draait — bestemmingen zijn vergrendeld.';

  @override
  String get sendEmpty =>
      'Nog geen bestemming. Voeg er een toe om ontvangen AIS-frames door te sturen.';

  @override
  String get fieldName => 'Naam';

  @override
  String get fieldProtocol => 'Protocol';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Poort';

  @override
  String get fieldTagSourceId => 'Tag-bron-id';

  @override
  String get fieldFile => 'Bestand';

  @override
  String get fieldCancel => 'Annuleren';

  @override
  String get fieldAdd => 'Toevoegen';

  @override
  String get receptionFeeds => 'Feeds';

  @override
  String get receptionValidateChecksums => 'NMEA-checksums valideren';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zinnen verloren',
      one: '1 zin verloren',
      zero: 'Geen zin verloren',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Importframe-indeling';

  @override
  String get receptionStart => 'Start';

  @override
  String get receptionStop => 'Stop';

  @override
  String get receptionLogs => 'Logs';

  @override
  String get receptionFrameCopied => 'Frame gekopieerd';

  @override
  String get receptionAddSource => 'Bron toevoegen';

  @override
  String get receptionNetwork => 'Netwerk';

  @override
  String get receptionFile => 'Bestand';

  @override
  String get receptionSerial => 'Serieel';

  @override
  String get receptionHeaderOptional => 'Koptekst (optioneel)';

  @override
  String get receptionPathOrBrowse => 'Pad of Bladeren…';

  @override
  String get receptionIntervalMs => 'Interval tussen frames (ms)';

  @override
  String get receptionReplayTimestamps => 'Afspelen met bestandstijdstempels';

  @override
  String get receptionReplayTimestampsHint =>
      'Volgt de geregistreerde tijden (tagblok t: of tijdstempelvoorvoegsel) in plaats van een vast interval';

  @override
  String get receptionSpeed => 'Snelheid';

  @override
  String get receptionReplayLoop => 'Lus (afspelen vanaf het begin)';

  @override
  String get receptionSerialPort => 'Seriële poort';

  @override
  String get receptionSerialPortHint => 'bijv. COM3 of /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Baudrate';

  @override
  String get msgType1 => 'Positierapport klasse A';

  @override
  String get msgType2 => 'Positierapport klasse A (toegewezen)';

  @override
  String get msgType3 => 'Positierapport klasse A (respons)';

  @override
  String get msgType4 => 'Basisstation';

  @override
  String get msgType5 => 'Statische en reisgerelateerde gegevens';

  @override
  String get msgType6 => 'Binair geadresseerd bericht';

  @override
  String get msgType7 => 'Binaire bevestiging';

  @override
  String get msgType8 => 'Binair broadcastbericht';

  @override
  String get msgType9 => 'Standaard SAR-vliegtuigpositierapport';

  @override
  String get msgType10 => 'UTC/datum-verzoek';

  @override
  String get msgType11 => 'UTC/datum-respons';

  @override
  String get msgType12 => 'Geadresseerd veiligheidsbericht';

  @override
  String get msgType13 => 'Veiligheidsbevestiging';

  @override
  String get msgType14 => 'Veiligheidsbroadcastbericht';

  @override
  String get msgType15 => 'Interrogatie';

  @override
  String get msgType16 => 'Opdracht toewijzingsmodus';

  @override
  String get msgType17 => 'DGNSS-binair broadcastbericht';

  @override
  String get msgType18 => 'Standaard klasse B CS-positierapport';

  @override
  String get msgType19 => 'Uitgebreid klasse B-apparatuurpositierapport';

  @override
  String get msgType20 => 'Datalinkbeheerbericht';

  @override
  String get msgType21 => 'Navigatiehulpmiddelrapport';

  @override
  String get msgType22 => 'Kanaalbeheer';

  @override
  String get msgType23 => 'Groepstoewijzingsopdracht';

  @override
  String get msgType24 => 'Statisch gegevensrapport';

  @override
  String get msgType25 => 'Binair bericht met enkele tijdsleuf';

  @override
  String get msgType26 => 'Binair bericht met meerdere tijdsleuven';

  @override
  String get msgType27 => 'Positierapport voor langeafstandstoepassingen';

  @override
  String get statsTitle => 'Statistieken';

  @override
  String get statsFeed => 'Feed';

  @override
  String get statsAllFeeds => 'Alle feeds';

  @override
  String get statsReceived => 'Ontvangen';

  @override
  String get statsDecoded => 'Gedecodeerd';

  @override
  String get statsInvalidChecksums => 'Ongeldige checksums';

  @override
  String get statsDroppedFragments => 'Verloren fragmenten';

  @override
  String get statsParseErrors => 'Parsefouten';

  @override
  String get statsPendingFragments => 'In behandeling zijnde fragmenten';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(alle feeds)';

  @override
  String get statsReceivedVsDecoded =>
      'Ontvangen vs gedecodeerd (laatste 60 s)';

  @override
  String get statsPerSecondLabel => 'per seconde';

  @override
  String get statsAccounting => 'Verantwoording';

  @override
  String get statsMultiPartParts => 'Meerdelige onderdelen';

  @override
  String get statsPending => 'In behandeling';

  @override
  String get statsDropped => 'Verloren';

  @override
  String get statsReconcile => 'Ontvangen en gedecodeerd stemmen overeen.';

  @override
  String get statsGapPaused =>
      'Het gat omvat zinnen die zijn ontvangen terwijl het decoderen was gepauzeerd.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Ontvangen $received = $sum';
  }

  @override
  String get statsByMessageType => 'Naar berichttype';

  @override
  String get statsNoDecodedYet => 'Nog geen gedecodeerde berichten';

  @override
  String statsTypeFallback(Object type) {
    return 'Type $type';
  }

  @override
  String get statsByFeed => 'Per feed';

  @override
  String statsFeedFilter(Object filter) {
    return 'Feed: $filter';
  }

  @override
  String get statsNoActivityYet => 'Nog geen feed-activiteit';

  @override
  String get statsCollecting => 'verzamelen…';

  @override
  String get simVesselCargo => 'Vrachtschip';

  @override
  String get simVesselTanker => 'Tanker';

  @override
  String get simVesselFishing => 'Visserij';

  @override
  String get simVesselSailing => 'Zeilvaart';

  @override
  String get simVesselPassenger => 'Passagier';

  @override
  String get simVesselTug => 'Sleepboot';

  @override
  String get simVesselHsc => 'Snelvaartuig';

  @override
  String get simVesselOther => 'Overig';

  @override
  String get simType1 => 'Positierapport (1/2/3)';

  @override
  String get simType5 => 'Statisch & reis (5)';

  @override
  String get simType9 => 'SAR-vliegtuig (9)';

  @override
  String get simType18 => 'Klasse B-positie (18)';

  @override
  String get simType19 => 'Klasse B uitgebreid (19)';

  @override
  String get simType27 => 'Lange afstand (27)';

  @override
  String get simType4 => 'Basisstation (4)';

  @override
  String get simType21 => 'Navigatiehulpmiddel (21)';

  @override
  String get simType8 => 'Weerbroadcast (8)';

  @override
  String get simType11 => 'UTC/datum-respons (11)';

  @override
  String get simType12 => 'Veiligheid geadresseerd (12)';

  @override
  String get simType14 => 'Veiligheidsbroadcast (14)';

  @override
  String get simType22 => 'Kanaalbeheer (22)';

  @override
  String get simType23 => 'Groepstoewijzing (23)';

  @override
  String get simType24 => 'Klasse B statisch (24)';

  @override
  String get simTitle => 'Simulatie';

  @override
  String get simInfoBanner =>
      'De vloot wordt uitgezonden wanneer de feed \"Simulatie\" is ingeschakeld op het tabblad Ontvangst en de doorstuurder draait.';

  @override
  String get simOpenReception => 'Ontvangst openen';

  @override
  String get simFleetSection => 'Vloot';

  @override
  String get simRadiusKm => 'Straal (km)';

  @override
  String get simVessels => 'Vaartuigen';

  @override
  String get simSpeedMinKn => 'Snelheid min (kn)';

  @override
  String get simSpeedMaxKn => 'Snelheid max (kn)';

  @override
  String get simIntervalS => 'Interval (s)';

  @override
  String get simSeed => 'Zaadwaarde';

  @override
  String get simAnchoredPct => 'Voor anker (%)';

  @override
  String get simNamePrefix => 'Naamvoorvoegsel';

  @override
  String get simMmsiMid => 'MMSI-land / MID';

  @override
  String get simSearchMmid => 'Zoek een land of typ een 3-cijferige MID';

  @override
  String get simCustom => 'Aangepast';

  @override
  String get simVesselTypes => 'Vaartuigtypes';

  @override
  String get simRealisticNames => 'Realistische namen';

  @override
  String get simRealisticDimensions => 'Realistische afmetingen';

  @override
  String get simRealisticMmsi => 'Realistische ITU-MMSI';

  @override
  String get simZoneSection => 'Zone & verkeer';

  @override
  String get simLocationPreset => 'Locatievoorkeuze';

  @override
  String get simSearchPort => 'Zoek een haven…';

  @override
  String get simCenterLat => 'Middelpuntbreedte';

  @override
  String get simCenterLon => 'Middelpuntlengte';

  @override
  String get simZoneShape => 'Zonevorm';

  @override
  String get simTransitPct => 'In transit (%)';

  @override
  String get simRegeneratePeriodically => 'Periodiek opnieuw genereren';

  @override
  String get simRegenerateTicks => 'Opnieuw genereren (tikken)';

  @override
  String get simPresetHint =>
      'Kies een voorkeuze om de coördinaten in te vullen, of typ de middelpuntbreedte/-lengte direct in.';

  @override
  String get simMovementSection => 'Beweging & uitzending';

  @override
  String get simVarySpeed => 'Snelheid in de loop van de tijd variëren';

  @override
  String get simReportIntervalTicks => 'Rapportage-interval (tikken)';

  @override
  String get simWander => 'Afwijking (0-3)';

  @override
  String get simSpeedByType => 'Snelheid per vaartuigtype';

  @override
  String get simClassBSharePct => 'Klasse B-aandeel (%)';

  @override
  String get simHighAccuracy => 'Hoge nauwkeurigheid';

  @override
  String get simRealisticRot => 'Realistische draaisnelheid';

  @override
  String get simContentSection => 'Inhoud';

  @override
  String get simSafetyTexts => 'Veiligheidsteksten (één per regel)';

  @override
  String get simDestinations => 'Bestemmingen (één per regel)';

  @override
  String get simStationsSection => 'Stations';

  @override
  String get simBaseStations => 'Basisstations';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => 'Transmissiekwaliteit';

  @override
  String get simInjectErrors => 'Fouten injecteren';

  @override
  String get simErrorRatePct => 'Foutpercentage (%)';

  @override
  String get simTalkerId => 'Talker-id';

  @override
  String get simNmea4Tag => 'NMEA 4.0-tagblok';

  @override
  String get simMessagesSection => 'Berichten';

  @override
  String get simApplyFleet => 'Vloot toepassen';

  @override
  String get simRegenerateFleet => 'Vloot opnieuw genereren';

  @override
  String get simLiveFleet => 'Live vloot';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats vaartuigen · $frames frames uitgezonden';
  }

  @override
  String get mapSearchVessels => 'Vaartuigen zoeken';

  @override
  String get mapSearchHint => 'Naam, MMSI of IMO';

  @override
  String get mapNoResults => 'Geen resultaten';

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
    return 'Alle $label';
  }

  @override
  String get mapVesselType => 'Vaartuigtype';

  @override
  String get mapNavigationStatus => 'Navigatiestatus';

  @override
  String get mapCountry => 'Land';

  @override
  String get mapMinSog => 'Min SOG (kn)';

  @override
  String get mapMaxSog => 'Max SOG (kn)';

  @override
  String get mapOnlyNamed => 'Alleen vaartuigen met een naam';

  @override
  String get mapReset => 'Herstellen';

  @override
  String get mapApply => 'Toepassen';

  @override
  String get mapAutoBasemap => 'Automatisch (thema volgen)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Volgen $mmsi';
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
  String get basemapVoyagerLight => 'Voyager (licht)';

  @override
  String get basemapPositronLight => 'Positron (licht, minimaal)';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Esri-satelliet';

  @override
  String get basemapEsriStreets => 'Esri World Street Map';

  @override
  String get decoderInputLabel => 'Plak of schrijf één of meer NMEA AIS-zinnen';

  @override
  String get decoderValidateChecksums => 'Checksums valideren';

  @override
  String get decoderDecode => 'Decoderen';

  @override
  String get decoderDecoded => 'Gedecodeerd';

  @override
  String decoderDecodedN(Object n) {
    return 'Gedecodeerd ($n zinnen)';
  }

  @override
  String get decoderInvalidChecksum => 'Ongeldige checksum';

  @override
  String get decoderParseError => 'Parsefout';

  @override
  String get decoderWaitingFragments => 'Wachten op meer fragmenten…';

  @override
  String decoderTagSource(Object id) {
    return 'bron $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Tagblok · $content';
  }

  @override
  String get fMessageType => 'Berichttype';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Herhalingsindicator';

  @override
  String get fNavStatus => 'Navigatiestatus';

  @override
  String get fLatitude => 'Breedtegraad';

  @override
  String get fLongitude => 'Lengtegraad';

  @override
  String get fSogKn => 'SOG (kn)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Kop (°)';

  @override
  String get fRateOfTurn => 'Draaisnelheid';

  @override
  String get fManeuver => 'Manoeuvre';

  @override
  String get fTimestamp => 'Tijdstempel';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Nauwkeurigheid';

  @override
  String get fEpfdFixType => 'EPFD-positiebepalingsmethode';

  @override
  String get fSyncState => 'Synchronisatiestatus';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Roepnaam';

  @override
  String get fVesselName => 'Scheepsnaam';

  @override
  String get fShipType => 'Scheepstype';

  @override
  String get fShipTypeText => 'Scheepstype (tekst)';

  @override
  String get fDims => 'Boeg/achtersteven/bakboord/stuurboord (m)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Diepgang (m)';

  @override
  String get fDestination => 'Bestemming';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'Bestemmings-MMSI';

  @override
  String get fSeqNumber => 'Volgnummer';

  @override
  String get fRetransmit => 'Opnieuw verzenden';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Gegevens';

  @override
  String get fAltitudeM => 'Hoogte (m)';

  @override
  String get fAssignedMode => 'Toegewezen modus';

  @override
  String get fRegionalReserved => 'Regionaal gereserveerd';

  @override
  String get fText => 'Tekst';

  @override
  String fStationN(Object n) {
    return 'Station $n';
  }

  @override
  String fSlotN(Object n) {
    return 'Tijdsleuf $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return 'offset $offset · nummer $number · timeout $timeout · inc $increment';
  }

  @override
  String get fAidType => 'Hulpmiddeltype';

  @override
  String get fAidTypeCode => 'Hulpmiddeltype (code)';

  @override
  String get fName => 'Naam';

  @override
  String get fNameExt => 'Naamuitbreiding';

  @override
  String get fVirtualAid => 'Virtueel hulpmiddel';

  @override
  String get fOffPosition => 'Buiten positie';

  @override
  String get fSecond => 'Seconde';

  @override
  String get fChannelA => 'Kanaal A';

  @override
  String get fChannelB => 'Kanaal B';

  @override
  String get fTxRxMode => 'TX/RX-modus';

  @override
  String get fPower => 'Vermogen';

  @override
  String get fZone => 'Zone';

  @override
  String get fAddressed => 'Geadresseerd';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Band A';

  @override
  String get fBandB => 'Band B';

  @override
  String get fZoneSize => 'Zonegrootte';

  @override
  String get fStationType => 'Stationstype';

  @override
  String get fReportInterval => 'Rapportage-interval';

  @override
  String get fQuietTime => 'Stille periode';

  @override
  String get fPart => 'Onderdeel';

  @override
  String get fVendorId => 'Verkoper-id';

  @override
  String get fUnitModel => 'Eenheidsmodel';

  @override
  String get fSerialNumber => 'Serienummer';

  @override
  String get fMothershipMmsi => 'Moederschip-MMSI';

  @override
  String get fRadioStatus => 'Radiostatus';

  @override
  String get fGnssStatus => 'GNSS-positiestatus';

  @override
  String fDestN(Object n) {
    return 'Bestemming $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => 'Bestemmingsindicator';

  @override
  String get fBinaryDataFlag => 'Vlag binaire gegevens';

  @override
  String get fApplicationId => 'Toepassings-id';

  @override
  String get fPowerHigh => 'Hoog';

  @override
  String get fPowerLow => 'Laag';

  @override
  String get fPartA => 'A (naam)';

  @override
  String get fPartB => 'B (scheepsgegevens)';

  @override
  String get editorTitle => 'AIS-berichteditor';

  @override
  String get editorCompose => 'Bericht samenstellen';

  @override
  String get editorMessageType => 'Berichttype';

  @override
  String get editorAddTagBlock => 'NMEA 4.0-tagblok toevoegen';

  @override
  String get editorSourceId => 'Bron-id';

  @override
  String get editorInjectToMap => 'In kaart injecteren';

  @override
  String get editorSendToTarget => 'Naar doel verzenden';

  @override
  String get editorPreview => 'NMEA-voorbeeld';

  @override
  String get editorNmeaCopied => 'NMEA gekopieerd';

  @override
  String get editorInjected => 'Bericht geïnjecteerd';

  @override
  String get editorSentToTarget => 'Bericht naar doel verzonden';

  @override
  String get editorNavStatus0_15 => 'Navigatiestatus (0-15)';

  @override
  String get editorYear => 'Jaar';

  @override
  String get editorMonth => 'Maand';

  @override
  String get editorDay => 'Dag';

  @override
  String get editorHour => 'Uur';

  @override
  String get editorMinute => 'Minuut';

  @override
  String get editorSecond => 'Seconde';

  @override
  String get editorImoNumber => 'IMO-nummer';

  @override
  String get editorBowM => 'Boeg (m)';

  @override
  String get editorSternM => 'Achtersteven (m)';

  @override
  String get editorPortM => 'Bakboord (m)';

  @override
  String get editorStarboardM => 'Stuurboord (m)';

  @override
  String get editorEtaMonth => 'ETA-maand';

  @override
  String get editorEtaDay => 'ETA-dag';

  @override
  String get editorEtaHour => 'ETA-uur';

  @override
  String get editorEtaMinute => 'ETA-minuut';

  @override
  String get editorSequence0_3 => 'Volgorde (0-3)';

  @override
  String get editorDataBytes => 'Gegevensbytes (hex of 1,2,3)';

  @override
  String get editorDestMmsisComma => 'Bestemmings-MMSI\'s (komma)';

  @override
  String get editorSequencesComma => 'Volgorden (komma)';

  @override
  String get editorInterrogatedMmsi => 'Geïnterrogeerde MMSI';

  @override
  String get editorType1 => 'Type 1';

  @override
  String get editorOffset1 => 'Offset 1';

  @override
  String get editorTargetMmsi => 'Doel-MMSI';

  @override
  String get editorOffset => 'Offset';

  @override
  String get editorIncrement => 'Verhoging';

  @override
  String get editorNumber => 'Aantal';

  @override
  String get editorTimeout => 'Timeout';

  @override
  String get editorAidType0_31 => 'Hulpmiddeltype (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Virtueel hulpmiddel (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Tx/Rx-modus (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Tx/Rx-modus (0-3)';

  @override
  String get editorNeLat => 'NO-breedte';

  @override
  String get editorNeLon => 'NO-lengte';

  @override
  String get editorSwLat => 'ZW-breedte';

  @override
  String get editorSwLon => 'ZW-lengte';

  @override
  String get editorInterval0_15 => 'Interval (0-15)';

  @override
  String get editorPart => 'Onderdeel (0 = A naam, 1 = B statisch)';

  @override
  String get editorDestMmsiEmpty => 'Bestemmings-MMSI (leeg = broadcast)';

  @override
  String get editorAppDacEmpty => 'App-DAC (leeg = geen)';

  @override
  String get editorAppFidEmpty => 'App-FID (leeg = geen)';

  @override
  String get nmeaTalker => 'Talker';

  @override
  String get nmeaFragments => 'Fragmenten';

  @override
  String get nmeaFragmentN => 'Fragment #';

  @override
  String get nmeaMessageId => 'Bericht-id';

  @override
  String get nmeaChannel => 'Kanaal';

  @override
  String get nmeaPayload => 'Payload';

  @override
  String get nmeaFillBits => 'Opvulbits';

  @override
  String get nmeaTagBlock => 'Tagblok';

  @override
  String get nmeaChecksum => 'Checksum';

  @override
  String get nmeaEmpty => '(leeg)';

  @override
  String get bubbleKindVessel => 'Vaartuig';

  @override
  String get bubbleKindAircraft => 'SAR-vliegtuig';

  @override
  String get bubbleKindAton => 'Navigatiehulpmiddel';

  @override
  String get bubbleKindStation => 'Basisstation';

  @override
  String get bubbleGeneralInfo => 'Algemene informatie';

  @override
  String get bubbleKind => 'Soort';

  @override
  String get bubbleAidType => 'Hulpmiddeltype';

  @override
  String get bubbleVirtual => 'Virtueel';

  @override
  String get bubbleAltitude => 'Hoogte';

  @override
  String get bubbleCallSign => 'Roepnaam';

  @override
  String get bubblePosNav => 'Positie & navigatie';

  @override
  String get bubbleHeading => 'Kop';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Vaartuiggegevens';

  @override
  String get bubbleType => 'Type';

  @override
  String get bubbleTypeInt => 'Type (int)';

  @override
  String get bubbleDimsBowStern => 'Afmetingen boeg/achtersteven';

  @override
  String get bubbleDimsPortStarboard => 'Afmetingen bakboord/stuurboord';

  @override
  String get bubbleSpare => 'Reserve';

  @override
  String get bubbleDraught => 'Diepgang';

  @override
  String bubbleFrames(Object n) {
    return 'Frames ($n)';
  }

  @override
  String get bubbleNoFrames => 'Nog geen frames';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get textFiles => 'Tekstbestanden';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Doel $name verbonden ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Verbinden met doel $name mislukt: $error';
  }

  @override
  String get logStopping => 'Doorstuurder stoppen...';

  @override
  String get logStopped => 'Doorstuurder gestopt.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Feed toegevoegd: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Feed verwijderd: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Feed $name verbonden.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Feed $name verbroken. Opnieuw verbinden over 5 s...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Verbinden met feed $name mislukt: $error. Opnieuw proberen over 5 s...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Doel $name: TCP-server luistert op poort $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Doel $name: client verbonden $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Doel $name: client verbroken';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Doel $name: clientfout $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Doel $name: verzendfout $error';
  }

  @override
  String get docNavStatus0 => 'Onderweg met motor';

  @override
  String get docNavStatus1 => 'Voor anker';

  @override
  String get docNavStatus2 => 'Niet onder commando';

  @override
  String get docNavStatus3 => 'Beperkte manoeuvreerbaarheid';

  @override
  String get docNavStatus4 => 'Beperkt door haar diepgang';

  @override
  String get docNavStatus5 => 'Afgemeerd';

  @override
  String get docNavStatus6 => 'Aan de grond';

  @override
  String get docNavStatus7 => 'Bezig met vissen';

  @override
  String get docNavStatus8 => 'Onderweg zeilend';

  @override
  String get docNavStatus9 => 'Gereserveerd (HSC)';

  @override
  String get docNavStatus10 => 'Gereserveerd (WIG)';

  @override
  String get docNavStatus11 => 'Slepend achter (regionaal)';

  @override
  String get docNavStatus12 => 'Duwend vooruit / slepend langszij (regionaal)';

  @override
  String get docNavStatus13 => 'Gereserveerd voor toekomstig gebruik';

  @override
  String get docNavStatus14 => 'AIS-SART actief';

  @override
  String get docNavStatus15 => 'Niet gedefinieerd (standaard)';

  @override
  String get docEpfd0 => 'Niet gedefinieerd (standaard)';

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
  String get docEpfd6 => 'Geïntegreerd navigatiesysteem';

  @override
  String get docEpfd7 => 'Ingemeten (vast)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'Interne GNSS';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · bits $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields velden · $bits bits totaal · tik op een segment';
  }

  @override
  String get docTextToEncode => 'Tekst om te coderen';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Elk teken is één 6-bitswaarde (\"@\" = 0, spatie = 32, \"A\" = 1…). Kleine letters kunnen niet worden gecodeerd en worden meestal als hoofdletters verzonden.';

  @override
  String get docChecksumBody => 'Body (zonder leidend ! en volgend *XX)';

  @override
  String get docChecksumExplanation =>
      'De NMEA-checksum is de XOR van elke byte tussen de \"!\" en de \"*\".';

  @override
  String get docLatitude => 'Breedtegraad';

  @override
  String get docLongitude => 'Lengtegraad';

  @override
  String get docLatitudeInvalid => 'Breedtegraad: voer een getal in';

  @override
  String get docLongitudeInvalid => 'Lengtegraad: voer een getal in';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Breedtegraad → $value (27-bit ondertekend, deg = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Lengtegraad → $value (28-bit ondertekend, deg = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Coördinaten worden opgeslagen in 1/10 000 van een minuut: deel door 600 000 om graden te verkrijgen.';

  @override
  String get docSearchShipTypes => 'Scheepstypes zoeken';

  @override
  String get docShipCat0_19 => '0-19 · Gereserveerd';

  @override
  String get docShipCat20_29 => '20-29 · Grondzeiler (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Visserij';

  @override
  String get docShipCat40_49 => '40-49 · Snelvaartuigen';

  @override
  String get docShipCat50_59 => '50-59 · Speciaal vaartuig';

  @override
  String get docShipCat60_69 => '60-69 · Passagier';

  @override
  String get docShipCat70_79 => '70-79 · Vrachtschip';

  @override
  String get docShipCat80_89 => '80-89 · Tanker';

  @override
  String get docShipCat90_99 => '90-99 · Overig';

  @override
  String get docSearchGlossary => 'Woordenlijst zoeken';

  @override
  String get docNoMatchingTerms => 'Geen overeenkomende termen.';

  @override
  String get docAspect => 'Aspect';

  @override
  String get docClassA => 'Klasse A';

  @override
  String get docClassB => 'Klasse B';

  @override
  String get docCheatRadio => 'Radio';

  @override
  String get docCheatFrequencies => 'Frequenties';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulatie';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bits/s';

  @override
  String get docCheatRange => 'Bereik';

  @override
  String get docCheatRangeValue => '~10-20 NM schip tot schip, in zichtlijn';

  @override
  String get docCheatReportingRates => 'Rapportagefrequenties';

  @override
  String get docCheatClassAPos1 => 'Klasse A-positie (1)';

  @override
  String get docCheatClassAPos1Value =>
      'Elke 2-10 s onderweg, 3 min voor anker';

  @override
  String get docCheatStatic5 => 'Statisch (5)';

  @override
  String get docCheatStatic5Value => 'Elke 6 min';

  @override
  String get docCheatClassBPos18 => 'Klasse B-positie (18)';

  @override
  String get docCheatClassBPos18Value => '~Elke 30 s';

  @override
  String get docCheatAtoN21 => 'Navigatiehulpmiddel (21)';

  @override
  String get docCheatAtoN21Value => 'Elke 3 min';

  @override
  String get docCheatNavStatus0_15 => 'Navigatiestatus (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'Onderweg met motor';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'Voor anker';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Beperkte manoeuvreerbaarheid';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Afgemeerd';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'Aan de grond';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Visserij';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'Onderweg zeilend';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART actief';

  @override
  String get docCheatMmsiFormats => 'MMSI-indelingen';

  @override
  String get docCheatFixTypes => 'Positiebepalingsmethoden (EPFD)';

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
  String get docCheatEpfd15Value => 'Interne GNSS';

  @override
  String get docCheatFooter =>
      'KikAis levert op elk tabblad een volledige interactieve referentie — de Editor kan elk bericht opbouwen, de Decoder leest ze terug.';

  @override
  String get docMmsiFmtDiversRadio => 'Duikersradio';

  @override
  String get docMmsiFmtShip => 'Schip';

  @override
  String get docMmsiFmtGroupShips =>
      'Groep van schepen (bijv. een vloot of de USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Kust-/walstation';

  @override
  String get docMmsiFmtSarAircraft => 'SAR-vliegtuig';

  @override
  String get docMmsiFmtAuxCraft => 'Hulpvaartuig gekoppeld aan een moederschip';

  @override
  String get docMmsiFmtAtoN => 'Navigatiehulpmiddel';

  @override
  String get docMmsiFmtSart => 'AIS-SART (search- & rescue-zender)';

  @override
  String get docMmsiFmtMob => 'MOB-apparaat (man-overboord)';

  @override
  String get docMmsiFmtEpirb => 'AIS-EPIRB (noodbaken)';

  @override
  String get docVesselCat0_9 => 'Gereserveerd / toekomstig gebruik';

  @override
  String get docVesselCat10_19 => 'Gereserveerd voor toekomstig gebruik';

  @override
  String get docVesselCat20_29 => 'Grondzeiler (WIG)-vaartuig';

  @override
  String get docVesselCat30_39 => 'Visserij';

  @override
  String get docVesselCat40_49 => 'Snelvaartuigen';

  @override
  String get docVesselCat50_59 =>
      'Speciale vaartuigen (loodsboot, sleepboten, baggerschepen…)';

  @override
  String get docVesselCat60_69 => 'Passagiersschepen';

  @override
  String get docVesselCat70_79 => 'Vrachtschepen';

  @override
  String get docVesselCat80_89 => 'Tankers';

  @override
  String get docVesselCat90_99 => 'Andere types';

  @override
  String get docTalkerAB => 'AIS-basisstation';

  @override
  String get docTalkerAD => 'Afhankelijk AIS-basisstation';

  @override
  String get docTalkerAI => 'Mobiel AIS-station';

  @override
  String get docTalkerAN => 'AIS-station voor navigatiehulpmiddelen';

  @override
  String get docTalkerAR => 'AIS-ontvangststation';

  @override
  String get docTalkerAS => 'Beperkt basisstation';

  @override
  String get docTalkerAT => 'AIS-zendstation';

  @override
  String get docTalkerAX => 'AIS-repeaterstation';

  @override
  String get docTalkerBS => 'AIS-basisstation (verouderd)';

  @override
  String get docTalkerSA => 'Fysiek AIS-kuststation';

  @override
  String get docType1Name => 'Positierapport klasse A';

  @override
  String get docType1Family => 'Positierapporten';

  @override
  String get docType1Summary =>
      'De werkpaard van het systeem: een klasse A-transponder die zijn positie, koers, snelheid, kop en navigatiestatus uitzendt.';

  @override
  String get docType1EmittedBy => 'Klasse A-transponders (SOLAS-vaartuigen)';

  @override
  String get docType1Cadence => 'Elke 2-10 s onderweg, elke 3 min voor anker';

  @override
  String get docType2Name => 'Positierapport klasse A (toegewezen)';

  @override
  String get docType2Family => 'Positierapporten';

  @override
  String get docType2Summary =>
      'Identiek aan type 1, maar verzonden volgens een tijdsleufplan dat een basisstation aan het vaartuig heeft toegewezen (toewijzingsmodus).';

  @override
  String get docType2EmittedBy => 'Klasse A-transponders in toewijzingsmodus';

  @override
  String get docType2Cadence => 'Toegewezen schema';

  @override
  String get docType3Name => 'Positierapport klasse A (respons)';

  @override
  String get docType3Family => 'Positierapporten';

  @override
  String get docType3Summary =>
      'Identiek aan type 1, verzonden als antwoord op een interrogatie (type 15).';

  @override
  String get docType3EmittedBy =>
      'Klasse A-transponders die een interrogatie beantwoorden';

  @override
  String get docType3Cadence => 'Bij interrogatie';

  @override
  String get docType4Name => 'Rapport basisstation';

  @override
  String get docType4Family => 'Basisstation & netwerk';

  @override
  String get docType4Summary =>
      'Het periodieke rapport van een vast walstation: zijn positie plus de UTC-datum- en tijdsreferentie.';

  @override
  String get docType4EmittedBy => 'Vaste basisstations';

  @override
  String get docType4Cadence => 'Elke 10 s';

  @override
  String get docType5Name => 'Statische en reisgerelateerde gegevens';

  @override
  String get docType5Family => 'Statische & reisgegevens';

  @override
  String get docType5Summary =>
      'De \"identiteitskaart\" van een schip: naam, roepnaam, IMO-nummer, scheepstype, afmetingen, diepgang, ETA en bestemming.';

  @override
  String get docType5EmittedBy => 'Klasse A-transponders';

  @override
  String get docType5Cadence => 'Elke 6 min en bij wijziging van gegevens';

  @override
  String get docType6Name => 'Binair geadresseerd bericht';

  @override
  String get docType6Family => 'Binaire gegevens';

  @override
  String get docType6Summary =>
      'Een gestructureerde binaire payload verzonden naar één specifieke bestemmings-MMSI (bijv. een aangevraagd weerbericht).';

  @override
  String get docType6EmittedBy => 'Elk station';

  @override
  String get docType6Cadence => 'Op aanvraag';

  @override
  String get docType7Name => 'Binaire bevestiging';

  @override
  String get docType7Family => 'Binaire gegevens';

  @override
  String get docType7Summary =>
      'De bevestiging die als antwoord op een binair geadresseerd bericht van type 6 wordt verzonden.';

  @override
  String get docType7EmittedBy => 'Elk station dat een type 6 heeft ontvangen';

  @override
  String get docType7Cadence => 'Bij antwoord';

  @override
  String get docType8Name => 'Binair broadcastbericht';

  @override
  String get docType8Family => 'Binaire gegevens';

  @override
  String get docType8Summary =>
      'Een gestructureerde binaire payload die naar iedereen wordt uitgezonden — weer- en hydrografische rapporten, regionale gegevens, of privé-/versleutelde berichten.';

  @override
  String get docType8EmittedBy => 'Elk station';

  @override
  String get docType8Cadence => 'Op aanvraag';

  @override
  String get docType9Name => 'Standaard SAR-vliegtuigpositierapport';

  @override
  String get docType9Family => 'Positierapporten';

  @override
  String get docType9Summary =>
      'Een positierapport dat zoek- en reddingsvliegtuigen gebruiken om zichtbaar te zijn voor schepen. Bevat hoogte en een speciaal MMSI-bereik (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'SAR-vliegtuigen';

  @override
  String get docType9Cadence => 'Elke 10 s ter plaatse';

  @override
  String get docType10Name => 'UTC- en datumverzoek';

  @override
  String get docType10Family => 'Basisstation & netwerk';

  @override
  String get docType10Summary =>
      'Een klein verzoek dat een specifiek station vraagt om zijn UTC-datum en -tijd.';

  @override
  String get docType10EmittedBy => 'Elk station';

  @override
  String get docType10Cadence => 'Op aanvraag';

  @override
  String get docType11Name => 'UTC- en datumrespons';

  @override
  String get docType11Family => 'Basisstation & netwerk';

  @override
  String get docType11Summary =>
      'Identiek qua structuur aan type 4, verzonden als antwoord op een UTC/datum-verzoek van type 10.';

  @override
  String get docType11EmittedBy => 'Basisstations';

  @override
  String get docType11Cadence => 'Bij verzoek';

  @override
  String get docType12Name => 'Geadresseerd veiligheidsbericht';

  @override
  String get docType12Family => 'Veiligheid & tekst';

  @override
  String get docType12Summary =>
      'Een vrij-tekst-veiligheidsbericht verzonden naar één bestemmings-MMSI (bijv. een noodbericht aan het dichtstbijzijnde basisstation).';

  @override
  String get docType12EmittedBy => 'Elk station';

  @override
  String get docType12Cadence => 'Op aanvraag';

  @override
  String get docType13Name => 'Veiligheidsbevestiging';

  @override
  String get docType13Family => 'Veiligheid & tekst';

  @override
  String get docType13Summary =>
      'De bevestiging die als antwoord op een geadresseerd veiligheidsbericht van type 12 wordt verzonden.';

  @override
  String get docType13EmittedBy =>
      'Elk station dat een type 12 heeft ontvangen';

  @override
  String get docType13Cadence => 'Bij antwoord';

  @override
  String get docType14Name => 'Veiligheidsbroadcastbericht';

  @override
  String get docType14Family => 'Veiligheid & tekst';

  @override
  String get docType14Summary =>
      'Een vrij-tekst-broadcast gericht aan iedereen binnen bereik — navigatiewaarschuwingen, nood- of verkeersmeldingen.';

  @override
  String get docType14EmittedBy => 'Elk station (vaak basisstations / VTS)';

  @override
  String get docType14Cadence => 'Op aanvraag';

  @override
  String get docType15Name => 'Interrogatie';

  @override
  String get docType15Family => 'Basisstation & netwerk';

  @override
  String get docType15Summary =>
      'Een verzoek dat één of twee specifieke stations vraagt om een bepaald berichttype te verzenden (meestal type 3 of 5).';

  @override
  String get docType15EmittedBy => 'Basisstations';

  @override
  String get docType15Cadence => 'Op aanvraag';

  @override
  String get docType16Name => 'Opdracht toewijzingsmodus';

  @override
  String get docType16Family => 'Basisstation & netwerk';

  @override
  String get docType16Summary =>
      'Instrueert maximaal twee vaartuigen om te zenden volgens een specifieke tijdsleufallocatie (toewijzingsmodus).';

  @override
  String get docType16EmittedBy => 'Basisstations';

  @override
  String get docType16Cadence => 'Op aanvraag';

  @override
  String get docType17Name => 'DGNSS-binair broadcastbericht';

  @override
  String get docType17Family => 'Binaire gegevens';

  @override
  String get docType17Summary =>
      'Differentiële GNSS-correctiegegevens die door walstations worden uitgezonden om de positioneringsnauwkeurigheid in het dekkingsgebied te verbeteren.';

  @override
  String get docType17EmittedBy => 'DGNSS-referentiestations';

  @override
  String get docType17Cadence => 'Periodiek';

  @override
  String get docType18Name => 'Standaard klasse B CS-positierapport';

  @override
  String get docType18Family => 'Positierapporten';

  @override
  String get docType18Summary =>
      'Het standaard klasse B-positierapport. Lichter dan klasse A: geen navigatiestatus of draaisnelheid, maar werkt met CSTDMA.';

  @override
  String get docType18EmittedBy => 'Klasse B-transponders';

  @override
  String get docType18Cadence => 'Elke 30 s (of minder in sommige regio\'s)';

  @override
  String get docType19Name => 'Uitgebreid klasse B-apparatuurpositierapport';

  @override
  String get docType19Family => 'Positierapporten';

  @override
  String get docType19Summary =>
      'Een groter klasse B-positierapport dat ook de scheepsnaam, het scheepstype en de afmetingen bevat — een hybride van eenmalige statische gegevens en positie.';

  @override
  String get docType19EmittedBy => 'Uitgebreide klasse B-transponders';

  @override
  String get docType19Cadence => 'Elke 30 s';

  @override
  String get docType20Name => 'Datalinkbeheer';

  @override
  String get docType20Family => 'Basisstation & netwerk';

  @override
  String get docType20Summary =>
      'Een netwerkonderhoudsbericht waarmee TDMA-tijdsleuven in een gebied worden toegewezen en gereserveerd.';

  @override
  String get docType20EmittedBy => 'Basisstations';

  @override
  String get docType20Cadence => 'Netwerkbeheer';

  @override
  String get docType21Name => 'Rapport navigatiehulpmiddel';

  @override
  String get docType21Family => 'Navigatiehulpmiddelen';

  @override
  String get docType21Summary =>
      'Zendt de positie, naam en status van een navigatiehulpmiddel uit — boeien, bakens, vuurtorens of virtuele hulpmiddelen. Vaak verzonden vanuit een virtuele positie.';

  @override
  String get docType21EmittedBy => 'AtoN-stations (echt of virtueel)';

  @override
  String get docType21Cadence => 'Elke 3 min (of bij gebeurtenis)';

  @override
  String get docType22Name => 'Kanaalbeheer';

  @override
  String get docType22Family => 'Basisstation & netwerk';

  @override
  String get docType22Summary =>
      'Door een basisstation gebruikt om stations binnen een geografische zone naar andere VHF-kanalen te schakelen.';

  @override
  String get docType22EmittedBy => 'Basisstations';

  @override
  String get docType22Cadence => 'Op aanvraag';

  @override
  String get docType23Name => 'Opdracht groepstoewijzing';

  @override
  String get docType23Family => 'Basisstation & netwerk';

  @override
  String get docType23Summary =>
      'Een opdracht die een basisstation naar een groep vaartuigen binnen een zone stuurt, waarmee rapportage-intervallen en transmissiemodus worden ingesteld.';

  @override
  String get docType23EmittedBy => 'Basisstations';

  @override
  String get docType23Cadence => 'Op aanvraag';

  @override
  String get docType24Name => 'Statisch gegevensrapport';

  @override
  String get docType24Family => 'Statische & reisgegevens';

  @override
  String get docType24Summary =>
      'Het klasse B-equivalent van type 5, opgesplitst in deel A (naam) en deel B (scheepstype, roepnaam, afmetingen).';

  @override
  String get docType24EmittedBy => 'Klasse B-transponders';

  @override
  String get docType24Cadence => 'Elke 6 min';

  @override
  String get docType25Name => 'Binair bericht met enkele tijdsleuf';

  @override
  String get docType25Family => 'Binaire gegevens';

  @override
  String get docType25Summary =>
      'Een kort binair bericht dat in een enkele TDMA-tijdsleuf past, met een optionele bestemming en toepassings-id.';

  @override
  String get docType25EmittedBy => 'Elk station';

  @override
  String get docType25Cadence => 'Op aanvraag';

  @override
  String get docType26Name => 'Binair bericht met meerdere tijdsleuven';

  @override
  String get docType26Family => 'Binaire gegevens';

  @override
  String get docType26Summary =>
      'Een langer binair bericht verspreid over meerdere TDMA-tijdsleuven, met radiostatusinformatie.';

  @override
  String get docType26EmittedBy => 'Elk station';

  @override
  String get docType26Cadence => 'Op aanvraag';

  @override
  String get docType27Name => 'Positierapport voor langeafstandstoepassingen';

  @override
  String get docType27Family => 'Positierapporten';

  @override
  String get docType27Summary =>
      'Een zeer compact positierapport ontworpen voor ontvangst via satelliet over lange afstanden, met een lagere resolutie.';

  @override
  String get docType27EmittedBy =>
      'Vaartuigen in langeafstandsmodus (satelliet)';

  @override
  String get docType27Cadence => 'Elke 3 min (langeafstandsmodus)';

  @override
  String get docTimeline1990sTitle => 'Een Zweedse uitvinding';

  @override
  String get docTimeline1990sText =>
      'Het concept ontstaat in Zweden: een VHF-systeem waarin elk schip zichzelf kenbaar maakt zodat anderen \"zien en gezien worden\", zelfs in mist en achter eilanden. Het wordt aan de IMO gepresenteerd en wordt de basis van AIS.';

  @override
  String get docTimeline1998Title => 'Standaardisatie begint';

  @override
  String get docTimeline1998Text =>
      'De ITU en IEC beginnen het concept om te zetten in een radiostandaard met precieze bitniveau-indelingen, gebaseerd op TDMA over twee VHF-kanalen.';

  @override
  String get docTimeline2001Title => 'ITU-R M.1371 gepubliceerd';

  @override
  String get docTimeline2001Text =>
      'Aanbeveling ITU-R M.1371 \"Technische kenmerken voor een universeel scheepsgebonden automatisch identificatiesysteem\" definieert de 27 berichttypen en hun bitindeling.';

  @override
  String get docTimeline2002Title => 'SOLAS-verplichting';

  @override
  String get docTimeline2002Text =>
      'De IMO maakt AIS verplicht voor alle internationale vaartuigen van meer dan 300 bruto ton en alle passagiersschepen — ruwweg 100.000 vaartuigen. AIS wordt naast radar een standaard anti-aanvaringshulpmiddel.';

  @override
  String get docTimeline2006Title => 'Klasse B arriveert';

  @override
  String get docTimeline2006Text =>
      'De klasse B-standaard wordt gepubliceerd, waardoor de deur opengaat voor goedkope, eenvoudigere transponders. Hetzelfde jaar wordt de TacSat-2-satelliet de eerste die AIS-signalen vanuit de ruimte vastlegt (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Satellietconstellaties';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire en anderen plaatsen AIS-ontvangers in een lage baan om de aarde, waardoor het dekkingsgebied ver voorbij de VHF-horizon reikt en wereldwijde vaartuigvolging mogelijk wordt.';

  @override
  String get docTimeline2010Title => 'AIS-SART in GMDSS';

  @override
  String get docTimeline2010Text =>
      'De AIS zoek- en reddingszender (AIS-SART, IEC 61097-14) treedt toe tot het Global Maritime Distress and Safety System, waardoor reddingsboten noodposities via AIS kunnen uitzenden.';

  @override
  String get docTimeline2014Title => 'Visserij & binnenvaartvloten';

  @override
  String get docTimeline2014Text =>
      'Europese regels vereisen klasse A-AIS op alle EU-vissersvaartuigen van meer dan 15 m; binnenvaart-AIS wordt op grote schaal op Europese rivieren ingezet.';

  @override
  String get docTimeline2021Title => '1,6 miljoen schepen';

  @override
  String get docTimeline2021Text =>
      'Meer dan 1,6 miljoen vaartuigen zijn uitgerust met AIS en voeden terrestrische en satellietnetwerken die scheepsvolging, visserijcontrole en maritieme beveiliging wereldwijd mogelijk maken.';

  @override
  String get docTimelineVdesTitle => 'VDES — de opvolger';

  @override
  String get docTimelineVdesText =>
      'Het VHF Data Exchange System (ITU-R M.2092) wordt uitgerold om drukke gebieden te ontlasten, met veel meer bandbreedte en beveiligde e-navigatiediensten.';

  @override
  String get docAppTitle => 'Documentatie';

  @override
  String get docSearchChapters => 'Hoofdstukken zoeken';

  @override
  String get docChapterOverview => 'Overzicht';

  @override
  String get docChapterHistory => 'Geschiedenis & regelgeving';

  @override
  String get docChapterHowItWorks => 'Hoe het werkt';

  @override
  String get docChapterRadio => 'Radio & TDMA';

  @override
  String get docChapterClasses => 'Klassen & apparatuur';

  @override
  String get docChapterMmsi => 'MMSI & identiteit';

  @override
  String get docChapterShipTypes => 'Scheepstypes';

  @override
  String get docChapterMessages => 'De 27 berichten';

  @override
  String get docChapterNmea => 'NMEA & AIVDM';

  @override
  String get docChapterPayload => 'In de payload';

  @override
  String get docChapterSecurity => 'Beveiliging & beperkingen';

  @override
  String get docChapterFieldNotes => 'Veldnotities';

  @override
  String get docChapterKikais => 'AIS in KikAis';

  @override
  String get docChapterGlossary => 'Woordenlijst';

  @override
  String get docChapterCheatSheet => 'Spiekbriefje';

  @override
  String get docChapterSources => 'Bronnen';

  @override
  String get docOverviewTitle => 'Wat is AIS?';

  @override
  String get docOverviewIntro =>
      'Het Automatic Identification System (AIS) is een volgsysteem dat op schepen en door verkeersbegeleidingsdiensten voor de scheepvaart (VTS) wordt gebruikt. Elk uitgerust vaartuig zendt continu zijn identiteit, positie, koers en snelheid uit via VHF-radio, zodat elk ander schip en walstation binnen bereik het kan \"zien\" — het concept van \"zien en gezien worden\".';

  @override
  String get docOverviewRadar =>
      'AIS vervangt geen maritieme radar. Radar detecteert onafhankelijk elk object, maar zegt weinig over wie het is. AIS vertelt je precies wie, waar en waarheen ze gaan — maar vertrouwt erop wat de zender verklaart. De twee systemen vullen elkaar aan.';

  @override
  String get docOverviewAdsBTitle => 'Zie het als de maritieme ADS-B';

  @override
  String get docOverviewAdsBText =>
      'Net zoals ADS-B vliegtuigen in staat stelt zich aan te melden bij de luchtverkeersleiding, stelt AIS schepen in staat zich aan elkaar en aan de wal bekend te maken. Schepen bekijken het omliggende verkeer op een chartplotter of op een display dat op radar lijkt; havenautoriteiten houden bewegingen en visserij in de gaten.';

  @override
  String get docOverviewTransponder => 'Wat een transponder uitzendt';

  @override
  String get docOverviewBullet1 =>
      'Unieke identiteit: een 9-cijferig MMSI-nummer (waarvan de eerste drie cijfers het uitgevende land identificeren).';

  @override
  String get docOverviewBullet2 =>
      'Dynamische gegevens: positie, snelheid over de grond (SOG), koers over de grond (COG), ware kop, draaisnelheid, navigatiestatus.';

  @override
  String get docOverviewBullet3 =>
      'Statische & reisgegevens: naam, roepnaam, IMO-nummer, scheepstype, afmetingen, diepgang, bestemming, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Veiligheids- en binaire berichten: noodteksten, weerberichten, netwerkopdrachten.';

  @override
  String get docOverviewWho => 'Wie het moet voeren';

  @override
  String get docOverviewImo =>
      'De IMO (SOLAS-verdrag) verplicht AIS op internationale vaartuigen van meer dan 300 bruto ton en op alle passagiersschepen. Regionale regels breiden dit uit naar vissersvloten, binnenwateren en steeds vaker naar recreatievaartuigen via goedkope klasse B-transponders.';

  @override
  String get docOverviewLimits => 'Beperkingen in één oogopslag';

  @override
  String get docOverviewLimit1 =>
      'Het bereik is ruwweg de zichtlijn: ongeveer 10-20 zeemijl voor schip-tot-schip, meer vanaf kuststations en satellieten.';

  @override
  String get docOverviewLimit2 =>
      'AIS heeft geen authenticatie: iedereen kan elke identiteit uitzenden (spoofing) of het kanaal verstoren.';

  @override
  String get docOverviewLimit3 =>
      'De nauwkeurigheid hangt af van de GNSS-positiebepaling van de zender en van de betrouwbaarheid van de gegevens die hij verklaart.';

  @override
  String get docHistoryIntro =>
      'AIS groeide uit van een Zweeds idee tot een wereldwijd verplicht veiligheidssysteem. Tik op elk mijlpaal in de tijdlijn voor details.';

  @override
  String get docHistoryStandards => 'De geldende standaarden';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — Technische kenmerken voor een universeel scheepsgebonden AIS (definieert de 27 berichttypen en hun bitindeling).';

  @override
  String get docHistoryStd2 =>
      'IALA-richtlijnen — verduidelijkingen en implementatiebegeleiding.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — de NMEA-zinopbouw en de klasse B/CSTDMA-vereisten.';

  @override
  String get docHistoryStd4 => 'IEC 61097-14 — de AIS-SART-noodzender.';

  @override
  String get docHowIntro =>
      'AIS is een VHF-radiosysteem. Elke transponder luistert naar het verkeer om hem heen en zendt zijn eigen rapporten uit in gereserveerde tijdsleuven, waardoor botsingen met de andere schepen binnen bereik worden vermeden.';

  @override
  String get docHowRadioLink => 'De radiolink';

  @override
  String get docHowRadioLink1 =>
      'Twee toegewijde VHF-kanalen: AIS 1 op 161.975 MHz (87B) en AIS 2 op 162.025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'Digitale smalband-FM, met 9 600 bits per seconde.';

  @override
  String get docHowRadioLink3 =>
      'Berichten worden georganiseerd in TDMA-frames van 2250 tijdsleuven (1 minuut).';

  @override
  String get docHowSlots => 'Hoe tijdsleuven worden gedeeld';

  @override
  String get docHowSotdma =>
      'Klasse A-transponders gebruiken SOTDMA (Self-Organizing Time Division Multiple Access): elke eenheid reserveert een herhalende tijdsleuf en reserveert opnieuw wanneer het beeld verandert, zodat schepen continu coördineren zonder centrale controller.';

  @override
  String get docHowCstdma =>
      'Klasse B-transponders gebruiken het eenvoudigere CSTDMA (Carrier Sense TDMA): ze luisteren naar een vrije tijdsleuf en grijpen die, wat de reden is dat klasse B-rapporten minder frequent zijn en verloren kunnen gaan in zeer druk verkeer.';

  @override
  String get docHowRates => 'Rapportagefrequenties';

  @override
  String get docHowRates1 =>
      'Klasse A-positierapport (type 1): elke 2-10 seconden onderweg, elke 3 minuten voor anker.';

  @override
  String get docHowRates2 =>
      'Statische & reisgegevens (type 5): elke 6 minuten.';

  @override
  String get docHowRates3 =>
      'Klasse B-positie (type 18): ruwweg elke 30 seconden.';

  @override
  String get docHowRates4 => 'Navigatiehulpmiddel (type 21): elke 3 minuten.';

  @override
  String get docHowTerrestrial => 'Terrestrisch en satelliet';

  @override
  String get docHowTerrestrialText =>
      'Aan de oppervlakte wordt het AIS-bereik beperkt door de VHF-horizon (T-AIS). Sinds het midden van de jaren 2000 ontvangen satellieten in een lage baan om de aarde (S-AIS) dezelfde signalen, wat bijna wereldwijde dekking geeft — satellieten versterken het terrestrische netwerk eerder dan dat ze het vervangen.';

  @override
  String get docRadioIntro =>
      'Onder de berichten schuilt een klein, efficiënt radiosysteem. AIS zendt met 9 600 bits per seconde op twee VHF-kanalen, met behulp van Gaussian minimum-shift keying (GMSK) en HDLC-stijl framing.';

  @override
  String get docRadioPhysical => 'De fysieke link';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 op 161.975 MHz en AIS 2 op 162.025 MHz (VHF-kanalen 87B en 88B).';

  @override
  String get docRadioPhysical2 =>
      'GMSK-modulatie met 9 600 baud — smal genoeg om in de maritieme VHF-band te passen.';

  @override
  String get docRadioPhysical3 =>
      'HDLC-framing met bit stuffing en NRZI-lijncodering, overgeërfd uit de pakketradiowereld.';

  @override
  String get docRadioFrames => 'TDMA-frames en tijdsleuven';

  @override
  String get docRadioFrames1 =>
      'Elk kanaal wordt opgesplitst in frames van exact 1 minuut, verdeeld over 2 250 tijdsleuven van ~26.7 ms elk.';

  @override
  String get docRadioFrames2 =>
      'Een tijdsleuf draagt één AIS-bericht (256 bits met op-/afbouw en guard time).';

  @override
  String get docRadioFrames3 =>
      'Stations hergebruiken elke frame dezelfde tijdsleuven, zodat ze periodiek uitzenden zonder te botsen.';

  @override
  String get docRadioCode =>
      '2250 slots/frame · 1 frame = 60 s · slot ≈ 26.7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — hoe klasse A zichzelf organiseert';

  @override
  String get docRadioSotdmaText =>
      'Elke klasse A-transponder luistert naar de tijdsleuven om zich heen, kiest een vrije en kondigt in zijn radiostatusveld aan wanneer hij de volgende keer zal zenden. Stations blijven opnieuw reserveren naarmate het verkeersbeeld verandert, dus er is geen centrale coördinator nodig.';

  @override
  String get docRadioCstdma => 'CSTDMA — hoe klasse B meedoet';

  @override
  String get docRadioCstdmaText =>
      'Klasse B-eenheden zijn eenvoudiger: ze luisteren naar een tijdsleuf die momenteel vrij is en zenden er eenmaal in. Dit is goedkoper, maar klasse B-rapporten kunnen verloren gaan in zeer druk verkeer waar een tijdsleuf altijd bezet is.';

  @override
  String get docRadioVdes => 'VDES — de toekomst';

  @override
  String get docRadioVdesText =>
      'Het VHF Data Exchange System (ITU-R M.2092) wordt uitgerold om drukke wateren te ontlasten: het voegt nieuwe frequenties, veel meer bandbreedte en beveiligde tweerichtingsgegevens toe voor e-navigatie, naast de bestaande AIS-dienst.';

  @override
  String get docClassesIntro =>
      'AIS-hardware is er in verschillende klassen en rollen. De twee die je het vaakst zult tegenkomen zijn de volwaardige klasse A-transponder en de goedkope klasse B-eenheid.';

  @override
  String get docClassesComparison => 'Klasse A versus klasse B';

  @override
  String get docClassesReceivers => 'Ontvangers en transponders';

  @override
  String get docClassesReceiversText =>
      'Transponders zenden en ontvangen beide. Veel walstations en hobbyisten draaien alleen ontvangers, zodat ze verkeer kunnen bekijken zonder erop te verschijnen.';

  @override
  String get docClassesAton => 'Navigatiehulpmiddelen';

  @override
  String get docClassesAtonText =>
      'AtoN-stations (type 21) zenden boeien, bakens en vuurtorens uit. Ze kunnen ook een virtueel hulpmiddel uitzenden — een marker die alleen op kaarten bestaat, handig om te waarschuwen voor een nieuw gevaar.';

  @override
  String get docClassesDistress => 'Nood- en veiligheidsapparaten';

  @override
  String get docClassesDistressIntro =>
      'Naast gewone schepen draagt AIS noodzenders die elke ontvanger zou moeten kunnen opsporen:';

  @override
  String get docClassesSartNote =>
      'Een SART in actie zet ook navigatiestatus 14 (\"AIS-SART actief\") in zijn positierapport.';

  @override
  String get docShipTypesIntro =>
      'Type 5- en 24-statische berichten bevatten een 8-bits scheepstypecode (0-99) die beschrijft wat het vaartuig is — vrachtschip, tanker, vissersboot, pleziervaartuig enzovoort. De volledige tabel staat hieronder.';

  @override
  String get docShipTypesCategories => 'Categorieën in één oogopslag';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle => 'Veldnotities & praktische eigenaardigheden';

  @override
  String get docFieldNotesIntro =>
      'Echt AIS-verkeer komt niet altijd overeen met de theorie. Deze eigenaardigheden kennen helpt je vertrouwen op wat de decoder je toont — en wat hij afwijst.';

  @override
  String get docGlossaryIntro =>
      'Een doorzoekbaar woordenboek van de afkortingen en termen die in deze gids en door de AIS-gemeenschap worden gebruikt.';

  @override
  String get docCheatSheetIntro =>
      'De essentiële getallen en codes in één oogopslag — frequenties, rapportagefrequenties, statuscodes en indelingen.';

  @override
  String get docMmsiIntro =>
      'De Maritime Mobile Service Identity (MMSI) is een uniek 9-cijferig nummer dat de radioapparatuur van een schip identificeert, als een telefoonnummer voor het vaartuig. De eerste drie cijfers zijn de MID — de Maritime Identification Digits die het land identificeren dat het heeft afgegeven.';

  @override
  String get docMmsiFormats => 'Nummerindelingen';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Een MMSI opzoeken';

  @override
  String get docMmsiLookupHint =>
      'Voer hieronder een 9-cijferige MMSI in om de klasse en het land van de afgevende autoriteit te zien.';

  @override
  String get docMmsiMidHeading => 'Landcodes (MID)';

  @override
  String get docMmsiMidText =>
      'De volledige MID-tabel is gebundeld met KikAis en wordt overal gebruikt waar een MMSI wordt weergegeven.';

  @override
  String get docMessagesTitle => 'De 27 berichttypen';

  @override
  String get docMessagesIntro =>
      'Elke AIS-payload begint met een 6-bits berichttype (1 tot 27). De catalogus hieronder groepeert ze per familie. Elke kaart toont een echte NMEA-zin die door KikAis\' eigen encoder is gegenereerd, de gedecodeerde velden en een knop om die in de Decoder te openen.';

  @override
  String get docNmeaTitle => 'NMEA & AIVDM-framing';

  @override
  String get docNmeaIntro =>
      'Op de kabel reizen AIS-berichten als NMEA 0183-zinnen die beginnen met !AIVDM (andere schepen) of !AIVDO (je eigen schip). De payload is een ASCII-gepantserde bitvector.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Zinvelden';

  @override
  String get docNmeaField1 =>
      'Talker & formatter — !AIVDM of !AIVDO (zie talker-id\'s hieronder).';

  @override
  String get docNmeaField2 =>
      'Fragmenttelling — uit hoeveel zinnen het volledige bericht bestaat (NMEA beperkt elke regel tot ~82 tekens).';

  @override
  String get docNmeaField3 =>
      'Fragmentnummer — welk deel dit is (1-gebaseerd).';

  @override
  String get docNmeaField4 =>
      'Sequentieel bericht-id — koppelt fragmenten van hetzelfde bericht aan elkaar.';

  @override
  String get docNmeaField5 => 'Radiokanaal — A of B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Gegevenspayload — de zes-bits gepantserde AIS-payload.';

  @override
  String get docNmeaField7 =>
      'Opvulbits — hoeveel opvulbits aan de laatste 6-bitsgroep zijn toegevoegd (0-5).';

  @override
  String get docNmeaField8 =>
      'Checksum — de XOR van alle bytes vóór de *, in hexadecimaal.';

  @override
  String get docNmeaMulti => 'Berichten met meerdere fragmenten';

  @override
  String get docNmeaMultiText =>
      'Berichten langer dan één regel (zoals type 5-statische gegevens) worden gesplitst: de eerste zin rapporteert een fragmenttelling van 2 en de tweede voltooit die met hetzelfde bericht-id.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Zes-bits pantsering';

  @override
  String get docNmeaArmoringText =>
      'Elk payloadteken bevat 6 bits. Trek 48 af van de ASCII-code en trek nog eens 8 af als het resultaat boven de 40 ligt.';

  @override
  String get docNmeaTalkers => 'Talker-id\'s';

  @override
  String get docNmeaTalkersIntro =>
      'Verschillende NMEA 4.0-talker-id\'s identificeren het type AIS-station:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Checksum';

  @override
  String get docNmeaChecksumText =>
      'De checksum aan het eind is de XOR van elke byte tussen de \"!\" en de \"*\". Bereken hieronder je eigen:';

  @override
  String get docNmeaInspectorTitle => 'Probeer het: zininspecteur';

  @override
  String get docNmeaInspectorText =>
      'Plak een willekeurige AIVDM/AIVDO-zin (of gebruik een voorbeeld hierboven) om de velden opgesplitst en de gedecodeerde waarden te zien.';

  @override
  String get docPayloadIntro =>
      'Zodra de zes-bits pantsering ongedaan is gemaakt, is een AIS-payload een reeks bitvelden. De eerste zes bits zijn het berichttype; de volgende twee zijn de herhalingsindicator; daarna komen 30 bits MMSI.';

  @override
  String get docPayloadCnb => 'Het Common Navigation Block (typen 1-3)';

  @override
  String get docPayloadCnbText =>
      'De belangrijkste indeling wordt gedeeld door de klasse A-positierapporten. Gebruik de selector om de belangrijkste berichtindelingen te bekijken en klik op een segment om te lezen wat het codeert.';

  @override
  String get docPayloadCoords => 'Coördinaten';

  @override
  String get docPayloadCoordsText =>
      'Breedte- en lengtegraad worden opgeslagen in 1/10 000 van een minuut. Deel door 600 000 om graden te krijgen: 60 minuten per graad en 10 000 eenheden per minuut. Oost/noord zijn positief.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert =>
      'Converteer hieronder je eigen coördinaten:';

  @override
  String get docPayloadSpeed => 'Snelheid, koers, kop';

  @override
  String get docPayloadSpeed1 =>
      'SOG — snelheid over de grond in tienden van een knoop (0-102.2 kn); 1023 betekent \"niet beschikbaar\".';

  @override
  String get docPayloadSpeed2 =>
      'COG — koers over de grond in tienden van een graad, ten opzichte van het ware noorden.';

  @override
  String get docPayloadSpeed3 =>
      'Kop — ware kop in hele graden; 511 betekent \"niet beschikbaar\".';

  @override
  String get docPayloadSpeed4 =>
      'ROT — draaisnelheid: waarde ≈ 4.733 × √(draaisnelheid in °/min), ondertekend (positief = rechts).';

  @override
  String get docPayloadNavStatus => 'Navigatiestatus';

  @override
  String get docPayloadEpfd => 'Positiebepalingsmethode (EPFD)';

  @override
  String get docPayloadText => 'Zes-bits tekst';

  @override
  String get docPayloadTextIntro =>
      'Namen, roepnamen en bestemmingen gebruiken hetzelfde zes-bits alfabet als de payload zelf. Kleine letters kunnen niet worden gecodeerd, daarom zijn AIS-namen meestal in hoofdletters.';

  @override
  String get docSecurityTitle => 'Beveiliging & gegevenskwaliteit';

  @override
  String get docSecurityIntro =>
      'AIS is ontworpen voor samenwerking, niet voor beveiliging. Het radiokanaal is open en onversleuteld, en er is geen authenticatie van wie uitzendt.';

  @override
  String get docSecurityThreats => 'Bedreigingen';

  @override
  String get docSecurityThreat1 =>
      'Spoofing — het uitzenden van een nep-MMSI, -positie of -identiteit (spookschepen, sanctieontduiking).';

  @override
  String get docSecurityThreat2 =>
      'Jamming — het overspoelen van de twee VHF-kanalen zodat echt verkeer niet kan worden ontvangen.';

  @override
  String get docSecurityThreat3 =>
      'Meaconing — het opnieuw afspelen van echte signalen van elders om ontvangers in de war te brengen.';

  @override
  String get docSecurityQuality => 'Gegevenskwaliteit';

  @override
  String get docSecurityQuality1 =>
      'De positienauwkeurigheidsbit onderscheidt een niet-uitgebreide GNSS-positiebepaling (> 10 m) van een positiebepaling van DGPS-kwaliteit (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'Ontvangers zouden posities, snelheden en tijdstempels moeten controleren; ongeveer 0,3% van de berichten in de echte wereld heeft een verkeerde payloadlengte.';

  @override
  String get docSecurityQuality3 =>
      'Satelliet-AIS lijdt af en toe onder botsingen omdat de voetafdruk van de satelliet veel groter is dan een TDMA-cel — nog een reden om te correleren met radar en andere bronnen.';

  @override
  String get docKikaisIntro =>
      'KikAis is een volledig AIS-lab: ontvang live of gesimuleerd verkeer, decodeer het, bekijk en verzend je eigen berichten en bouw vloten. Hier is hoe elk tabblad zich verhoudt tot wat je zojuist hebt gelezen.';

  @override
  String get docTabReceptionText =>
      'Kies feeds (bestand, serieel, simulatie), start de doorstuurder en bekijk de ruwe NMEA-stroom en de gedecodeerde boten.';

  @override
  String get docTabSendText =>
      'Stuur de ontvangen zinnen door naar één of meer TCP/UDP-doelen — zoals een walstation verkeer zou distribueren.';

  @override
  String get docTabMapText =>
      'Zie gedecodeerde vaartuigen weergegeven op basis van hun type 1/2/3-, 18-, 19- en 27-positierapporten.';

  @override
  String get docTabEditorText =>
      'Bouw elk van de 27 berichttypen met de hand vanuit een gebruiksvriendelijk formulier en verzend het — de beste manier om de velden te leren.';

  @override
  String get docTabDecoderText =>
      'Plak een willekeurige zin en krijg de gedecodeerde velden, checksum en fragmentafhandeling — de praktische metgezel van deze gids.';

  @override
  String get docTabStatsText =>
      'Berichttellers, snelheden per feed en de gezondheid van de decoder (ongeldige checksums, verloren fragmenten).';

  @override
  String get docTabSimulationText =>
      'Genereer een hele vloot rond elke locatie — elk berichttype, MMSI-schema, zonevorm en zelfs foutinjectie.';

  @override
  String get docSourcesIntro =>
      'Deze gids synthetiseert openbaar beschikbare, gezaghebbende documentatie:';

  @override
  String get docSources1 =>
      'gpsd — AIVDM/AIVDO-protocoldecodering, door Eric S. Raymond (de facto technische bijbel voor het zinformat en de payload-bitvelden).';

  @override
  String get docSources2 =>
      'Wikipedia — Automatic Identification System (overzicht, geschiedenis, toepassingen, beveiliging).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — AIS-pagina\'s.';

  @override
  String get docSources4 =>
      'ITU-R Recommendation M.1371 — de geldende AIS-standaard.';

  @override
  String get docSources5 => 'IALA — verduidelijkingen van ITU-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA-framing, klasse B en AIS-SART.';

  @override
  String get docSourcesLearn => 'Hoe meer te leren';

  @override
  String get docSourcesLearnText =>
      'De beste manier om AIS te begrijpen is experimenteren: gebruik de Editor om berichten te bouwen, de Decoder om ze terug te lezen en het tabblad Simulatie om een hele vloot te bekijken. Alles in deze gids wordt gegenereerd door KikAis\' eigen encoder en decoder.';

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
    return 'Uitgezonden door: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Openen in Decoder';

  @override
  String get docInspectorNmeaLabel => 'NMEA-zin';

  @override
  String get docInspectorInspect => 'Inspecteren';

  @override
  String get docInspectorInvalidChecksum => 'Ongeldige checksum';

  @override
  String get docInspectorCouldNotDecode => 'Kan niet decoderen';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Gedecodeerd: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Type $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 cijfers)';

  @override
  String get docMmsiLookupButton => 'Opzoeken';

  @override
  String get docMmsiLookupError =>
      'Voer een 9-cijferige MMSI in (alleen cijfers).';

  @override
  String get docMmsiLookupClassGroup => 'Groep van schepen (groepsoproep)';

  @override
  String get docMmsiUnknownCountry => 'onbekend land';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Openen';

  @override
  String get updateCheckForUpdates => 'Controleren op updates';

  @override
  String get updateChecking => 'Controleren op updates…';

  @override
  String updateNewVersion(Object version) {
    return 'Nieuwe versie $version';
  }

  @override
  String get updateUpToDate => 'Je bent up-to-date.';

  @override
  String get updateCheckFailed => 'Updatecontrole mislukt.';
}
