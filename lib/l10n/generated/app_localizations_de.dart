// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get languageSystem => 'Auto (System)';

  @override
  String get languageEn => 'Englisch';

  @override
  String get languageFr => 'Französisch';

  @override
  String get languageEs => 'Spanisch';

  @override
  String get languageDe => 'Deutsch';

  @override
  String get languagePt => 'Portugiesisch';

  @override
  String get languageIt => 'Italienisch';

  @override
  String get languageNl => 'Niederländisch';

  @override
  String get languageZh => 'Chinesisch';

  @override
  String get languageJa => 'Japanisch';

  @override
  String get languageRu => 'Russisch';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeHighContrast => 'Hoher Kontrast';

  @override
  String get tabReception => 'Empfang';

  @override
  String get tabSend => 'Senden';

  @override
  String get tabMap => 'Karte';

  @override
  String get tabEditor => 'Editor';

  @override
  String get tabTools => 'Werkzeuge';

  @override
  String get tabStats => 'Statistik';

  @override
  String get tabSimulation => 'Simulation';

  @override
  String get tabDocs => 'Doku';

  @override
  String get protocolUdpServer => 'UDP-Server';

  @override
  String get protocolUdpClient => 'UDP-Client';

  @override
  String get protocolTcpClient => 'TCP-Client';

  @override
  String get protocolTcpServer => 'TCP-Server';

  @override
  String get formatPassthrough => 'Durchreichen';

  @override
  String get formatStrip => 'Tag-Blöcke entfernen';

  @override
  String get formatTag => 'Tag-Block hinzufügen';

  @override
  String get sendAddDestination => 'Ziel hinzufügen';

  @override
  String get sendEditDestination => 'Ziel bearbeiten';

  @override
  String get sendFormat => 'Sendeformat';

  @override
  String get sendSave => 'Speichern';

  @override
  String get sendLockedBanner => 'Der Forwarder läuft — Ziele sind gesperrt.';

  @override
  String get sendEmpty =>
      'Noch kein Ziel. Füge eines hinzu, um empfangene AIS-Frames weiterzuleiten.';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldProtocol => 'Protokoll';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldTagSourceId => 'Tag-Quellen-ID';

  @override
  String get fieldFile => 'Datei';

  @override
  String get fieldCancel => 'Abbrechen';

  @override
  String get fieldAdd => 'Hinzufügen';

  @override
  String get receptionFeeds => 'Feeds';

  @override
  String get receptionValidateChecksums => 'NMEA-Prüfsummen validieren';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sätze verworfen',
      one: '1 Satz verworfen',
      zero: 'Kein Satz verworfen',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Format für importierte Frames';

  @override
  String get receptionStart => 'Start';

  @override
  String get receptionStop => 'Stopp';

  @override
  String get receptionLogs => 'Protokolle';

  @override
  String get receptionFrameCopied => 'Frame kopiert';

  @override
  String get receptionAddSource => 'Quelle hinzufügen';

  @override
  String get receptionNetwork => 'Netzwerk';

  @override
  String get receptionFile => 'Datei';

  @override
  String get receptionSerial => 'Seriell';

  @override
  String get receptionHeaderOptional => 'Header (optional)';

  @override
  String get receptionPathOrBrowse => 'Pfad oder Durchsuchen…';

  @override
  String get receptionIntervalMs => 'Intervall zwischen Frames (ms)';

  @override
  String get receptionReplayTimestamps => 'Wiedergabe mit Dateizeitstempeln';

  @override
  String get receptionReplayTimestampsHint =>
      'Verwendet die aufgezeichneten Zeiten (Tag-Block t: oder Zeitstempel-Präfix) anstelle eines festen Intervalls';

  @override
  String get receptionSpeed => 'Geschwindigkeit';

  @override
  String get receptionReplayLoop => 'Schleife (von Anfang an abspielen)';

  @override
  String get receptionSerialPort => 'Serielle Schnittstelle';

  @override
  String get receptionSerialPortHint => 'z. B. COM3 oder /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Baudrate';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'RTL-SDR-Gerät';

  @override
  String get tooltipReceptionRtlSdrDevices =>
      'Liste der RTL-SDR-Dongles aktualisieren';

  @override
  String get receptionRtlSdrNoDevice =>
      'Kein RTL-SDR-Gerät gefunden. Installieren Sie die RTL-SDR-Treiber (Zadig / WinUSB unter Windows) und schließen Sie den Dongle an.';

  @override
  String get receptionRtlSdrAutoGain => 'Automatische Verstärkung (empfohlen)';

  @override
  String get receptionRtlSdrGainDb => 'Tuner-Verstärkung (dB)';

  @override
  String get receptionRtlSdrSampleRate => 'Abtastrate';

  @override
  String get receptionRtlSdrChannels => 'Kanäle';

  @override
  String get msgType1 => 'Positionsmeldung Klasse A';

  @override
  String get msgType2 => 'Positionsmeldung Klasse A (zugewiesen)';

  @override
  String get msgType3 => 'Positionsmeldung Klasse A (Antwort)';

  @override
  String get msgType4 => 'Basisstation';

  @override
  String get msgType5 => 'Statische und reisebezogene Daten';

  @override
  String get msgType6 => 'Binäre gerichtete Nachricht';

  @override
  String get msgType7 => 'Binäre Bestätigung';

  @override
  String get msgType8 => 'Binäre Broadcast-Nachricht';

  @override
  String get msgType9 => 'Standard-Positionsmeldung SAR-Luftfahrzeug';

  @override
  String get msgType10 => 'UTC/Datum-Abfrage';

  @override
  String get msgType11 => 'UTC/Datum-Antwort';

  @override
  String get msgType12 => 'Gerichtete Sicherheitsmeldung';

  @override
  String get msgType13 => 'Sicherheitsbestätigung';

  @override
  String get msgType14 => 'Sicherheits-Broadcast-Nachricht';

  @override
  String get msgType15 => 'Abfrage';

  @override
  String get msgType16 => 'Befehl Zuweisungsmodus';

  @override
  String get msgType17 => 'DGNSS-Binär-Broadcast-Nachricht';

  @override
  String get msgType18 => 'Standard-Positionsmeldung Klasse B CS';

  @override
  String get msgType19 => 'Erweiterte Positionsmeldung Klasse-B-Gerät';

  @override
  String get msgType20 => 'Datenlink-Verwaltungsnachricht';

  @override
  String get msgType21 => 'Schifffahrtszeichen-Meldung';

  @override
  String get msgType22 => 'Kanalverwaltung';

  @override
  String get msgType23 => 'Gruppenzuweisungsbefehl';

  @override
  String get msgType24 => 'Statische Datenmeldung';

  @override
  String get msgType25 => 'Binäre Einzel-Slot-Nachricht';

  @override
  String get msgType26 => 'Binäre Mehrfach-Slot-Nachricht';

  @override
  String get msgType27 => 'Positionsmeldung für Langstreckenanwendungen';

  @override
  String get statsTitle => 'Statistik';

  @override
  String get statsFeed => 'Feed';

  @override
  String get statsAllFeeds => 'Alle Feeds';

  @override
  String get statsReceived => 'Empfangen';

  @override
  String get statsDecoded => 'Dekodiert';

  @override
  String get statsInvalidChecksums => 'Ungültige Prüfsummen';

  @override
  String get statsDroppedFragments => 'Verworfene Fragmente';

  @override
  String get statsParseErrors => 'Parse-Fehler';

  @override
  String get statsPendingFragments => 'Ausstehende Fragmente';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(alle Feeds)';

  @override
  String get statsReceivedVsDecoded => 'Empfangen vs. dekodiert (letzte 60 s)';

  @override
  String get statsPerSecondLabel => 'pro Sekunde';

  @override
  String get statsAccounting => 'Buchführung';

  @override
  String get statsMultiPartParts => 'Teile mehrteiliger Nachrichten';

  @override
  String get statsPending => 'Ausstehend';

  @override
  String get statsDropped => 'Verworfen';

  @override
  String get statsReconcile => 'Empfangen und dekodiert stimmen überein.';

  @override
  String get statsGapPaused =>
      'Die Differenz umfasst Sätze, die empfangen wurden, während die Dekodierung pausiert war.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Empfangen $received = $sum';
  }

  @override
  String get statsByMessageType => 'Nach Nachrichtentyp';

  @override
  String get statsNoDecodedYet => 'Noch keine dekodierten Nachrichten';

  @override
  String statsTypeFallback(Object type) {
    return 'Typ $type';
  }

  @override
  String get statsByFeed => 'Nach Feed';

  @override
  String statsFeedFilter(Object filter) {
    return 'Feed: $filter';
  }

  @override
  String get statsNoActivityYet => 'Noch keine Feed-Aktivität';

  @override
  String get statsCollecting => 'wird gesammelt…';

  @override
  String get simVesselCargo => 'Frachtschiff';

  @override
  String get simVesselTanker => 'Tanker';

  @override
  String get simVesselFishing => 'Fischerei';

  @override
  String get simVesselSailing => 'Segeln';

  @override
  String get simVesselPassenger => 'Passagier';

  @override
  String get simVesselTug => 'Schlepper';

  @override
  String get simVesselHsc => 'Schnellboot';

  @override
  String get simVesselOther => 'Sonstige';

  @override
  String get simType1 => 'Positionsmeldung (1/2/3)';

  @override
  String get simType5 => 'Statisch & Reise (5)';

  @override
  String get simType9 => 'SAR-Luftfahrzeug (9)';

  @override
  String get simType18 => 'Klasse-B-Position (18)';

  @override
  String get simType19 => 'Klasse B erweitert (19)';

  @override
  String get simType27 => 'Langstrecke (27)';

  @override
  String get simType4 => 'Basisstation (4)';

  @override
  String get simType21 => 'Schifffahrtszeichen (21)';

  @override
  String get simType8 => 'Wetterrundfunk (8)';

  @override
  String get simType11 => 'UTC/Datum-Antwort (11)';

  @override
  String get simType12 => 'Sicherheit gerichtet (12)';

  @override
  String get simType14 => 'Sicherheit Rundsendung (14)';

  @override
  String get simType22 => 'Kanalverwaltung (22)';

  @override
  String get simType23 => 'Gruppenzuweisung (23)';

  @override
  String get simType24 => 'Klasse B statisch (24)';

  @override
  String get simTitle => 'Simulation';

  @override
  String get simInfoBanner =>
      'Die Flotte wird gesendet, wenn der Feed „Simulation“ auf der Registerkarte Empfang aktiviert ist und der Forwarder läuft.';

  @override
  String get simOpenReception => 'Empfang öffnen';

  @override
  String get simFleetSection => 'Flotte';

  @override
  String get simRadiusKm => 'Radius (km)';

  @override
  String get simVessels => 'Fahrzeuge';

  @override
  String get simSpeedMinKn => 'Mindestgeschwindigkeit (kn)';

  @override
  String get simSpeedMaxKn => 'Höchstgeschwindigkeit (kn)';

  @override
  String get simIntervalS => 'Intervall (s)';

  @override
  String get simSeed => 'Seed';

  @override
  String get simAnchoredPct => 'Verankert (%)';

  @override
  String get simNamePrefix => 'Namenspräfix';

  @override
  String get simMmsiMid => 'MMSI-Land / MID';

  @override
  String get simSearchMmid => 'Land suchen oder 3-stellige MID eingeben';

  @override
  String get simCustom => 'Benutzerdefiniert';

  @override
  String get simVesselTypes => 'Fahrzeugtypen';

  @override
  String get simRealisticNames => 'Realistische Namen';

  @override
  String get simRealisticDimensions => 'Realistische Abmessungen';

  @override
  String get simRealisticMmsi => 'Realistische ITU-MMSI';

  @override
  String get simZoneSection => 'Zone & Verkehr';

  @override
  String get simLocationPreset => 'Ortsvorgabe';

  @override
  String get simSearchPort => 'Hafen suchen…';

  @override
  String get simCenterLat => 'Breitengrad (Mitte)';

  @override
  String get simCenterLon => 'Längengrad (Mitte)';

  @override
  String get simZoneShape => 'Zonenform';

  @override
  String get simTransitPct => 'Durchfahrt (%)';

  @override
  String get simRegeneratePeriodically => 'Periodisch neu erzeugen';

  @override
  String get simRegenerateTicks => 'Neu erzeugen (Ticks)';

  @override
  String get simPresetHint =>
      'Wähle eine Vorgabe zum Ausfüllen der Koordinaten oder gib Breitengrad/Längengrad (Mitte) direkt ein.';

  @override
  String get simMovementSection => 'Bewegung & Aussendung';

  @override
  String get simVarySpeed => 'Geschwindigkeit über die Zeit variieren';

  @override
  String get simReportIntervalTicks => 'Meldeintervall (Ticks)';

  @override
  String get simWander => 'Drift (0-3)';

  @override
  String get simSpeedByType => 'Geschwindigkeit nach Fahrzeugtyp';

  @override
  String get simClassBSharePct => 'Klasse-B-Anteil (%)';

  @override
  String get simHighAccuracy => 'Hohe Genauigkeit';

  @override
  String get simRealisticRot => 'Realistische Drehrate';

  @override
  String get simContentSection => 'Inhalt';

  @override
  String get simSafetyTexts => 'Sicherheitstexte (eine pro Zeile)';

  @override
  String get simDestinations => 'Ziele (eine pro Zeile)';

  @override
  String get simStationsSection => 'Stationen';

  @override
  String get simBaseStations => 'Basisstationen';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => 'Übertragungsqualität';

  @override
  String get simInjectErrors => 'Fehler einfügen';

  @override
  String get simErrorRatePct => 'Fehlerrate (%)';

  @override
  String get simTalkerId => 'Talker-ID';

  @override
  String get simNmea4Tag => 'NMEA-4.0-Tag-Block';

  @override
  String get simMessagesSection => 'Nachrichten';

  @override
  String get simApplyFleet => 'Flotte anwenden';

  @override
  String get simRegenerateFleet => 'Flotte neu erzeugen';

  @override
  String get simGenerating => 'Generierung…';

  @override
  String get simLiveFleet => 'Live-Flotte';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats Boote · $frames Frames gesendet';
  }

  @override
  String get mapSearchVessels => 'Fahrzeuge suchen';

  @override
  String get mapSearchHint => 'Name, MMSI oder IMO';

  @override
  String get mapNoResults => 'Keine Ergebnisse';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'Filter';

  @override
  String mapAllLabel(Object label) {
    return 'Alle $label';
  }

  @override
  String get mapVesselType => 'Fahrzeugtyp';

  @override
  String get mapNavigationStatus => 'Navigationsstatus';

  @override
  String get mapCountry => 'Land';

  @override
  String get mapMinSog => 'Min. SOG (kn)';

  @override
  String get mapMaxSog => 'Max. SOG (kn)';

  @override
  String get mapOnlyNamed => 'Nur Fahrzeuge mit Namen';

  @override
  String get mapReset => 'Zurücksetzen';

  @override
  String get mapApply => 'Anwenden';

  @override
  String get mapAutoBasemap => 'Auto (Thema folgen)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Verfolge $mmsi';
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
  String get basemapVoyagerLight => 'Voyager (hell)';

  @override
  String get basemapPositronLight => 'Positron (hell, minimal)';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Esri-Satellit';

  @override
  String get basemapEsriStreets => 'Esri World Street Map';

  @override
  String get decoderInputLabel =>
      'Eine oder mehrere NMEA-AIS-Sätze einfügen oder eingeben';

  @override
  String get decoderValidateChecksums => 'Prüfsummen validieren';

  @override
  String get decoderDecode => 'Dekodieren';

  @override
  String get decoderDecoded => 'Dekodiert';

  @override
  String decoderDecodedN(Object n) {
    return 'Dekodiert ($n Sätze)';
  }

  @override
  String get decoderInvalidChecksum => 'Ungültige Prüfsumme';

  @override
  String get decoderParseError => 'Parse-Fehler';

  @override
  String get decoderWaitingFragments => 'Warte auf weitere Fragmente…';

  @override
  String decoderTagSource(Object id) {
    return 'Quelle $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Tag-Block · $content';
  }

  @override
  String get toolDecoder => 'NMEA-Dekoder';

  @override
  String get toolDecoderSub => 'AIS-Sätze dekodieren';

  @override
  String get toolChecksum => 'Prüfsumme';

  @override
  String get toolChecksumSub => 'NMEA-XOR berechnen';

  @override
  String get toolMmsi => 'MMSI-Suche';

  @override
  String get toolMmsiSub => 'MMSI validieren und identifizieren';

  @override
  String get toolSpeed => 'Geschwindigkeitsrechner';

  @override
  String get toolSpeedSub => 'kn · km/h · m/s · mph';

  @override
  String get toolBinary => 'Binär-Inspektor';

  @override
  String get toolBinarySub => 'Payload bis zum Bit';

  @override
  String get toolEta => 'ETA-Rechner';

  @override
  String get toolEtaSub => 'ETA als Typ-5-Felder';

  @override
  String get toolRadio => 'Funkreichweite';

  @override
  String get toolRadioSub => 'VHF-AIS-Radiohorizont';

  @override
  String get toolTextToBinary => 'Text zu Binär';

  @override
  String get toolTextToBinarySub => '6-Bit-ASCII zu Hex/Bits';

  @override
  String get checksumInputLabel => 'Einen oder mehrere NMEA-Sätze einfügen';

  @override
  String get checksumComputed => 'Berechnet';

  @override
  String get checksumDeclared => 'Deklariert';

  @override
  String get checksumValid => 'Prüfsumme gültig';

  @override
  String get checksumInvalid => 'Prüfsummenfehler';

  @override
  String get checksumFix => 'Prüfsumme korrigieren';

  @override
  String get mmsiInputLabel => 'MMSI (9 Ziffern)';

  @override
  String get mmsiValid => 'Gültige MMSI';

  @override
  String get mmsiInvalid => 'Keine gültige 9-stellige MMSI';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'Land';

  @override
  String get mmsiCountryUnknown => 'Unbekannte MID';

  @override
  String get mmsiType => 'Stationstyp';

  @override
  String get mmsiGroupCall => 'Gruppenruf';

  @override
  String get mmsiSarAircraft => 'SAR-Flugzeug';

  @override
  String get mmsiCoastStation => 'Küstenstation';

  @override
  String get mmsiShipStation => 'Schiffsstation';

  @override
  String get mmsiHandheldVhf => 'Handheld-VHF';

  @override
  String get mmsiAton => 'Schifffahrtszeichen (AtoN)';

  @override
  String get mmsiSar => 'SAR-Einheit';

  @override
  String get mmsiOther => 'Sonstige';

  @override
  String get speedValue => 'Wert';

  @override
  String get speedUnit => 'Einheit';

  @override
  String get binaryInputLabel => 'NMEA-Satz oder roher 6-Bit-Payload';

  @override
  String get binaryPayload => 'Payload';

  @override
  String get binaryBits => 'Bits';

  @override
  String get binaryBinary => 'Binär';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Hex-Bytes';

  @override
  String get binarySixBit => '6-Bit-Zeichen';

  @override
  String get etaDistance => 'Distanz';

  @override
  String get etaUnitNm => 'Seemeilen';

  @override
  String get etaUnitKm => 'Kilometer';

  @override
  String get etaSpeed => 'Geschwindigkeit';

  @override
  String get etaDuration => 'Dauer';

  @override
  String get etaEtaLocal => 'ETA (lokal)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'AIS-Typ-5-ETA-Felder';

  @override
  String get etaMonth => 'Monat';

  @override
  String get etaDay => 'Tag';

  @override
  String get etaHour => 'Stunde';

  @override
  String get etaMinute => 'Minute';

  @override
  String get etaCombined => 'MM/TT SS:MM';

  @override
  String get radioHeight1 => 'Antennenhöhe 1';

  @override
  String get radioHeight2 => 'Antennenhöhe 2';

  @override
  String get radioHorizon => 'Radiohorizont';

  @override
  String get radioHorizonKm => 'Radiohorizont (km)';

  @override
  String get radioFrequencies => 'AIS-Kanäle';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Text eingeben (AIS-6-Bit-Alphabet)';

  @override
  String get t2bCharTable => 'Zeichen · Wert · 6-Bit';

  @override
  String get t2bBinary => 'Binär';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Bytes (Editorformat)';

  @override
  String get t2bPayload => 'Armierter Payload';

  @override
  String get t2bNote =>
      'Die Byte-Liste kann in das Feld „Data bytes“ des Editors einer 6/8/25/26-Nachricht eingefügt werden; der armierte Payload ist das exakte NMEA-Payload-Feld.';

  @override
  String editorAsmDetected(Object name) {
    return 'Anwendungsspezifische Nachricht — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Felder des erkannten ASM. Das rohe Feld „Data bytes“ hat weiterhin Vorrang, wenn es ausgefüllt ist.';

  @override
  String get fMessageType => 'Nachrichtentyp';

  @override
  String get editorAsmPreset => 'ASM-Vorlage';

  @override
  String get editorAsmPresetManual =>
      'Benutzerdefiniert — DAC/FID manuell eingeben';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'ASM-Felder';

  @override
  String get asmStateInForce => 'in Kraft';

  @override
  String get asmStateDeprecated => 'veraltet';

  @override
  String get asmStateReplaced => 'ersetzt';

  @override
  String get asmStateDiscontinued => 'eingestellt';

  @override
  String get asmStateDraft => 'Entwurf';

  @override
  String get asmStateProposal => 'Vorschlag';

  @override
  String get asmStateTesting => 'im Test';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Veraltet seit $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'Für $name ist kein Bit-Layout dokumentiert — bearbeiten Sie die rohen Data bytes.';
  }

  @override
  String get docChapterAsm => 'Anwendungsspezifische Nachrichten';

  @override
  String get docAsmIntro =>
      'Nicht jedes AIS-Payload ist ein Standard-Positionsbericht. Die Typen 6, 8, 25 und 26 tragen anwendungsspezifische Binärdaten (ASM), deren Bedeutung durch zwei Zahlen definiert wird: einen Designated Area Code (DAC) und einen Function Identifier (FID).';

  @override
  String get docAsmWhatTitle => 'Was ist ein ASM?';

  @override
  String get docAsmWhat =>
      'Eine anwendungsspezifische Nachricht ist ein strukturiertes Payload, das von einer Organisation (IMO, IALA, nationale Verwaltungen, Hersteller) für einen bestimmten Zweck veröffentlicht wird: Wetter- und hydrografische Daten, Überwachung von Navigationshilfen, DGPS-Korrekturen, Hafendienste und mehr. Typ 6/8 trägt den DAC/FID-Header; Typ 25/26 wiederholt dasselbe DAC/FID-Schema in den Slot-Nachrichten.';

  @override
  String get docAsmDacFidTitle => 'DAC und FID';

  @override
  String get docAsmDacFid1 =>
      'Der DAC ist ein 10-Bit-Code, der die herausgebende Organisation oder das Land identifiziert (z. B. 001 = IMO, 002 = IALA). Der FID ist ein 6-Bit-Funktionscode im Namensraum dieses DAC (z. B. 001/11 = IMO Wetter- & Hydrodaten).';

  @override
  String get docAsmDacFid2 =>
      'Die auf den DAC/FID-Header folgenden Datenbytes werden nach dem passenden Anwendungsstandard decodiert. Unterschiedliche DAC/FID-Paare können dieselben Bytes völlig unterschiedlich interpretieren – das Paar muss also immer zuerst bekannt sein.';

  @override
  String get docAsmWhereTitle => 'Wo die Definitionen zu finden sind';

  @override
  String get docAsmWhere1 =>
      'IMO-Rundschreiben und ITU-R M.1371 (Anhänge) — maßgebliche Quelle für IMO-DAC 001.';

  @override
  String get docAsmWhere2 =>
      'IALA-Richtlinien (z. B. G1139) und nationale Verwaltungen — für regionale DACs.';

  @override
  String get docAsmWhere3 =>
      'Die gpsd-AIVDM-Dokumentation — ein offener, maschinenlesbarer Katalog der gängigsten DAC/FID-Schemata.';

  @override
  String get docAsmInKikaisTitle => 'In KikAis';

  @override
  String get docAsmInKikais =>
      'Der Editor kennt einen kuratierten Satz bekannter ASMs: Wenn DAC/FID einer 6/8/25/26-Nachricht übereinstimmen, wird das Datenfeld als benannte Teilfelder angezeigt, die automatisch gepackt werden. Das rohe Feld „Data bytes“ hat bei Befüllung immer Vorrang. Die Liste liegt in asm_formats.dart und lässt sich leicht erweitern.';

  @override
  String get docAsmExampleTitle => 'Beispiel: IMO Wetter & Hydro (001/11)';

  @override
  String get docAsmExample =>
      'Stelle im Editor Typ 8, DAC=1 und FID=11 ein, um eine IMO-Wetternachricht zu bauen: Wind, Luft- und Wassertemperatur, Druck, Sicht, Strömungen und Wellen lassen sich dann Feld für Feld bearbeiten statt als Byte-Blob.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Wiederholungsanzeiger';

  @override
  String get fNavStatus => 'Navigationsstatus';

  @override
  String get fLatitude => 'Breitengrad';

  @override
  String get fLongitude => 'Längengrad';

  @override
  String get fSogKn => 'SOG (kn)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Kurs (°)';

  @override
  String get fRateOfTurn => 'Drehrate';

  @override
  String get fManeuver => 'Manöver';

  @override
  String get fTimestamp => 'Zeitstempel';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Genauigkeit';

  @override
  String get fEpfdFixType => 'EPFD-Positionsart';

  @override
  String get fSyncState => 'Synchronisationsstatus';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Rufzeichen';

  @override
  String get fVesselName => 'Fahrzeugname';

  @override
  String get fShipType => 'Schiffstyp';

  @override
  String get fShipTypeText => 'Schiffstyp (Text)';

  @override
  String get fDims => 'Bug/Heck/Backbord/Steuerbord (m)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Tiefgang (m)';

  @override
  String get fDestination => 'Ziel';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'Ziel-MMSI';

  @override
  String get fSeqNumber => 'Sequenznummer';

  @override
  String get fRetransmit => 'Erneut senden';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Daten';

  @override
  String get fAltitudeM => 'Höhe (m)';

  @override
  String get fAssignedMode => 'Zugewiesener Modus';

  @override
  String get fRegionalReserved => 'Regional reserviert';

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
    return 'offset $offset · Nummer $number · timeout $timeout · Inkrement $increment';
  }

  @override
  String get fAidType => 'Schifffahrtszeichen-Typ';

  @override
  String get fAidTypeCode => 'Schifffahrtszeichen-Typ (Code)';

  @override
  String get fName => 'Name';

  @override
  String get fNameExt => 'Namenserweiterung';

  @override
  String get fVirtualAid => 'Virtuelles Zeichen';

  @override
  String get fOffPosition => 'Außer Position';

  @override
  String get fSecond => 'Sekunde';

  @override
  String get fChannelA => 'Kanal A';

  @override
  String get fChannelB => 'Kanal B';

  @override
  String get fTxRxMode => 'TX/RX-Modus';

  @override
  String get fPower => 'Sendeleistung';

  @override
  String get fZone => 'Zone';

  @override
  String get fAddressed => 'Gerichtet';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Band A';

  @override
  String get fBandB => 'Band B';

  @override
  String get fZoneSize => 'Zonengröße';

  @override
  String get fStationType => 'Stationstyp';

  @override
  String get fReportInterval => 'Meldeintervall';

  @override
  String get fQuietTime => 'Ruhezeit';

  @override
  String get fPart => 'Teil';

  @override
  String get fVendorId => 'Hersteller-ID';

  @override
  String get fUnitModel => 'Gerätemodell';

  @override
  String get fSerialNumber => 'Seriennummer';

  @override
  String get fMothershipMmsi => 'Mutterschiffs-MMSI';

  @override
  String get fRadioStatus => 'Funkstatus';

  @override
  String get fGnssStatus => 'GNSS-Positionsstatus';

  @override
  String fDestN(Object n) {
    return 'Ziel $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => 'Zielanzeiger';

  @override
  String get fBinaryDataFlag => 'Binärdaten-Flag';

  @override
  String get fApplicationId => 'Anwendungs-ID';

  @override
  String get fPowerHigh => 'Hoch';

  @override
  String get fPowerLow => 'Niedrig';

  @override
  String get fPartA => 'A (Name)';

  @override
  String get fPartB => 'B (Schiffsdaten)';

  @override
  String get editorTitle => 'AIS-Nachrichten-Editor';

  @override
  String get editorCompose => 'Nachricht verfassen';

  @override
  String get editorMessageType => 'Nachrichtentyp';

  @override
  String get editorAddTagBlock => 'NMEA-4.0-Tag-Block hinzufügen';

  @override
  String get editorSourceId => 'Quellen-ID';

  @override
  String get editorInjectToMap => 'In Karte einfügen';

  @override
  String get editorSendToTarget => 'An Ziel senden';

  @override
  String get editorPreview => 'NMEA-Vorschau';

  @override
  String get editorNmeaCopied => 'NMEA kopiert';

  @override
  String get editorInjected => 'Nachricht eingefügt';

  @override
  String get editorSentToTarget => 'Nachricht an Ziel gesendet';

  @override
  String get editorNavStatus0_15 => 'Navigationsstatus (0-15)';

  @override
  String get editorYear => 'Jahr';

  @override
  String get editorMonth => 'Monat';

  @override
  String get editorDay => 'Tag';

  @override
  String get editorHour => 'Stunde';

  @override
  String get editorMinute => 'Minute';

  @override
  String get editorSecond => 'Sekunde';

  @override
  String get editorImoNumber => 'IMO-Nummer';

  @override
  String get editorBowM => 'Bug (m)';

  @override
  String get editorSternM => 'Heck (m)';

  @override
  String get editorPortM => 'Backbord (m)';

  @override
  String get editorStarboardM => 'Steuerbord (m)';

  @override
  String get editorEtaMonth => 'ETA-Monat';

  @override
  String get editorEtaDay => 'ETA-Tag';

  @override
  String get editorEtaHour => 'ETA-Stunde';

  @override
  String get editorEtaMinute => 'ETA-Minute';

  @override
  String get editorSequence0_3 => 'Sequenz (0-3)';

  @override
  String get editorDataBytes => 'Datenbytes (hex oder 1,2,3)';

  @override
  String get editorDestMmsisComma => 'Ziel-MMSIs (Komma getrennt)';

  @override
  String get editorSequencesComma => 'Sequenzen (Komma getrennt)';

  @override
  String get editorInterrogatedMmsi => 'Befragte MMSI';

  @override
  String get editorType1 => 'Typ 1';

  @override
  String get editorOffset1 => 'Offset 1';

  @override
  String get editorTargetMmsi => 'Ziel-MMSI';

  @override
  String get editorOffset => 'Offset';

  @override
  String get editorIncrement => 'Inkrement';

  @override
  String get editorNumber => 'Nummer';

  @override
  String get editorTimeout => 'Timeout';

  @override
  String get editorAidType0_31 => 'Schifffahrtszeichen-Typ (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Virtuelles Zeichen (0/1)';

  @override
  String get editorTxRxMode0_15 => 'TX/RX-Modus (0-15)';

  @override
  String get editorTxRxMode0_3 => 'TX/RX-Modus (0-3)';

  @override
  String get editorNeLat => 'NO-Breitengrad';

  @override
  String get editorNeLon => 'NO-Längengrad';

  @override
  String get editorSwLat => 'SW-Breitengrad';

  @override
  String get editorSwLon => 'SW-Längengrad';

  @override
  String get editorInterval0_15 => 'Intervall (0-15)';

  @override
  String get editorPart => 'Teil (0 = A Name, 1 = B statisch)';

  @override
  String get editorDestMmsiEmpty => 'Ziel-MMSI (leer = Broadcast)';

  @override
  String get editorAppDacEmpty => 'App-DAC (leer = keine)';

  @override
  String get editorAppFidEmpty => 'App-FID (leer = keine)';

  @override
  String get nmeaTalker => 'Talker';

  @override
  String get nmeaFragments => 'Fragmente';

  @override
  String get nmeaFragmentN => 'Fragment #';

  @override
  String get nmeaMessageId => 'Nachrichten-ID';

  @override
  String get nmeaChannel => 'Kanal';

  @override
  String get nmeaPayload => 'Payload';

  @override
  String get nmeaFillBits => 'Füllbits';

  @override
  String get nmeaTagBlock => 'Tag-Block';

  @override
  String get nmeaChecksum => 'Prüfsumme';

  @override
  String get nmeaEmpty => '(leer)';

  @override
  String get bubbleKindVessel => 'Fahrzeug';

  @override
  String get bubbleKindAircraft => 'SAR-Luftfahrzeug';

  @override
  String get bubbleKindAton => 'Schifffahrtszeichen';

  @override
  String get bubbleKindStation => 'Basisstation';

  @override
  String get bubbleGeneralInfo => 'Allgemeine Informationen';

  @override
  String get bubbleKind => 'Art';

  @override
  String get bubbleAidType => 'Zeichentyp';

  @override
  String get bubbleVirtual => 'Virtuell';

  @override
  String get bubbleAltitude => 'Höhe';

  @override
  String get bubbleCallSign => 'Rufzeichen';

  @override
  String get bubblePosNav => 'Position & Navigation';

  @override
  String get bubbleHeading => 'Kurs';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Fahrzeugdetails';

  @override
  String get bubbleType => 'Typ';

  @override
  String get bubbleTypeInt => 'Typ (Int)';

  @override
  String get bubbleDimsBowStern => 'Abmessungen Bug/Heck';

  @override
  String get bubbleDimsPortStarboard => 'Abmessungen Backbord/Steuerbord';

  @override
  String get bubbleSpare => 'Reserve';

  @override
  String get bubbleDraught => 'Tiefgang';

  @override
  String bubbleFrames(Object n) {
    return 'Frames ($n)';
  }

  @override
  String get bubbleNoFrames => 'Noch keine Frames';

  @override
  String get copied => 'Kopiert';

  @override
  String get textFiles => 'Textdateien';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Ziel $name verbunden ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Verbindung zum Ziel $name fehlgeschlagen: $error';
  }

  @override
  String get logStopping => 'Forwarder wird beendet…';

  @override
  String get logStopped => 'Forwarder beendet.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Feed hinzugefügt: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Feed entfernt: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Feed $name verbunden.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Feed $name getrennt. Erneute Verbindung in 5 s…';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Verbindung zum Feed $name fehlgeschlagen: $error. Erneuter Versuch in 5 s…';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Ziel $name: TCP-Server lauscht auf Port $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Ziel $name: Client verbunden $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Ziel $name: Client getrennt';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Ziel $name: Client-Fehler $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Sendefehler bei Ziel $name: $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'RTL-SDR-Dongle $device wird geöffnet...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device verbunden ($freq, Abtastrate $rate, Verstärkung $gain, Kanäle $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device: Fehler $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'RTL-SDR-Stream $device geschlossen.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device getrennt.';
  }

  @override
  String get docNavStatus0 => 'Mit Maschinenkraft in Fahrt';

  @override
  String get docNavStatus1 => 'Vor Anker';

  @override
  String get docNavStatus2 => 'Manövrierunfähig';

  @override
  String get docNavStatus3 => 'Manövrierbehinderung';

  @override
  String get docNavStatus4 => 'Durch Tiefgang beschränkt';

  @override
  String get docNavStatus5 => 'Festgemacht';

  @override
  String get docNavStatus6 => 'Grundberührung';

  @override
  String get docNavStatus7 => 'Beim Fischen';

  @override
  String get docNavStatus8 => 'Unter Segeln';

  @override
  String get docNavStatus9 => 'Reserviert (HSC)';

  @override
  String get docNavStatus10 => 'Reserviert (WIG)';

  @override
  String get docNavStatus11 => 'Schleppen achteraus (regional)';

  @override
  String get docNavStatus12 =>
      'Vorbugschieben / längsseits schleppen (regional)';

  @override
  String get docNavStatus13 => 'Für spätere Verwendung reserviert';

  @override
  String get docNavStatus14 => 'AIS-SART aktiv';

  @override
  String get docNavStatus15 => 'Undefiniert (Standard)';

  @override
  String get docEpfd0 => 'Undefiniert (Standard)';

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
  String get docEpfd6 => 'Integriertes Navigationssystem';

  @override
  String get docEpfd7 => 'Vermessen (fest)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'Internes GNSS';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · Bits $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields Felder · $bits Bits gesamt · Segment antippen';
  }

  @override
  String get docTextToEncode => 'Zu kodierender Text';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Jedes Zeichen ist ein 6-Bit-Wert („@“ = 0, Leerzeichen = 32, „A“ = 1…). Kleinbuchstaben sind nicht kodierbar und werden üblicherweise als Großbuchstaben gesendet.';

  @override
  String get docChecksumBody =>
      'Body (ohne führendes ! und abschließendes *XX)';

  @override
  String get docChecksumExplanation =>
      'Die NMEA-Prüfsumme ist das XOR aller Bytes zwischen „!“ und „*“.';

  @override
  String get docLatitude => 'Breitengrad';

  @override
  String get docLongitude => 'Längengrad';

  @override
  String get docLatitudeInvalid => 'Breitengrad: Zahl eingeben';

  @override
  String get docLongitudeInvalid => 'Längengrad: Zahl eingeben';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Breitengrad → $value (27-Bit, vorzeichenbehaftet, deg = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Längengrad → $value (28-Bit, vorzeichenbehaftet, deg = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Koordinaten werden in 1/10 000 Minute gespeichert: Durch 600 000 dividieren, um Grad zu erhalten.';

  @override
  String get docSearchShipTypes => 'Schiffstypen suchen';

  @override
  String get docShipCat0_19 => '0-19 · Reserviert';

  @override
  String get docShipCat20_29 => '20-29 · Bodeneffektfahrzeug (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Fischerei';

  @override
  String get docShipCat40_49 => '40-49 · Schnelles Fahrzeug';

  @override
  String get docShipCat50_59 => '50-59 · Sonderfahrzeug';

  @override
  String get docShipCat60_69 => '60-69 · Passagier';

  @override
  String get docShipCat70_79 => '70-79 · Fracht';

  @override
  String get docShipCat80_89 => '80-89 · Tanker';

  @override
  String get docShipCat90_99 => '90-99 · Sonstige';

  @override
  String get docSearchGlossary => 'Glossar durchsuchen';

  @override
  String get docNoMatchingTerms => 'Keine passenden Begriffe.';

  @override
  String get docAspect => 'Aspekt';

  @override
  String get docClassA => 'Klasse A';

  @override
  String get docClassB => 'Klasse B';

  @override
  String get docCheatRadio => 'Funk';

  @override
  String get docCheatFrequencies => 'Frequenzen';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulation';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bit/s';

  @override
  String get docCheatRange => 'Reichweite';

  @override
  String get docCheatRangeValue =>
      '~10-20 NM von Schiff zu Schiff, in Sichtweite';

  @override
  String get docCheatReportingRates => 'Melderaten';

  @override
  String get docCheatClassAPos1 => 'Klasse-A-Position (1)';

  @override
  String get docCheatClassAPos1Value => 'Alle 2-10 s in Fahrt, 3 min vor Anker';

  @override
  String get docCheatStatic5 => 'Statisch (5)';

  @override
  String get docCheatStatic5Value => 'Alle 6 min';

  @override
  String get docCheatClassBPos18 => 'Klasse-B-Position (18)';

  @override
  String get docCheatClassBPos18Value => '~Alle 30 s';

  @override
  String get docCheatAtoN21 => 'Schifffahrtszeichen (21)';

  @override
  String get docCheatAtoN21Value => 'Alle 3 min';

  @override
  String get docCheatNavStatus0_15 => 'Navigationsstatus (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'Mit Maschinenkraft in Fahrt';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'Vor Anker';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Manövrierbehinderung';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Festgemacht';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'Grundberührung';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Fischerei';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'Unter Segeln';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART aktiv';

  @override
  String get docCheatMmsiFormats => 'MMSI-Formate';

  @override
  String get docCheatFixTypes => 'Positionsarten (EPFD)';

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
  String get docCheatEpfd15Value => 'Internes GNSS';

  @override
  String get docCheatFooter =>
      'KikAis liefert auf jeder Registerkarte eine vollständige interaktive Referenz — der Editor kann jede Nachricht erstellen, der Decoder liest sie wieder aus.';

  @override
  String get docMmsiFmtDiversRadio => 'Funkgerät eines Tauchers';

  @override
  String get docMmsiFmtShip => 'Schiff';

  @override
  String get docMmsiFmtGroupShips =>
      'Schiffsgruppe (z. B. eine Flotte oder die USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Küstenstation';

  @override
  String get docMmsiFmtSarAircraft => 'SAR-Luftfahrzeug';

  @override
  String get docMmsiFmtAuxCraft => 'Hilfsfahrzeug eines Mutterschiffs';

  @override
  String get docMmsiFmtAtoN => 'Schifffahrtszeichen';

  @override
  String get docMmsiFmtSart => 'AIS-SART (Such- und Rettungssender)';

  @override
  String get docMmsiFmtMob => 'MOB-Gerät (Mann über Bord)';

  @override
  String get docMmsiFmtEpirb => 'AIS-EPIRB (Notbake)';

  @override
  String get docVesselCat0_9 => 'Reserviert / zukünftige Verwendung';

  @override
  String get docVesselCat10_19 => 'Für spätere Verwendung reserviert';

  @override
  String get docVesselCat20_29 => 'Bodeneffektfahrzeug (WIG)';

  @override
  String get docVesselCat30_39 => 'Fischerei';

  @override
  String get docVesselCat40_49 => 'Schnelle Fahrzeuge';

  @override
  String get docVesselCat50_59 =>
      'Sonderfahrzeuge (Lotsen, Schlepper, Bagger…)';

  @override
  String get docVesselCat60_69 => 'Fahrgastschiffe';

  @override
  String get docVesselCat70_79 => 'Frachtschiffe';

  @override
  String get docVesselCat80_89 => 'Tanker';

  @override
  String get docVesselCat90_99 => 'Andere Typen';

  @override
  String get docTalkerAB => 'AIS-Basisstation';

  @override
  String get docTalkerAD => 'Abhängige AIS-Basisstation';

  @override
  String get docTalkerAI => 'Mobile AIS-Station';

  @override
  String get docTalkerAN => 'AIS-Station für Schifffahrtszeichen';

  @override
  String get docTalkerAR => 'AIS-Empfangsstation';

  @override
  String get docTalkerAS => 'Begrenzte Basisstation';

  @override
  String get docTalkerAT => 'AIS-Sendestation';

  @override
  String get docTalkerAX => 'AIS-Relaisstation';

  @override
  String get docTalkerBS => 'AIS-Basisstation (veraltet)';

  @override
  String get docTalkerSA => 'Physische AIS-Küstenstation';

  @override
  String get docType1Name => 'Positionsmeldung Klasse A';

  @override
  String get docType1Family => 'Positionsmeldungen';

  @override
  String get docType1Summary =>
      'Das Arbeitspferd des Systems: ein Klasse-A-Transponder, der Position, Kurs, Geschwindigkeit, Heading und Navigationsstatus sendet.';

  @override
  String get docType1EmittedBy => 'Klasse-A-Transponder (SOLAS-Schiffe)';

  @override
  String get docType1Cadence => 'Alle 2-10 s in Fahrt, alle 3 min vor Anker';

  @override
  String get docType2Name => 'Positionsmeldung Klasse A (zugewiesen)';

  @override
  String get docType2Family => 'Positionsmeldungen';

  @override
  String get docType2Summary =>
      'Identisch mit Typ 1, wird aber gemäß einem Slot-Zeitplan gesendet, den eine Basisstation dem Fahrzeug zugewiesen hat (Zuweisungsmodus).';

  @override
  String get docType2EmittedBy => 'Klasse-A-Transponder unter Zuweisung';

  @override
  String get docType2Cadence => 'Zugewiesener Zeitplan';

  @override
  String get docType3Name => 'Positionsmeldung Klasse A (Antwort)';

  @override
  String get docType3Family => 'Positionsmeldungen';

  @override
  String get docType3Summary =>
      'Identisch mit Typ 1, wird als Antwort auf eine Abfrage (Typ 15) gesendet.';

  @override
  String get docType3EmittedBy =>
      'Klasse-A-Transponder, die auf eine Abfrage antworten';

  @override
  String get docType3Cadence => 'Bei Abfrage';

  @override
  String get docType4Name => 'Basisstations-Meldung';

  @override
  String get docType4Family => 'Basisstation & Netzwerk';

  @override
  String get docType4Summary =>
      'Die periodische Meldung einer festen Küstenstation: ihre Position sowie die UTC-Datums- und Zeitreferenz.';

  @override
  String get docType4EmittedBy => 'Feste Basisstationen';

  @override
  String get docType4Cadence => 'Alle 10 s';

  @override
  String get docType5Name => 'Statische und reisebezogene Daten';

  @override
  String get docType5Family => 'Statische & Reisedaten';

  @override
  String get docType5Summary =>
      'Der „Personalausweis“ eines Schiffs: Name, Rufzeichen, IMO-Nummer, Schiffstyp, Abmessungen, Tiefgang, ETA und Ziel.';

  @override
  String get docType5EmittedBy => 'Klasse-A-Transponder';

  @override
  String get docType5Cadence => 'Alle 6 min und bei Datenänderungen';

  @override
  String get docType6Name => 'Binäre gerichtete Nachricht';

  @override
  String get docType6Family => 'Binärdaten';

  @override
  String get docType6Summary =>
      'Ein strukturierter Binär-Payload, der an eine bestimmte Ziel-MMSI gesendet wird (z. B. ein angeforderter Wetterbericht).';

  @override
  String get docType6EmittedBy => 'Jede Station';

  @override
  String get docType6Cadence => 'Auf Anfrage';

  @override
  String get docType7Name => 'Binäre Bestätigung';

  @override
  String get docType7Family => 'Binärdaten';

  @override
  String get docType7Summary =>
      'Die Bestätigung, die als Antwort auf eine binäre gerichtete Nachricht vom Typ 6 gesendet wird.';

  @override
  String get docType7EmittedBy =>
      'Jede Station, die eine Typ-6-Nachricht empfangen hat';

  @override
  String get docType7Cadence => 'Bei Antwort';

  @override
  String get docType8Name => 'Binäre Broadcast-Nachricht';

  @override
  String get docType8Family => 'Binärdaten';

  @override
  String get docType8Summary =>
      'Ein strukturierter Binär-Payload, der an alle gesendet wird — Wetter- und hydrografische Berichte, regionale Daten oder private/verschlüsselte Nachrichten.';

  @override
  String get docType8EmittedBy => 'Jede Station';

  @override
  String get docType8Cadence => 'Auf Anfrage';

  @override
  String get docType9Name => 'Standard-Positionsmeldung SAR-Luftfahrzeug';

  @override
  String get docType9Family => 'Positionsmeldungen';

  @override
  String get docType9Summary =>
      'Eine Positionsmeldung von Such- und Rettungsflugzeugen, um für Schiffe sichtbar zu sein. Enthält Höhe und einen speziellen MMSI-Bereich (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'SAR-Luftfahrzeuge';

  @override
  String get docType9Cadence => 'Alle 10 s im Einsatz';

  @override
  String get docType10Name => 'UTC- und Datumsabfrage';

  @override
  String get docType10Family => 'Basisstation & Netzwerk';

  @override
  String get docType10Summary =>
      'Eine kleine Anfrage an eine bestimmte Station nach ihrem UTC-Datum und ihrer Zeit.';

  @override
  String get docType10EmittedBy => 'Jede Station';

  @override
  String get docType10Cadence => 'Auf Anfrage';

  @override
  String get docType11Name => 'UTC- und Datumsantwort';

  @override
  String get docType11Family => 'Basisstation & Netzwerk';

  @override
  String get docType11Summary =>
      'In der Struktur identisch mit Typ 4, wird als Antwort auf eine UTC/Datum-Abfrage (Typ 10) gesendet.';

  @override
  String get docType11EmittedBy => 'Basisstationen';

  @override
  String get docType11Cadence => 'Bei Abfrage';

  @override
  String get docType12Name => 'Gerichtete Sicherheitsmeldung';

  @override
  String get docType12Family => 'Sicherheit & Text';

  @override
  String get docType12Summary =>
      'Eine Freitext-Sicherheitsmeldung, die an eine einzelne Ziel-MMSI gesendet wird (z. B. eine Notmeldung an die nächste Basisstation).';

  @override
  String get docType12EmittedBy => 'Jede Station';

  @override
  String get docType12Cadence => 'Auf Anfrage';

  @override
  String get docType13Name => 'Sicherheitsbestätigung';

  @override
  String get docType13Family => 'Sicherheit & Text';

  @override
  String get docType13Summary =>
      'Die Bestätigung, die als Antwort auf eine gerichtete Sicherheitsmeldung vom Typ 12 gesendet wird.';

  @override
  String get docType13EmittedBy =>
      'Jede Station, die eine Typ-12-Nachricht empfangen hat';

  @override
  String get docType13Cadence => 'Bei Antwort';

  @override
  String get docType14Name => 'Sicherheits-Broadcast-Nachricht';

  @override
  String get docType14Family => 'Sicherheit & Text';

  @override
  String get docType14Summary =>
      'Ein Freitext-Broadcast an alle in Reichweite — Navigationswarnungen, Not- oder Verkehrsmeldungen.';

  @override
  String get docType14EmittedBy => 'Jede Station (oft Basisstationen / VTS)';

  @override
  String get docType14Cadence => 'Auf Anfrage';

  @override
  String get docType15Name => 'Abfrage';

  @override
  String get docType15Family => 'Basisstation & Netzwerk';

  @override
  String get docType15Summary =>
      'Eine Anfrage an eine oder zwei bestimmte Stationen, einen bestimmten Nachrichtentyp zu senden (üblicherweise Typ 3 oder 5).';

  @override
  String get docType15EmittedBy => 'Basisstationen';

  @override
  String get docType15Cadence => 'Auf Anfrage';

  @override
  String get docType16Name => 'Befehl Zuweisungsmodus';

  @override
  String get docType16Family => 'Basisstation & Netzwerk';

  @override
  String get docType16Summary =>
      'Weist bis zu zwei Fahrzeuge an, in einer bestimmten Slot-Zuordnung zu senden (Zuweisungsmodus).';

  @override
  String get docType16EmittedBy => 'Basisstationen';

  @override
  String get docType16Cadence => 'Auf Anfrage';

  @override
  String get docType17Name => 'DGNSS-Binär-Broadcast-Nachricht';

  @override
  String get docType17Family => 'Binärdaten';

  @override
  String get docType17Summary =>
      'Differential-GNSS-Korrekturdaten, die von Küstenstationen gesendet werden, um die Positionsgenauigkeit im abgedeckten Gebiet zu verbessern.';

  @override
  String get docType17EmittedBy => 'DGNSS-Referenzstationen';

  @override
  String get docType17Cadence => 'Periodisch';

  @override
  String get docType18Name => 'Standard-Positionsmeldung Klasse B CS';

  @override
  String get docType18Family => 'Positionsmeldungen';

  @override
  String get docType18Summary =>
      'Die Standard-Positionsmeldung der Klasse B. Leichter als Klasse A: kein Navigationsstatus oder Drehrate, funktioniert aber mit CSTDMA.';

  @override
  String get docType18EmittedBy => 'Klasse-B-Transponder';

  @override
  String get docType18Cadence => 'Alle 30 s (in einigen Regionen seltener)';

  @override
  String get docType19Name => 'Erweiterte Positionsmeldung Klasse-B-Gerät';

  @override
  String get docType19Family => 'Positionsmeldungen';

  @override
  String get docType19Summary =>
      'Eine größere Klasse-B-Positionsmeldung, die auch Fahrzeugname, Schiffstyp und Abmessungen enthält — ein Hybrid aus Statik und Position in einer Meldung.';

  @override
  String get docType19EmittedBy => 'Erweiterte Klasse-B-Transponder';

  @override
  String get docType19Cadence => 'Alle 30 s';

  @override
  String get docType20Name => 'Datenlink-Verwaltung';

  @override
  String get docType20Family => 'Basisstation & Netzwerk';

  @override
  String get docType20Summary =>
      'Eine Netzwerk-Wartungsnachricht zur Zuweisung und Reservierung von TDMA-Zeitschlitzen in einem Gebiet.';

  @override
  String get docType20EmittedBy => 'Basisstationen';

  @override
  String get docType20Cadence => 'Netzwerkverwaltung';

  @override
  String get docType21Name => 'Schifffahrtszeichen-Meldung';

  @override
  String get docType21Family => 'Schifffahrtszeichen';

  @override
  String get docType21Summary =>
      'Sendet Position, Name und Status eines Schifffahrtszeichens — Bojen, Baken, Leuchttürme oder virtuelle Zeichen. Oft von einer virtuellen Position aus gesendet.';

  @override
  String get docType21EmittedBy => 'AtoN-Stationen (real oder virtuell)';

  @override
  String get docType21Cadence => 'Alle 3 min (oder bei Ereignis)';

  @override
  String get docType22Name => 'Kanalverwaltung';

  @override
  String get docType22Family => 'Basisstation & Netzwerk';

  @override
  String get docType22Summary =>
      'Wird von einer Basisstation verwendet, um Stationen innerhalb einer geografischen Zone auf andere VHF-Kanäle umzuschalten.';

  @override
  String get docType22EmittedBy => 'Basisstationen';

  @override
  String get docType22Cadence => 'Auf Anfrage';

  @override
  String get docType23Name => 'Gruppenzuweisungsbefehl';

  @override
  String get docType23Family => 'Basisstation & Netzwerk';

  @override
  String get docType23Summary =>
      'Ein Befehl einer Basisstation an eine Gruppe von Fahrzeugen in einer Zone, der Meldeintervalle und Übertragungsmodus festlegt.';

  @override
  String get docType23EmittedBy => 'Basisstationen';

  @override
  String get docType23Cadence => 'Auf Anfrage';

  @override
  String get docType24Name => 'Statische Datenmeldung';

  @override
  String get docType24Family => 'Statische & Reisedaten';

  @override
  String get docType24Summary =>
      'Das Klasse-B-Pendant zu Typ 5, aufgeteilt in Teil A (Name) und Teil B (Schiffstyp, Rufzeichen, Abmessungen).';

  @override
  String get docType24EmittedBy => 'Klasse-B-Transponder';

  @override
  String get docType24Cadence => 'Alle 6 min';

  @override
  String get docType25Name => 'Binäre Einzel-Slot-Nachricht';

  @override
  String get docType25Family => 'Binärdaten';

  @override
  String get docType25Summary =>
      'Eine kurze Binärnachricht, die in einen einzigen TDMA-Slot passt, mit optionalem Ziel und Anwendungs-ID.';

  @override
  String get docType25EmittedBy => 'Jede Station';

  @override
  String get docType25Cadence => 'Auf Anfrage';

  @override
  String get docType26Name => 'Binäre Mehrfach-Slot-Nachricht';

  @override
  String get docType26Family => 'Binärdaten';

  @override
  String get docType26Summary =>
      'Eine längere Binärnachricht über mehrere TDMA-Slots, die Funkstatus-Informationen überträgt.';

  @override
  String get docType26EmittedBy => 'Jede Station';

  @override
  String get docType26Cadence => 'Auf Anfrage';

  @override
  String get docType27Name => 'Positionsmeldung für Langstreckenanwendungen';

  @override
  String get docType27Family => 'Positionsmeldungen';

  @override
  String get docType27Summary =>
      'Eine sehr kompakte Positionsmeldung für den Satellitenempfang über große Entfernungen, mit reduzierter Auflösung.';

  @override
  String get docType27EmittedBy => 'Fahrzeuge im Langstreckenmodus (Satellit)';

  @override
  String get docType27Cadence => 'Alle 3 min (Langstreckenmodus)';

  @override
  String get docTimeline1990sTitle => 'Eine schwedische Erfindung';

  @override
  String get docTimeline1990sText =>
      'Das Konzept entsteht in Schweden: ein VHF-System, bei dem sich jedes Schiff selbst meldet, damit andere „sehen und gesehen werden“, selbst bei Nebel und hinter Inseln. Es wird der IMO vorgestellt und wird zum Keim des AIS.';

  @override
  String get docTimeline1998Title => 'Die Normierung beginnt';

  @override
  String get docTimeline1998Text =>
      'ITU und IEC beginnen, das Konzept in einen Funkstandard mit präzisen Formaten auf Bitebene zu verwandeln, basierend auf TDMA über zwei VHF-Kanäle.';

  @override
  String get docTimeline2001Title => 'ITU-R M.1371 veröffentlicht';

  @override
  String get docTimeline2001Text =>
      'Die Empfehlung ITU-R M.1371 „Technical characteristics for a universal shipborne automatic identification system“ definiert die 27 Nachrichtentypen und ihr Bit-Layout.';

  @override
  String get docTimeline2002Title => 'SOLAS-Verpflichtung';

  @override
  String get docTimeline2002Text =>
      'Die IMO macht AIS für alle internationalen Schiffe über 300 Bruttotonnen und alle Fahrgastschiffe verpflichtend — etwa 100.000 Schiffe. AIS wird neben dem Radar zum Standardmittel gegen Kollisionen.';

  @override
  String get docTimeline2006Title => 'Klasse B kommt';

  @override
  String get docTimeline2006Text =>
      'Der Klasse-B-Standard wird veröffentlicht und ebnet den Weg für günstige, einfachere Transponder. Im selben Jahr fängt der Satellit TacSat-2 als erster AIS-Signale aus dem Weltraum ein (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Satellitenkonstellationen';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire und andere betreiben AIS-Empfänger in erdnahen Umlaufbahnen, erweitern die Abdeckung weit über den VHF-Horizont hinaus und ermöglichen eine nahezu globale Schiffsverfolgung.';

  @override
  String get docTimeline2010Title => 'AIS-SART im GMDSS';

  @override
  String get docTimeline2010Text =>
      'Der AIS-Such- und Rettungssender (AIS-SART, IEC 61097-14) kommt zum Global Maritime Distress and Safety System hinzu und ermöglicht es Rettungsbooten, Notpositionen über AIS zu senden.';

  @override
  String get docTimeline2014Title => 'Fischerei & Binnenflotten';

  @override
  String get docTimeline2014Text =>
      'Europäische Regeln verlangen Klasse-A-AIS auf allen EU-Fischereifahrzeugen über 15 m; AIS für die Binnenschifffahrt ist auf europäischen Flüssen weit verbreitet.';

  @override
  String get docTimeline2021Title => '1,6 Millionen Schiffe';

  @override
  String get docTimeline2021Text =>
      'Mehr als 1,6 Millionen Fahrzeuge sind mit AIS ausgestattet und speisen terrestrische und Satellitennetze, die weltweit Schiffsverfolgung, Fischereikontrolle und maritime Sicherheit unterstützen.';

  @override
  String get docTimelineVdesTitle => 'VDES — der Nachfolger';

  @override
  String get docTimelineVdesText =>
      'Das VHF Data Exchange System (ITU-R M.2092) wird ausgerollt, um überlastete Gebiete zu entlasten und deutlich mehr Bandbreite sowie sichere E-Navigation-Dienste zu bieten.';

  @override
  String get docAppTitle => 'Dokumentation';

  @override
  String get docSearchChapters => 'Kapitel durchsuchen';

  @override
  String get docChapterOverview => 'Überblick';

  @override
  String get docChapterHistory => 'Geschichte & Regulierung';

  @override
  String get docChapterHowItWorks => 'So funktioniert es';

  @override
  String get docChapterRadio => 'Funk & TDMA';

  @override
  String get docChapterClasses => 'Klassen & Ausrüstung';

  @override
  String get docChapterMmsi => 'MMSI & Identität';

  @override
  String get docChapterShipTypes => 'Schiffstypen';

  @override
  String get docChapterMessages => 'Die 27 Nachrichten';

  @override
  String get docChapterNmea => 'NMEA & AIVDM';

  @override
  String get docChapterPayload => 'Im Inneren des Payloads';

  @override
  String get docChapterSecurity => 'Sicherheit & Grenzen';

  @override
  String get docChapterFieldNotes => 'Praxishinweise';

  @override
  String get docChapterKikais => 'AIS in KikAis';

  @override
  String get docChapterGlossary => 'Glossar';

  @override
  String get docChapterCheatSheet => 'Spickzettel';

  @override
  String get docChapterSources => 'Quellen';

  @override
  String get docOverviewTitle => 'Was ist AIS?';

  @override
  String get docOverviewIntro =>
      'Das Automatic Identification System (AIS) ist ein Ortungssystem, das auf Schiffen und von Verkehrsleitsystemen (VTS) eingesetzt wird. Jedes ausgerüstete Fahrzeug sendet kontinuierlich Identität, Position, Kurs und Geschwindigkeit über VHF-Funk, sodass jedes andere Schiff und jede Küstenstation in Reichweite es „sehen“ kann — das Konzept „sehen und gesehen werden“.';

  @override
  String get docOverviewRadar =>
      'AIS ersetzt kein Schiffsradar. Radar erkennt jedes Objekt unabhängig, verrät aber wenig darüber, wer es ist. AIS sagt dir genau, wer, wo und wohin — aber es vertraut dem, was der Sender angibt. Die beiden Systeme ergänzen sich.';

  @override
  String get docOverviewAdsBTitle => 'Stell es dir als maritimes ADS-B vor';

  @override
  String get docOverviewAdsBText =>
      'So wie ADS-B es Flugzeugen ermöglicht, sich bei der Flugsicherung zu melden, ermöglicht AIS Schiffen, sich untereinander und gegenüber dem Land zu melden. Schiffe sehen den umliegenden Verkehr auf einem Kartenplotter oder einem radarähnlichen Display; Hafenbehörden überwachen Bewegungen und Fischerei.';

  @override
  String get docOverviewTransponder => 'Was ein Transponder sendet';

  @override
  String get docOverviewBullet1 =>
      'Eindeutige Identität: eine 9-stellige MMSI-Nummer (deren erste drei Ziffern das ausstellende Land kennzeichnen).';

  @override
  String get docOverviewBullet2 =>
      'Dynamische Daten: Position, Geschwindigkeit über Grund (SOG), Kurs über Grund (COG), rechtweisender Kurs, Drehrate, Navigationsstatus.';

  @override
  String get docOverviewBullet3 =>
      'Statische & Reisedaten: Name, Rufzeichen, IMO-Nummer, Schiffstyp, Abmessungen, Tiefgang, Ziel, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Sicherheits- und Binärmeldungen: Nottexte, Wetterberichte, Netzwerkbefehle.';

  @override
  String get docOverviewWho => 'Wer es mitführen muss';

  @override
  String get docOverviewImo =>
      'Die IMO (SOLAS-Abkommen) schreibt AIS auf internationalen Schiffen über 300 Bruttotonnen und auf allen Fahrgastschiffen vor. Regionale Regeln erweitern dies auf Fischereiflotten, Binnenwasserstraßen und zunehmend auf Freizeitboote über günstige Klasse-B-Transponder.';

  @override
  String get docOverviewLimits => 'Grenzen auf einen Blick';

  @override
  String get docOverviewLimit1 =>
      'Die Reichweite entspricht etwa der Sichtlinie: ungefähr 10-20 Seemeilen von Schiff zu Schiff, von Küstenstationen und Satelliten aus mehr.';

  @override
  String get docOverviewLimit2 =>
      'AIS hat keine Authentifizierung: Jeder kann eine beliebige Identität senden (Spoofing) oder den Kanal stören.';

  @override
  String get docOverviewLimit3 =>
      'Die Genauigkeit hängt vom GNSS-Fix des Senders und von der Ehrlichkeit der von ihm gemeldeten Daten ab.';

  @override
  String get docHistoryIntro =>
      'AIS entwickelte sich von einer schwedischen Idee zu einem weltweit verpflichtenden Sicherheitssystem. Tippe für Details auf einen beliebigen Meilenstein der Zeitleiste.';

  @override
  String get docHistoryStandards => 'Die maßgeblichen Standards';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — Technische Merkmale für ein universelles schiffsgestütztes AIS (definiert die 27 Nachrichtentypen und deren Bit-Layout).';

  @override
  String get docHistoryStd2 =>
      'IALA-Richtlinien — Klarstellungen und Umsetzungshinweise.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — das NMEA-Satzformat und die Anforderungen für Klasse B/CSTDMA.';

  @override
  String get docHistoryStd4 => 'IEC 61097-14 — der AIS-SART-Notfunksender.';

  @override
  String get docHowIntro =>
      'AIS ist ein VHF-Funksystem. Jeder Transponder hört den Verkehr um sich herum ab und sendet seine eigenen Meldungen in reservierten Zeitschlitzen, um Kollisionen mit den anderen Schiffen in Reichweite zu vermeiden.';

  @override
  String get docHowRadioLink => 'Die Funkverbindung';

  @override
  String get docHowRadioLink1 =>
      'Zwei eigene VHF-Kanäle: AIS 1 auf 161.975 MHz (87B) und AIS 2 auf 162.025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'Digitales Schmalband-FM mit 9 600 Bit pro Sekunde.';

  @override
  String get docHowRadioLink3 =>
      'Nachrichten sind in TDMA-Frames mit 2250 Zeitschlitzen (1 Minute) organisiert.';

  @override
  String get docHowSlots => 'Wie Slots geteilt werden';

  @override
  String get docHowSotdma =>
      'Klasse-A-Transponder verwenden SOTDMA (Self-Organizing Time Division Multiple Access): Jede Einheit reserviert einen sich wiederholenden Slot und reserviert neu, wenn sich das Bild ändert — so koordinieren sich Schiffe kontinuierlich ohne zentrale Steuerung.';

  @override
  String get docHowCstdma =>
      'Klasse-B-Transponder verwenden das einfachere CSTDMA (Carrier Sense TDMA): Sie hören auf einen freien Slot und belegen ihn — deshalb sind Klasse-B-Meldungen seltener und können in sehr dichtem Verkehr verloren gehen.';

  @override
  String get docHowRates => 'Melderaten';

  @override
  String get docHowRates1 =>
      'Klasse-A-Positionsmeldung (Typ 1): alle 2-10 Sekunden in Fahrt, alle 3 Minuten vor Anker.';

  @override
  String get docHowRates2 => 'Statische & Reisedaten (Typ 5): alle 6 Minuten.';

  @override
  String get docHowRates3 =>
      'Klasse-B-Position (Typ 18): ungefähr alle 30 Sekunden.';

  @override
  String get docHowRates4 => 'Schifffahrtszeichen (Typ 21): alle 3 Minuten.';

  @override
  String get docHowTerrestrial => 'Terrestrisch und Satellit';

  @override
  String get docHowTerrestrialText =>
      'An der Oberfläche ist die AIS-Reichweite durch den VHF-Horizont begrenzt (T-AIS). Seit Mitte der 2000er Jahre empfangen Satelliten in erdnaher Umlaufbahn (S-AIS) dieselben Signale und ermöglichen eine nahezu globale Abdeckung — Satelliten ergänzen das terrestrische Netz, statt es zu ersetzen.';

  @override
  String get docRadioIntro =>
      'Unter den Nachrichten liegt ein kleines, effizientes Funksystem. AIS sendet mit 9 600 Bit pro Sekunde auf zwei VHF-Kanälen und verwendet Gaussian Minimum Shift Keying (GMSK) und HDLC-artiges Framing.';

  @override
  String get docRadioPhysical => 'Die physikalische Verbindung';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 auf 161.975 MHz und AIS 2 auf 162.025 MHz (VHF-Kanäle 87B und 88B).';

  @override
  String get docRadioPhysical2 =>
      'GMSK-Modulation mit 9 600 Baud — schmal genug für das maritime VHF-Band.';

  @override
  String get docRadioPhysical3 =>
      'HDLC-Framing mit Bitstopfen und NRZI-Leitungskodierung, geerbt aus der Welt des Paketfunks.';

  @override
  String get docRadioFrames => 'TDMA-Frames und Slots';

  @override
  String get docRadioFrames1 =>
      'Jeder Kanal ist in Frames von exakt 1 Minute unterteilt, aufgeteilt in 2 250 Zeitschlitze von je ~26,7 ms.';

  @override
  String get docRadioFrames2 =>
      'Ein Slot trägt eine AIS-Nachricht (256 Bits mit Anlauf/Auslauf und Schutzzeit).';

  @override
  String get docRadioFrames3 =>
      'Stationen verwenden dieselben Slots in jedem Frame wieder und senden so periodisch, ohne zu kollidieren.';

  @override
  String get docRadioCode =>
      '2250 Slots/Frame · 1 Frame = 60 s · Slot ≈ 26,7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — wie sich Klasse A selbst organisiert';

  @override
  String get docRadioSotdmaText =>
      'Jeder Klasse-A-Transponder hört die Slots um sich herum ab, wählt einen freien aus und kündigt in seinem Funkstatus-Feld an, wann er als Nächstes sendet. Stationen reservieren kontinuierlich neu, wenn sich das Verkehrsbild ändert — ein zentraler Koordinator ist also nicht nötig.';

  @override
  String get docRadioCstdma => 'CSTDMA — wie Klasse B einsteigt';

  @override
  String get docRadioCstdmaText =>
      'Klasse-B-Geräte sind einfacher: Sie suchen einen aktuell freien Slot und senden einmal darin. Das ist günstiger, aber Klasse-B-Meldungen können in sehr dichtem Verkehr verloren gehen, in dem ein Slot immer belegt ist.';

  @override
  String get docRadioVdes => 'VDES — die Zukunft';

  @override
  String get docRadioVdesText =>
      'Das VHF Data Exchange System (ITU-R M.2092) wird ausgerollt, um überlastete Gewässer zu entlasten: Es ergänzt den bestehenden AIS-Dienst um neue Frequenzen, deutlich mehr Bandbreite und sicheren bidirektionalen Datenaustausch für die E-Navigation.';

  @override
  String get docClassesIntro =>
      'AIS-Hardware gibt es in verschiedenen Klassen und Rollen. Die beiden, die du am häufigsten siehst, sind der vollwertige Klasse-A-Transponder und das günstige Klasse-B-Gerät.';

  @override
  String get docClassesComparison => 'Klasse A vs. Klasse B';

  @override
  String get docClassesReceivers => 'Empfänger und Transponder';

  @override
  String get docClassesReceiversText =>
      'Transponder empfangen und senden. Viele Küstenstationen und Hobbyisten betreiben nur Empfänger, um den Verkehr zu beobachten, ohne selbst aufzutauchen.';

  @override
  String get docClassesAton => 'Schifffahrtszeichen';

  @override
  String get docClassesAtonText =>
      'AtoN-Stationen (Typ 21) senden Bojen, Baken und Leuchttürme. Sie können auch ein virtuelles Zeichen aussenden — eine Markierung, die nur auf Karten existiert und nützlich ist, um vor neuen Gefahren zu warnen.';

  @override
  String get docClassesDistress => 'Not- & Sicherheitsgeräte';

  @override
  String get docClassesDistressIntro =>
      'Neben normalen Schiffen überträgt AIS auch Notsender, die jeder Empfänger erkennen können sollte:';

  @override
  String get docClassesSartNote =>
      'Ein aktiver SART setzt in seiner Positionsmeldung außerdem den Navigationsstatus 14 („AIS-SART aktiv“).';

  @override
  String get docShipTypesIntro =>
      'Die statischen Meldungen der Typen 5 und 24 enthalten einen 8-Bit-Schiffstypscode (0-99), der beschreibt, was das Fahrzeug ist — Frachtschiff, Tanker, Fischerboot, Sportboot usw. Die vollständige Tabelle ist unten dargestellt.';

  @override
  String get docShipTypesCategories => 'Kategorien auf einen Blick';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle =>
      'Praxishinweise & Eigenheiten aus der Praxis';

  @override
  String get docFieldNotesIntro =>
      'Echter AIS-Verkehr entspricht nicht immer der Theorie. Wer diese Eigenheiten kennt, kann dem vertrauen, was der Decoder anzeigt — und was er ablehnt.';

  @override
  String get docGlossaryIntro =>
      'Ein durchsuchbares Wörterbuch der Abkürzungen und Begriffe, die in diesem Leitfaden und in der AIS-Community verwendet werden.';

  @override
  String get docCheatSheetIntro =>
      'Die wichtigsten Zahlen und Codes auf einen Blick — Frequenzen, Melderaten, Statuscodes und Formate.';

  @override
  String get docMmsiIntro =>
      'Die Maritime Mobile Service Identity (MMSI) ist eine eindeutige 9-stellige Nummer, die die Funkausrüstung eines Schiffs kennzeichnet — wie eine Telefonnummer des Fahrzeugs. Ihre ersten drei Ziffern bilden die MID — die Maritime Identification Digits, die das ausstellende Land kennzeichnen.';

  @override
  String get docMmsiFormats => 'Zahlenformate';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Eine MMSI nachschlagen';

  @override
  String get docMmsiLookupHint =>
      'Gib unten eine 9-stellige MMSI ein, um ihre Klasse und das Land der ausstellenden Behörde zu sehen.';

  @override
  String get docMmsiMidHeading => 'Ländercodes (MID)';

  @override
  String get docMmsiMidText =>
      'Die vollständige MID-Tabelle ist in KikAis enthalten und wird überall dort verwendet, wo eine MMSI angezeigt wird.';

  @override
  String get docMessagesTitle => 'Die 27 Nachrichtentypen';

  @override
  String get docMessagesIntro =>
      'Jeder AIS-Payload beginnt mit einem 6-Bit-Nachrichtentyp (1 bis 27). Der Katalog unten gruppiert sie nach Familien. Jede Karte zeigt einen echten NMEA-Satz, der mit dem eigenen Encoder von KikAis erzeugt wurde, seine dekodierten Felder und einen Button zum Öffnen im Decoder.';

  @override
  String get docNmeaTitle => 'NMEA- & AIVDM-Format';

  @override
  String get docNmeaIntro =>
      'Über die Leitung werden AIS-Nachrichten als NMEA-0183-Sätze übertragen, die mit !AIVDM (andere Schiffe) oder !AIVDO (das eigene Schiff) beginnen. Der Payload ist ein ASCII-kodierter Bitvektor.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Satzfelder';

  @override
  String get docNmeaField1 =>
      'Talker & Formatter — !AIVDM oder !AIVDO (siehe Talker-IDs unten).';

  @override
  String get docNmeaField2 =>
      'Anzahl der Fragmente — aus wie vielen Sätzen die vollständige Nachricht besteht (NMEA begrenzt jede Zeile auf ~82 Zeichen).';

  @override
  String get docNmeaField3 =>
      'Fragmentnummer — um welchen Teil es sich handelt (1-basiert).';

  @override
  String get docNmeaField4 =>
      'Sequenzielle Nachrichten-ID — verbindet Fragmente derselben Nachricht.';

  @override
  String get docNmeaField5 => 'Funkkanal — A oder B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Daten-Payload — der sechsbitige, kodierte AIS-Payload.';

  @override
  String get docNmeaField7 =>
      'Füllbits — wie viele Pad-Bits zur letzten 6-Bit-Gruppe hinzugefügt wurden (0-5).';

  @override
  String get docNmeaField8 =>
      'Prüfsumme — das XOR aller Bytes vor dem *, in hexadezimaler Darstellung.';

  @override
  String get docNmeaMulti => 'Mehrfragment-Nachrichten';

  @override
  String get docNmeaMultiText =>
      'Nachrichten, die länger als eine Zeile sind (wie die statischen Daten von Typ 5), werden aufgeteilt: Der erste Satz meldet eine Fragmentanzahl von 2, der zweite vervollständigt die Nachricht mit derselben Nachrichten-ID.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Sechsbit-Kodierung';

  @override
  String get docNmeaArmoringText =>
      'Jedes Payload-Zeichen enthält 6 Bits. Ziehe 48 vom ASCII-Code ab und ziehe dann weitere 8 ab, wenn das Ergebnis über 40 liegt.';

  @override
  String get docNmeaTalkers => 'Talker-IDs';

  @override
  String get docNmeaTalkersIntro =>
      'Verschiedene NMEA-4.0-Talker-IDs kennzeichnen den Typ der AIS-Station:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Prüfsumme';

  @override
  String get docNmeaChecksumText =>
      'Die abschließende Prüfsumme ist das XOR aller Bytes zwischen „!“ und „*“. Berechne deine eigene unten:';

  @override
  String get docNmeaInspectorTitle => 'Probier es aus: Satzinspektor';

  @override
  String get docNmeaInspectorText =>
      'Füge einen beliebigen AIVDM/AIVDO-Satz ein (oder verwende ein Beispiel oben), um die aufgeschlüsselten Felder und die dekodierten Werte zu sehen.';

  @override
  String get docPayloadIntro =>
      'Nach der Dekodierung der Sechsbit-Kodierung ist ein AIS-Payload eine Folge von Bitfeldern. Die ersten sechs Bits sind der Nachrichtentyp, die nächsten zwei der Wiederholungsanzeiger, danach folgen 30 Bits MMSI.';

  @override
  String get docPayloadCnb => 'Der Common Navigation Block (Typen 1-3)';

  @override
  String get docPayloadCnbText =>
      'Das wichtigste Layout teilen sich die Klasse-A-Positionsmeldungen. Verwende den Auswahlregler, um die wichtigsten Nachrichtenlayouts zu durchsuchen, und klicke auf ein Segment, um zu lesen, was es kodiert.';

  @override
  String get docPayloadCoords => 'Koordinaten';

  @override
  String get docPayloadCoordsText =>
      'Breiten- und Längengrad werden in 1/10 000 Minute gespeichert. Durch 600 000 dividieren, um Grad zu erhalten: 60 Minuten pro Grad und 10 000 Einheiten pro Minute. Ost/Nord sind positiv.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert =>
      'Rechne unten deine eigenen Koordinaten um:';

  @override
  String get docPayloadSpeed => 'Geschwindigkeit, Kurs, Heading';

  @override
  String get docPayloadSpeed1 =>
      'SOG — Geschwindigkeit über Grund in Zehntelknoten (0-102,2 kn); 1023 bedeutet „nicht verfügbar“.';

  @override
  String get docPayloadSpeed2 =>
      'COG — Kurs über Grund in Zehntelgrad, bezogen auf den geografischen Norden.';

  @override
  String get docPayloadSpeed3 =>
      'Heading — rechtweisender Kurs in ganzen Graden; 511 bedeutet „nicht verfügbar“.';

  @override
  String get docPayloadSpeed4 =>
      'ROT — Drehrate: Wert ≈ 4,733 × √(Drehgeschwindigkeit in °/min), vorzeichenbehaftet (positiv = rechts).';

  @override
  String get docPayloadNavStatus => 'Navigationsstatus';

  @override
  String get docPayloadEpfd => 'Positionsart (EPFD)';

  @override
  String get docPayloadText => 'Sechsbit-Text';

  @override
  String get docPayloadTextIntro =>
      'Namen, Rufzeichen und Ziele verwenden dasselbe Sechsbit-Alphabet wie der Payload selbst. Kleinbuchstaben können nicht kodiert werden, weshalb AIS-Namen üblicherweise in Großbuchstaben stehen.';

  @override
  String get docSecurityTitle => 'Sicherheit & Datenqualität';

  @override
  String get docSecurityIntro =>
      'AIS ist für Kooperation ausgelegt, nicht für Sicherheit. Der Funkkanal ist offen und unverschlüsselt, und es gibt keine Authentifizierung des Senders.';

  @override
  String get docSecurityThreats => 'Bedrohungen';

  @override
  String get docSecurityThreat1 =>
      'Spoofing — Senden einer gefälschten MMSI, Position oder Identität (Geisterschiffe, Sanktionsumgehung).';

  @override
  String get docSecurityThreat2 =>
      'Jamming — die beiden VHF-Kanäle so überfluten, dass echter Verkehr nicht mehr empfangen werden kann.';

  @override
  String get docSecurityThreat3 =>
      'Meaconing — echte Signale von anderswo erneut senden, um Empfänger zu verwirren.';

  @override
  String get docSecurityQuality => 'Datenqualität';

  @override
  String get docSecurityQuality1 =>
      'Das Genauigkeitsbit unterscheidet einen unverbesserten GNSS-Fix (> 10 m) von einem Fix in DGPS-Qualität (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'Empfänger sollten Positionen, Geschwindigkeiten und Zeitstempel plausibilisieren; etwa 0,3 % der realen Nachrichten haben eine fehlerhafte Payload-Länge.';

  @override
  String get docSecurityQuality3 =>
      'Satelliten-AIS leidet gelegentlich unter Kollisionen, weil der Satelliten-Fußabdruck viel größer ist als eine TDMA-Zelle — ein weiterer Grund, mit Radar und anderen Quellen abzugleichen.';

  @override
  String get docKikaisIntro =>
      'KikAis ist ein vollwertiges AIS-Labor: Empfange Live- oder simulierten Verkehr, dekodiere ihn, prüfe und sende eigene Nachrichten und baue Flotten. So ordnet sich jede Registerkarte dem eben Gelesenen zu.';

  @override
  String get docTabReceptionText =>
      'Feeds wählen (Datei, seriell, Simulation), den Forwarder starten und den rohen NMEA-Datenstrom sowie die dekodierten Boote beobachten.';

  @override
  String get docTabSendText =>
      'Empfangene Sätze an ein oder mehrere TCP/UDP-Ziele weiterleiten — so würde eine Küstenstation Verkehr verteilen.';

  @override
  String get docTabMapText =>
      'Dekodierte Fahrzeuge sehen, die aus ihren Positionsmeldungen der Typen 1/2/3, 18, 19 und 27 eingezeichnet werden.';

  @override
  String get docTabEditorText =>
      'Einen der 27 Nachrichtentypen von Hand über ein übersichtliches Formular erstellen und senden — der beste Weg, die Felder zu lernen.';

  @override
  String get docTabDecoderText =>
      'Einen beliebigen Satz einfügen und dekodierte Felder, Prüfsumme und Fragmentbearbeitung erhalten — der praktische Begleiter zu diesem Leitfaden.';

  @override
  String get docTabStatsText =>
      'Nachrichtenzähler, Raten pro Feed und Decoder-Zustand (ungültige Prüfsummen, verworfene Fragmente).';

  @override
  String get docTabSimulationText =>
      'Eine ganze Flotte um jeden Ort erzeugen — jeden Nachrichtentyp, MMSI-Schema, Zonenform und sogar Fehlerinjektion.';

  @override
  String get docSourcesIntro =>
      'Dieser Leitfaden fasst öffentlich verfügbare, maßgebliche Dokumentation zusammen:';

  @override
  String get docSources1 =>
      'gpsd — AIVDM/AIVDO-Protokolldekodierung, von Eric S. Raymond (die faktische technische Bibel für das Satzformat und die Payload-Bitfelder).';

  @override
  String get docSources2 =>
      'Wikipedia — Automatic Identification System (Überblick, Geschichte, Anwendungen, Sicherheit).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — AIS-Seiten.';

  @override
  String get docSources4 =>
      'ITU-R-Empfehlung M.1371 — der maßgebliche AIS-Standard.';

  @override
  String get docSources5 => 'IALA — Klarstellungen zu ITU-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA-Format, Klasse B und AIS-SART.';

  @override
  String get docSourcesLearn => 'So lernst du mehr';

  @override
  String get docSourcesLearnText =>
      'Der beste Weg, AIS zu verstehen, ist zu experimentieren: den Editor zum Erstellen von Nachrichten nutzen, den Decoder zum Auslesen und die Registerkarte Simulation, um eine ganze Flotte zu beobachten. Alles in diesem Leitfaden wird mit dem eigenen Encoder und Decoder von KikAis erzeugt.';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return 'Typ $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits Bits · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return 'Gesendet von: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Im Decoder öffnen';

  @override
  String get docInspectorNmeaLabel => 'NMEA-Satz';

  @override
  String get docInspectorInspect => 'Untersuchen';

  @override
  String get docInspectorInvalidChecksum => 'Ungültige Prüfsumme';

  @override
  String get docInspectorCouldNotDecode => 'Konnte nicht dekodiert werden';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Dekodiert: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Typ $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 Ziffern)';

  @override
  String get docMmsiLookupButton => 'Nachschlagen';

  @override
  String get docMmsiLookupError =>
      'Gib eine 9-stellige MMSI ein (nur Ziffern).';

  @override
  String get docMmsiLookupClassGroup => 'Schiffsgruppe (Gruppenruf)';

  @override
  String get docMmsiUnknownCountry => 'unbekanntes Land';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Öffnen';

  @override
  String get updateCheckForUpdates => 'Nach Updates suchen';

  @override
  String get updateChecking => 'Suche nach Updates…';

  @override
  String updateNewVersion(Object version) {
    return 'Neue Version $version';
  }

  @override
  String get updateUpToDate => 'Sie sind auf dem neuesten Stand.';

  @override
  String get updateCheckFailed => 'Update-Suche fehlgeschlagen.';

  @override
  String get tooltipLanguage =>
      'Sprache der Benutzeroberfläche ändern. Alle zehn Sprachen sind vollständig übersetzt; „Auto“ folgt der Sprache des Betriebssystems.';

  @override
  String get tooltipTheme =>
      'Farbschema wechseln: dunkel, hell oder hoher Kontrast. Hoher Kontrast verbessert die Lesbarkeit.';

  @override
  String get tooltipUpdate =>
      'Nach einer neuen Version suchen. Wenn eine verfügbar ist, erscheint ein grünes Abzeichen neben der Versionsnummer.';

  @override
  String get tooltipMapSearch =>
      'Ein Schiff nach Name, MMSI oder IMO-Nummer suchen und die Karte darauf zentrieren und ihm folgen.';

  @override
  String get tooltipMapFilters =>
      'Angezeigte Schiffe filtern: nach Typ, Navigationsstatus, Land (MID), Geschwindigkeit oder nur Namen.';

  @override
  String get tooltipMapCluster =>
      'Schiffs-Clustering umschalten. Wenn aktiviert, werden nahe Schiffe zu einem Marker mit Zähler zusammengefasst.';

  @override
  String get tooltipMapTrails =>
      'Spuren umschalten. Wenn aktiviert, zeichnet jedes Schiff seinen letzten Weg auf der Karte.';

  @override
  String get tooltipMapVectors =>
      'Kursvektoren umschalten. Wenn aktiviert, zeigt jedes Schiff einen Pfeil in Fahrtrichtung.';

  @override
  String get tooltipMapSendToMap =>
      'Übertragung dekodierter Schiffe auf die Karte umschalten. Wenn aktiviert, erscheint jedes dekodierte Schiff als Marker.';

  @override
  String get tooltipMapClear =>
      'Entfernt alle derzeit auf der Karte befindlichen Schiffe.';

  @override
  String get tooltipMapBasemap =>
      'Kartenhintergrund wählen. „Auto“ folgt dem aktuellen Thema.';

  @override
  String get tooltipSendAdd =>
      'Ein neues Sendeziel hinzufügen (UDP oder TCP, Client oder Server). Eingehende AIS-Frames werden an jedes aktivierte Ziel weitergeleitet.';

  @override
  String get tooltipSendEdit =>
      'Name, Protokoll, Host, Port und Frame-Format dieses Ziels bearbeiten.';

  @override
  String get tooltipSendDelete =>
      'Dieses Ziel löschen. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get tooltipSendToggle =>
      'Weiterleitung an dieses Ziel aktivieren oder deaktivieren.';

  @override
  String get tooltipSendLocked =>
      'Die Ziele sind gesperrt, solange der Forwarder läuft. Stoppen Sie die Quelle auf der Registerkarte Empfang, um sie zu bearbeiten.';

  @override
  String get tooltipReceptionAddSource =>
      'Eine Datenquelle hinzufügen: einen Netzwerk-Feed (UDP/TCP/gpsd), eine Datei mit aufgezeichneten NMEA-Sätzen oder einen seriellen Port.';

  @override
  String get tooltipReceptionStart =>
      'Empfang und Weiterleitung von AIS-Frames aus allen aktivierten Quellen starten.';

  @override
  String get tooltipReceptionStop =>
      'Empfang und Weiterleitung von AIS-Frames stoppen.';

  @override
  String get tooltipReceptionFeed =>
      'Diese AIS-Quelle aktivieren oder deaktivieren.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Das Verbindungsprotokoll in eine Textdatei speichern.';

  @override
  String get tooltipReceptionClearLogs => 'Das Verbindungsprotokoll löschen.';

  @override
  String get tooltipReceptionRemoveSource => 'Diese AIS-Quelle entfernen.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Wenn aktiviert, werden Frames mit ungültiger NMEA-Prüfsumme verworfen.';

  @override
  String get tooltipReceptionImportFormat =>
      'Wie empfangene Frames vor dem Dekodieren normalisiert werden.';

  @override
  String get tooltipReceptionLoop =>
      'Wenn aktiviert, startet die Dateiwiedergabe nach dem Ende wieder von vorn.';

  @override
  String get tooltipReceptionSpeed =>
      'Wiedergabegeschwindigkeit (1x = Echtzeit).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Liste der verfügbaren seriellen Ports aktualisieren.';

  @override
  String get tooltipSimApply =>
      'Aktuelle Einstellungen anwenden und die Flotte generieren. Große Flotten werden im Hintergrund generiert.';

  @override
  String get tooltipSimGenerate =>
      'Eine neue zufällige Flotte mit einem neuen Seed generieren und dann anwenden.';

  @override
  String get tooltipSimOpenReception =>
      'Zur Registerkarte Empfang gehen, um den Simulations-Feed zu starten.';

  @override
  String get tooltipSimRadius =>
      'Radius der Navigationszone um den Mittelpunkt, in Kilometern.';

  @override
  String get tooltipSimVessels =>
      'Anzahl der zu generierenden Schiffe in der Flotte.';

  @override
  String get tooltipSimSpeedMin =>
      'Mindestgeschwindigkeit der Schiffe, in Knoten.';

  @override
  String get tooltipSimSpeedMax =>
      'Höchstgeschwindigkeit der Schiffe, in Knoten.';

  @override
  String get tooltipSimInterval =>
      'Verzögerung zwischen zwei Emissions-Ticks, in Sekunden.';

  @override
  String get tooltipSimSeed =>
      'Zufallsseed. Derselbe Seed erzeugt immer dieselbe Flotte.';

  @override
  String get tooltipSimAnchored =>
      'Prozentsatz der Schiffe, die ankern oder vertäut bleiben statt sich zu bewegen.';

  @override
  String get tooltipSimNamePrefix => 'Präfix für die generierten Schiffsnamen.';

  @override
  String get tooltipSimMmsiMid =>
      'Maritime Identifikationsziffern (3-stelliger Ländercode) für den MMSI-Aufbau.';

  @override
  String get tooltipSimCenterLat =>
      'Breitengrad des Zentrums der Navigationszone.';

  @override
  String get tooltipSimCenterLon =>
      'Längengrad des Zentrums der Navigationszone.';

  @override
  String get tooltipSimTransit =>
      'Prozentsatz der Schiffe, die die Zone auf direkter Route durchqueren.';

  @override
  String get tooltipSimRegenEvery =>
      'Flotte alle N Ticks neu generieren, wenn periodische Regenerierung aktiviert ist.';

  @override
  String get tooltipSimReportInterval =>
      'Maximales Positionsberichtsintervall pro Schiff, in Ticks.';

  @override
  String get tooltipSimWander =>
      'Stärke der zufälligen Kursabweichung (0 = gerade Linien).';

  @override
  String get tooltipSimClassBShare =>
      'Anteil von Klasse-B- gegenüber Klasse-A-Positionsberichten, wenn beide aktiviert sind.';

  @override
  String get tooltipSimErrorRate =>
      'Wahrscheinlichkeit, jeden ausgegebenen Satz zu beschädigen oder zu duplizieren.';

  @override
  String get tooltipSimBaseStations =>
      'Anzahl der zu generierenden festen Basisstationen.';

  @override
  String get tooltipSimAtoN =>
      'Anzahl der zu generierenden festen Navigationshilfen (Baken).';

  @override
  String get tooltipSimRealisticNames =>
      'Realistische Schiffsnamen, Rufzeichen und Ziele verwenden.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Schiffsmaße und Tiefgang nach Schiffstyp skalieren.';

  @override
  String get tooltipSimRealisticMmsi =>
      'MMSIs entsprechend der ITU-Struktur je Schiffskategorie aufbauen.';

  @override
  String get tooltipSimVarySpeed =>
      'Die Geschwindigkeit innerhalb des konfigurierten Bereichs sanft driften lassen.';

  @override
  String get tooltipSimSpeedByType =>
      'Die Geschwindigkeit aus dem typischen Bereich jedes Schiffstyps wählen.';

  @override
  String get tooltipSimHighAccuracy =>
      'Das Hochpräzisions-Positionsflag auf ausgegebenen Berichten setzen.';

  @override
  String get tooltipSimRealisticRot =>
      'Eine aus der Kursänderung abgeleitete Drehrate ausgeben.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Flotte automatisch alle N Ticks neu generieren, um wechselnden Verkehr zu simulieren.';

  @override
  String get tooltipSimInjectErrors =>
      'Einige ausgegebene Sätze beschädigen oder duplizieren, um die Fehlerbehandlung zu testen.';

  @override
  String get tooltipSimNmea4Tag =>
      'Jeden ausgegebenen Frame mit einem NMEA-4.0-Tagblock versehen.';

  @override
  String get tooltipSimVesselType =>
      'Diesen Schiffstyp in die Flotte aufnehmen.';

  @override
  String get tooltipSimMessageType => 'Diesen AIS-Meldungstyp ausgeben.';

  @override
  String get tooltipDecoderClear => 'Decoder-Eingabe und Ergebnisse löschen.';

  @override
  String get tooltipStatsDecode =>
      'Dekodierung eingehender AIS-Frames anhalten oder fortsetzen.';

  @override
  String get tooltipStatsReset => 'Alle Statistikzähler auf null zurücksetzen.';

  @override
  String get tooltipDocOpenTab =>
      'Diesen Abschnitt in einer eigenen Registerkarte öffnen.';

  @override
  String get tooltipEditorInject =>
      'Die zusammengesetzte Nachricht in den Decoder einspeisen, als ob sie empfangen worden wäre.';

  @override
  String get tooltipEditorSend =>
      'Die zusammengesetzte Nachricht an jedes aktivierte Sendeziel senden.';

  @override
  String get tooltipCopy => 'In die Zwischenablage kopieren.';

  @override
  String get tooltipClose => 'Dieses Panel schließen.';

  @override
  String get tooltipBrowse => 'Datei auswählen.';

  @override
  String get tooltipFeedName =>
      'Eine Bezeichnung, die diese Quelle in der Feed-Liste identifiziert.';

  @override
  String get tooltipFeedHost => 'Adresse des Servers, der AIS-Sätze überträgt.';

  @override
  String get tooltipFeedPort =>
      'TCP- oder UDP-Port zur Verbindung mit dem Server.';

  @override
  String get tooltipFeedHeader =>
      'Optionale Bytes, die beim Verbinden vor dem Lesen gesendet werden (z. B. eine gpsd-Anfrage).';

  @override
  String get tooltipFeedFile =>
      'Pfad zu einer Textdatei mit aufgezeichneten NMEA-Sätzen.';

  @override
  String get tooltipFeedInterval =>
      'Verzögerung zwischen zwei Frames beim Abspielen der Datei.';

  @override
  String get tooltipFeedLoop =>
      'Startet die Dateiwiedergabe am Anfang neu, wenn das Ende erreicht ist.';

  @override
  String get tooltipFeedSpeed =>
      'Geschwindigkeitsmultiplikator der Wiedergabe (1x = Echtzeit).';

  @override
  String get tooltipFeedSerialPort =>
      'Serielle Schnittstelle des AIS-Empfängers (z. B. COM3 oder /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Baudrate für die Kommunikation mit dem seriellen AIS-Empfänger.';

  @override
  String get tooltipFeedRtlDevice =>
      'Der RTL-SDR-Dongle zum Empfang von AIS auf UKW.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Lässt den Tuner die Verstärkung automatisch einstellen. Für die meisten Setups empfohlen.';

  @override
  String get tooltipFeedRtlGain =>
      'Feste Tuner-Verstärkung in Dezibel, wenn die automatische Verstärkung deaktiviert ist.';

  @override
  String get tooltipFeedRtlChannels =>
      'Welche UKW-AIS-Kanäle dekodiert werden: A (161,975 MHz), B (162,025 MHz) oder beide.';

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
