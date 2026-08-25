// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get languageSystem => 'Auto (sistema)';

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
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeHighContrast => 'Alto contrasto';

  @override
  String get tabReception => 'Ricezione';

  @override
  String get tabSend => 'Invio';

  @override
  String get tabMap => 'Mappa';

  @override
  String get tabEditor => 'Editor';

  @override
  String get tabTools => 'Strumenti';

  @override
  String get tabStats => 'Statistiche';

  @override
  String get tabSimulation => 'Simulazione';

  @override
  String get tabDocs => 'Documentazione';

  @override
  String get protocolUdpServer => 'Server UDP';

  @override
  String get protocolUdpClient => 'Client UDP';

  @override
  String get protocolTcpClient => 'Client TCP';

  @override
  String get protocolTcpServer => 'Server TCP';

  @override
  String get formatPassthrough => 'Pass-through';

  @override
  String get formatStrip => 'Rimuovi blocchi tag';

  @override
  String get formatTag => 'Aggiungi blocco tag';

  @override
  String get sendAddDestination => 'Aggiungi destinazione';

  @override
  String get sendEditDestination => 'Modifica destinazione';

  @override
  String get sendFormat => 'Formato di invio';

  @override
  String get sendSave => 'Salva';

  @override
  String get sendLockedBanner =>
      'Il forwarder è in esecuzione — le destinazioni sono bloccate.';

  @override
  String get sendEmpty =>
      'Nessuna destinazione. Aggiungine una per inoltrare i frame AIS ricevuti.';

  @override
  String get fieldName => 'Nome';

  @override
  String get fieldProtocol => 'Protocollo';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Porta';

  @override
  String get fieldTagSourceId => 'ID sorgente tag';

  @override
  String get fieldFile => 'File';

  @override
  String get fieldCancel => 'Annulla';

  @override
  String get fieldAdd => 'Aggiungi';

  @override
  String get receptionFeeds => 'Feed';

  @override
  String get receptionValidateChecksums => 'Valida i checksum NMEA';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count frasi scartate',
      one: '1 frase scartata',
      zero: 'Nessuna frase scartata',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Formato frame di importazione';

  @override
  String get receptionStart => 'Avvia';

  @override
  String get receptionStop => 'Ferma';

  @override
  String get receptionLogs => 'Log';

  @override
  String get receptionFrameCopied => 'Frame copiato';

  @override
  String get receptionAddSource => 'Aggiungi sorgente';

  @override
  String get receptionNetwork => 'Rete';

  @override
  String get receptionFile => 'File';

  @override
  String get receptionSerial => 'Seriale';

  @override
  String get receptionHeaderOptional => 'Intestazione (opzionale)';

  @override
  String get receptionPathOrBrowse => 'Percorso o Sfoglia…';

  @override
  String get receptionIntervalMs => 'Intervallo tra frame (ms)';

  @override
  String get receptionReplayTimestamps =>
      'Riproduci usando i timestamp del file';

  @override
  String get receptionReplayTimestampsHint =>
      'Segue i tempi registrati (blocco tag t: o prefisso timestamp) invece di un intervallo fisso';

  @override
  String get receptionSpeed => 'Velocità';

  @override
  String get receptionReplayLoop => 'Loop (riproduci dall\'inizio)';

  @override
  String get receptionSerialPort => 'Porta seriale';

  @override
  String get receptionSerialPortHint => 'es. COM3 o /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Baud rate';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'Dispositivo RTL-SDR';

  @override
  String get tooltipReceptionRtlSdrDevices =>
      'Aggiorna l\'elenco dei dongle RTL-SDR';

  @override
  String get receptionRtlSdrNoDevice =>
      'Nessun dispositivo RTL-SDR trovato. Installa i driver RTL-SDR (Zadig / WinUSB su Windows) e collega il dongle.';

  @override
  String get receptionRtlSdrAutoGain => 'Guadagno automatico (consigliato)';

  @override
  String get receptionRtlSdrGainDb => 'Guadagno del tuner (dB)';

  @override
  String get receptionRtlSdrSampleRate => 'Frequenza di campionamento';

  @override
  String get receptionRtlSdrChannels => 'Canali';

  @override
  String get msgType1 => 'Rapporto di posizione Classe A';

  @override
  String get msgType2 => 'Rapporto di posizione Classe A (assegnato)';

  @override
  String get msgType3 => 'Rapporto di posizione Classe A (risposta)';

  @override
  String get msgType4 => 'Stazione di base';

  @override
  String get msgType5 => 'Dati statici e relativi al viaggio';

  @override
  String get msgType6 => 'Messaggio binario indirizzato';

  @override
  String get msgType7 => 'Conferma binaria';

  @override
  String get msgType8 => 'Messaggio binario broadcast';

  @override
  String get msgType9 => 'Rapporto di posizione SAR standard di aeromobile';

  @override
  String get msgType10 => 'Interrogazione UTC/Data';

  @override
  String get msgType11 => 'Risposta UTC/Data';

  @override
  String get msgType12 => 'Messaggio di sicurezza indirizzato';

  @override
  String get msgType13 => 'Conferma di sicurezza';

  @override
  String get msgType14 => 'Messaggio di sicurezza broadcast';

  @override
  String get msgType15 => 'Interrogazione';

  @override
  String get msgType16 => 'Comando modalità di assegnazione';

  @override
  String get msgType17 => 'Messaggio binario broadcast DGNSS';

  @override
  String get msgType18 => 'Rapporto di posizione CS standard Classe B';

  @override
  String get msgType19 => 'Rapporto di posizione esteso Classe B';

  @override
  String get msgType20 => 'Messaggio di gestione del data link';

  @override
  String get msgType21 => 'Rapporto aiuti alla navigazione';

  @override
  String get msgType22 => 'Gestione canali';

  @override
  String get msgType23 => 'Comando assegnazione di gruppo';

  @override
  String get msgType24 => 'Rapporto dati statici';

  @override
  String get msgType25 => 'Messaggio binario a slot singolo';

  @override
  String get msgType26 => 'Messaggio binario a slot multiplo';

  @override
  String get msgType27 =>
      'Rapporto di posizione per applicazioni a lungo raggio';

  @override
  String get statsTitle => 'Statistiche';

  @override
  String get statsFeed => 'Feed';

  @override
  String get statsAllFeeds => 'Tutti i feed';

  @override
  String get statsReceived => 'Ricevuti';

  @override
  String get statsDecoded => 'Decodificati';

  @override
  String get statsInvalidChecksums => 'Checksum non validi';

  @override
  String get statsDroppedFragments => 'Frammenti scartati';

  @override
  String get statsParseErrors => 'Errori di parsing';

  @override
  String get statsPendingFragments => 'Frammenti in attesa';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(tutti i feed)';

  @override
  String get statsReceivedVsDecoded => 'Ricevuti vs Decodificati (ultimi 60 s)';

  @override
  String get statsPerSecondLabel => 'al secondo';

  @override
  String get statsAccounting => 'Contabilità';

  @override
  String get statsMultiPartParts => 'Parti multi-frame';

  @override
  String get statsPending => 'In attesa';

  @override
  String get statsDropped => 'Scartati';

  @override
  String get statsReconcile => 'Ricevuti e decodificati coincidono.';

  @override
  String get statsGapPaused =>
      'Il divario include le frasi ricevute mentre la decodifica era in pausa.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Ricevuti $received = $sum';
  }

  @override
  String get statsByMessageType => 'Per tipo di messaggio';

  @override
  String get statsNoDecodedYet => 'Nessun messaggio decodificato finora';

  @override
  String statsTypeFallback(Object type) {
    return 'Tipo $type';
  }

  @override
  String get statsByFeed => 'Per feed';

  @override
  String statsFeedFilter(Object filter) {
    return 'Feed: $filter';
  }

  @override
  String get statsNoActivityYet => 'Nessuna attività di feed finora';

  @override
  String get statsCollecting => 'raccolta…';

  @override
  String get simVesselCargo => 'Cargo';

  @override
  String get simVesselTanker => 'Petroliera';

  @override
  String get simVesselFishing => 'Pesca';

  @override
  String get simVesselSailing => 'Vela';

  @override
  String get simVesselPassenger => 'Passeggeri';

  @override
  String get simVesselTug => 'Rimorchiatore';

  @override
  String get simVesselHsc => 'Unità ad alta velocità';

  @override
  String get simVesselOther => 'Altro';

  @override
  String get simType1 => 'Rapporto di posizione (1/2/3)';

  @override
  String get simType5 => 'Statico e viaggio (5)';

  @override
  String get simType9 => 'Aeromobile SAR (9)';

  @override
  String get simType18 => 'Posizione Classe B (18)';

  @override
  String get simType19 => 'Classe B esteso (19)';

  @override
  String get simType27 => 'Lungo raggio (27)';

  @override
  String get simType4 => 'Stazione di base (4)';

  @override
  String get simType21 => 'Aiuto alla navigazione (21)';

  @override
  String get simType8 => 'Trasmissione meteo (8)';

  @override
  String get simType11 => 'Risposta UTC/data (11)';

  @override
  String get simType12 => 'Sicurezza indirizzato (12)';

  @override
  String get simType14 => 'Sicurezza broadcast (14)';

  @override
  String get simType22 => 'Gestione canali (22)';

  @override
  String get simType23 => 'Assegnazione di gruppo (23)';

  @override
  String get simType24 => 'Classe B statico (24)';

  @override
  String get simTitle => 'Simulazione';

  @override
  String get simInfoBanner =>
      'La flotta viene emessa quando il feed \"Simulation\" è abilitato nella scheda Ricezione e il forwarder è in esecuzione.';

  @override
  String get simOpenReception => 'Apri Ricezione';

  @override
  String get simFleetSection => 'Flotta';

  @override
  String get simRadiusKm => 'Raggio (km)';

  @override
  String get simVessels => 'Navi';

  @override
  String get simSpeedMinKn => 'Velocità min (kn)';

  @override
  String get simSpeedMaxKn => 'Velocità max (kn)';

  @override
  String get simIntervalS => 'Intervallo (s)';

  @override
  String get simSeed => 'Seed';

  @override
  String get simAnchoredPct => 'Ancorate (%)';

  @override
  String get simNamePrefix => 'Prefisso nome';

  @override
  String get simMmsiMid => 'Paese MMSI / MID';

  @override
  String get simSearchMmid => 'Cerca un paese o digita un MID a 3 cifre';

  @override
  String get simCustom => 'Personalizzato';

  @override
  String get simVesselTypes => 'Tipi di imbarcazione';

  @override
  String get simRealisticNames => 'Nomi realistici';

  @override
  String get simRealisticDimensions => 'Dimensioni realistiche';

  @override
  String get simRealisticMmsi => 'MMSI ITU realistici';

  @override
  String get simZoneSection => 'Zona e traffico';

  @override
  String get simLocationPreset => 'Preset posizione';

  @override
  String get simSearchPort => 'Cerca un porto…';

  @override
  String get simCenterLat => 'Latitudine centro';

  @override
  String get simCenterLon => 'Longitudine centro';

  @override
  String get simZoneShape => 'Forma della zona';

  @override
  String get simTransitPct => 'Transito (%)';

  @override
  String get simRegeneratePeriodically => 'Rigenera periodicamente';

  @override
  String get simRegenerateTicks => 'Rigenera (tick)';

  @override
  String get simPresetHint =>
      'Scegli un preset per riempire le coordinate, oppure digita direttamente Latitudine / Longitudine centro.';

  @override
  String get simMovementSection => 'Movimento ed emissione';

  @override
  String get simVarySpeed => 'Varia la velocità nel tempo';

  @override
  String get simReportIntervalTicks => 'Intervallo di report (tick)';

  @override
  String get simWander => 'Vagabondaggio (0-3)';

  @override
  String get simSpeedByType => 'Velocità per tipo di imbarcazione';

  @override
  String get simClassBSharePct => 'Quota Classe B (%)';

  @override
  String get simHighAccuracy => 'Alta precisione';

  @override
  String get simRealisticRot => 'Tasso di rotazione realistico';

  @override
  String get simContentSection => 'Contenuto';

  @override
  String get simSafetyTexts => 'Testi di sicurezza (uno per riga)';

  @override
  String get simDestinations => 'Destinazioni (una per riga)';

  @override
  String get simStationsSection => 'Stazioni';

  @override
  String get simBaseStations => 'Stazioni di base';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => 'Qualità di trasmissione';

  @override
  String get simInjectErrors => 'Inietta errori';

  @override
  String get simErrorRatePct => 'Tasso di errore (%)';

  @override
  String get simTalkerId => 'ID talker';

  @override
  String get simNmea4Tag => 'Blocco tag NMEA 4.0';

  @override
  String get simMessagesSection => 'Messaggi';

  @override
  String get simApplyFleet => 'Applica flotta';

  @override
  String get simRegenerateFleet => 'Rigenera flotta';

  @override
  String get simGenerating => 'Generazione…';

  @override
  String get simLiveFleet => 'Flotta live';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats barche · $frames frame emessi';
  }

  @override
  String get mapSearchVessels => 'Cerca imbarcazioni';

  @override
  String get mapSearchHint => 'Nome, MMSI o IMO';

  @override
  String get mapNoResults => 'Nessun risultato';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'Filtri';

  @override
  String mapAllLabel(Object label) {
    return 'Tutti $label';
  }

  @override
  String get mapVesselType => 'Tipo di imbarcazione';

  @override
  String get mapNavigationStatus => 'Stato di navigazione';

  @override
  String get mapCountry => 'Paese';

  @override
  String get mapMinSog => 'SOG min (kn)';

  @override
  String get mapMaxSog => 'SOG max (kn)';

  @override
  String get mapOnlyNamed => 'Solo imbarcazioni con nome';

  @override
  String get mapReset => 'Reimposta';

  @override
  String get mapApply => 'Applica';

  @override
  String get mapAutoBasemap => 'Auto (segui tema)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Segui $mmsi';
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
  String get basemapVoyagerLight => 'Voyager (chiaro)';

  @override
  String get basemapPositronLight => 'Positron (chiaro minimale)';

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
  String get decoderInputLabel => 'Incolla o scrivi una o più frasi NMEA AIS';

  @override
  String get decoderValidateChecksums => 'Valida checksum';

  @override
  String get decoderDecode => 'Decodifica';

  @override
  String get decoderDecoded => 'Decodificato';

  @override
  String decoderDecodedN(Object n) {
    return 'Decodificato ($n frasi)';
  }

  @override
  String get decoderInvalidChecksum => 'Checksum non valido';

  @override
  String get decoderParseError => 'Errore di parsing';

  @override
  String get decoderWaitingFragments => 'In attesa di altri frammenti…';

  @override
  String decoderTagSource(Object id) {
    return 'sorgente $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Blocco tag · $content';
  }

  @override
  String get toolDecoder => 'Decodificatore NMEA';

  @override
  String get toolDecoderSub => 'Decodifica frasi AIS';

  @override
  String get toolChecksum => 'Checksum';

  @override
  String get toolChecksumSub => 'Calcola XOR NMEA';

  @override
  String get toolMmsi => 'Ricerca MMSI';

  @override
  String get toolMmsiSub => 'Valida e identifica un MMSI';

  @override
  String get toolSpeed => 'Convertitore di velocità';

  @override
  String get toolSpeedSub => 'nodi · km/h · m/s · mph';

  @override
  String get toolBinary => 'Ispezione binaria';

  @override
  String get toolBinarySub => 'Payload fino ai bit';

  @override
  String get toolEta => 'Calcolatrice ETA';

  @override
  String get toolEtaSub => 'ETA nei campi tipo 5';

  @override
  String get toolRadio => 'Portata radio';

  @override
  String get toolRadioSub => 'Orizzonte radio VHF-AIS';

  @override
  String get toolTextToBinary => 'Testo in binario';

  @override
  String get toolTextToBinarySub => 'ASCII 6-bit in hex/bit';

  @override
  String get checksumInputLabel => 'Incolla una o più frasi NMEA';

  @override
  String get checksumComputed => 'Calcolata';

  @override
  String get checksumDeclared => 'Dichiarata';

  @override
  String get checksumValid => 'Checksum valido';

  @override
  String get checksumInvalid => 'Checksum non valido';

  @override
  String get checksumFix => 'Correggi checksum';

  @override
  String get mmsiInputLabel => 'MMSI (9 cifre)';

  @override
  String get mmsiValid => 'MMSI valido';

  @override
  String get mmsiInvalid => 'Non è un MMSI valido a 9 cifre';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'Paese';

  @override
  String get mmsiCountryUnknown => 'MID sconosciuto';

  @override
  String get mmsiType => 'Tipo di stazione';

  @override
  String get mmsiGroupCall => 'Chiamata di gruppo';

  @override
  String get mmsiSarAircraft => 'Aeromobile SAR';

  @override
  String get mmsiCoastStation => 'Stazione costiera';

  @override
  String get mmsiShipStation => 'Stazione di nave';

  @override
  String get mmsiHandheldVhf => 'VHF portatile';

  @override
  String get mmsiAton => 'Aiuto alla navigazione (AtoN)';

  @override
  String get mmsiSar => 'Unità SAR';

  @override
  String get mmsiOther => 'Altro';

  @override
  String get speedValue => 'Valore';

  @override
  String get speedUnit => 'Unità';

  @override
  String get binaryInputLabel => 'Frase NMEA o payload 6-bit grezzo';

  @override
  String get binaryPayload => 'Payload';

  @override
  String get binaryBits => 'Bit';

  @override
  String get binaryBinary => 'Binario';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Byte hex';

  @override
  String get binarySixBit => 'Caratteri 6-bit';

  @override
  String get etaDistance => 'Distanza';

  @override
  String get etaUnitNm => 'miglia nautiche';

  @override
  String get etaUnitKm => 'chilometri';

  @override
  String get etaSpeed => 'Velocità';

  @override
  String get etaDuration => 'Durata';

  @override
  String get etaEtaLocal => 'ETA (locale)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'Campi ETA del tipo 5';

  @override
  String get etaMonth => 'Mese';

  @override
  String get etaDay => 'Giorno';

  @override
  String get etaHour => 'Ora';

  @override
  String get etaMinute => 'Minuto';

  @override
  String get etaCombined => 'MM/GG HH:MM';

  @override
  String get radioHeight1 => 'Altezza antenna 1';

  @override
  String get radioHeight2 => 'Altezza antenna 2';

  @override
  String get radioHorizon => 'Orizzonte radio';

  @override
  String get radioHorizonKm => 'Orizzonte radio (km)';

  @override
  String get radioFrequencies => 'Canali AIS';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Inserisci un testo (alfabeto AIS 6-bit)';

  @override
  String get t2bCharTable => 'Carattere · valore · 6-bit';

  @override
  String get t2bBinary => 'Binario';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Byte (formato editor)';

  @override
  String get t2bPayload => 'Payload blindato';

  @override
  String get t2bNote =>
      'L\'elenco di byte può essere incollato nel campo «Data bytes» dell\'editor di un messaggio 6/8/25/26; il payload blindato è il campo payload esatto della frase NMEA.';

  @override
  String editorAsmDetected(Object name) {
    return 'Messaggio specifico dell\'applicazione — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Campi dell\'ASM riconosciuto. Il campo grezzo «Data bytes» continua a prevalere quando compilato.';

  @override
  String get fMessageType => 'Tipo di messaggio';

  @override
  String get editorAsmPreset => 'Preselezione ASM';

  @override
  String get editorAsmPresetManual =>
      'Personalizzato — inserire DAC/FID a mano';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'Campi ASM';

  @override
  String get asmStateInForce => 'in vigore';

  @override
  String get asmStateDeprecated => 'deprecato';

  @override
  String get asmStateReplaced => 'sostituito';

  @override
  String get asmStateDiscontinued => 'discontinuato';

  @override
  String get asmStateDraft => 'bozza';

  @override
  String get asmStateProposal => 'proposta';

  @override
  String get asmStateTesting => 'in test';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Deprecato dal $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'Nessun layout di bit è documentato per $name — modifica i Data bytes grezzi.';
  }

  @override
  String get docChapterAsm => 'Messaggi specifici dell\'applicazione';

  @override
  String get docAsmIntro =>
      'Non tutti i payload AIS sono report di posizione standard. I tipi 6, 8, 25 e 26 trasportano dati binari specifici (ASM) il cui significato è definito da due numeri: un Designated Area Code (DAC) e un Function Identifier (FID).';

  @override
  String get docAsmWhatTitle => 'Cos\'è un ASM?';

  @override
  String get docAsmWhat =>
      'Un messaggio specifico dell\'applicazione è un payload strutturato pubblicato da un\'organizzazione (IMO, IALA, amministrazioni nazionali, produttori) per un uso preciso: dati meteo e idrografici, monitoraggio degli aiuti alla navigazione, correzioni DGPS, servizi portuali e altro. I tipi 6/8 portano l\'intestazione DAC/FID; i 25/26 ripetono lo stesso schema DAC/FID nei messaggi a slot.';

  @override
  String get docAsmDacFidTitle => 'DAC e FID';

  @override
  String get docAsmDacFid1 =>
      'Il DAC è un codice a 10 bit che identifica l\'organizzazione o il paese emittente (es. 001 = IMO, 002 = IALA). Il FID è un codice di funzione a 6 bit nello spazio di quel DAC (es. 001/11 = dati meteo-idro IMO).';

  @override
  String get docAsmDacFid2 =>
      'I byte di dati che seguono l\'intestazione DAC/FID vengono decodificati secondo lo standard applicativo corrispondente. Coppie DAC/FID diverse possono interpretare gli stessi byte in modo del tutto diverso: bisogna sempre conoscere prima la coppia.';

  @override
  String get docAsmWhereTitle => 'Dove trovare le definizioni';

  @override
  String get docAsmWhere1 =>
      'Circolari IMO e ITU-R M.1371 (Allegati) — fonte autorevole per il DAC 001.';

  @override
  String get docAsmWhere2 =>
      'Linee guida IALA (es. G1139) e amministrazioni nazionali — per i DAC regionali.';

  @override
  String get docAsmWhere3 =>
      'La documentazione AIVDM di gpsd — un catalogo aperto e leggibile da macchina degli schemi DAC/FID più comuni.';

  @override
  String get docAsmInKikaisTitle => 'In KikAis';

  @override
  String get docAsmInKikais =>
      'L\'Editor conosce un insieme curato di ASM noti: quando il DAC/FID di un messaggio 6/8/25/26 corrisponde, il campo data viene mostrato come sottocampi nominati impacchettati automaticamente. Il campo grezzo «Data bytes» prevale sempre quando compilato. L\'elenco vive in asm_formats.dart ed è facile da estendere.';

  @override
  String get docAsmExampleTitle => 'Esempio: meteo-idro IMO (001/11)';

  @override
  String get docAsmExample =>
      'Nell\'Editor imposta tipo 8, DAC=1 e FID=11 per costruire un messaggio meteo IMO: vento, temperature di aria e acqua, pressione, visibilità, correnti e onde si modificano campo per campo invece che come blocco di byte.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Indicatore di ripetizione';

  @override
  String get fNavStatus => 'Stato di navigazione';

  @override
  String get fLatitude => 'Latitudine';

  @override
  String get fLongitude => 'Longitudine';

  @override
  String get fSogKn => 'SOG (kn)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Rotta (°)';

  @override
  String get fRateOfTurn => 'Tasso di rotazione';

  @override
  String get fManeuver => 'Manovra';

  @override
  String get fTimestamp => 'Timestamp';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Precisione';

  @override
  String get fEpfdFixType => 'Tipo di fix EPFD';

  @override
  String get fSyncState => 'Stato di sincronizzazione';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Indicativo di chiamata';

  @override
  String get fVesselName => 'Nome imbarcazione';

  @override
  String get fShipType => 'Tipo di nave';

  @override
  String get fShipTypeText => 'Tipo di nave (testo)';

  @override
  String get fDims => 'Prua/Poppa/Sinistra/Dritta (m)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Pescaggio (m)';

  @override
  String get fDestination => 'Destinazione';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'MMSI di destinazione';

  @override
  String get fSeqNumber => 'Numero di sequenza';

  @override
  String get fRetransmit => 'Ritrasmissione';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Dati';

  @override
  String get fAltitudeM => 'Altitudine (m)';

  @override
  String get fAssignedMode => 'Modalità assegnata';

  @override
  String get fRegionalReserved => 'Riservato regionale';

  @override
  String get fText => 'Testo';

  @override
  String fStationN(Object n) {
    return 'Stazione $n';
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
    return 'offset $offset · numero $number · timeout $timeout · inc $increment';
  }

  @override
  String get fAidType => 'Tipo di aiuto';

  @override
  String get fAidTypeCode => 'Tipo di aiuto (codice)';

  @override
  String get fName => 'Nome';

  @override
  String get fNameExt => 'Estensione nome';

  @override
  String get fVirtualAid => 'Aiuto virtuale';

  @override
  String get fOffPosition => 'Fuori posizione';

  @override
  String get fSecond => 'Secondo';

  @override
  String get fChannelA => 'Canale A';

  @override
  String get fChannelB => 'Canale B';

  @override
  String get fTxRxMode => 'Modalità TX/RX';

  @override
  String get fPower => 'Potenza';

  @override
  String get fZone => 'Zona';

  @override
  String get fAddressed => 'Indirizzato';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Banda A';

  @override
  String get fBandB => 'Banda B';

  @override
  String get fZoneSize => 'Dimensione zona';

  @override
  String get fStationType => 'Tipo di stazione';

  @override
  String get fReportInterval => 'Intervallo di report';

  @override
  String get fQuietTime => 'Tempo di silenzio';

  @override
  String get fPart => 'Parte';

  @override
  String get fVendorId => 'ID produttore';

  @override
  String get fUnitModel => 'Modello unità';

  @override
  String get fSerialNumber => 'Numero di serie';

  @override
  String get fMothershipMmsi => 'MMSI nave madre';

  @override
  String get fRadioStatus => 'Stato radio';

  @override
  String get fGnssStatus => 'Stato posizione GNSS';

  @override
  String fDestN(Object n) {
    return 'Destinazione $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => 'Indicatore di destinazione';

  @override
  String get fBinaryDataFlag => 'Flag dati binari';

  @override
  String get fApplicationId => 'ID applicazione';

  @override
  String get fPowerHigh => 'Alta';

  @override
  String get fPowerLow => 'Bassa';

  @override
  String get fPartA => 'A (nome)';

  @override
  String get fPartB => 'B (dati nave)';

  @override
  String get editorTitle => 'Editor messaggi AIS';

  @override
  String get editorCompose => 'Componi messaggio';

  @override
  String get editorMessageType => 'Tipo di messaggio';

  @override
  String get editorAddTagBlock => 'Aggiungi blocco tag NMEA 4.0';

  @override
  String get editorSourceId => 'ID sorgente';

  @override
  String get editorInjectToMap => 'Inietta nella mappa';

  @override
  String get editorSendToTarget => 'Invia al target';

  @override
  String get editorPreview => 'Anteprima NMEA';

  @override
  String get editorNmeaCopied => 'NMEA copiato';

  @override
  String get editorInjected => 'Messaggio iniettato';

  @override
  String get editorSentToTarget => 'Messaggio inviato al target';

  @override
  String get editorNavStatus0_15 => 'Stato di navigazione (0-15)';

  @override
  String get editorYear => 'Anno';

  @override
  String get editorMonth => 'Mese';

  @override
  String get editorDay => 'Giorno';

  @override
  String get editorHour => 'Ora';

  @override
  String get editorMinute => 'Minuto';

  @override
  String get editorSecond => 'Secondo';

  @override
  String get editorImoNumber => 'Numero IMO';

  @override
  String get editorBowM => 'Prua (m)';

  @override
  String get editorSternM => 'Poppa (m)';

  @override
  String get editorPortM => 'Sinistra (m)';

  @override
  String get editorStarboardM => 'Dritta (m)';

  @override
  String get editorEtaMonth => 'Mese ETA';

  @override
  String get editorEtaDay => 'Giorno ETA';

  @override
  String get editorEtaHour => 'Ora ETA';

  @override
  String get editorEtaMinute => 'Minuto ETA';

  @override
  String get editorSequence0_3 => 'Sequenza (0-3)';

  @override
  String get editorDataBytes => 'Byte dati (hex o 1,2,3)';

  @override
  String get editorDestMmsisComma => 'MMSI dest. (separati da virgola)';

  @override
  String get editorSequencesComma => 'Sequenze (separate da virgola)';

  @override
  String get editorInterrogatedMmsi => 'MMSI interrogato';

  @override
  String get editorType1 => 'Tipo 1';

  @override
  String get editorOffset1 => 'Offset 1';

  @override
  String get editorTargetMmsi => 'MMSI target';

  @override
  String get editorOffset => 'Offset';

  @override
  String get editorIncrement => 'Incremento';

  @override
  String get editorNumber => 'Numero';

  @override
  String get editorTimeout => 'Timeout';

  @override
  String get editorAidType0_31 => 'Tipo di aiuto (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Aiuto virtuale (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Modalità Tx/Rx (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Modalità Tx/Rx (0-3)';

  @override
  String get editorNeLat => 'Latitudine NE';

  @override
  String get editorNeLon => 'Longitudine NE';

  @override
  String get editorSwLat => 'Latitudine SW';

  @override
  String get editorSwLon => 'Longitudine SW';

  @override
  String get editorInterval0_15 => 'Intervallo (0-15)';

  @override
  String get editorPart => 'Parte (0 = nome A, 1 = statico B)';

  @override
  String get editorDestMmsiEmpty => 'MMSI di destinazione (vuoto = broadcast)';

  @override
  String get editorAppDacEmpty => 'App DAC (vuoto = nessuno)';

  @override
  String get editorAppFidEmpty => 'App FID (vuoto = nessuno)';

  @override
  String get nmeaTalker => 'Talker';

  @override
  String get nmeaFragments => 'Frammenti';

  @override
  String get nmeaFragmentN => 'Frammento #';

  @override
  String get nmeaMessageId => 'ID messaggio';

  @override
  String get nmeaChannel => 'Canale';

  @override
  String get nmeaPayload => 'Payload';

  @override
  String get nmeaFillBits => 'Bit di riempimento';

  @override
  String get nmeaTagBlock => 'Blocco tag';

  @override
  String get nmeaChecksum => 'Checksum';

  @override
  String get nmeaEmpty => '(vuoto)';

  @override
  String get bubbleKindVessel => 'Imbarcazione';

  @override
  String get bubbleKindAircraft => 'Aeromobile SAR';

  @override
  String get bubbleKindAton => 'Aiuto alla navigazione';

  @override
  String get bubbleKindStation => 'Stazione di base';

  @override
  String get bubbleGeneralInfo => 'Informazioni generali';

  @override
  String get bubbleKind => 'Tipo';

  @override
  String get bubbleAidType => 'Tipo di aiuto';

  @override
  String get bubbleVirtual => 'Virtuale';

  @override
  String get bubbleAltitude => 'Altitudine';

  @override
  String get bubbleCallSign => 'Indicativo di chiamata';

  @override
  String get bubblePosNav => 'Posizione e navigazione';

  @override
  String get bubbleHeading => 'Rotta';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Dettagli imbarcazione';

  @override
  String get bubbleType => 'Tipo';

  @override
  String get bubbleTypeInt => 'Tipo (Int)';

  @override
  String get bubbleDimsBowStern => 'Dimensioni Prua/Poppa';

  @override
  String get bubbleDimsPortStarboard => 'Dimensioni Sinistra/Dritta';

  @override
  String get bubbleSpare => 'Riserva';

  @override
  String get bubbleDraught => 'Pescaggio';

  @override
  String bubbleFrames(Object n) {
    return 'Frame ($n)';
  }

  @override
  String get bubbleNoFrames => 'Nessun frame finora';

  @override
  String get copied => 'Copiato';

  @override
  String get textFiles => 'File di testo';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Target $name connesso ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Impossibile connettere il target $name: $error';
  }

  @override
  String get logStopping => 'Arresto del forwarder...';

  @override
  String get logStopped => 'Forwarder arrestato.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Feed aggiunto: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Feed rimosso: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Feed $name connesso.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Feed $name disconnesso. Riconnessione tra 5s...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Impossibile connettere il feed $name: $error. Nuovo tentativo tra 5s...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Target $name: server TCP in ascolto sulla porta $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Target $name: client connesso $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Target $name: client disconnesso';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Target $name: errore client $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Target $name: errore di invio $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'Apertura dongle RTL-SDR $device...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device connesso ($freq, frequenza di campionamento $rate, guadagno $gain, canali $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device: errore $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'Flusso RTL-SDR $device chiuso.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device disconnesso.';
  }

  @override
  String get docNavStatus0 => 'In navigazione con motore';

  @override
  String get docNavStatus1 => 'All\'ancora';

  @override
  String get docNavStatus2 => 'Non governabile';

  @override
  String get docNavStatus3 => 'Manovrabilità limitata';

  @override
  String get docNavStatus4 => 'Limitato dal proprio pescaggio';

  @override
  String get docNavStatus5 => 'Ormeggiato';

  @override
  String get docNavStatus6 => 'In secco';

  @override
  String get docNavStatus7 => 'Impegnato nella pesca';

  @override
  String get docNavStatus8 => 'In navigazione a vela';

  @override
  String get docNavStatus9 => 'Riservato (HSC)';

  @override
  String get docNavStatus10 => 'Riservato (WIG)';

  @override
  String get docNavStatus11 => 'A rimorchio a poppa (regionale)';

  @override
  String get docNavStatus12 =>
      'Spinta a prua / rimorchio di fianco (regionale)';

  @override
  String get docNavStatus13 => 'Riservato per uso futuro';

  @override
  String get docNavStatus14 => 'AIS-SART attivo';

  @override
  String get docNavStatus15 => 'Indefinito (predefinito)';

  @override
  String get docEpfd0 => 'Indefinito (predefinito)';

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
  String get docEpfd6 => 'Sistema di navigazione integrato';

  @override
  String get docEpfd7 => 'Rilevato (fisso)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'GNSS interno';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · bit $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields campi · $bits bit totali · tocca un segmento';
  }

  @override
  String get docTextToEncode => 'Testo da codificare';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Ogni carattere è un valore a 6 bit (\"@\" = 0, spazio = 32, \"A\" = 1…). Le lettere minuscole non sono codificabili e di solito vengono inviate in maiuscolo.';

  @override
  String get docChecksumBody => 'Body (senza ! iniziale e *XX finale)';

  @override
  String get docChecksumExplanation =>
      'Il checksum NMEA è lo XOR di ogni byte tra \"!\" e \"*\".';

  @override
  String get docLatitude => 'Latitudine';

  @override
  String get docLongitude => 'Longitudine';

  @override
  String get docLatitudeInvalid => 'Latitudine: inserisci un numero';

  @override
  String get docLongitudeInvalid => 'Longitudine: inserisci un numero';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Latitudine → $value (27 bit con segno, deg = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Longitudine → $value (28 bit con segno, deg = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Le coordinate sono memorizzate in 1/10 000 di minuto: dividi per 600 000 per recuperare i gradi.';

  @override
  String get docSearchShipTypes => 'Cerca tipi di nave';

  @override
  String get docShipCat0_19 => '0-19 · Riservato';

  @override
  String get docShipCat20_29 => '20-29 · Effetto suolo (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Pesca';

  @override
  String get docShipCat40_49 => '40-49 · Unità ad alta velocità';

  @override
  String get docShipCat50_59 => '50-59 · Unità speciali';

  @override
  String get docShipCat60_69 => '60-69 · Passeggeri';

  @override
  String get docShipCat70_79 => '70-79 · Cargo';

  @override
  String get docShipCat80_89 => '80-89 · Petroliere';

  @override
  String get docShipCat90_99 => '90-99 · Altro';

  @override
  String get docSearchGlossary => 'Cerca nel glossario';

  @override
  String get docNoMatchingTerms => 'Nessun termine corrispondente.';

  @override
  String get docAspect => 'Aspetto';

  @override
  String get docClassA => 'Classe A';

  @override
  String get docClassB => 'Classe B';

  @override
  String get docCheatRadio => 'Radio';

  @override
  String get docCheatFrequencies => 'Frequenze';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulazione';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bit/s';

  @override
  String get docCheatRange => 'Portata';

  @override
  String get docCheatRangeValue => '~10-20 NM nave-nave, linea di vista';

  @override
  String get docCheatReportingRates => 'Frequenze di trasmissione';

  @override
  String get docCheatClassAPos1 => 'Posizione Classe A (1)';

  @override
  String get docCheatClassAPos1Value =>
      'Ogni 2-10 s in navigazione, 3 min all\'ancora';

  @override
  String get docCheatStatic5 => 'Statico (5)';

  @override
  String get docCheatStatic5Value => 'Ogni 6 min';

  @override
  String get docCheatClassBPos18 => 'Posizione Classe B (18)';

  @override
  String get docCheatClassBPos18Value => '~Ogni 30 s';

  @override
  String get docCheatAtoN21 => 'Aiuto alla navigazione (21)';

  @override
  String get docCheatAtoN21Value => 'Ogni 3 min';

  @override
  String get docCheatNavStatus0_15 => 'Stato di navigazione (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'In navigazione con motore';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'All\'ancora';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Manovrabilità limitata';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Ormeggiato';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'In secco';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Pesca';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'In navigazione a vela';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART attivo';

  @override
  String get docCheatMmsiFormats => 'Formati MMSI';

  @override
  String get docCheatFixTypes => 'Tipi di fix (EPFD)';

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
  String get docCheatEpfd15Value => 'GNSS interno';

  @override
  String get docCheatFooter =>
      'KikAis include un riferimento interattivo completo in ogni scheda: l\'Editor può costruire qualsiasi messaggio, il Decoder li legge.';

  @override
  String get docMmsiFmtDiversRadio => 'Radio del subacqueo';

  @override
  String get docMmsiFmtShip => 'Nave';

  @override
  String get docMmsiFmtGroupShips =>
      'Gruppo di navi (es. una flotta o la USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Stazione costiera / di terra';

  @override
  String get docMmsiFmtSarAircraft => 'Aeromobile SAR';

  @override
  String get docMmsiFmtAuxCraft =>
      'Unità ausiliaria associata a una nave madre';

  @override
  String get docMmsiFmtAtoN => 'Aiuto alla navigazione';

  @override
  String get docMmsiFmtSart => 'AIS-SART (trasmettitore di ricerca e soccorso)';

  @override
  String get docMmsiFmtMob => 'Dispositivo MOB (uomo a mare)';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB (radioboia di emergenza)';

  @override
  String get docVesselCat0_9 => 'Riservato / uso futuro';

  @override
  String get docVesselCat10_19 => 'Riservato per uso futuro';

  @override
  String get docVesselCat20_29 => 'Unità a effetto suolo (WIG)';

  @override
  String get docVesselCat30_39 => 'Pesca';

  @override
  String get docVesselCat40_49 => 'Unità ad alta velocità';

  @override
  String get docVesselCat50_59 =>
      'Unità speciali (piloti, rimorchiatori, draghe…)';

  @override
  String get docVesselCat60_69 => 'Navi passeggeri';

  @override
  String get docVesselCat70_79 => 'Navi cargo';

  @override
  String get docVesselCat80_89 => 'Petroliere';

  @override
  String get docVesselCat90_99 => 'Altri tipi';

  @override
  String get docTalkerAB => 'Stazione AIS di base';

  @override
  String get docTalkerAD => 'Stazione AIS di base dipendente';

  @override
  String get docTalkerAI => 'Stazione AIS mobile';

  @override
  String get docTalkerAN => 'Stazione AIS aiuto alla navigazione';

  @override
  String get docTalkerAR => 'Stazione AIS ricevente';

  @override
  String get docTalkerAS => 'Stazione di base limitata';

  @override
  String get docTalkerAT => 'Stazione AIS trasmittente';

  @override
  String get docTalkerAX => 'Stazione AIS ripetitore';

  @override
  String get docTalkerBS => 'Stazione AIS di base (deprecato)';

  @override
  String get docTalkerSA => 'Stazione AIS fisica di terra';

  @override
  String get docType1Name => 'Rapporto di posizione Classe A';

  @override
  String get docType1Family => 'Rapporti di posizione';

  @override
  String get docType1Summary =>
      'Il cavallo di battaglia del sistema: un transponder di Classe A che trasmette posizione, rotta, velocità, direzione e stato di navigazione.';

  @override
  String get docType1EmittedBy => 'Transponder di Classe A (navi SOLAS)';

  @override
  String get docType1Cadence =>
      'Ogni 2-10 s in navigazione, ogni 3 min all\'ancora';

  @override
  String get docType2Name => 'Rapporto di posizione Classe A (assegnato)';

  @override
  String get docType2Family => 'Rapporti di posizione';

  @override
  String get docType2Summary =>
      'Identico al tipo 1, ma inviato su uno schema di slot assegnato alla nave da una stazione di base (modalità di assegnazione).';

  @override
  String get docType2EmittedBy => 'Transponder di Classe A sotto assegnazione';

  @override
  String get docType2Cadence => 'Schema assegnato';

  @override
  String get docType3Name => 'Rapporto di posizione Classe A (risposta)';

  @override
  String get docType3Family => 'Rapporti di posizione';

  @override
  String get docType3Summary =>
      'Identico al tipo 1, inviato come risposta a un\'interrogazione (tipo 15).';

  @override
  String get docType3EmittedBy =>
      'Transponder di Classe A che rispondono a un\'interrogazione';

  @override
  String get docType3Cadence => 'Su interrogazione';

  @override
  String get docType4Name => 'Rapporto stazione di base';

  @override
  String get docType4Family => 'Stazione di base e rete';

  @override
  String get docType4Summary =>
      'Il rapporto periodico di una stazione di terra fissa: la sua posizione più il riferimento di data e ora UTC.';

  @override
  String get docType4EmittedBy => 'Stazioni di base fisse';

  @override
  String get docType4Cadence => 'Ogni 10 s';

  @override
  String get docType5Name => 'Dati statici e relativi al viaggio';

  @override
  String get docType5Family => 'Dati statici e di viaggio';

  @override
  String get docType5Summary =>
      'La \"carta d\'identità\" di una nave: nome, indicativo di chiamata, numero IMO, tipo di nave, dimensioni, pescaggio, ETA e destinazione.';

  @override
  String get docType5EmittedBy => 'Transponder di Classe A';

  @override
  String get docType5Cadence => 'Ogni 6 min e al cambio dei dati';

  @override
  String get docType6Name => 'Messaggio binario indirizzato';

  @override
  String get docType6Family => 'Dati binari';

  @override
  String get docType6Summary =>
      'Un payload binario strutturato inviato a un MMSI di destinazione specifico (es. un rapporto meteo richiesto).';

  @override
  String get docType6EmittedBy => 'Qualsiasi stazione';

  @override
  String get docType6Cadence => 'Su richiesta';

  @override
  String get docType7Name => 'Conferma binaria';

  @override
  String get docType7Family => 'Dati binari';

  @override
  String get docType7Summary =>
      'La conferma inviata in risposta a un messaggio binario indirizzato di tipo 6.';

  @override
  String get docType7EmittedBy =>
      'Qualsiasi stazione che ha ricevuto un tipo 6';

  @override
  String get docType7Cadence => 'In risposta';

  @override
  String get docType8Name => 'Messaggio binario broadcast';

  @override
  String get docType8Family => 'Dati binari';

  @override
  String get docType8Summary =>
      'Un payload binario strutturato trasmesso a tutti: rapporti meteo e idrografici, dati regionali o messaggi privati/cifrati.';

  @override
  String get docType8EmittedBy => 'Qualsiasi stazione';

  @override
  String get docType8Cadence => 'Su richiesta';

  @override
  String get docType9Name => 'Rapporto di posizione SAR standard di aeromobile';

  @override
  String get docType9Family => 'Rapporti di posizione';

  @override
  String get docType9Summary =>
      'Un rapporto di posizione usato dagli aeromobili di ricerca e soccorso per essere visibili alle navi. Contiene altitudine e un intervallo MMSI speciale (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'Aeromobili SAR';

  @override
  String get docType9Cadence => 'Ogni 10 s in stazione';

  @override
  String get docType10Name => 'Interrogazione UTC e data';

  @override
  String get docType10Family => 'Stazione di base e rete';

  @override
  String get docType10Summary =>
      'Una piccola richiesta che chiede a una stazione specifica la sua data e ora UTC.';

  @override
  String get docType10EmittedBy => 'Qualsiasi stazione';

  @override
  String get docType10Cadence => 'Su richiesta';

  @override
  String get docType11Name => 'Risposta UTC e data';

  @override
  String get docType11Family => 'Stazione di base e rete';

  @override
  String get docType11Summary =>
      'Identica nella struttura al tipo 4, inviata come risposta a un\'interrogazione UTC/data di tipo 10.';

  @override
  String get docType11EmittedBy => 'Stazioni di base';

  @override
  String get docType11Cadence => 'Su interrogazione';

  @override
  String get docType12Name => 'Messaggio di sicurezza indirizzato';

  @override
  String get docType12Family => 'Sicurezza e testo';

  @override
  String get docType12Summary =>
      'Un messaggio di sicurezza a testo libero inviato a un singolo MMSI di destinazione (es. un messaggio di soccorso alla stazione di base più vicina).';

  @override
  String get docType12EmittedBy => 'Qualsiasi stazione';

  @override
  String get docType12Cadence => 'Su richiesta';

  @override
  String get docType13Name => 'Conferma relativa alla sicurezza';

  @override
  String get docType13Family => 'Sicurezza e testo';

  @override
  String get docType13Summary =>
      'La conferma inviata in risposta a un messaggio di sicurezza indirizzato di tipo 12.';

  @override
  String get docType13EmittedBy =>
      'Qualsiasi stazione che ha ricevuto un tipo 12';

  @override
  String get docType13Cadence => 'In risposta';

  @override
  String get docType14Name => 'Messaggio di sicurezza broadcast';

  @override
  String get docType14Family => 'Sicurezza e testo';

  @override
  String get docType14Summary =>
      'Una trasmissione a testo libero indirizzata a tutti quelli nel raggio: avvisi di navigazione, soccorsi o annunci sul traffico.';

  @override
  String get docType14EmittedBy =>
      'Qualsiasi stazione (spesso stazioni di base / VTS)';

  @override
  String get docType14Cadence => 'Su richiesta';

  @override
  String get docType15Name => 'Interrogazione';

  @override
  String get docType15Family => 'Stazione di base e rete';

  @override
  String get docType15Summary =>
      'Una richiesta che chiede a una o due stazioni specifiche di inviare un particolare tipo di messaggio (di solito tipo 3 o 5).';

  @override
  String get docType15EmittedBy => 'Stazioni di base';

  @override
  String get docType15Cadence => 'Su richiesta';

  @override
  String get docType16Name => 'Comando modalità di assegnazione';

  @override
  String get docType16Family => 'Stazione di base e rete';

  @override
  String get docType16Summary =>
      'Ordina a un massimo di due navi di trasmettere su una specifica allocazione di slot (modalità di assegnazione).';

  @override
  String get docType16EmittedBy => 'Stazioni di base';

  @override
  String get docType16Cadence => 'Su richiesta';

  @override
  String get docType17Name => 'Messaggio binario broadcast DGNSS';

  @override
  String get docType17Family => 'Dati binari';

  @override
  String get docType17Summary =>
      'Dati di correzione GNSS differenziale trasmessi dalle stazioni di terra per migliorare la precisione del posizionamento nell\'area coperta.';

  @override
  String get docType17EmittedBy => 'Stazioni di riferimento DGNSS';

  @override
  String get docType17Cadence => 'Periodico';

  @override
  String get docType18Name => 'Rapporto di posizione CS standard Classe B';

  @override
  String get docType18Family => 'Rapporti di posizione';

  @override
  String get docType18Summary =>
      'Il rapporto di posizione standard di Classe B. Più leggero della Classe A: niente stato di navigazione o tasso di rotazione, ma funziona con CSTDMA.';

  @override
  String get docType18EmittedBy => 'Transponder di Classe B';

  @override
  String get docType18Cadence => 'Ogni 30 s (o meno in alcune regioni)';

  @override
  String get docType19Name => 'Rapporto di posizione esteso Classe B';

  @override
  String get docType19Family => 'Rapporti di posizione';

  @override
  String get docType19Summary =>
      'Un rapporto di posizione Classe B più grande che include anche nome dell\'imbarcazione, tipo di nave e dimensioni: un ibrido statico+posizione monouso.';

  @override
  String get docType19EmittedBy => 'Transponder di Classe B estesi';

  @override
  String get docType19Cadence => 'Ogni 30 s';

  @override
  String get docType20Name => 'Gestione del data link';

  @override
  String get docType20Family => 'Stazione di base e rete';

  @override
  String get docType20Summary =>
      'Un messaggio di manutenzione della rete usato per allocare e riservare gli slot temporali TDMA in un\'area.';

  @override
  String get docType20EmittedBy => 'Stazioni di base';

  @override
  String get docType20Cadence => 'Gestione della rete';

  @override
  String get docType21Name => 'Rapporto aiuti alla navigazione';

  @override
  String get docType21Family => 'Aiuti alla navigazione';

  @override
  String get docType21Summary =>
      'Trasmette posizione, nome e stato di un aiuto alla navigazione: boe, fari, fanali o aiuti virtuali. Spesso inviato da una posizione virtuale.';

  @override
  String get docType21EmittedBy => 'Stazioni AtoN (reali o virtuali)';

  @override
  String get docType21Cadence => 'Ogni 3 min (o su evento)';

  @override
  String get docType22Name => 'Gestione canali';

  @override
  String get docType22Family => 'Stazione di base e rete';

  @override
  String get docType22Summary =>
      'Usato da una stazione di base per spostare le stazioni su canali VHF diversi all\'interno di una zona geografica.';

  @override
  String get docType22EmittedBy => 'Stazioni di base';

  @override
  String get docType22Cadence => 'Su richiesta';

  @override
  String get docType23Name => 'Comando assegnazione di gruppo';

  @override
  String get docType23Family => 'Stazione di base e rete';

  @override
  String get docType23Summary =>
      'Un comando inviato da una stazione di base a un gruppo di navi in una zona, che imposta intervalli di trasmissione e modalità di trasmissione.';

  @override
  String get docType23EmittedBy => 'Stazioni di base';

  @override
  String get docType23Cadence => 'Su richiesta';

  @override
  String get docType24Name => 'Rapporto dati statici';

  @override
  String get docType24Family => 'Dati statici e di viaggio';

  @override
  String get docType24Summary =>
      'L\'equivalente di Classe B del tipo 5, diviso in Parte A (nome) e Parte B (tipo di nave, indicativo di chiamata, dimensioni).';

  @override
  String get docType24EmittedBy => 'Transponder di Classe B';

  @override
  String get docType24Cadence => 'Ogni 6 min';

  @override
  String get docType25Name => 'Messaggio binario a slot singolo';

  @override
  String get docType25Family => 'Dati binari';

  @override
  String get docType25Summary =>
      'Un messaggio binario breve che rientra in un singolo slot TDMA, con destinazione e ID applicazione opzionali.';

  @override
  String get docType25EmittedBy => 'Qualsiasi stazione';

  @override
  String get docType25Cadence => 'Su richiesta';

  @override
  String get docType26Name => 'Messaggio binario a slot multiplo';

  @override
  String get docType26Family => 'Dati binari';

  @override
  String get docType26Summary =>
      'Un messaggio binario più lungo distribuito su più slot TDMA, che trasporta informazioni sullo stato radio.';

  @override
  String get docType26EmittedBy => 'Qualsiasi stazione';

  @override
  String get docType26Cadence => 'Su richiesta';

  @override
  String get docType27Name =>
      'Rapporto di posizione per applicazioni a lungo raggio';

  @override
  String get docType27Family => 'Rapporti di posizione';

  @override
  String get docType27Summary =>
      'Un rapporto di posizione molto compatto progettato per la ricezione satellitare su lunghe distanze, con risoluzione ridotta.';

  @override
  String get docType27EmittedBy =>
      'Navi in modalità lungo raggio (satellitare)';

  @override
  String get docType27Cadence => 'Ogni 3 min (modalità lungo raggio)';

  @override
  String get docTimeline1990sTitle => 'Un\'invenzione svedese';

  @override
  String get docTimeline1990sText =>
      'Il concetto nasce in Svezia: un sistema VHF in cui ogni nave si annuncia affinché gli altri \"vedano e siano visti\", anche nella nebbia e dietro le isole. Viene presentato all\'IMO e diventa il seme dell\'AIS.';

  @override
  String get docTimeline1998Title => 'Inizia la standardizzazione';

  @override
  String get docTimeline1998Text =>
      'ITU e IEC iniziano a trasformare il concetto in uno standard radio con formati a livello di bit precisi, basato su TDMA su due canali VHF.';

  @override
  String get docTimeline2001Title => 'Pubblicata la ITU-R M.1371';

  @override
  String get docTimeline2001Text =>
      'La Raccomandazione ITU-R M.1371 \"Technical characteristics for a universal shipborne automatic identification system\" definisce i 27 tipi di messaggio e il loro layout di bit.';

  @override
  String get docTimeline2002Title => 'Obbligo SOLAS';

  @override
  String get docTimeline2002Text =>
      'L\'IMO rende l\'AIS obbligatorio per tutte le navi internazionali oltre le 300 tonnellate lorde e per tutte le navi passeggeri: circa 100 000 navi. L\'AIS diventa un aiuto anticollisione standard accanto al radar.';

  @override
  String get docTimeline2006Title => 'Arriva la Classe B';

  @override
  String get docTimeline2006Text =>
      'Viene pubblicato lo standard di Classe B, che apre la porta a transponder economici e semplici. Nello stesso anno, il satellite TacSat-2 è il primo a catturare segnali AIS dallo spazio (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Costellazioni satellitari';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire e altri dispiegano ricevitori AIS in orbita terrestre bassa, estendendo la copertura ben oltre l\'orizzonte VHF e consentendo un tracciamento quasi globale delle navi.';

  @override
  String get docTimeline2010Title => 'AIS-SART nel GMDSS';

  @override
  String get docTimeline2010Text =>
      'Il trasmettitore di ricerca e soccorso AIS (AIS-SART, IEC 61097-14) entra nel Global Maritime Distress and Safety System, consentendo alle scialuppe di trasmettere le posizioni di soccorso via AIS.';

  @override
  String get docTimeline2014Title => 'Pesca e flotte interne';

  @override
  String get docTimeline2014Text =>
      'Le normative europee richiedono l\'AIS di Classe A su tutte le navi da pesca dell\'UE oltre i 15 m; l\'AIS per vie navigabili interne è ampiamente diffuso sui fiumi europei.';

  @override
  String get docTimeline2021Title => '1,6 milioni di navi';

  @override
  String get docTimeline2021Text =>
      'Più di 1,6 milioni di navi sono dotate di AIS, alimentando reti terrestri e satellitari che alimentano il tracciamento delle navi, il controllo della pesca e la sicurezza marittima in tutto il mondo.';

  @override
  String get docTimelineVdesTitle => 'VDES — il successore';

  @override
  String get docTimelineVdesText =>
      'Il VHF Data Exchange System (ITU-R M.2092) viene implementato per alleggerire le aree congestionate, aggiungendo molta più larghezza di banda e servizi di e-navigation sicuri.';

  @override
  String get docAppTitle => 'Documentazione';

  @override
  String get docSearchChapters => 'Cerca capitoli';

  @override
  String get docChapterOverview => 'Panoramica';

  @override
  String get docChapterHistory => 'Storia e regolamentazione';

  @override
  String get docChapterHowItWorks => 'Come funziona';

  @override
  String get docChapterRadio => 'Radio e TDMA';

  @override
  String get docChapterClasses => 'Classi e apparecchiature';

  @override
  String get docChapterMmsi => 'MMSI e identità';

  @override
  String get docChapterShipTypes => 'Tipi di nave';

  @override
  String get docChapterMessages => 'I 27 messaggi';

  @override
  String get docChapterNmea => 'NMEA e AIVDM';

  @override
  String get docChapterPayload => 'Dentro il payload';

  @override
  String get docChapterSecurity => 'Sicurezza e limiti';

  @override
  String get docChapterFieldNotes => 'Note sul campo';

  @override
  String get docChapterKikais => 'L\'AIS in KikAis';

  @override
  String get docChapterGlossary => 'Glossario';

  @override
  String get docChapterCheatSheet => 'Prontuario';

  @override
  String get docChapterSources => 'Fonti';

  @override
  String get docOverviewTitle => 'Cos\'è l\'AIS?';

  @override
  String get docOverviewIntro =>
      'Il Sistema di Identificazione Automatica (AIS) è un sistema di tracciamento usato sulle navi e dai servizi di traffico navale (VTS). Ogni nave equipaggiata trasmette continuamente identità, posizione, rotta e velocità via radio VHF, così ogni altra nave e stazione di terra nel raggio può \"vederla\": il concetto di \"vedere ed essere visti\".';

  @override
  String get docOverviewRadar =>
      'L\'AIS non sostituisce il radar di bordo. Il radar rileva indipendentemente qualsiasi oggetto, ma ti dice poco su chi sia. L\'AIS ti dice esattamente chi, dove e dove sta andando: ma si fida di ciò che dichiara il mittente. I due sistemi si completano a vicenda.';

  @override
  String get docOverviewAdsBTitle => 'Pensalo come l\'ADS-B marittimo';

  @override
  String get docOverviewAdsBText =>
      'Proprio come l\'ADS-B consente agli aeromobili di annunciarsi al controllo del traffico aereo, l\'AIS consente alle navi di annunciarsi tra loro e alla terraferma. Le navi vedono il traffico circostante su un cartografo o su un display simile a un radar; le autorità portuali monitorano movimenti e pesca.';

  @override
  String get docOverviewTransponder => 'Cosa trasmette un transponder';

  @override
  String get docOverviewBullet1 =>
      'Identità unica: un numero MMSI di 9 cifre (le cui prime tre cifre identificano il paese emittente).';

  @override
  String get docOverviewBullet2 =>
      'Dati dinamici: posizione, velocità sul fondo (SOG), rotta sul fondo (COG), rotta vera, tasso di rotazione, stato di navigazione.';

  @override
  String get docOverviewBullet3 =>
      'Dati statici e di viaggio: nome, indicativo di chiamata, numero IMO, tipo di nave, dimensioni, pescaggio, destinazione, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Messaggi di sicurezza e binari: testi di soccorso, rapporti meteo, comandi di rete.';

  @override
  String get docOverviewWho => 'Chi deve trasportarlo';

  @override
  String get docOverviewImo =>
      'L\'IMO (convenzione SOLAS) impone l\'AIS sulle navi internazionali oltre le 300 tonnellate lorde e su tutte le navi passeggeri. Le regole regionali lo estendono alle flotte da pesca, alle vie navigabili interne e sempre più alle imbarcazioni da diporto tramite transponder di Classe B a basso costo.';

  @override
  String get docOverviewLimits => 'Limiti a colpo d\'occhio';

  @override
  String get docOverviewLimit1 =>
      'La portata è più o meno a linea di vista: circa 10-20 miglia nautiche tra navi, di più dalle stazioni costiere e dai satelliti.';

  @override
  String get docOverviewLimit2 =>
      'L\'AIS non ha autenticazione: chiunque può trasmettere qualsiasi identità (spoofing) o disturbare il canale.';

  @override
  String get docOverviewLimit3 =>
      'La precisione dipende dal fix GNSS del mittente e dall\'affidabilità dei dati che dichiara.';

  @override
  String get docHistoryIntro =>
      'L\'AIS è cresciuto da un\'idea svedese a un sistema di sicurezza obbligatorio mondiale. Tocca ogni tappa della timeline per i dettagli.';

  @override
  String get docHistoryStandards => 'Gli standard che lo governano';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — caratteristiche tecniche per un AIS universale di bordo (definisce i 27 tipi di messaggio e il loro layout di bit).';

  @override
  String get docHistoryStd2 =>
      'Linee guida IALA — chiarimenti e indicazioni di implementazione.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — l\'inquadramento delle frasi NMEA e i requisiti di Classe B/CSTDMA.';

  @override
  String get docHistoryStd4 =>
      'IEC 61097-14 — il trasmettitore di soccorso AIS-SART.';

  @override
  String get docHowIntro =>
      'L\'AIS è un sistema radio VHF. Ogni transponder ascolta il traffico intorno a sé e trasmette i propri rapporti in slot temporali riservati, evitando collisioni con le altre navi nel raggio.';

  @override
  String get docHowRadioLink => 'Il collegamento radio';

  @override
  String get docHowRadioLink1 =>
      'Due canali VHF dedicati: AIS 1 a 161.975 MHz (87B) e AIS 2 a 162.025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'FM digitale a banda stretta, a 9 600 bit al secondo.';

  @override
  String get docHowRadioLink3 =>
      'I messaggi sono organizzati in frame TDMA di 2250 slot temporali (1 minuto).';

  @override
  String get docHowSlots => 'Come vengono condivisi gli slot';

  @override
  String get docHowSotdma =>
      'I transponder di Classe A usano SOTDMA (Self-Organizing Time Division Multiple Access): ogni unità riserva uno slot ricorrente e lo ri-riserva quando il quadro cambia, così le navi si coordinano continuamente senza un controllore centrale.';

  @override
  String get docHowCstdma =>
      'I transponder di Classe B usano il più semplice CSTDMA (Carrier Sense TDMA): ascoltano per trovare uno slot libero e lo occupano, motivo per cui i rapporti di Classe B sono meno frequenti e possono perdersi nel traffico molto denso.';

  @override
  String get docHowRates => 'Frequenze di trasmissione';

  @override
  String get docHowRates1 =>
      'Rapporto di posizione Classe A (tipo 1): ogni 2-10 secondi in navigazione, ogni 3 minuti all\'ancora.';

  @override
  String get docHowRates2 =>
      'Dati statici e di viaggio (tipo 5): ogni 6 minuti.';

  @override
  String get docHowRates3 =>
      'Posizione Classe B (tipo 18): circa ogni 30 secondi.';

  @override
  String get docHowRates4 => 'Aiuto alla navigazione (tipo 21): ogni 3 minuti.';

  @override
  String get docHowTerrestrial => 'Terrestre e satellitare';

  @override
  String get docHowTerrestrialText =>
      'In superficie, la portata AIS è limitata dall\'orizzonte VHF (T-AIS). Dalla metà degli anni 2000, i satelliti in orbita terrestre bassa (S-AIS) ricevono gli stessi segnali, dando una copertura quasi globale: i satelliti completano, non sostituiscono, la rete terrestre.';

  @override
  String get docRadioIntro =>
      'Sotto i messaggi si trova un sistema radio piccolo ed efficiente. L\'AIS trasmette a 9 600 bit al secondo su due canali VHF, usando la modulazione Gaussian minimum-shift keying (GMSK) e l\'inquadramento stile HDLC.';

  @override
  String get docRadioPhysical => 'Il collegamento fisico';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 a 161.975 MHz e AIS 2 a 162.025 MHz (canali VHF 87B e 88B).';

  @override
  String get docRadioPhysical2 =>
      'Modulazione GMSK a 9 600 baud: abbastanza stretta da stare nella banda VHF marittima.';

  @override
  String get docRadioPhysical3 =>
      'Inquadramento HDLC con bit stuffing e codifica di linea NRZI, ereditati dal mondo della radio-pacchetto.';

  @override
  String get docRadioFrames => 'Frame e slot TDMA';

  @override
  String get docRadioFrames1 =>
      'Ogni canale è diviso in frame di esattamente 1 minuto, suddivisi in 2 250 slot temporali di circa 26,7 ms ciascuno.';

  @override
  String get docRadioFrames2 =>
      'Uno slot trasporta un messaggio AIS (256 bit con rampa di salita/discesa e tempo di guardia).';

  @override
  String get docRadioFrames3 =>
      'Le stazioni riusano gli stessi slot a ogni frame così trasmettono periodicamente senza collidere.';

  @override
  String get docRadioCode =>
      '2250 slot/frame · 1 frame = 60 s · slot ≈ 26,7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — come la Classe A si auto-organizza';

  @override
  String get docRadioSotdmaText =>
      'Ogni transponder di Classe A ascolta gli slot intorno a sé, ne sceglie uno libero e annuncia nel suo campo stato radio quando trasmetterà la volta successiva. Le stazioni ri-riservano continuamente mentre il quadro del traffico cambia, quindi non serve un coordinatore centrale.';

  @override
  String get docRadioCstdma => 'CSTDMA — come si inserisce la Classe B';

  @override
  String get docRadioCstdmaText =>
      'Le unità di Classe B sono più semplici: ascoltano per trovare uno slot attualmente libero e vi trasmettono una volta. È più economico, ma i rapporti di Classe B possono perdersi nel traffico molto denso in cui uno slot è sempre occupato.';

  @override
  String get docRadioVdes => 'VDES — il futuro';

  @override
  String get docRadioVdesText =>
      'Il VHF Data Exchange System (ITU-R M.2092) sta per essere implementato per alleggerire le acque congestionate: aggiunge nuove frequenze, molta più larghezza di banda e dati bidirezionali sicuri per la e-navigation, accanto all\'attuale servizio AIS.';

  @override
  String get docClassesIntro =>
      'L\'hardware AIS esiste in diverse classi e ruoli. I due che incontrerai più spesso sono il transponder di Classe A completo e l\'unità di Classe B economica.';

  @override
  String get docClassesComparison => 'Classe A vs Classe B';

  @override
  String get docClassesReceivers => 'Ricevitori e transponder';

  @override
  String get docClassesReceiversText =>
      'I transponder sia ricevono sia trasmettono. Molte stazioni di terra e appassionati usano solo ricevitori, così possono osservare il traffico senza comparire su di esso.';

  @override
  String get docClassesAton => 'Aiuti alla navigazione';

  @override
  String get docClassesAtonText =>
      'Le stazioni AtoN (tipo 21) trasmettono boe, fari e fanali. Possono anche trasmettere un aiuto virtuale: un segnalatore che esiste solo sulle carte, utile per avvisare di un nuovo pericolo.';

  @override
  String get docClassesDistress => 'Dispositivi di soccorso e sicurezza';

  @override
  String get docClassesDistressIntro =>
      'Oltre alle navi normali, l\'AIS trasporta trasmettitori di soccorso che ogni ricevitore dovrebbe saper individuare:';

  @override
  String get docClassesSartNote =>
      'Un SART in azione imposta anche lo stato di navigazione 14 (\"AIS-SART attivo\") sul suo rapporto di posizione.';

  @override
  String get docShipTypesIntro =>
      'I messaggi statici di tipo 5 e 24 trasportano un codice di tipo di nave a 8 bit (0-99) che descrive cos\'è l\'imbarcazione: cargo, petroliera, peschereccio, unità da diporto e così via. La tabella completa è mostrata di seguito.';

  @override
  String get docShipTypesCategories => 'Categorie a colpo d\'occhio';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle =>
      'Note sul campo e particolarità del mondo reale';

  @override
  String get docFieldNotesIntro =>
      'Il traffico AIS reale non corrisponde sempre alla teoria. Conoscere queste particolarità ti aiuta a fidarti di ciò che mostra il decoder e di ciò che rifiuta.';

  @override
  String get docGlossaryIntro =>
      'Un dizionario ricercabile degli acronimi e dei termini usati in tutta questa guida e dalla comunità AIS.';

  @override
  String get docCheatSheetIntro =>
      'I numeri e i codici essenziali a colpo d\'occhio: frequenze, frequenze di trasmissione, codici di stato e formati.';

  @override
  String get docMmsiIntro =>
      'La Maritime Mobile Service Identity (MMSI) è un numero unico di 9 cifre che identifica l\'apparecchiatura radio di una nave, come un numero di telefono per l\'imbarcazione. Le sue prime tre cifre sono il MID: le Maritime Identification Digits che identificano il paese che lo ha emesso.';

  @override
  String get docMmsiFormats => 'Formati numerici';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Cerca un MMSI';

  @override
  String get docMmsiLookupHint =>
      'Inserisci un MMSI di 9 cifre qui sotto per vedere la sua classe e il paese dell\'autorità emittente.';

  @override
  String get docMmsiMidHeading => 'Codici di paese (MID)';

  @override
  String get docMmsiMidText =>
      'La tabella completa dei MID è inclusa in KikAis e usata ovunque venga visualizzato un MMSI.';

  @override
  String get docMessagesTitle => 'I 27 tipi di messaggio';

  @override
  String get docMessagesIntro =>
      'Ogni payload AIS inizia con un tipo di messaggio a 6 bit (da 1 a 27). Il catalogo qui sotto li raggruppa per famiglia. Ogni card mostra una vera frase NMEA generata dal codificatore di KikAis, i suoi campi decodificati e un pulsante per aprirla nel Decoder.';

  @override
  String get docNmeaTitle => 'Inquadramento NMEA e AIVDM';

  @override
  String get docNmeaIntro =>
      'Sul filo, i messaggi AIS viaggiano come frasi NMEA 0183 che iniziano con !AIVDM (altre navi) o !AIVDO (la tua nave). Il payload è un vettore di bit protetto da armoring ASCII.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Campi della frase';

  @override
  String get docNmeaField1 =>
      'Talker e formatter — !AIVDM o !AIVDO (vedi gli ID talker qui sotto).';

  @override
  String get docNmeaField2 =>
      'Numero di frammenti — quante frasi compongono il messaggio completo (NMEA limita ogni riga a circa 82 caratteri).';

  @override
  String get docNmeaField3 =>
      'Numero di frammento — quale parte è questa (partendo da 1).';

  @override
  String get docNmeaField4 =>
      'ID messaggio sequenziale — collega i frammenti dello stesso messaggio.';

  @override
  String get docNmeaField5 => 'Canale radio — A o B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 => 'Payload dati — il payload AIS armato a sei bit.';

  @override
  String get docNmeaField7 =>
      'Bit di riempimento — quanti bit di padding sono stati aggiunti all\'ultimo gruppo da 6 bit (0-5).';

  @override
  String get docNmeaField8 =>
      'Checksum — lo XOR di tutti i byte prima del *, in esadecimale.';

  @override
  String get docNmeaMulti => 'Messaggi a più frammenti';

  @override
  String get docNmeaMultiText =>
      'I messaggi più lunghi di una riga (come i dati statici di tipo 5) vengono divisi: la prima frase riporta un numero di frammenti di 2 e la seconda lo completa con lo stesso ID messaggio.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Armoring a sei bit';

  @override
  String get docNmeaArmoringText =>
      'Ogni carattere del payload contiene 6 bit. Sottrai 48 dal codice ASCII, poi sottrai altri 8 se il risultato è superiore a 40.';

  @override
  String get docNmeaTalkers => 'ID talker';

  @override
  String get docNmeaTalkersIntro =>
      'Diversi ID talker NMEA 4.0 identificano il tipo di stazione AIS:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Checksum';

  @override
  String get docNmeaChecksumText =>
      'Il checksum finale è lo XOR di ogni byte tra \"!\" e \"*\". Calcola il tuo qui sotto:';

  @override
  String get docNmeaInspectorTitle => 'Prova tu: ispettore di frasi';

  @override
  String get docNmeaInspectorText =>
      'Incolla una qualsiasi frase AIVDM/AIVDO (o usa un esempio qui sopra) per vedere i suoi campi scomposti e i valori decodificati.';

  @override
  String get docPayloadIntro =>
      'Una volta rimosso l\'armoring a sei bit, un payload AIS è una sequenza di campi di bit. I primi sei bit sono il tipo di messaggio; i successivi due sono l\'indicatore di ripetizione; poi vengono 30 bit di MMSI.';

  @override
  String get docPayloadCnb => 'Il blocco di navigazione comune (tipi 1-3)';

  @override
  String get docPayloadCnbText =>
      'Il layout più importante è condiviso dai rapporti di posizione di Classe A. Usa il selettore per sfogliare i principali layout di messaggio e clicca un segmento per leggere cosa codifica.';

  @override
  String get docPayloadCoords => 'Coordinate';

  @override
  String get docPayloadCoordsText =>
      'Latitudine e longitudine sono memorizzate in 1/10 000 di minuto. Dividi per 600 000 per ottenere i gradi: 60 minuti in un grado e 10 000 unità per minuto. Est/Nord sono positivi.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // es. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert => 'Converti le tue coordinate qui sotto:';

  @override
  String get docPayloadSpeed => 'Velocità, rotta, direzione';

  @override
  String get docPayloadSpeed1 =>
      'SOG — velocità sul fondo in decimi di nodo (0-102.2 kn); 1023 significa \"non disponibile\".';

  @override
  String get docPayloadSpeed2 =>
      'COG — rotta sul fondo in decimi di grado, relativa al nord vero.';

  @override
  String get docPayloadSpeed3 =>
      'Rotta — rotta vera in gradi interi; 511 significa \"non disponibile\".';

  @override
  String get docPayloadSpeed4 =>
      'ROT — tasso di rotazione: valore ≈ 4.733 × √(tasso di rotazione in °/min), con segno (positivo = dritta).';

  @override
  String get docPayloadNavStatus => 'Stato di navigazione';

  @override
  String get docPayloadEpfd => 'Tipo di fix della posizione (EPFD)';

  @override
  String get docPayloadText => 'Testo a sei bit';

  @override
  String get docPayloadTextIntro =>
      'Nomi, indicativi di chiamata e destinazioni usano lo stesso alfabeto a sei bit del payload stesso. Le lettere minuscole non possono essere codificate, motivo per cui i nomi AIS sono di solito in maiuscolo.';

  @override
  String get docSecurityTitle => 'Sicurezza e qualità dei dati';

  @override
  String get docSecurityIntro =>
      'L\'AIS è progettato per la cooperazione, non per la sicurezza. Il canale radio è aperto e non cifrato e non c\'è autenticazione di chi sta trasmettendo.';

  @override
  String get docSecurityThreats => 'Minacce';

  @override
  String get docSecurityThreat1 =>
      'Spoofing — trasmettere un MMSI, una posizione o un\'identità falsi (navi fantasma, elusione delle sanzioni).';

  @override
  String get docSecurityThreat2 =>
      'Jamming — inondare i due canali VHF così che il traffico reale non possa essere ricevuto.';

  @override
  String get docSecurityThreat3 =>
      'Meaconing — riprodurre segnali reali provenienti da altrove per confondere i ricevitori.';

  @override
  String get docSecurityQuality => 'Qualità dei dati';

  @override
  String get docSecurityQuality1 =>
      'Il bit di precisione della posizione distingue un fix GNSS non potenziato (> 10 m) da un fix di qualità DGPS (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'I ricevitori dovrebbero controllare la coerenza di posizioni, velocità e timestamp; circa lo 0,3% dei messaggi reali ha una lunghezza di payload errata.';

  @override
  String get docSecurityQuality3 =>
      'L\'AIS satellitare subisce occasionalmente collisioni perché l\'impronta del satellite è molto più grande di una cella TDMA: un motivo in più per correlare con il radar e altre fonti.';

  @override
  String get docKikaisIntro =>
      'KikAis è un vero e proprio laboratorio AIS: ricevi traffico live o simulato, decodificalo, ispeziona e invia i tuoi messaggi e costruisci flotte. Ecco come ogni scheda corrisponde a ciò che hai appena letto.';

  @override
  String get docTabReceptionText =>
      'Scegli i feed (file, seriale, simulazione), avvia il forwarder e osserva il flusso NMEA grezzo e le imbarcazioni decodificate.';

  @override
  String get docTabSendText =>
      'Inoltra le frasi ricevute a una o più destinazioni TCP/UDP: è così che una stazione di terra distribuirebbe il traffico.';

  @override
  String get docTabMapText =>
      'Guarda le navi decodificate tracciate dai loro rapporti di posizione di tipo 1/2/3, 18, 19 e 27.';

  @override
  String get docTabEditorText =>
      'Costruisci a mano uno qualsiasi dei 27 tipi di messaggio da un modulo intuitivo e invialo: il modo migliore per imparare i campi.';

  @override
  String get docTabDecoderText =>
      'Incolla qualsiasi frase e ottieni i campi decodificati, il checksum e la gestione dei frammenti: il compagno pratico di questa guida.';

  @override
  String get docTabStatsText =>
      'Contatori di messaggi, frequenze per feed e salute del decoder (checksum non validi, frammenti scartati).';

  @override
  String get docTabSimulationText =>
      'Genera un\'intera flotta intorno a qualsiasi posizione: ogni tipo di messaggio, schema MMSI, forma di zona e persino iniezione di errori.';

  @override
  String get docSourcesIntro =>
      'Questa guida sintetizza documentazione autorevole e pubblicamente disponibile:';

  @override
  String get docSources1 =>
      'gpsd — decodifica del protocollo AIVDM/AIVDO, di Eric S. Raymond (la bibbia tecnica de facto per il formato delle frasi e i campi di bit del payload).';

  @override
  String get docSources2 =>
      'Wikipedia — Automatic Identification System (panoramica, storia, applicazioni, sicurezza).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — pagine sull\'AIS.';

  @override
  String get docSources4 =>
      'Raccomandazione ITU-R M.1371 — lo standard AIS che lo governa.';

  @override
  String get docSources5 => 'IALA — chiarimenti della ITU-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — inquadramento NMEA, Classe B e AIS-SART.';

  @override
  String get docSourcesLearn => 'Come approfondire';

  @override
  String get docSourcesLearnText =>
      'Il modo migliore per capire l\'AIS è sperimentare: usa l\'Editor per costruire messaggi, il Decoder per rileggerli e la scheda Simulazione per osservare un\'intera flotta. Tutto in questa guida è generato dal codificatore e dal decoder di KikAis.';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return 'Tipo $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits bit · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return 'Emesso da: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Apri nel Decoder';

  @override
  String get docInspectorNmeaLabel => 'Frase NMEA';

  @override
  String get docInspectorInspect => 'Ispeziona';

  @override
  String get docInspectorInvalidChecksum => 'Checksum non valido';

  @override
  String get docInspectorCouldNotDecode => 'Impossibile decodificare';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Decodificato: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Tipo $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 cifre)';

  @override
  String get docMmsiLookupButton => 'Cerca';

  @override
  String get docMmsiLookupError => 'Inserisci un MMSI di 9 cifre (solo cifre).';

  @override
  String get docMmsiLookupClassGroup => 'Gruppo di navi (chiamata di gruppo)';

  @override
  String get docMmsiUnknownCountry => 'paese sconosciuto';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Apri';

  @override
  String get updateCheckForUpdates => 'Controlla aggiornamenti';

  @override
  String get updateChecking => 'Controllo aggiornamenti…';

  @override
  String updateNewVersion(Object version) {
    return 'Nuova versione $version';
  }

  @override
  String get updateUpToDate => 'Sei aggiornato.';

  @override
  String get updateCheckFailed => 'Controllo aggiornamenti non riuscito.';

  @override
  String get tooltipLanguage =>
      'Cambiare la lingua dell\'interfaccia. Tutte e dieci le lingue sono completamente tradotte; scegli \"Auto\" per seguire la lingua del sistema.';

  @override
  String get tooltipTheme =>
      'Cambiare il tema dei colori: scuro, chiaro o ad alto contrasto. L\'alto contrasto migliora la leggibilità.';

  @override
  String get tooltipUpdate =>
      'Verificare la presenza di una nuova versione. Se disponibile, appare un badge verde accanto al numero di versione.';

  @override
  String get tooltipMapSearch =>
      'Cercare un\'imbarcazione per nome, MMSI o numero IMO, quindi centrare e seguire la mappa su di essa.';

  @override
  String get tooltipMapFilters =>
      'Filtrare le imbarcazioni visualizzate: per tipo, stato di navigazione, paese (MID), velocità o solo nome.';

  @override
  String get tooltipMapCluster =>
      'Attiva/disattiva il raggruppamento delle imbarcazioni. Quando è attivo, le imbarcazioni vicine vengono raggruppate in un unico marker con conteggio.';

  @override
  String get tooltipMapTrails =>
      'Attiva/disattiva le tracce. Quando sono attive, ogni imbarcazione disegna il proprio percorso recente sulla mappa.';

  @override
  String get tooltipMapVectors =>
      'Attiva/disattiva i vettori di rotta. Quando sono attivi, ogni imbarcazione mostra una freccia lungo la propria rotta.';

  @override
  String get tooltipMapSendToMap =>
      'Attiva/disattiva l\'invio delle imbarcazioni decodificate alla mappa. Quando è attivo, ogni imbarcazione decodificata appare come marker.';

  @override
  String get tooltipMapClear =>
      'Rimuove tutte le imbarcazioni attualmente sulla mappa.';

  @override
  String get tooltipMapBasemap =>
      'Scegliere lo sfondo della mappa. \"Auto\" segue il tema corrente.';

  @override
  String get tooltipSendAdd =>
      'Aggiungere una nuova destinazione di invio (UDP o TCP, client o server). I frame AIS ricevuti vengono inoltrati a ogni destinazione attivata.';

  @override
  String get tooltipSendEdit =>
      'Modificare nome, protocollo, host, porta e formato dei frame di questa destinazione.';

  @override
  String get tooltipSendDelete =>
      'Eliminare questa destinazione. L\'operazione non può essere annullata.';

  @override
  String get tooltipSendToggle =>
      'Attivare o disattivare l\'inoltro a questa destinazione.';

  @override
  String get tooltipSendLocked =>
      'Le destinazioni sono bloccate mentre il forwarder è in esecuzione. Ferma la sorgente nella scheda Ricezione per modificarle.';

  @override
  String get tooltipReceptionAddSource =>
      'Aggiungere una sorgente dati: un feed di rete (UDP/TCP/gpsd), un file di frasi NMEA registrate o una porta seriale.';

  @override
  String get tooltipReceptionStart =>
      'Avviare la ricezione e l\'inoltro dei frame AIS da tutte le sorgenti attivate.';

  @override
  String get tooltipReceptionStop =>
      'Fermare la ricezione e l\'inoltro dei frame AIS.';

  @override
  String get tooltipReceptionFeed =>
      'Attivare o disattivare questa sorgente AIS.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Salvare il registro di connessione in un file di testo.';

  @override
  String get tooltipReceptionClearLogs =>
      'Cancellare il registro di connessione.';

  @override
  String get tooltipReceptionRemoveSource => 'Rimuovere questa sorgente AIS.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Quando è attivo, i frame con checksum NMEA non valido vengono rifiutati.';

  @override
  String get tooltipReceptionImportFormat =>
      'Come i frame ricevuti vengono normalizzati prima della decodifica.';

  @override
  String get tooltipReceptionLoop =>
      'Quando è attivo, la riproduzione del file ricomincia dall\'inizio dopo la fine.';

  @override
  String get tooltipReceptionSpeed =>
      'Moltiplicatore di velocità di riproduzione (1x = tempo reale).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Aggiornare l\'elenco delle porte seriali disponibili.';

  @override
  String get tooltipSimApply =>
      'Applicare le impostazioni correnti e generare la flotta. Le flotte grandi vengono generate in background.';

  @override
  String get tooltipSimGenerate =>
      'Generare una nuova flotta casuale con un nuovo seed, quindi applicarla.';

  @override
  String get tooltipSimOpenReception =>
      'Andare alla scheda Ricezione per avviare il feed di simulazione.';

  @override
  String get tooltipSimRadius =>
      'Raggio della zona di navigazione attorno al centro, in chilometri.';

  @override
  String get tooltipSimVessels =>
      'Numero di imbarcazioni da generare nella flotta.';

  @override
  String get tooltipSimSpeedMin =>
      'Velocità minima delle imbarcazioni, in nodi.';

  @override
  String get tooltipSimSpeedMax =>
      'Velocità massima delle imbarcazioni, in nodi.';

  @override
  String get tooltipSimInterval => 'Ritardo tra due emissioni, in secondi.';

  @override
  String get tooltipSimSeed =>
      'Seme casuale. Lo stesso seme produce sempre la stessa flotta.';

  @override
  String get tooltipSimAnchored =>
      'Percentuale di imbarcazioni all\'ancora o ormeggiate invece che in movimento.';

  @override
  String get tooltipSimNamePrefix =>
      'Prefisso usato per i nomi delle imbarcazioni generate.';

  @override
  String get tooltipSimMmsiMid =>
      'Cifre di identificazione marittima (codice paese a 3 cifre) per costruire gli MMSI.';

  @override
  String get tooltipSimCenterLat =>
      'Latitudine del centro della zona di navigazione.';

  @override
  String get tooltipSimCenterLon =>
      'Longitudine del centro della zona di navigazione.';

  @override
  String get tooltipSimTransit =>
      'Percentuale di imbarcazioni che attraversano la zona in rotta diretta.';

  @override
  String get tooltipSimRegenEvery =>
      'Rigenera la flotta ogni N emissioni quando la rigenerazione periodica è attiva.';

  @override
  String get tooltipSimReportInterval =>
      'Intervallo massimo del rapporto di posizione per imbarcazione, in emissioni.';

  @override
  String get tooltipSimWander =>
      'Intensità della deriva casuale della rotta (0 = linee rette).';

  @override
  String get tooltipSimClassBShare =>
      'Percentuale di rapporti di posizione classe B rispetto a classe A quando entrambi sono attivi.';

  @override
  String get tooltipSimErrorRate =>
      'Probabilità di corrompere o duplicare ogni frase emessa.';

  @override
  String get tooltipSimBaseStations =>
      'Numero di stazioni base fisse da generare.';

  @override
  String get tooltipSimAtoN =>
      'Numero di ausili alla navigazione (boe) fissi da generare.';

  @override
  String get tooltipSimRealisticNames =>
      'Usare nomi, nominativi e destinazioni realistici.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Scalare dimensioni e pescaggio in base al tipo di imbarcazione.';

  @override
  String get tooltipSimRealisticMmsi =>
      'Costruire MMSI conformi alla struttura ITU per categoria di imbarcazione.';

  @override
  String get tooltipSimVarySpeed =>
      'Lasciare che la velocità vari leggermente nel range configurato.';

  @override
  String get tooltipSimSpeedByType =>
      'Scegliere la velocità dal range tipico di ogni tipo di imbarcazione.';

  @override
  String get tooltipSimHighAccuracy =>
      'Impostare il flag di posizione ad alta precisione sui rapporti emessi.';

  @override
  String get tooltipSimRealisticRot =>
      'Emettere una velocità di rotazione derivata dal cambio di rotta.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Rigenerare automaticamente la flotta ogni N emissioni per simulare traffico variabile.';

  @override
  String get tooltipSimInjectErrors =>
      'Corrompere o duplicare alcune frasi emesse per testare la gestione degli errori.';

  @override
  String get tooltipSimNmea4Tag =>
      'Prefissare ogni frame emesso con un blocco di tag NMEA 4.0.';

  @override
  String get tooltipSimVesselType =>
      'Includere questo tipo di imbarcazione nella flotta.';

  @override
  String get tooltipSimMessageType => 'Emettere questo tipo di messaggio AIS.';

  @override
  String get tooltipDecoderClear =>
      'Cancellare l\'input e i risultati del decodificatore.';

  @override
  String get tooltipStatsDecode =>
      'Mettere in pausa o riprendere la decodifica dei frame AIS ricevuti.';

  @override
  String get tooltipStatsReset =>
      'Azzerare tutti i contatori delle statistiche.';

  @override
  String get tooltipDocOpenTab => 'Aprire questa sezione nella propria scheda.';

  @override
  String get tooltipEditorInject =>
      'Iniettare il messaggio composto nel decodificatore come se fosse stato ricevuto.';

  @override
  String get tooltipEditorSend =>
      'Inviare il messaggio composto a ogni destinazione di invio attivata.';

  @override
  String get tooltipCopy => 'Copia negli appunti.';

  @override
  String get tooltipClose => 'Chiudi questo pannello.';

  @override
  String get tooltipBrowse => 'Sfoglia per scegliere un file.';

  @override
  String get tooltipFeedName =>
      'Un\'etichetta che identifica questa sorgente nell\'elenco dei feed.';

  @override
  String get tooltipFeedHost =>
      'Indirizzo del server che trasmette le frasi AIS.';

  @override
  String get tooltipFeedPort =>
      'Porta TCP o UDP usata per raggiungere il server.';

  @override
  String get tooltipFeedHeader =>
      'Byte opzionali inviati alla connessione, prima della lettura (es. una richiesta gpsd).';

  @override
  String get tooltipFeedFile =>
      'Percorso di un file di testo con frasi NMEA registrate.';

  @override
  String get tooltipFeedInterval =>
      'Ritardo tra due frame durante la riproduzione del file.';

  @override
  String get tooltipFeedLoop =>
      'Riavvia la riproduzione del file dall\'inizio quando si raggiunge la fine.';

  @override
  String get tooltipFeedSpeed =>
      'Moltiplicatore di velocità di riproduzione (1x = tempo reale).';

  @override
  String get tooltipFeedSerialPort =>
      'Porta seriale del ricevitore AIS (es. COM3 o /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Baud rate usato per comunicare con il ricevitore AIS seriale.';

  @override
  String get tooltipFeedRtlDevice =>
      'Il dongle RTL-SDR usato per ricevere AIS in VHF.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Lascia che il sintonizzatore regoli il guadagno automaticamente. Consigliato per la maggior parte.';

  @override
  String get tooltipFeedRtlGain =>
      'Guadagno fisso del sintonizzatore in decibel, usato quando il guadagno automatico è disattivato.';

  @override
  String get tooltipFeedRtlChannels =>
      'Quali canali VHF AIS decodificare: A (161,975 MHz), B (162,025 MHz) o entrambi.';

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

  @override
  String get statsChannelOccupancy => 'Occupazione canale';

  @override
  String get statsChannelA => 'Ch A · 161,975 MHz';

  @override
  String get statsChannelB => 'Ch B · 162,025 MHz';

  @override
  String get statsChannelOther => 'Altro';

  @override
  String get statsChannelNoData => 'Nessun dato canale ancora';

  @override
  String statsChannelPercent(Object percent) => '${percent} %';

  @override
  String statsChannelRate(Object rate) => '${rate}/s';
}
