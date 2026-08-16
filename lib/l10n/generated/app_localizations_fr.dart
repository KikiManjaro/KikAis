// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get languageSystem => 'Auto (système)';

  @override
  String get languageEn => 'Anglais';

  @override
  String get languageFr => 'Français';

  @override
  String get languageEs => 'Espagnol';

  @override
  String get languageDe => 'Allemand';

  @override
  String get languagePt => 'Portugais';

  @override
  String get languageIt => 'Italien';

  @override
  String get languageNl => 'Néerlandais';

  @override
  String get languageZh => 'Chinois';

  @override
  String get languageJa => 'Japonais';

  @override
  String get languageRu => 'Russe';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeHighContrast => 'Contraste élevé';

  @override
  String get tabReception => 'Réception';

  @override
  String get tabSend => 'Envoi';

  @override
  String get tabMap => 'Carte';

  @override
  String get tabEditor => 'Éditeur';

  @override
  String get tabTools => 'Outils';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabSimulation => 'Simulation';

  @override
  String get tabDocs => 'Docs';

  @override
  String get protocolUdpServer => 'Serveur UDP';

  @override
  String get protocolUdpClient => 'Client UDP';

  @override
  String get protocolTcpClient => 'Client TCP';

  @override
  String get protocolTcpServer => 'Serveur TCP';

  @override
  String get formatPassthrough => 'Pass-through';

  @override
  String get formatStrip => 'Supprimer les blocs de tag';

  @override
  String get formatTag => 'Ajouter un bloc de tag';

  @override
  String get sendAddDestination => 'Ajouter une destination';

  @override
  String get sendEditDestination => 'Modifier la destination';

  @override
  String get sendFormat => 'Format d\'envoi';

  @override
  String get sendSave => 'Enregistrer';

  @override
  String get sendLockedBanner =>
      'Le forwarder est en cours d\'exécution — les destinations sont verrouillées.';

  @override
  String get sendEmpty =>
      'Aucune destination pour l\'instant. Ajoutez-en une pour transférer les trames AIS reçues.';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldProtocol => 'Protocole';

  @override
  String get fieldHost => 'Hôte';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldTagSourceId => 'ID source du tag';

  @override
  String get fieldFile => 'Fichier';

  @override
  String get fieldCancel => 'Annuler';

  @override
  String get fieldAdd => 'Ajouter';

  @override
  String get receptionFeeds => 'Flux';

  @override
  String get receptionValidateChecksums =>
      'Valider les sommes de contrôle NMEA';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phrases perdues',
      one: '1 phrase perdue',
      zero: 'Aucune phrase perdue',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Format d\'import des trames';

  @override
  String get receptionStart => 'Démarrer';

  @override
  String get receptionStop => 'Arrêter';

  @override
  String get receptionLogs => 'Journaux';

  @override
  String get receptionFrameCopied => 'Trame copiée';

  @override
  String get receptionAddSource => 'Ajouter une source';

  @override
  String get receptionNetwork => 'Réseau';

  @override
  String get receptionFile => 'Fichier';

  @override
  String get receptionSerial => 'Série';

  @override
  String get receptionHeaderOptional => 'En-tête (facultatif)';

  @override
  String get receptionPathOrBrowse => 'Chemin ou Parcourir…';

  @override
  String get receptionIntervalMs => 'Intervalle entre les trames (ms)';

  @override
  String get receptionReplayTimestamps =>
      'Relire en utilisant les horodatages du fichier';

  @override
  String get receptionReplayTimestampsHint =>
      'Suit les heures enregistrées (bloc de tag t: ou préfixe d\'horodatage) au lieu d\'un intervalle fixe';

  @override
  String get receptionSpeed => 'Vitesse';

  @override
  String get receptionReplayLoop => 'Boucle (relire depuis le début)';

  @override
  String get receptionSerialPort => 'Port série';

  @override
  String get receptionSerialPortHint => 'ex. COM3 ou /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Débit en bauds';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'Périphérique RTL-SDR';

  @override
  String get tooltipReceptionRtlSdrDevices =>
      'Actualiser la liste des dongles RTL-SDR';

  @override
  String get receptionRtlSdrNoDevice =>
      'Aucun périphérique RTL-SDR trouvé. Installez les pilotes RTL-SDR (Zadig / WinUSB sur Windows) et branchez le dongle.';

  @override
  String get receptionRtlSdrAutoGain => 'Gain automatique (recommandé)';

  @override
  String get receptionRtlSdrGainDb => 'Gain du tuner (dB)';

  @override
  String get receptionRtlSdrSampleRate => 'Fréquence d\'échantillonnage';

  @override
  String get receptionRtlSdrChannels => 'Canaux';

  @override
  String get msgType1 => 'Compte-rendu de position Classe A';

  @override
  String get msgType2 => 'Compte-rendu de position Classe A (assigné)';

  @override
  String get msgType3 => 'Compte-rendu de position Classe A (réponse)';

  @override
  String get msgType4 => 'Station de base';

  @override
  String get msgType5 => 'Données statiques et de voyage';

  @override
  String get msgType6 => 'Message binaire adressé';

  @override
  String get msgType7 => 'Accusé de réception binaire';

  @override
  String get msgType8 => 'Message binaire diffusé';

  @override
  String get msgType9 => 'Compte-rendu de position d\'aéronef SAR standard';

  @override
  String get msgType10 => 'Demande d\'heure UTC/date';

  @override
  String get msgType11 => 'Réponse d\'heure UTC/date';

  @override
  String get msgType12 => 'Message de sécurité adressé';

  @override
  String get msgType13 => 'Accusé de réception de sécurité';

  @override
  String get msgType14 => 'Message de sécurité diffusé';

  @override
  String get msgType15 => 'Interrogation';

  @override
  String get msgType16 => 'Commande de mode assignation';

  @override
  String get msgType17 => 'Message binaire diffusé DGNSS';

  @override
  String get msgType18 => 'Compte-rendu de position CS Classe B standard';

  @override
  String get msgType19 => 'Compte-rendu de position étendu Classe B';

  @override
  String get msgType20 => 'Message de gestion de liaison de données';

  @override
  String get msgType21 => 'Compte-rendu d\'aide à la navigation';

  @override
  String get msgType22 => 'Gestion des canaux';

  @override
  String get msgType23 => 'Commande d\'assignation de groupe';

  @override
  String get msgType24 => 'Compte-rendu de données statiques';

  @override
  String get msgType25 => 'Message binaire mono-tranche';

  @override
  String get msgType26 => 'Message binaire multi-tranches';

  @override
  String get msgType27 => 'Compte-rendu de position longue portée';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsFeed => 'Flux';

  @override
  String get statsAllFeeds => 'Tous les flux';

  @override
  String get statsReceived => 'Reçus';

  @override
  String get statsDecoded => 'Décodés';

  @override
  String get statsInvalidChecksums => 'Sommes de contrôle invalides';

  @override
  String get statsDroppedFragments => 'Fragments perdus';

  @override
  String get statsParseErrors => 'Erreurs d\'analyse';

  @override
  String get statsPendingFragments => 'Fragments en attente';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(tous les flux)';

  @override
  String get statsReceivedVsDecoded => 'Reçus vs Décodés (60 dernières s)';

  @override
  String get statsPerSecondLabel => 'par seconde';

  @override
  String get statsAccounting => 'Comptabilité';

  @override
  String get statsMultiPartParts => 'Parties multi-fragments';

  @override
  String get statsPending => 'En attente';

  @override
  String get statsDropped => 'Perdus';

  @override
  String get statsReconcile => 'Les reçus et les décodés concordent.';

  @override
  String get statsGapPaused =>
      'L\'écart inclut les phrases reçues pendant que le décodage était en pause.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Reçus $received = $sum';
  }

  @override
  String get statsByMessageType => 'Par type de message';

  @override
  String get statsNoDecodedYet => 'Aucun message décodé pour l\'instant';

  @override
  String statsTypeFallback(Object type) {
    return 'Type $type';
  }

  @override
  String get statsByFeed => 'Par flux';

  @override
  String statsFeedFilter(Object filter) {
    return 'Flux : $filter';
  }

  @override
  String get statsNoActivityYet => 'Aucune activité de flux pour l\'instant';

  @override
  String get statsCollecting => 'collecte…';

  @override
  String get simVesselCargo => 'Cargo';

  @override
  String get simVesselTanker => 'Pétrolier';

  @override
  String get simVesselFishing => 'Pêche';

  @override
  String get simVesselSailing => 'Voilier';

  @override
  String get simVesselPassenger => 'Passager';

  @override
  String get simVesselTug => 'Remorqueur';

  @override
  String get simVesselHsc => 'Navire rapide';

  @override
  String get simVesselOther => 'Autre';

  @override
  String get simType1 => 'Compte-rendu de position (1/2/3)';

  @override
  String get simType5 => 'Statiques et voyage (5)';

  @override
  String get simType9 => 'Aéronef SAR (9)';

  @override
  String get simType18 => 'Position Classe B (18)';

  @override
  String get simType19 => 'Classe B étendu (19)';

  @override
  String get simType27 => 'Longue portée (27)';

  @override
  String get simType4 => 'Station de base (4)';

  @override
  String get simType21 => 'Aide à la navigation (21)';

  @override
  String get simType8 => 'Diffusion météo (8)';

  @override
  String get simType11 => 'Réponse UTC/date (11)';

  @override
  String get simType12 => 'Sécurité adressée (12)';

  @override
  String get simType14 => 'Diffusion de sécurité (14)';

  @override
  String get simType22 => 'Gestion des canaux (22)';

  @override
  String get simType23 => 'Assignation de groupe (23)';

  @override
  String get simType24 => 'Statiques Classe B (24)';

  @override
  String get simTitle => 'Simulation';

  @override
  String get simInfoBanner =>
      'La flotte est émise lorsque le flux « Simulation » est activé dans l\'onglet Réception et que le forwarder est en cours d\'exécution.';

  @override
  String get simOpenReception => 'Ouvrir la Réception';

  @override
  String get simFleetSection => 'Flotte';

  @override
  String get simRadiusKm => 'Rayon (km)';

  @override
  String get simVessels => 'Navires';

  @override
  String get simSpeedMinKn => 'Vitesse min (nd)';

  @override
  String get simSpeedMaxKn => 'Vitesse max (nd)';

  @override
  String get simIntervalS => 'Intervalle (s)';

  @override
  String get simSeed => 'Graine';

  @override
  String get simAnchoredPct => 'À l\'ancre (%)';

  @override
  String get simNamePrefix => 'Préfixe du nom';

  @override
  String get simMmsiMid => 'Pays MMSI / MID';

  @override
  String get simSearchMmid =>
      'Rechercher un pays ou saisir un MID à 3 chiffres';

  @override
  String get simCustom => 'Personnalisé';

  @override
  String get simVesselTypes => 'Types de navires';

  @override
  String get simRealisticNames => 'Noms réalistes';

  @override
  String get simRealisticDimensions => 'Dimensions réalistes';

  @override
  String get simRealisticMmsi => 'MMSI UIT réaliste';

  @override
  String get simZoneSection => 'Zone et trafic';

  @override
  String get simLocationPreset => 'Préréglage de localisation';

  @override
  String get simSearchPort => 'Rechercher un port…';

  @override
  String get simCenterLat => 'Latitude du centre';

  @override
  String get simCenterLon => 'Longitude du centre';

  @override
  String get simZoneShape => 'Forme de la zone';

  @override
  String get simTransitPct => 'En transit (%)';

  @override
  String get simRegeneratePeriodically => 'Régénérer périodiquement';

  @override
  String get simRegenerateTicks => 'Régénérer (ticks)';

  @override
  String get simPresetHint =>
      'Choisissez un préréglage pour renseigner les coordonnées, ou saisissez directement la latitude / longitude du centre.';

  @override
  String get simMovementSection => 'Mouvement et émission';

  @override
  String get simVarySpeed => 'Faire varier la vitesse dans le temps';

  @override
  String get simReportIntervalTicks => 'Intervalle de compte-rendu (ticks)';

  @override
  String get simWander => 'Dérive (0-3)';

  @override
  String get simSpeedByType => 'Vitesse par type de navire';

  @override
  String get simClassBSharePct => 'Part Classe B (%)';

  @override
  String get simHighAccuracy => 'Haute précision';

  @override
  String get simRealisticRot => 'Vitesse de giration réaliste';

  @override
  String get simContentSection => 'Contenu';

  @override
  String get simSafetyTexts => 'Textes de sécurité (un par ligne)';

  @override
  String get simDestinations => 'Destinations (une par ligne)';

  @override
  String get simStationsSection => 'Stations';

  @override
  String get simBaseStations => 'Stations de base';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => 'Qualité de transmission';

  @override
  String get simInjectErrors => 'Injecter des erreurs';

  @override
  String get simErrorRatePct => 'Taux d\'erreur (%)';

  @override
  String get simTalkerId => 'ID du talker';

  @override
  String get simNmea4Tag => 'Bloc de tag NMEA 4.0';

  @override
  String get simMessagesSection => 'Messages';

  @override
  String get simApplyFleet => 'Appliquer la flotte';

  @override
  String get simRegenerateFleet => 'Régénérer la flotte';

  @override
  String get simGenerating => 'Génération…';

  @override
  String get simLiveFleet => 'Flotte en direct';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats navires · $frames trames émises';
  }

  @override
  String get mapSearchVessels => 'Rechercher des navires';

  @override
  String get mapSearchHint => 'Nom, MMSI ou IMO';

  @override
  String get mapNoResults => 'Aucun résultat';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'Filtres';

  @override
  String mapAllLabel(Object label) {
    return 'Tous $label';
  }

  @override
  String get mapVesselType => 'Type de navire';

  @override
  String get mapNavigationStatus => 'État de navigation';

  @override
  String get mapCountry => 'Pays';

  @override
  String get mapMinSog => 'SOG min (nd)';

  @override
  String get mapMaxSog => 'SOG max (nd)';

  @override
  String get mapOnlyNamed => 'Uniquement les navires nommés';

  @override
  String get mapReset => 'Réinitialiser';

  @override
  String get mapApply => 'Appliquer';

  @override
  String get mapAutoBasemap => 'Auto (suivre le thème)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Suivi de $mmsi';
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
  String get basemapVoyagerLight => 'Voyager (clair)';

  @override
  String get basemapPositronLight => 'Positron (minimal clair)';

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
      'Collez ou écrivez une ou plusieurs phrases NMEA AIS';

  @override
  String get decoderValidateChecksums => 'Valider les sommes de contrôle';

  @override
  String get decoderDecode => 'Décoder';

  @override
  String get decoderDecoded => 'Décodé';

  @override
  String decoderDecodedN(Object n) {
    return 'Décodé ($n phrases)';
  }

  @override
  String get decoderInvalidChecksum => 'Somme de contrôle invalide';

  @override
  String get decoderParseError => 'Erreur d\'analyse';

  @override
  String get decoderWaitingFragments => 'En attente d\'autres fragments…';

  @override
  String decoderTagSource(Object id) {
    return 'source $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Bloc de tag · $content';
  }

  @override
  String get toolDecoder => 'Décodeur NMEA';

  @override
  String get toolDecoderSub => 'Décoder des phrases AIS';

  @override
  String get toolChecksum => 'Somme de contrôle';

  @override
  String get toolChecksumSub => 'Calculer les XOR NMEA';

  @override
  String get toolMmsi => 'Recherche MMSI';

  @override
  String get toolMmsiSub => 'Valider et identifier un MMSI';

  @override
  String get toolSpeed => 'Convertisseur de vitesse';

  @override
  String get toolSpeedSub => 'nd · km/h · m/s · mph';

  @override
  String get toolBinary => 'Inspecteur binaire';

  @override
  String get toolBinarySub => 'Payload jusqu\'au bit';

  @override
  String get toolEta => 'Calculateur d\'ETA';

  @override
  String get toolEtaSub => 'ETA au format type 5';

  @override
  String get toolRadio => 'Portée radio';

  @override
  String get toolRadioSub => 'Horizon radio VHF-AIS';

  @override
  String get toolTextToBinary => 'Texte vers binaire';

  @override
  String get toolTextToBinarySub => 'ASCII 6-bit vers hex/bits';

  @override
  String get checksumInputLabel => 'Collez une ou plusieurs phrases NMEA';

  @override
  String get checksumComputed => 'Calculée';

  @override
  String get checksumDeclared => 'Déclarée';

  @override
  String get checksumValid => 'Somme de contrôle valide';

  @override
  String get checksumInvalid => 'Somme de contrôle incorrecte';

  @override
  String get checksumFix => 'Corriger la somme';

  @override
  String get mmsiInputLabel => 'MMSI (9 chiffres)';

  @override
  String get mmsiValid => 'MMSI valide';

  @override
  String get mmsiInvalid => 'Pas un MMSI valide à 9 chiffres';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'Pays';

  @override
  String get mmsiCountryUnknown => 'MID inconnu';

  @override
  String get mmsiType => 'Type de station';

  @override
  String get mmsiGroupCall => 'Appel de groupe';

  @override
  String get mmsiSarAircraft => 'Aéronef SAR';

  @override
  String get mmsiCoastStation => 'Station côtière';

  @override
  String get mmsiShipStation => 'Station de navire';

  @override
  String get mmsiHandheldVhf => 'VHF portatif';

  @override
  String get mmsiAton => 'Aide à la navigation (AtoN)';

  @override
  String get mmsiSar => 'Unité SAR';

  @override
  String get mmsiOther => 'Autre';

  @override
  String get speedValue => 'Valeur';

  @override
  String get speedUnit => 'Unité';

  @override
  String get binaryInputLabel => 'Phrase NMEA ou payload 6-bit brut';

  @override
  String get binaryPayload => 'Payload';

  @override
  String get binaryBits => 'Bits';

  @override
  String get binaryBinary => 'Binaire';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Octets hex';

  @override
  String get binarySixBit => 'Caractères 6-bit';

  @override
  String get etaDistance => 'Distance';

  @override
  String get etaUnitNm => 'milles nautiques';

  @override
  String get etaUnitKm => 'kilomètres';

  @override
  String get etaSpeed => 'Vitesse';

  @override
  String get etaDuration => 'Durée';

  @override
  String get etaEtaLocal => 'ETA (locale)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'Champs ETA du type 5';

  @override
  String get etaMonth => 'Mois';

  @override
  String get etaDay => 'Jour';

  @override
  String get etaHour => 'Heure';

  @override
  String get etaMinute => 'Minute';

  @override
  String get etaCombined => 'MM/JJ HH:MM';

  @override
  String get radioHeight1 => 'Hauteur antenne 1';

  @override
  String get radioHeight2 => 'Hauteur antenne 2';

  @override
  String get radioHorizon => 'Horizon radio';

  @override
  String get radioHorizonKm => 'Horizon radio (km)';

  @override
  String get radioFrequencies => 'Canaux AIS';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Saisissez du texte (alphabet AIS 6-bit)';

  @override
  String get t2bCharTable => 'Caractère · valeur · 6-bit';

  @override
  String get t2bBinary => 'Binaire';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Octets (format éditeur)';

  @override
  String get t2bPayload => 'Payload armuré';

  @override
  String get t2bNote =>
      'La liste d\'octets peut être collée dans le champ « Data bytes » de l\'éditeur d\'un message 6/8/25/26 ; le payload armuré est le champ payload exact de la trame NMEA.';

  @override
  String editorAsmDetected(Object name) {
    return 'Message spécifique à l\'application — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Champs de l\'ASM reconnu. Le champ « Data bytes » brut les remplace toujours s\'il est rempli.';

  @override
  String get fMessageType => 'Type de message';

  @override
  String get editorAsmPreset => 'Présélection ASM';

  @override
  String get editorAsmPresetManual => 'Personnalisé — saisir DAC/FID à la main';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'Champs ASM';

  @override
  String get asmStateInForce => 'en vigueur';

  @override
  String get asmStateDeprecated => 'déprécié';

  @override
  String get asmStateReplaced => 'remplacé';

  @override
  String get asmStateDiscontinued => 'abandonné';

  @override
  String get asmStateDraft => 'brouillon';

  @override
  String get asmStateProposal => 'proposition';

  @override
  String get asmStateTesting => 'en test';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Déprécié depuis $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'Aucun layout de bits n\'est documenté pour $name — éditez les Data bytes bruts.';
  }

  @override
  String get docChapterAsm => 'Messages spécifiques à l\'application';

  @override
  String get docAsmIntro =>
      'Tous les payloads AIS ne sont pas des comptes rendus de position standard. Les types 6, 8, 25 et 26 transportent des données binaires spécifiques (un ASM) dont la signification est définie par deux nombres : un code DAC (Designated Area Code) et un identifiant de fonction FID.';

  @override
  String get docAsmWhatTitle => 'Qu\'est-ce qu\'un ASM ?';

  @override
  String get docAsmWhat =>
      'Un message spécifique à l\'application est un payload structuré publié par une organisation (OMI, AISM, administrations nationales, fabricants) pour un usage précis : données météo et hydrographiques, suivi des aides à la navigation, corrections DGPS, services portuaires, etc. Les types 6/8 portent l\'en-tête DAC/FID ; les types 25/26 reprennent la même structure DAC/FID dans les messages à créneaux.';

  @override
  String get docAsmDacFidTitle => 'DAC et FID';

  @override
  String get docAsmDacFid1 =>
      'Le DAC est un code sur 10 bits qui identifie l\'organisation ou le pays émetteur (ex. 001 = OMI, 002 = AISM). Le FID est un code de fonction sur 6 bits dans l\'espace de ce DAC (ex. 001/11 = données météo-hydro OMI).';

  @override
  String get docAsmDacFid2 =>
      'Les octets de données qui suivent l\'en-tête DAC/FID sont décodés selon la norme d\'application correspondante. Deux couples DAC/FID différents peuvent interpréter les mêmes octets de façon totalement différente : il faut donc toujours connaître le couple en premier.';

  @override
  String get docAsmWhereTitle => 'Où trouver les définitions';

  @override
  String get docAsmWhere1 =>
      'Circulaires OMI et ITU-R M.1371 (annexes) — source faisant autorité pour le DAC 001.';

  @override
  String get docAsmWhere2 =>
      'Lignes directrices de l\'AISM (ex. G1139) et administrations nationales — pour les DAC régionaux.';

  @override
  String get docAsmWhere3 =>
      'Documentation AIVDM de gpsd — catalogue ouvert et lisible par machine des formats DAC/FID les plus courants.';

  @override
  String get docAsmInKikaisTitle => 'Dans KikAis';

  @override
  String get docAsmInKikais =>
      'L\'Éditeur connaît un ensemble curaté d\'ASM bien connus : quand le DAC/FID d\'un message 6/8/25/26 correspond, le champ data est affiché sous forme de sous-champs nommés empaquetés automatiquement. Le champ brut « Data bytes » remplace toujours l\'ASM lorsqu\'il est rempli. La liste vit dans asm_formats.dart et est facile à étendre.';

  @override
  String get docAsmExampleTitle => 'Exemple : météo-hydro OMI (001/11)';

  @override
  String get docAsmExample =>
      'Dans l\'Éditeur, choisissez le type 8, DAC=1 et FID=11 pour construire un message météo OMI : vent, températures air/eau, pression, visibilité, courants et vagues s\'éditent champ par champ au lieu d\'un bloc d\'octets.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Indicateur de répétition';

  @override
  String get fNavStatus => 'État de navigation';

  @override
  String get fLatitude => 'Latitude';

  @override
  String get fLongitude => 'Longitude';

  @override
  String get fSogKn => 'SOG (nd)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Cap (°)';

  @override
  String get fRateOfTurn => 'Vitesse de giration';

  @override
  String get fManeuver => 'Manœuvre';

  @override
  String get fTimestamp => 'Horodatage';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Précision';

  @override
  String get fEpfdFixType => 'Type de positionnement EPFD';

  @override
  String get fSyncState => 'État de synchronisation';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Indicatif d\'appel';

  @override
  String get fVesselName => 'Nom du navire';

  @override
  String get fShipType => 'Type de navire';

  @override
  String get fShipTypeText => 'Type de navire (texte)';

  @override
  String get fDims => 'Avant/Arrière/Bâbord/Tribord (m)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Tirant d\'eau (m)';

  @override
  String get fDestination => 'Destination';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'MMSI de destination';

  @override
  String get fSeqNumber => 'Numéro de séquence';

  @override
  String get fRetransmit => 'Retransmission';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Données';

  @override
  String get fAltitudeM => 'Altitude (m)';

  @override
  String get fAssignedMode => 'Mode assigné';

  @override
  String get fRegionalReserved => 'Réservé régional';

  @override
  String get fText => 'Texte';

  @override
  String fStationN(Object n) {
    return 'Station $n';
  }

  @override
  String fSlotN(Object n) {
    return 'Tranche $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return 'décalage $offset · nombre $number · délai $timeout · inc $increment';
  }

  @override
  String get fAidType => 'Type d\'aide';

  @override
  String get fAidTypeCode => 'Type d\'aide (code)';

  @override
  String get fName => 'Nom';

  @override
  String get fNameExt => 'Extension du nom';

  @override
  String get fVirtualAid => 'Aide virtuelle';

  @override
  String get fOffPosition => 'Hors position';

  @override
  String get fSecond => 'Seconde';

  @override
  String get fChannelA => 'Canal A';

  @override
  String get fChannelB => 'Canal B';

  @override
  String get fTxRxMode => 'Mode TX/RX';

  @override
  String get fPower => 'Puissance';

  @override
  String get fZone => 'Zone';

  @override
  String get fAddressed => 'Adressé';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Bande A';

  @override
  String get fBandB => 'Bande B';

  @override
  String get fZoneSize => 'Taille de la zone';

  @override
  String get fStationType => 'Type de station';

  @override
  String get fReportInterval => 'Intervalle de compte-rendu';

  @override
  String get fQuietTime => 'Temps de silence';

  @override
  String get fPart => 'Partie';

  @override
  String get fVendorId => 'ID du fabricant';

  @override
  String get fUnitModel => 'Modèle d\'unité';

  @override
  String get fSerialNumber => 'Numéro de série';

  @override
  String get fMothershipMmsi => 'MMSI du navire mère';

  @override
  String get fRadioStatus => 'État radio';

  @override
  String get fGnssStatus => 'État de la position GNSS';

  @override
  String fDestN(Object n) {
    return 'Destination $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => 'Indicateur de destination';

  @override
  String get fBinaryDataFlag => 'Indicateur de données binaires';

  @override
  String get fApplicationId => 'ID d\'application';

  @override
  String get fPowerHigh => 'Élevée';

  @override
  String get fPowerLow => 'Faible';

  @override
  String get fPartA => 'A (nom)';

  @override
  String get fPartB => 'B (données du navire)';

  @override
  String get editorTitle => 'Éditeur de messages AIS';

  @override
  String get editorCompose => 'Composer un message';

  @override
  String get editorMessageType => 'Type de message';

  @override
  String get editorAddTagBlock => 'Ajouter un bloc de tag NMEA 4.0';

  @override
  String get editorSourceId => 'ID de source';

  @override
  String get editorInjectToMap => 'Injecter dans la carte';

  @override
  String get editorSendToTarget => 'Envoyer vers la cible';

  @override
  String get editorPreview => 'Aperçu NMEA';

  @override
  String get editorNmeaCopied => 'NMEA copié';

  @override
  String get editorInjected => 'Message injecté';

  @override
  String get editorSentToTarget => 'Message envoyé à la cible';

  @override
  String get editorNavStatus0_15 => 'État de nav (0-15)';

  @override
  String get editorYear => 'Année';

  @override
  String get editorMonth => 'Mois';

  @override
  String get editorDay => 'Jour';

  @override
  String get editorHour => 'Heure';

  @override
  String get editorMinute => 'Minute';

  @override
  String get editorSecond => 'Seconde';

  @override
  String get editorImoNumber => 'Numéro IMO';

  @override
  String get editorBowM => 'Avant (m)';

  @override
  String get editorSternM => 'Arrière (m)';

  @override
  String get editorPortM => 'Bâbord (m)';

  @override
  String get editorStarboardM => 'Tribord (m)';

  @override
  String get editorEtaMonth => 'Mois ETA';

  @override
  String get editorEtaDay => 'Jour ETA';

  @override
  String get editorEtaHour => 'Heure ETA';

  @override
  String get editorEtaMinute => 'Minute ETA';

  @override
  String get editorSequence0_3 => 'Séquence (0-3)';

  @override
  String get editorDataBytes => 'Octets de données (hex ou 1,2,3)';

  @override
  String get editorDestMmsisComma => 'MMSI de dest. (virgule)';

  @override
  String get editorSequencesComma => 'Séquences (virgule)';

  @override
  String get editorInterrogatedMmsi => 'MMSI interrogé';

  @override
  String get editorType1 => 'Type 1';

  @override
  String get editorOffset1 => 'Décalage 1';

  @override
  String get editorTargetMmsi => 'MMSI cible';

  @override
  String get editorOffset => 'Décalage';

  @override
  String get editorIncrement => 'Incrément';

  @override
  String get editorNumber => 'Nombre';

  @override
  String get editorTimeout => 'Délai d\'attente';

  @override
  String get editorAidType0_31 => 'Type d\'aide (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Aide virtuelle (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Mode Tx/Rx (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Mode Tx/Rx (0-3)';

  @override
  String get editorNeLat => 'Latitude NE';

  @override
  String get editorNeLon => 'Longitude NE';

  @override
  String get editorSwLat => 'Latitude SO';

  @override
  String get editorSwLon => 'Longitude SO';

  @override
  String get editorInterval0_15 => 'Intervalle (0-15)';

  @override
  String get editorPart => 'Partie (0 = A nom, 1 = B statiques)';

  @override
  String get editorDestMmsiEmpty => 'MMSI de destination (vide = diffusion)';

  @override
  String get editorAppDacEmpty => 'DAC d\'app (vide = aucun)';

  @override
  String get editorAppFidEmpty => 'FID d\'app (vide = aucun)';

  @override
  String get nmeaTalker => 'Talker';

  @override
  String get nmeaFragments => 'Fragments';

  @override
  String get nmeaFragmentN => 'Fragment n°';

  @override
  String get nmeaMessageId => 'ID de message';

  @override
  String get nmeaChannel => 'Canal';

  @override
  String get nmeaPayload => 'Charge utile';

  @override
  String get nmeaFillBits => 'Bits de remplissage';

  @override
  String get nmeaTagBlock => 'Bloc de tag';

  @override
  String get nmeaChecksum => 'Somme de contrôle';

  @override
  String get nmeaEmpty => '(vide)';

  @override
  String get bubbleKindVessel => 'Navire';

  @override
  String get bubbleKindAircraft => 'Aéronef SAR';

  @override
  String get bubbleKindAton => 'Aide à la navigation';

  @override
  String get bubbleKindStation => 'Station de base';

  @override
  String get bubbleGeneralInfo => 'Informations générales';

  @override
  String get bubbleKind => 'Type';

  @override
  String get bubbleAidType => 'Type d\'aide';

  @override
  String get bubbleVirtual => 'Virtuelle';

  @override
  String get bubbleAltitude => 'Altitude';

  @override
  String get bubbleCallSign => 'Indicatif d\'appel';

  @override
  String get bubblePosNav => 'Position et navigation';

  @override
  String get bubbleHeading => 'Cap';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Détails du navire';

  @override
  String get bubbleType => 'Type';

  @override
  String get bubbleTypeInt => 'Type (Int)';

  @override
  String get bubbleDimsBowStern => 'Dimensions Avant/Arrière';

  @override
  String get bubbleDimsPortStarboard => 'Dimensions Bâbord/Tribord';

  @override
  String get bubbleSpare => 'Réserve';

  @override
  String get bubbleDraught => 'Tirant d\'eau';

  @override
  String bubbleFrames(Object n) {
    return 'Trames ($n)';
  }

  @override
  String get bubbleNoFrames => 'Aucune trame pour l\'instant';

  @override
  String get copied => 'Copié';

  @override
  String get textFiles => 'Fichiers texte';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Cible $name connectée ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Échec de la connexion à la cible $name : $error';
  }

  @override
  String get logStopping => 'Arrêt du forwarder...';

  @override
  String get logStopped => 'Forwarder arrêté.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Flux ajouté : $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Flux supprimé : $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Flux $name connecté.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Flux $name déconnecté. Reconnexion dans 5 s...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Échec de connexion du flux $name : $error. Nouvelle tentative dans 5 s...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Cible $name : serveur TCP à l\'écoute sur le port $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Cible $name : client connecté $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Cible $name : client déconnecté';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Cible $name : erreur du client $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Erreur d\'envoi à la cible $name : $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'Ouverture du dongle RTL-SDR $device...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device connecté ($freq, débit $rate, gain $gain, canaux $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device : erreur $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'Flux RTL-SDR $device fermé.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device déconnecté.';
  }

  @override
  String get docNavStatus0 => 'En route par propulsion mécanique';

  @override
  String get docNavStatus1 => 'Au mouillage';

  @override
  String get docNavStatus2 => 'Sans gouvernement';

  @override
  String get docNavStatus3 => 'Capacité de manœuvre restreinte';

  @override
  String get docNavStatus4 => 'Gêné par son tirant d\'eau';

  @override
  String get docNavStatus5 => 'Amarré';

  @override
  String get docNavStatus6 => 'Échoué';

  @override
  String get docNavStatus7 => 'En pêche';

  @override
  String get docNavStatus8 => 'En route à la voile';

  @override
  String get docNavStatus9 => 'Réservé (HSC)';

  @override
  String get docNavStatus10 => 'Réservé (WIG)';

  @override
  String get docNavStatus11 => 'Remorquage par l\'arrière (régional)';

  @override
  String get docNavStatus12 =>
      'Poussée avant / remorquage le long du bord (régional)';

  @override
  String get docNavStatus13 => 'Réservé pour usage futur';

  @override
  String get docNavStatus14 => 'AIS-SART actif';

  @override
  String get docNavStatus15 => 'Non défini (par défaut)';

  @override
  String get docEpfd0 => 'Non défini (par défaut)';

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
  String get docEpfd6 => 'Système de navigation intégré';

  @override
  String get docEpfd7 => 'Position reconnue (fixe)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'GNSS interne';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · bits $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields champs · $bits bits au total · touchez un segment';
  }

  @override
  String get docTextToEncode => 'Texte à encoder';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Chaque caractère est une valeur sur 6 bits (\"@\" = 0, espace = 32, \"A\" = 1…). Les lettres minuscules ne sont pas encodables et sont généralement envoyées en majuscules.';

  @override
  String get docChecksumBody => 'Corps (sans le ! initial ni le *XX final)';

  @override
  String get docChecksumExplanation =>
      'La somme de contrôle NMEA est le XOR de chaque octet situé entre le \"!\" et le \"*\".';

  @override
  String get docLatitude => 'Latitude';

  @override
  String get docLongitude => 'Longitude';

  @override
  String get docLatitudeInvalid => 'Latitude : saisissez un nombre';

  @override
  String get docLongitudeInvalid => 'Longitude : saisissez un nombre';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Latitude → $value (signé sur 27 bits, deg = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Longitude → $value (signé sur 28 bits, deg = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Les coordonnées sont stockées en 1/10 000 de minute : divisez par 600 000 pour retrouver les degrés.';

  @override
  String get docSearchShipTypes => 'Rechercher des types de navires';

  @override
  String get docShipCat0_19 => '0-19 · Réservé';

  @override
  String get docShipCat20_29 => '20-29 · À effet de sol (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Pêche';

  @override
  String get docShipCat40_49 => '40-49 · Navire rapide';

  @override
  String get docShipCat50_59 => '50-59 · Navire spécial';

  @override
  String get docShipCat60_69 => '60-69 · Passager';

  @override
  String get docShipCat70_79 => '70-79 · Cargo';

  @override
  String get docShipCat80_89 => '80-89 · Pétrolier';

  @override
  String get docShipCat90_99 => '90-99 · Autre';

  @override
  String get docSearchGlossary => 'Rechercher dans le glossaire';

  @override
  String get docNoMatchingTerms => 'Aucun terme correspondant.';

  @override
  String get docAspect => 'Aspect';

  @override
  String get docClassA => 'Classe A';

  @override
  String get docClassB => 'Classe B';

  @override
  String get docCheatRadio => 'Radio';

  @override
  String get docCheatFrequencies => 'Fréquences';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulation';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bits/s';

  @override
  String get docCheatRange => 'Portée';

  @override
  String get docCheatRangeValue =>
      '~10-20 NM de navire à navire, en visibilité directe';

  @override
  String get docCheatReportingRates => 'Fréquences de compte-rendu';

  @override
  String get docCheatClassAPos1 => 'Position Classe A (1)';

  @override
  String get docCheatClassAPos1Value =>
      'Toutes les 2-10 s en route, 3 min au mouillage';

  @override
  String get docCheatStatic5 => 'Statiques (5)';

  @override
  String get docCheatStatic5Value => 'Toutes les 6 min';

  @override
  String get docCheatClassBPos18 => 'Position Classe B (18)';

  @override
  String get docCheatClassBPos18Value => '~Toutes les 30 s';

  @override
  String get docCheatAtoN21 => 'Aide à la navigation (21)';

  @override
  String get docCheatAtoN21Value => 'Toutes les 3 min';

  @override
  String get docCheatNavStatus0_15 => 'État de navigation (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'En route par propulsion mécanique';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'Au mouillage';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Capacité de manœuvre restreinte';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Amarré';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'Échoué';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Pêche';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'En route à la voile';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART actif';

  @override
  String get docCheatMmsiFormats => 'Formats MMSI';

  @override
  String get docCheatFixTypes => 'Types de positionnement (EPFD)';

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
  String get docCheatEpfd15Value => 'GNSS interne';

  @override
  String get docCheatFooter =>
      'KikAis embarque une référence interactive complète dans chaque onglet — l\'Éditeur peut construire n\'importe quel message, le Décodeur permet de les relire.';

  @override
  String get docMmsiFmtDiversRadio => 'Radio de plongeur';

  @override
  String get docMmsiFmtShip => 'Navire';

  @override
  String get docMmsiFmtGroupShips =>
      'Groupe de navires (ex. une flotte ou l\'USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Station côtière / terrestre';

  @override
  String get docMmsiFmtSarAircraft => 'Aéronef SAR';

  @override
  String get docMmsiFmtAuxCraft =>
      'Embarcation auxiliaire associée à un navire mère';

  @override
  String get docMmsiFmtAtoN => 'Aide à la navigation';

  @override
  String get docMmsiFmtSart => 'AIS-SART (émetteur de recherche et sauvetage)';

  @override
  String get docMmsiFmtMob => 'Dispositif MOB (homme à la mer)';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB (balise de détresse)';

  @override
  String get docVesselCat0_9 => 'Réservé / usage futur';

  @override
  String get docVesselCat10_19 => 'Réservé pour usage futur';

  @override
  String get docVesselCat20_29 => 'Navire à effet de sol (WIG)';

  @override
  String get docVesselCat30_39 => 'Pêche';

  @override
  String get docVesselCat40_49 => 'Navire rapide';

  @override
  String get docVesselCat50_59 =>
      'Navire spécial (pilotage, remorqueurs, dragues…)';

  @override
  String get docVesselCat60_69 => 'Navires à passagers';

  @override
  String get docVesselCat70_79 => 'Navires de charge';

  @override
  String get docVesselCat80_89 => 'Pétroliers';

  @override
  String get docVesselCat90_99 => 'Autres types';

  @override
  String get docTalkerAB => 'Station de base AIS';

  @override
  String get docTalkerAD => 'Station de base AIS dépendante';

  @override
  String get docTalkerAI => 'Station AIS mobile';

  @override
  String get docTalkerAN => 'Station AIS d\'aide à la navigation';

  @override
  String get docTalkerAR => 'Station AIS de réception';

  @override
  String get docTalkerAS => 'Station de base limitée';

  @override
  String get docTalkerAT => 'Station AIS d\'émission';

  @override
  String get docTalkerAX => 'Station répétitrice AIS';

  @override
  String get docTalkerBS => 'Station de base AIS (obsolète)';

  @override
  String get docTalkerSA => 'Station AIS côtière physique';

  @override
  String get docType1Name => 'Compte-rendu de position Classe A';

  @override
  String get docType1Family => 'Comptes-rendus de position';

  @override
  String get docType1Summary =>
      'Le cheval de trait du système : un transpondeur Classe A qui diffuse sa position, sa route, sa vitesse, son cap et son état de navigation.';

  @override
  String get docType1EmittedBy => 'Transpondeurs Classe A (navires SOLAS)';

  @override
  String get docType1Cadence =>
      'Toutes les 2-10 s en route, toutes les 3 min au mouillage';

  @override
  String get docType2Name => 'Compte-rendu de position Classe A (assigné)';

  @override
  String get docType2Family => 'Comptes-rendus de position';

  @override
  String get docType2Summary =>
      'Identique au type 1, mais émis selon un planning de tranches assigné au navire par une station de base (mode assignation).';

  @override
  String get docType2EmittedBy => 'Transpondeurs Classe A sous assignation';

  @override
  String get docType2Cadence => 'Planning assigné';

  @override
  String get docType3Name => 'Compte-rendu de position Classe A (réponse)';

  @override
  String get docType3Family => 'Comptes-rendus de position';

  @override
  String get docType3Summary =>
      'Identique au type 1, émis en réponse à une interrogation (type 15).';

  @override
  String get docType3EmittedBy =>
      'Transpondeurs Classe A répondant à une interrogation';

  @override
  String get docType3Cadence => 'Sur interrogation';

  @override
  String get docType4Name => 'Compte-rendu de station de base';

  @override
  String get docType4Family => 'Station de base et réseau';

  @override
  String get docType4Summary =>
      'Le compte-rendu périodique d\'une station terrestre fixe : sa position ainsi que la référence de date et d\'heure UTC.';

  @override
  String get docType4EmittedBy => 'Stations de base fixes';

  @override
  String get docType4Cadence => 'Toutes les 10 s';

  @override
  String get docType5Name => 'Données statiques et de voyage';

  @override
  String get docType5Family => 'Données statiques et de voyage';

  @override
  String get docType5Summary =>
      'La « carte d\'identité » d\'un navire : nom, indicatif d\'appel, numéro IMO, type de navire, dimensions, tirant d\'eau, ETA et destination.';

  @override
  String get docType5EmittedBy => 'Transpondeurs Classe A';

  @override
  String get docType5Cadence =>
      'Toutes les 6 min et à chaque changement de données';

  @override
  String get docType6Name => 'Message binaire adressé';

  @override
  String get docType6Family => 'Données binaires';

  @override
  String get docType6Summary =>
      'Une charge utile binaire structurée envoyée à un MMSI de destination précis (ex. un bulletin météo demandé).';

  @override
  String get docType6EmittedBy => 'Toute station';

  @override
  String get docType6Cadence => 'À la demande';

  @override
  String get docType7Name => 'Accusé de réception binaire';

  @override
  String get docType7Family => 'Données binaires';

  @override
  String get docType7Summary =>
      'L\'accusé de réception envoyé en réponse à un message binaire adressé de type 6.';

  @override
  String get docType7EmittedBy => 'Toute station ayant reçu un type 6';

  @override
  String get docType7Cadence => 'Sur réponse';

  @override
  String get docType8Name => 'Message binaire diffusé';

  @override
  String get docType8Family => 'Données binaires';

  @override
  String get docType8Summary =>
      'Une charge utile binaire structurée diffusée à tous — bulletins météo et hydrographiques, données régionales ou messages privés/chiffrés.';

  @override
  String get docType8EmittedBy => 'Toute station';

  @override
  String get docType8Cadence => 'À la demande';

  @override
  String get docType9Name => 'Compte-rendu de position d\'aéronef SAR standard';

  @override
  String get docType9Family => 'Comptes-rendus de position';

  @override
  String get docType9Summary =>
      'Un compte-rendu de position utilisé par les aéronefs de recherche et sauvetage pour être visibles des navires. Il porte l\'altitude et une plage MMSI spéciale (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'Aéronefs SAR';

  @override
  String get docType9Cadence => 'Toutes les 10 s en station';

  @override
  String get docType10Name => 'Demande d\'heure UTC et de date';

  @override
  String get docType10Family => 'Station de base et réseau';

  @override
  String get docType10Summary =>
      'Une petite requête demandant à une station précise son heure et sa date UTC.';

  @override
  String get docType10EmittedBy => 'Toute station';

  @override
  String get docType10Cadence => 'À la demande';

  @override
  String get docType11Name => 'Réponse d\'heure UTC et de date';

  @override
  String get docType11Family => 'Station de base et réseau';

  @override
  String get docType11Summary =>
      'Identique en structure au type 4, émis en réponse à une demande UTC/date de type 10.';

  @override
  String get docType11EmittedBy => 'Stations de base';

  @override
  String get docType11Cadence => 'Sur demande';

  @override
  String get docType12Name => 'Message de sécurité adressé';

  @override
  String get docType12Family => 'Sécurité et texte';

  @override
  String get docType12Summary =>
      'Un message de sécurité en texte libre envoyé à un seul MMSI de destination (ex. un message de détresse à la station de base la plus proche).';

  @override
  String get docType12EmittedBy => 'Toute station';

  @override
  String get docType12Cadence => 'À la demande';

  @override
  String get docType13Name => 'Accusé de réception de sécurité';

  @override
  String get docType13Family => 'Sécurité et texte';

  @override
  String get docType13Summary =>
      'L\'accusé de réception envoyé en réponse à un message de sécurité adressé de type 12.';

  @override
  String get docType13EmittedBy => 'Toute station ayant reçu un type 12';

  @override
  String get docType13Cadence => 'Sur réponse';

  @override
  String get docType14Name => 'Message de sécurité diffusé';

  @override
  String get docType14Family => 'Sécurité et texte';

  @override
  String get docType14Summary =>
      'Une diffusion en texte libre adressée à tous à portée — avis aux navigateurs, détresse ou annonces de trafic.';

  @override
  String get docType14EmittedBy =>
      'Toute station (souvent les stations de base / VTS)';

  @override
  String get docType14Cadence => 'À la demande';

  @override
  String get docType15Name => 'Interrogation';

  @override
  String get docType15Family => 'Station de base et réseau';

  @override
  String get docType15Summary =>
      'Une requête demandant à une ou deux stations précises d\'émettre un type de message particulier (généralement le type 3 ou 5).';

  @override
  String get docType15EmittedBy => 'Stations de base';

  @override
  String get docType15Cadence => 'À la demande';

  @override
  String get docType16Name => 'Commande de mode assignation';

  @override
  String get docType16Family => 'Station de base et réseau';

  @override
  String get docType16Summary =>
      'Demande à deux navires au plus d\'émettre sur une allocation de tranches précise (mode assignation).';

  @override
  String get docType16EmittedBy => 'Stations de base';

  @override
  String get docType16Cadence => 'À la demande';

  @override
  String get docType17Name => 'Message binaire diffusé DGNSS';

  @override
  String get docType17Family => 'Données binaires';

  @override
  String get docType17Summary =>
      'Données de correction GNSS différentiel diffusées par les stations côtières pour améliorer la précision de positionnement dans la zone couverte.';

  @override
  String get docType17EmittedBy => 'Stations de référence DGNSS';

  @override
  String get docType17Cadence => 'Périodique';

  @override
  String get docType18Name => 'Compte-rendu de position CS Classe B standard';

  @override
  String get docType18Family => 'Comptes-rendus de position';

  @override
  String get docType18Summary =>
      'Le compte-rendu de position Classe B standard. Plus léger que la Classe A : pas d\'état de navigation ni de vitesse de giration, mais compatible CSTDMA.';

  @override
  String get docType18EmittedBy => 'Transpondeurs Classe B';

  @override
  String get docType18Cadence =>
      'Toutes les 30 s (ou moins dans certaines régions)';

  @override
  String get docType19Name =>
      'Compte-rendu de position étendu d\'équipement Classe B';

  @override
  String get docType19Family => 'Comptes-rendus de position';

  @override
  String get docType19Summary =>
      'Un compte-rendu de position Classe B plus complet qui porte aussi le nom du navire, le type de navire et les dimensions — un hybride statiques+position en un seul envoi.';

  @override
  String get docType19EmittedBy => 'Transpondeurs Classe B étendus';

  @override
  String get docType19Cadence => 'Toutes les 30 s';

  @override
  String get docType20Name => 'Gestion de liaison de données';

  @override
  String get docType20Family => 'Station de base et réseau';

  @override
  String get docType20Summary =>
      'Un message de maintenance réseau utilisé pour allouer et réserver les tranches temporelles TDMA dans une zone.';

  @override
  String get docType20EmittedBy => 'Stations de base';

  @override
  String get docType20Cadence => 'Gestion du réseau';

  @override
  String get docType21Name => 'Compte-rendu d\'aide à la navigation';

  @override
  String get docType21Family => 'Aide à la navigation';

  @override
  String get docType21Summary =>
      'Diffuse la position, le nom et l\'état d\'une aide à la navigation — bouées, balises, phares ou aides virtuelles. Souvent émis depuis une position virtuelle.';

  @override
  String get docType21EmittedBy => 'Stations AtoN (réelles ou virtuelles)';

  @override
  String get docType21Cadence => 'Toutes les 3 min (ou sur événement)';

  @override
  String get docType22Name => 'Gestion des canaux';

  @override
  String get docType22Family => 'Station de base et réseau';

  @override
  String get docType22Summary =>
      'Utilisé par une station de base pour basculer les stations vers différents canaux VHF au sein d\'une zone géographique.';

  @override
  String get docType22EmittedBy => 'Stations de base';

  @override
  String get docType22Cadence => 'À la demande';

  @override
  String get docType23Name => 'Commande d\'assignation de groupe';

  @override
  String get docType23Family => 'Station de base et réseau';

  @override
  String get docType23Summary =>
      'Une commande envoyée par une station de base à un groupe de navires situés dans une zone, définissant les intervalles de compte-rendu et le mode d\'émission.';

  @override
  String get docType23EmittedBy => 'Stations de base';

  @override
  String get docType23Cadence => 'À la demande';

  @override
  String get docType24Name => 'Compte-rendu de données statiques';

  @override
  String get docType24Family => 'Données statiques et de voyage';

  @override
  String get docType24Summary =>
      'L\'équivalent Classe B du type 5, réparti en Partie A (nom) et Partie B (type de navire, indicatif d\'appel, dimensions).';

  @override
  String get docType24EmittedBy => 'Transpondeurs Classe B';

  @override
  String get docType24Cadence => 'Toutes les 6 min';

  @override
  String get docType25Name => 'Message binaire mono-tranche';

  @override
  String get docType25Family => 'Données binaires';

  @override
  String get docType25Summary =>
      'Un message binaire court tenant dans une seule tranche TDMA, avec une destination et un ID d\'application facultatifs.';

  @override
  String get docType25EmittedBy => 'Toute station';

  @override
  String get docType25Cadence => 'À la demande';

  @override
  String get docType26Name => 'Message binaire multi-tranches';

  @override
  String get docType26Family => 'Données binaires';

  @override
  String get docType26Summary =>
      'Un message binaire plus long réparti sur plusieurs tranches TDMA, portant des informations d\'état radio.';

  @override
  String get docType26EmittedBy => 'Toute station';

  @override
  String get docType26Cadence => 'À la demande';

  @override
  String get docType27Name =>
      'Compte-rendu de position pour applications longue portée';

  @override
  String get docType27Family => 'Comptes-rendus de position';

  @override
  String get docType27Summary =>
      'Un compte-rendu de position très compact conçu pour une réception par satellite sur de longues distances, avec une résolution réduite.';

  @override
  String get docType27EmittedBy => 'Navires en mode longue portée (satellite)';

  @override
  String get docType27Cadence => 'Toutes les 3 min (mode longue portée)';

  @override
  String get docTimeline1990sTitle => 'Une invention suédoise';

  @override
  String get docTimeline1990sText =>
      'Le concept naît en Suède : un système VHF où chaque navire s\'annonce afin que chacun « voie et soit vu », même dans le brouillard et derrière les îles. Il est présenté à l\'OMI et devient la graine de l\'AIS.';

  @override
  String get docTimeline1998Title => 'La normalisation commence';

  @override
  String get docTimeline1998Text =>
      'L\'UIT et la CEI commencent à transformer le concept en norme radio avec des formats bit précis, fondés sur la TDMA sur deux canaux VHF.';

  @override
  String get docTimeline2001Title => 'Publication de l\'UIT-R M.1371';

  @override
  String get docTimeline2001Text =>
      'La Recommandation UIT-R M.1371 « Caractéristiques techniques d\'un système universel d\'identification automatique à bord des navires » définit les 27 types de messages et leur agencement de bits.';

  @override
  String get docTimeline2002Title => 'Obligation SOLAS';

  @override
  String get docTimeline2002Text =>
      'L\'OMI rend l\'AIS obligatoire pour tous les navires internationaux de plus de 300 tonnes de jauge brute et tous les navires à passagers — environ 100 000 navires. L\'AIS devient une aide anticollision standard aux côtés du radar.';

  @override
  String get docTimeline2006Title => 'Arrivée de la Classe B';

  @override
  String get docTimeline2006Text =>
      'La norme Classe B est publiée, ouvrant la porte à des transpondeurs simples et bon marché. La même année, le satellite TacSat-2 devient le premier à capter les signaux AIS depuis l\'espace (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Constellations de satellites';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire et d\'autres déploient des récepteurs AIS en orbite terrestre basse, étendant la couverture bien au-delà de l\'horizon VHF et permettant un suivi des navires quasi mondial.';

  @override
  String get docTimeline2010Title => 'AIS-SART dans le SMDSM';

  @override
  String get docTimeline2010Text =>
      'L\'émetteur AIS de recherche et sauvetage (AIS-SART, IEC 61097-14) rejoint le Système mondial de détresse et de sécurité en mer, permettant aux embarcations de survie de diffuser des positions de détresse via l\'AIS.';

  @override
  String get docTimeline2014Title => 'Flottes de pêche et fluviales';

  @override
  String get docTimeline2014Text =>
      'Les règles européennes exigent l\'AIS Classe A sur tous les navires de pêche de l\'UE de plus de 15 m ; l\'AIS fluvial est largement déployé sur les rivières européennes.';

  @override
  String get docTimeline2021Title => '1,6 million de navires';

  @override
  String get docTimeline2021Text =>
      'Plus de 1,6 million de navires sont équipés d\'AIS, alimentant des réseaux terrestres et satellitaires qui soutiennent le suivi des navires, le contrôle de la pêche et la sécurité maritime dans le monde.';

  @override
  String get docTimelineVdesTitle => 'VDES — le successeur';

  @override
  String get docTimelineVdesText =>
      'Le système d\'échange de données VHF (UIT-R M.2092) est en cours de déploiement pour désengorger les zones saturées, ajoutant beaucoup plus de bande passante et des services de navigation électronique sécurisés.';

  @override
  String get docAppTitle => 'Documentation';

  @override
  String get docSearchChapters => 'Rechercher des chapitres';

  @override
  String get docChapterOverview => 'Vue d\'ensemble';

  @override
  String get docChapterHistory => 'Histoire et réglementation';

  @override
  String get docChapterHowItWorks => 'Comment ça marche';

  @override
  String get docChapterRadio => 'Radio et TDMA';

  @override
  String get docChapterClasses => 'Classes et équipements';

  @override
  String get docChapterMmsi => 'MMSI et identité';

  @override
  String get docChapterShipTypes => 'Types de navires';

  @override
  String get docChapterMessages => 'Les 27 messages';

  @override
  String get docChapterNmea => 'NMEA et AIVDM';

  @override
  String get docChapterPayload => 'Dans la charge utile';

  @override
  String get docChapterSecurity => 'Sécurité et limites';

  @override
  String get docChapterFieldNotes => 'Notes de terrain';

  @override
  String get docChapterKikais => 'AIS dans KikAis';

  @override
  String get docChapterGlossary => 'Glossaire';

  @override
  String get docChapterCheatSheet => 'Aide-mémoire';

  @override
  String get docChapterSources => 'Sources';

  @override
  String get docOverviewTitle => 'Qu\'est-ce que l\'AIS ?';

  @override
  String get docOverviewIntro =>
      'Le système d\'identification automatique (AIS) est un système de suivi utilisé à bord des navires et par les services de trafic maritime (VTS). Chaque navire équipé diffuse en continu son identité, sa position, sa route et sa vitesse par radio VHF, afin que tout autre navire et station côtière à portée puisse le « voir » — le concept de « voir et être vu ».';

  @override
  String get docOverviewRadar =>
      'L\'AIS ne remplace pas le radar maritime. Le radar détecte indépendamment tout objet, mais en dit peu sur son identité. L\'AIS vous dit exactement qui, où et vers où il se dirige — mais il fait confiance à ce que déclare l\'émetteur. Les deux systèmes se complètent.';

  @override
  String get docOverviewAdsBTitle => 'Considérez-le comme le ADS-B maritime';

  @override
  String get docOverviewAdsBText =>
      'De même que le ADS-B permet aux aéronefs de s\'annoncer au contrôle du trafic aérien, l\'AIS permet aux navires de s\'annoncer les uns aux autres et à la côte. Les navires visualisent le trafic environnant sur un traceur de cartes ou un affichage de type radar ; les autorités portuaires surveillent les mouvements et la pêche.';

  @override
  String get docOverviewTransponder => 'Ce que diffuse un transpondeur';

  @override
  String get docOverviewBullet1 =>
      'Identité unique : un numéro MMSI à 9 chiffres (dont les trois premiers identifient le pays émetteur).';

  @override
  String get docOverviewBullet2 =>
      'Données dynamiques : position, vitesse sur le fond (SOG), route sur le fond (COG), cap vrai, vitesse de giration, état de navigation.';

  @override
  String get docOverviewBullet3 =>
      'Données statiques et de voyage : nom, indicatif d\'appel, numéro IMO, type de navire, dimensions, tirant d\'eau, destination, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Messages de sécurité et binaires : textes de détresse, bulletins météo, commandes réseau.';

  @override
  String get docOverviewWho => 'Qui doit l\'embarquer';

  @override
  String get docOverviewImo =>
      'L\'OMI (convention SOLAS) rend l\'AIS obligatoire sur les navires internationaux de plus de 300 tonnes de jauge brute et sur tous les navires à passagers. Les règles régionales étendent cette obligation aux flottes de pêche, aux voies navigables intérieures et de plus en plus aux navires de plaisance via des transpondeurs Classe B bon marché.';

  @override
  String get docOverviewLimits => 'Les limites en un coup d\'œil';

  @override
  String get docOverviewLimit1 =>
      'La portée est à peu près la visibilité directe : environ 10-20 milles nautiques de navire à navire, davantage depuis les stations côtières et les satellites.';

  @override
  String get docOverviewLimit2 =>
      'L\'AIS n\'a aucune authentification : n\'importe qui peut diffuser n\'importe quelle identité (usurpation) ou brouiller le canal.';

  @override
  String get docOverviewLimit3 =>
      'La précision dépend de la position GNSS de l\'émetteur et de l\'honnêteté des données qu\'il déclare.';

  @override
  String get docHistoryIntro =>
      'L\'AIS est passée d\'une idée suédoise à un système de sécurité obligatoire mondial. Touchez un jalon de la chronologie pour plus de détails.';

  @override
  String get docHistoryStandards => 'Les normes qui s\'appliquent';

  @override
  String get docHistoryStd1 =>
      'UIT-R M.1371 — Caractéristiques techniques d\'un AIS universel de bord (définit les 27 types de messages et leur agencement de bits).';

  @override
  String get docHistoryStd2 =>
      'Recommandations de l\'AISM — clarifications et guide de mise en œuvre.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — la structure des phrases NMEA et les exigences Classe B/CSTDMA.';

  @override
  String get docHistoryStd4 =>
      'IEC 61097-14 — l\'émetteur de détresse AIS-SART.';

  @override
  String get docHowIntro =>
      'L\'AIS est un système radio VHF. Chaque transpondeur écoute le trafic autour de lui et émet ses propres comptes-rendus dans des tranches temporelles réservées, évitant ainsi les collisions avec les autres navires à portée.';

  @override
  String get docHowRadioLink => 'La liaison radio';

  @override
  String get docHowRadioLink1 =>
      'Deux canaux VHF dédiés : AIS 1 à 161,975 MHz (87B) et AIS 2 à 162,025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'FM numérique à bande étroite, à 9 600 bits par seconde.';

  @override
  String get docHowRadioLink3 =>
      'Les messages sont organisés en trames TDMA de 2250 tranches temporelles (1 minute).';

  @override
  String get docHowSlots => 'Comment les tranches sont partagées';

  @override
  String get docHowSotdma =>
      'Les transpondeurs Classe A utilisent la SOTDMA (accès multiple par répartition temporelle auto-organisé) : chaque unité réserve une tranche récurrente et la réserve à nouveau quand la situation change, si bien que les navires se coordonnent en continu sans contrôleur central.';

  @override
  String get docHowCstdma =>
      'Les transpondeurs Classe B utilisent la CSTDMA, plus simple (TDMA à écoute de porteuse) : ils écoutent une tranche libre et s\'en emparent, ce qui explique que les comptes-rendus Classe B soient moins fréquents et puissent se perdre dans un trafic très dense.';

  @override
  String get docHowRates => 'Fréquences de compte-rendu';

  @override
  String get docHowRates1 =>
      'Compte-rendu de position Classe A (type 1) : toutes les 2-10 secondes en route, toutes les 3 minutes au mouillage.';

  @override
  String get docHowRates2 =>
      'Données statiques et de voyage (type 5) : toutes les 6 minutes.';

  @override
  String get docHowRates3 =>
      'Position Classe B (type 18) : environ toutes les 30 secondes.';

  @override
  String get docHowRates4 =>
      'Aide à la navigation (type 21) : toutes les 3 minutes.';

  @override
  String get docHowTerrestrial => 'Terrestre et satellite';

  @override
  String get docHowTerrestrialText =>
      'En surface, la portée de l\'AIS est limitée par l\'horizon VHF (T-AIS). Depuis le milieu des années 2000, les satellites en orbite terrestre basse (S-AIS) reçoivent les mêmes signaux, offrant une couverture quasi mondiale — les satellites complètent plutôt qu\'ils ne remplacent le réseau terrestre.';

  @override
  String get docRadioIntro =>
      'Sous les messages se trouve un petit système radio efficace. L\'AIS émet à 9 600 bits par seconde sur deux canaux VHF, en utilisant la modulation par déplacement minimal gaussien (GMSK) et un tramage de type HDLC.';

  @override
  String get docRadioPhysical => 'La liaison physique';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 à 161,975 MHz et AIS 2 à 162,025 MHz (canaux VHF 87B et 88B).';

  @override
  String get docRadioPhysical2 =>
      'Modulation GMSK à 9 600 bauds — assez étroite pour tenir dans la bande VHF maritime.';

  @override
  String get docRadioPhysical3 =>
      'Tramage HDLC avec bourrage de bits et codage de ligne NRZI, hérités du monde de la radio par paquets.';

  @override
  String get docRadioFrames => 'Trames et tranches TDMA';

  @override
  String get docRadioFrames1 =>
      'Chaque canal est découpé en trames d\'exactement 1 minute, divisées en 2 250 tranches temporelles d\'environ 26,7 ms chacune.';

  @override
  String get docRadioFrames2 =>
      'Une tranche porte un message AIS (256 bits avec montée/descente en puissance et temps de garde).';

  @override
  String get docRadioFrames3 =>
      'Les stations réutilisent les mêmes tranches à chaque trame afin de diffuser périodiquement sans entrer en collision.';

  @override
  String get docRadioCode =>
      '2250 tranches/trame · 1 trame = 60 s · tranche ≈ 26,7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — comment la Classe A s\'auto-organise';

  @override
  String get docRadioSotdmaText =>
      'Chaque transpondeur Classe A écoute les tranches autour de lui, en choisit une libre et annonce dans son champ d\'état radio quand il transmettra ensuite. Les stations réservent de nouveau en continu à mesure que la situation du trafic évolue, si bien qu\'aucun coordonnateur central n\'est nécessaire.';

  @override
  String get docRadioCstdma => 'CSTDMA — comment la Classe B s\'y intègre';

  @override
  String get docRadioCstdmaText =>
      'Les unités Classe B sont plus simples : elles écoutent une tranche actuellement libre et y émettent une fois. C\'est moins cher, mais les comptes-rendus Classe B peuvent se perdre dans un trafic très dense où une tranche est toujours occupée.';

  @override
  String get docRadioVdes => 'VDES — l\'avenir';

  @override
  String get docRadioVdesText =>
      'Le système d\'échange de données VHF (UIT-R M.2092) se déploie pour désengorger les eaux saturées : il ajoute de nouvelles fréquences, beaucoup plus de bande passante et des données bidirectionnelles sécurisées pour la navigation électronique, aux côtés du service AIS existant.';

  @override
  String get docClassesIntro =>
      'Le matériel AIS se décline en différentes classes et rôles. Les deux que vous rencontrerez le plus souvent sont le transpondeur Classe A complet et l\'unité Classe B bon marché.';

  @override
  String get docClassesComparison => 'Classe A vs Classe B';

  @override
  String get docClassesReceivers => 'Récepteurs et transpondeurs';

  @override
  String get docClassesReceiversText =>
      'Les transpondeurs reçoivent et émettent. De nombreuses stations côtières et passionnés n\'utilisent que des récepteurs, afin d\'observer le trafic sans y apparaître.';

  @override
  String get docClassesAton => 'Aides à la navigation';

  @override
  String get docClassesAtonText =>
      'Les stations AtoN (type 21) diffusent les bouées, balises et phares. Elles peuvent aussi émettre une aide virtuelle — un repère qui n\'existe que sur les cartes, utile pour signaler un nouveau danger.';

  @override
  String get docClassesDistress => 'Dispositifs de détresse et de sécurité';

  @override
  String get docClassesDistressIntro =>
      'Au-delà des navires ordinaires, l\'AIS porte des émetteurs de détresse que tout récepteur doit être capable de repérer :';

  @override
  String get docClassesSartNote =>
      'Une SART en action met aussi l\'état de navigation 14 (« AIS-SART actif ») sur son compte-rendu de position.';

  @override
  String get docShipTypesIntro =>
      'Les messages statiques de types 5 et 24 portent un code de type de navire sur 8 bits (0-99) qui décrit ce qu\'est le navire — cargo, pétrolier, bateau de pêche, navire de plaisance, etc. Le tableau complet est présenté ci-dessous.';

  @override
  String get docShipTypesCategories => 'Les catégories en un coup d\'œil';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle =>
      'Notes de terrain et particularités du monde réel';

  @override
  String get docFieldNotesIntro =>
      'Le trafic AIS réel ne correspond pas toujours à la théorie. Connaître ces particularités vous aide à faire confiance à ce que le décodeur affiche — et à ce qu\'il rejette.';

  @override
  String get docGlossaryIntro =>
      'Un dictionnaire consultable des acronymes et termes utilisés tout au long de ce guide et par la communauté AIS.';

  @override
  String get docCheatSheetIntro =>
      'Les nombres et codes essentiels en un coup d\'œil — fréquences, fréquences de compte-rendu, codes d\'état et formats.';

  @override
  String get docMmsiIntro =>
      'L\'identité de service mobile maritime (MMSI) est un numéro unique à 9 chiffres identifiant l\'équipement radio d\'un navire, comme un numéro de téléphone pour le navire. Ses trois premiers chiffres constituent le MID — les chiffres d\'identification maritime qui identifient le pays émetteur.';

  @override
  String get docMmsiFormats => 'Formats de numéros';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Rechercher un MMSI';

  @override
  String get docMmsiLookupHint =>
      'Saisissez un MMSI à 9 chiffres ci-dessous pour voir sa classe et le pays de l\'autorité émettrice.';

  @override
  String get docMmsiMidHeading => 'Codes pays (MID)';

  @override
  String get docMmsiMidText =>
      'Le tableau complet des MID est fourni avec KikAis et utilisé partout où un MMSI est affiché.';

  @override
  String get docMessagesTitle => 'Les 27 types de messages';

  @override
  String get docMessagesIntro =>
      'Chaque charge utile AIS commence par un type de message sur 6 bits (de 1 à 27). Le catalogue ci-dessous les regroupe par famille. Chaque carte montre une phrase NMEA réelle générée par l\'encodeur propre à KikAis, ses champs décodés, et un bouton pour l\'ouvrir dans le Décodeur.';

  @override
  String get docNmeaTitle => 'Structure NMEA et AIVDM';

  @override
  String get docNmeaIntro =>
      'Sur le fil, les messages AIS circulent sous forme de phrases NMEA 0183 commençant par !AIVDM (autres navires) ou !AIVDO (votre propre navire). La charge utile est un vecteur de bits protégé en ASCII.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Champs de la phrase';

  @override
  String get docNmeaField1 =>
      'Talker et formateur — !AIVDM ou !AIVDO (voir les IDs de talker ci-dessous).';

  @override
  String get docNmeaField2 =>
      'Nombre de fragments — combien de phrases composent le message complet (NMEA limite chaque ligne à ~82 caractères).';

  @override
  String get docNmeaField3 =>
      'Numéro de fragment — quelle partie c\'est (commence à 1).';

  @override
  String get docNmeaField4 =>
      'ID de message séquentiel — relie les fragments du même message entre eux.';

  @override
  String get docNmeaField5 => 'Canal radio — A ou B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Charge utile de données — la charge utile AIS protégée sur six bits.';

  @override
  String get docNmeaField7 =>
      'Bits de remplissage — combien de bits de bourrage ont été ajoutés au dernier groupe de 6 bits (0-5).';

  @override
  String get docNmeaField8 =>
      'Somme de contrôle — le XOR de tous les octets avant le *, en hexadécimal.';

  @override
  String get docNmeaMulti => 'Messages multi-fragments';

  @override
  String get docNmeaMultiText =>
      'Les messages plus longs qu\'une ligne (comme les données statiques de type 5) sont découpés : la première phrase indique un nombre de fragments de 2 et la seconde le complète avec le même ID de message.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Protection sur six bits';

  @override
  String get docNmeaArmoringText =>
      'Chaque caractère de la charge utile contient 6 bits. Soustrayez 48 du code ASCII, puis soustrayez encore 8 si le résultat est supérieur à 40.';

  @override
  String get docNmeaTalkers => 'IDs de talker';

  @override
  String get docNmeaTalkersIntro =>
      'Différents IDs de talker NMEA 4.0 identifient le type de station AIS :';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Somme de contrôle';

  @override
  String get docNmeaChecksumText =>
      'La somme de contrôle finale est le XOR de chaque octet situé entre le \"!\" et le \"*\". Calculez la vôtre ci-dessous :';

  @override
  String get docNmeaInspectorTitle => 'Essayez : l\'inspecteur de phrases';

  @override
  String get docNmeaInspectorText =>
      'Collez n\'importe quelle phrase AIVDM/AIVDO (ou utilisez un exemple ci-dessus) pour voir ses champs détaillés et les valeurs décodées.';

  @override
  String get docPayloadIntro =>
      'Une fois la protection sur six bits levée, une charge utile AIS est une séquence de champs de bits. Les six premiers bits sont le type de message ; les deux suivants sont l\'indicateur de répétition ; viennent ensuite 30 bits de MMSI.';

  @override
  String get docPayloadCnb => 'Le bloc de navigation commun (types 1-3)';

  @override
  String get docPayloadCnbText =>
      'La disposition la plus importante est partagée par les comptes-rendus de position Classe A. Utilisez le sélecteur pour parcourir les principales dispositions de messages, et cliquez sur un segment pour lire ce qu\'il encode.';

  @override
  String get docPayloadCoords => 'Coordonnées';

  @override
  String get docPayloadCoordsText =>
      'La latitude et la longitude sont stockées en 1/10 000 de minute. Divisez par 600 000 pour obtenir les degrés : 60 minutes dans un degré, et 10 000 unités par minute. L\'est et le nord sont positifs.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert =>
      'Convertissez vos propres coordonnées ci-dessous :';

  @override
  String get docPayloadSpeed => 'Vitesse, route, cap';

  @override
  String get docPayloadSpeed1 =>
      'SOG — vitesse sur le fond en dixièmes de nœud (0-102,2 nd) ; 1023 signifie « non disponible ».';

  @override
  String get docPayloadSpeed2 =>
      'COG — route sur le fond en dixièmes de degré, par rapport au nord vrai.';

  @override
  String get docPayloadSpeed3 =>
      'Cap — cap vrai en degrés entiers ; 511 signifie « non disponible ».';

  @override
  String get docPayloadSpeed4 =>
      'ROT — vitesse de giration : valeur ≈ 4,733 × √(vitesse de giration en °/min), signée (positive = tribord).';

  @override
  String get docPayloadNavStatus => 'État de navigation';

  @override
  String get docPayloadEpfd => 'Type de positionnement (EPFD)';

  @override
  String get docPayloadText => 'Texte sur six bits';

  @override
  String get docPayloadTextIntro =>
      'Les noms, indicatifs d\'appel et destinations utilisent le même alphabet sur six bits que la charge utile elle-même. Les lettres minuscules ne peuvent pas être encodées, c\'est pourquoi les noms AIS sont généralement en majuscules.';

  @override
  String get docSecurityTitle => 'Sécurité et qualité des données';

  @override
  String get docSecurityIntro =>
      'L\'AIS est conçue pour la coopération, pas pour la sécurité. Le canal radio est ouvert et non chiffré, et l\'identité de qui diffuse n\'est pas authentifiée.';

  @override
  String get docSecurityThreats => 'Menaces';

  @override
  String get docSecurityThreat1 =>
      'Usurpation — transmettre un faux MMSI, une fausse position ou une fausse identité (navires fantômes, contournement des sanctions).';

  @override
  String get docSecurityThreat2 =>
      'Brouillage — inonder les deux canaux VHF pour que le trafic réel ne puisse pas être reçu.';

  @override
  String get docSecurityThreat3 =>
      'Meaconing — rejouer des signaux réels venus d\'ailleurs pour tromper les récepteurs.';

  @override
  String get docSecurityQuality => 'Qualité des données';

  @override
  String get docSecurityQuality1 =>
      'Le bit de précision de position distingue une position GNSS non corrigée (> 10 m) d\'une position de qualité DGPS (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'Les récepteurs devraient vérifier la plausibilité des positions, vitesses et horodatages ; environ 0,3 % des messages du monde réel ont une longueur de charge utile incorrecte.';

  @override
  String get docSecurityQuality3 =>
      'L\'AIS par satellite souffre occasionnellement de collisions car l\'empreinte du satellite est beaucoup plus grande qu\'une cellule TDMA — une raison de plus de recouper avec le radar et d\'autres sources.';

  @override
  String get docKikaisIntro =>
      'KikAis est un laboratoire AIS complet : recevez du trafic en direct ou simulé, décodez-le, inspectez et envoyez vos propres messages, et construisez des flottes. Voici comment chaque onglet correspond à ce que vous venez de lire.';

  @override
  String get docTabReceptionText =>
      'Choisissez les flux (fichier, série, simulation), démarrez le forwarder et observez le flux NMEA brut et les bateaux décodés.';

  @override
  String get docTabSendText =>
      'Transférez les phrases reçues vers une ou plusieurs cibles TCP/UDP — comme une station côtière distribuerait le trafic.';

  @override
  String get docTabMapText =>
      'Voyez les navires décodés tracés à partir de leurs comptes-rendus de position de types 1/2/3, 18, 19 et 27.';

  @override
  String get docTabEditorText =>
      'Construisez à la main l\'un des 27 types de messages à partir d\'un formulaire convivial et envoyez-le — la meilleure façon d\'apprendre les champs.';

  @override
  String get docTabDecoderText =>
      'Collez n\'importe quelle phrase et obtenez les champs décodés, la somme de contrôle et la gestion des fragments — le compagnon pratique de ce guide.';

  @override
  String get docTabStatsText =>
      'Compteurs de messages, taux par flux et santé du décodeur (sommes de contrôle invalides, fragments perdus).';

  @override
  String get docTabSimulationText =>
      'Générez toute une flotte autour de n\'importe quel lieu — chaque type de message, schéma MMSI, forme de zone et même l\'injection d\'erreurs.';

  @override
  String get docSourcesIntro =>
      'Ce guide synthétise une documentation publique et faisant autorité :';

  @override
  String get docSources1 =>
      'gpsd — décodage du protocole AIVDM/AIVDO, par Eric S. Raymond (la bible technique de facto pour le format des phrases et les champs de bits de la charge utile).';

  @override
  String get docSources2 =>
      'Wikipédia — Automatic Identification System (vue d\'ensemble, histoire, applications, sécurité).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — pages AIS.';

  @override
  String get docSources4 =>
      'Recommandation UIT-R M.1371 — la norme AIS de référence.';

  @override
  String get docSources5 => 'IALA — clarifications de l\'UIT-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — structure NMEA, Classe B et AIS-SART.';

  @override
  String get docSourcesLearn => 'Pour en savoir plus';

  @override
  String get docSourcesLearnText =>
      'La meilleure façon de comprendre l\'AIS est d\'expérimenter : utilisez l\'Éditeur pour construire des messages, le Décodeur pour les relire, et l\'onglet Simulation pour observer toute une flotte. Tout dans ce guide est généré par l\'encodeur et le décodeur propres à KikAis.';

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
    return 'Émis par : $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Ouvrir dans le Décodeur';

  @override
  String get docInspectorNmeaLabel => 'Phrase NMEA';

  @override
  String get docInspectorInspect => 'Inspecter';

  @override
  String get docInspectorInvalidChecksum => 'Somme de contrôle invalide';

  @override
  String get docInspectorCouldNotDecode => 'Impossible de décoder';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Décodé : T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Type $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 chiffres)';

  @override
  String get docMmsiLookupButton => 'Rechercher';

  @override
  String get docMmsiLookupError =>
      'Saisissez un MMSI à 9 chiffres (chiffres uniquement).';

  @override
  String get docMmsiLookupClassGroup => 'Groupe de navires (appel de groupe)';

  @override
  String get docMmsiUnknownCountry => 'pays inconnu';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Ouvrir';

  @override
  String get updateCheckForUpdates => 'Rechercher des mises à jour';

  @override
  String get updateChecking => 'Recherche de mises à jour…';

  @override
  String updateNewVersion(Object version) {
    return 'Nouvelle version $version';
  }

  @override
  String get updateUpToDate => 'Vous êtes à jour.';

  @override
  String get updateCheckFailed => 'Échec de la recherche de mise à jour.';

  @override
  String get tooltipLanguage =>
      'Définit la langue de l\'interface. Les dix langues sont entièrement traduites ; choisissez « Auto » pour suivre la langue du système.';

  @override
  String get tooltipTheme =>
      'Définit le thème de couleurs : sombre, clair ou contraste élevé. Le contraste élevé améliore la lisibilité.';

  @override
  String get tooltipUpdate =>
      'Vérifie la disponibilité d\'une nouvelle version. Un badge vert apparaît à côté du numéro de version lorsqu\'une mise à jour est disponible.';

  @override
  String get tooltipMapSearch =>
      'Recherche un navire par nom, MMSI ou numéro IMO, puis centre et suit la carte sur lui.';

  @override
  String get tooltipMapFilters =>
      'Filtre les navires affichés : par type, statut de navigation, pays (MID), vitesse ou nom uniquement.';

  @override
  String get tooltipMapCluster =>
      'Active ou désactive le regroupement des navires. Lorsqu\'il est activé, les navires proches sont regroupés en un seul marqueur avec un compte.';

  @override
  String get tooltipMapTrails =>
      'Active ou désactive les traces. Lorsqu\'elles sont activées, chaque navire dessine son parcours récent sur la carte.';

  @override
  String get tooltipMapVectors =>
      'Active ou désactive les vecteurs de cap. Lorsqu\'ils sont activés, chaque navire affiche une flèche dans sa direction.';

  @override
  String get tooltipMapSendToMap =>
      'Active ou désactive l\'envoi des navires décodés sur la carte. Lorsqu\'il est activé, chaque navire décodé apparaît comme un marqueur.';

  @override
  String get tooltipMapClear =>
      'Supprime tous les navires actuellement sur la carte.';

  @override
  String get tooltipMapBasemap =>
      'Définit le fond de carte. « Auto » suit le thème actuel.';

  @override
  String get tooltipSendAdd =>
      'Ajoute une destination d\'envoi (UDP ou TCP, client ou serveur). Les trames AIS reçues sont transmises à chaque destination activée.';

  @override
  String get tooltipSendEdit =>
      'Modifie le nom, le protocole, l\'hôte, le port et le format de trames de cette destination.';

  @override
  String get tooltipSendDelete =>
      'Supprime cette destination. Cette action est irréversible.';

  @override
  String get tooltipSendToggle =>
      'Active ou désactive la transmission vers cette destination.';

  @override
  String get tooltipSendLocked =>
      'Les destinations sont verrouillées tant que le transmetteur est en cours d\'exécution. Arrêtez la source dans l\'onglet Réception pour les modifier.';

  @override
  String get tooltipReceptionAddSource =>
      'Ajoute une source de données : un flux réseau (UDP/TCP/gpsd), un fichier de trames NMEA enregistrées ou un port série.';

  @override
  String get tooltipReceptionStart =>
      'Démarre la réception et la transmission des trames AIS depuis toutes les sources activées.';

  @override
  String get tooltipReceptionStop =>
      'Arrête la réception et la transmission des trames AIS.';

  @override
  String get tooltipReceptionFeed => 'Active ou désactive cette source AIS.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Enregistre le journal de connexion dans un fichier texte.';

  @override
  String get tooltipReceptionClearLogs => 'Efface le journal de connexion.';

  @override
  String get tooltipReceptionRemoveSource => 'Supprime cette source AIS.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Rejette les trames dont la somme de contrôle NMEA est invalide lorsqu\'il est activé.';

  @override
  String get tooltipReceptionImportFormat =>
      'Définit la normalisation des trames reçues avant décodage.';

  @override
  String get tooltipReceptionLoop =>
      'Relance la lecture du fichier depuis le début lorsqu\'elle atteint la fin.';

  @override
  String get tooltipReceptionSpeed =>
      'Définit le multiplicateur de vitesse de lecture (1x = temps réel).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Actualise la liste des ports série disponibles.';

  @override
  String get tooltipSimApply =>
      'Applique les réglages actuels et génère la flotte. Les grandes flottes sont générées en arrière-plan.';

  @override
  String get tooltipSimGenerate =>
      'Génère une nouvelle flotte aléatoire avec une nouvelle graine, puis l\'applique.';

  @override
  String get tooltipSimOpenReception =>
      'Ouvre l\'onglet Réception pour démarrer le flux de simulation.';

  @override
  String get tooltipSimRadius =>
      'Rayon de la zone de navigation autour du centre, en kilomètres.';

  @override
  String get tooltipSimVessels => 'Nombre de navires à générer dans la flotte.';

  @override
  String get tooltipSimSpeedMin => 'Vitesse minimale des navires, en nœuds.';

  @override
  String get tooltipSimSpeedMax => 'Vitesse maximale des navires, en nœuds.';

  @override
  String get tooltipSimInterval => 'Délai entre deux émissions, en secondes.';

  @override
  String get tooltipSimSeed =>
      'Graine aléatoire. La même graine produit toujours la même flotte.';

  @override
  String get tooltipSimAnchored =>
      'Pourcentage de navires ancrés ou amarrés au lieu de se déplacer.';

  @override
  String get tooltipSimNamePrefix =>
      'Préfixe utilisé pour les noms des navires générés.';

  @override
  String get tooltipSimMmsiMid =>
      'Identifiant maritime (code pays à 3 chiffres) utilisé pour construire les MMSI.';

  @override
  String get tooltipSimCenterLat =>
      'Latitude du centre de la zone de navigation.';

  @override
  String get tooltipSimCenterLon =>
      'Longitude du centre de la zone de navigation.';

  @override
  String get tooltipSimTransit =>
      'Pourcentage de navires traversant la zone en route directe.';

  @override
  String get tooltipSimRegenEvery =>
      'Régénérer la flotte toutes les N émissions lorsque la régénération périodique est activée.';

  @override
  String get tooltipSimReportInterval =>
      'Intervalle maximal de rapport de position par navire, en émissions.';

  @override
  String get tooltipSimWander =>
      'Intensité de la dérive aléatoire du cap (0 = lignes droites).';

  @override
  String get tooltipSimClassBShare =>
      'Pourcentage de rapports de position classe B par rapport à classe A lorsque les deux sont activés.';

  @override
  String get tooltipSimErrorRate =>
      'Probabilité de corrompre ou dupliquer chaque trame émise.';

  @override
  String get tooltipSimBaseStations =>
      'Nombre de stations de base fixes à générer.';

  @override
  String get tooltipSimAtoN =>
      'Nombre d\'aides à la navigation (balises) fixes à générer.';

  @override
  String get tooltipSimRealisticNames =>
      'Utiliser des noms, indicatifs et destinations de navires réalistes.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Adapter les dimensions et le tirant d\'eau au type de navire.';

  @override
  String get tooltipSimRealisticMmsi =>
      'Construire des MMSI conformes à la structure ITU selon la catégorie de navire.';

  @override
  String get tooltipSimVarySpeed =>
      'Laisser la vitesse dériver légèrement dans la plage configurée.';

  @override
  String get tooltipSimSpeedByType =>
      'Choisir la vitesse dans la plage typique de chaque type de navire.';

  @override
  String get tooltipSimHighAccuracy =>
      'Activer le drapeau de position haute précision sur les rapports émis.';

  @override
  String get tooltipSimRealisticRot =>
      'Émettre un taux de virage dérivé du changement de cap.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Régénérer automatiquement la flotte toutes les N émissions pour simuler un trafic changeant.';

  @override
  String get tooltipSimInjectErrors =>
      'Corrompre ou dupliquer certaines trames émises pour tester la gestion des erreurs.';

  @override
  String get tooltipSimNmea4Tag =>
      'Préfixer chaque trame émise avec un bloc de balise NMEA 4.0.';

  @override
  String get tooltipSimVesselType =>
      'Inclure ce type de navire dans la flotte.';

  @override
  String get tooltipSimMessageType => 'Émettre ce type de message AIS.';

  @override
  String get tooltipDecoderClear =>
      'Efface l\'entrée et les résultats du décodeur.';

  @override
  String get tooltipStatsDecode =>
      'Met en pause ou reprend le décodage des trames AIS reçues.';

  @override
  String get tooltipStatsReset =>
      'Remet tous les compteurs de statistiques à zéro.';

  @override
  String get tooltipDocOpenTab => 'Ouvre cette section dans son propre onglet.';

  @override
  String get tooltipEditorInject =>
      'Injecte le message composé dans le décodeur comme s\'il avait été reçu.';

  @override
  String get tooltipEditorSend =>
      'Envoie le message composé à chaque destination d\'envoi activée.';

  @override
  String get tooltipCopy => 'Copie la sélection dans le presse-papiers.';

  @override
  String get tooltipClose => 'Ferme ce panneau.';

  @override
  String get tooltipBrowse =>
      'Ouvre l\'explorateur de fichiers pour choisir un fichier.';

  @override
  String get tooltipFeedName =>
      'Une étiquette identifiant cette source dans la liste des flux.';

  @override
  String get tooltipFeedHost =>
      'Adresse du serveur qui diffuse les trames AIS.';

  @override
  String get tooltipFeedPort =>
      'Port TCP ou UDP utilisé pour joindre le serveur.';

  @override
  String get tooltipFeedHeader =>
      'Octets facultatifs envoyés à la connexion, avant la lecture (p. ex. une requête gpsd).';

  @override
  String get tooltipFeedFile =>
      'Chemin vers un fichier texte de trames NMEA enregistrées.';

  @override
  String get tooltipFeedInterval =>
      'Délai entre deux trames lors de la lecture du fichier.';

  @override
  String get tooltipFeedLoop =>
      'Reprend la lecture du fichier depuis le début quand la fin est atteinte.';

  @override
  String get tooltipFeedSpeed =>
      'Multiplicateur de vitesse de lecture (1x = temps réel).';

  @override
  String get tooltipFeedSerialPort =>
      'Port série du récepteur AIS (p. ex. COM3 ou /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Débit en bauds utilisé pour parler au récepteur AIS série.';

  @override
  String get tooltipFeedRtlDevice =>
      'Le dongle RTL-SDR utilisé pour recevoir l\'AIS en VHF.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Laisse le tuner ajuster son gain automatiquement. Recommandé pour la plupart des installations.';

  @override
  String get tooltipFeedRtlGain =>
      'Gain fixe du tuner en décibels, utilisé lorsque le gain automatique est désactivé.';

  @override
  String get tooltipFeedRtlChannels =>
      'Quels canaux VHF AIS décoder : A (161,975 MHz), B (162,025 MHz) ou les deux.';
}
