// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get languageSystem => 'Automático (sistema)';

  @override
  String get languageEn => 'Inglés';

  @override
  String get languageFr => 'Francés';

  @override
  String get languageEs => 'Español';

  @override
  String get languageDe => 'Alemán';

  @override
  String get languagePt => 'Portugués';

  @override
  String get languageIt => 'Italiano';

  @override
  String get languageNl => 'Neerlandés';

  @override
  String get languageZh => '中文';

  @override
  String get languageJa => '日本語';

  @override
  String get languageRu => 'Русский';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeHighContrast => 'Alto contraste';

  @override
  String get tabReception => 'Recepción';

  @override
  String get tabSend => 'Enviar';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabEditor => 'Editor';

  @override
  String get tabTools => 'Herramientas';

  @override
  String get tabStats => 'Estadísticas';

  @override
  String get tabSimulation => 'Simulación';

  @override
  String get tabDocs => 'Documentación';

  @override
  String get protocolUdpServer => 'Servidor UDP';

  @override
  String get protocolUdpClient => 'Cliente UDP';

  @override
  String get protocolTcpClient => 'Cliente TCP';

  @override
  String get protocolTcpServer => 'Servidor TCP';

  @override
  String get formatPassthrough => 'Transparente';

  @override
  String get formatStrip => 'Quitar bloques de etiquetas';

  @override
  String get formatTag => 'Añadir bloque de etiqueta';

  @override
  String get sendAddDestination => 'Añadir destino';

  @override
  String get sendEditDestination => 'Editar destino';

  @override
  String get sendFormat => 'Formato de envío';

  @override
  String get sendSave => 'Guardar';

  @override
  String get sendLockedBanner =>
      'El reenviador está en funcionamiento — los destinos están bloqueados.';

  @override
  String get sendEmpty =>
      'Todavía no hay ningún destino. Añade uno para reenviar las tramas AIS recibidas.';

  @override
  String get fieldName => 'Nombre';

  @override
  String get fieldProtocol => 'Protocolo';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Puerto';

  @override
  String get fieldTagSourceId => 'ID de fuente de etiqueta';

  @override
  String get fieldFile => 'Archivo';

  @override
  String get fieldCancel => 'Cancelar';

  @override
  String get fieldAdd => 'Añadir';

  @override
  String get receptionFeeds => 'Fuentes';

  @override
  String get receptionValidateChecksums => 'Validar sumas de comprobación NMEA';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oraciones descartadas',
      one: '1 oración descartada',
      zero: 'Ninguna oración descartada',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Formato de importación de tramas';

  @override
  String get receptionStart => 'Iniciar';

  @override
  String get receptionStop => 'Detener';

  @override
  String get receptionLogs => 'Registros';

  @override
  String get receptionFrameCopied => 'Trama copiada';

  @override
  String get receptionAddSource => 'Añadir fuente';

  @override
  String get receptionNetwork => 'Red';

  @override
  String get receptionFile => 'Archivo';

  @override
  String get receptionSerial => 'Puerto serie';

  @override
  String get receptionHeaderOptional => 'Cabecera (opcional)';

  @override
  String get receptionPathOrBrowse => 'Ruta o Examinar…';

  @override
  String get receptionIntervalMs => 'Intervalo entre tramas (ms)';

  @override
  String get receptionReplayTimestamps =>
      'Reproducir usando las marcas de tiempo del archivo';

  @override
  String get receptionReplayTimestampsHint =>
      'Sigue los tiempos registrados (etiqueta t: o prefijo de marca de tiempo) en lugar de un intervalo fijo';

  @override
  String get receptionSpeed => 'Velocidad';

  @override
  String get receptionReplayLoop => 'Bucle (reproducir desde el principio)';

  @override
  String get receptionSerialPort => 'Puerto serie';

  @override
  String get receptionSerialPortHint => 'p. ej. COM3 o /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Velocidad en baudios';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'Dispositivo RTL-SDR';

  @override
  String get tooltipReceptionRtlSdrDevices =>
      'Actualizar la lista de dongles RTL-SDR';

  @override
  String get receptionRtlSdrNoDevice =>
      'No se encontró ningún dispositivo RTL-SDR. Instale los controladores RTL-SDR (Zadig / WinUSB en Windows) y conecte el dongle.';

  @override
  String get receptionRtlSdrAutoGain => 'Ganancia automática (recomendado)';

  @override
  String get receptionRtlSdrGainDb => 'Ganancia del sintonizador (dB)';

  @override
  String get receptionRtlSdrSampleRate => 'Frecuencia de muestreo';

  @override
  String get receptionRtlSdrChannels => 'Canales';

  @override
  String get msgType1 => 'Informe de posición Clase A';

  @override
  String get msgType2 => 'Informe de posición Clase A (asignado)';

  @override
  String get msgType3 => 'Informe de posición Clase A (respuesta)';

  @override
  String get msgType4 => 'Estación base';

  @override
  String get msgType5 => 'Datos estáticos y de viaje';

  @override
  String get msgType6 => 'Mensaje binario dirigido';

  @override
  String get msgType7 => 'Acuse de recibo binario';

  @override
  String get msgType8 => 'Mensaje binario de difusión';

  @override
  String get msgType9 => 'Informe de posición estándar de aeronave SAR';

  @override
  String get msgType10 => 'Solicitud de UTC/fecha';

  @override
  String get msgType11 => 'Respuesta de UTC/fecha';

  @override
  String get msgType12 => 'Mensaje de seguridad dirigido';

  @override
  String get msgType13 => 'Acuse de recibo de seguridad';

  @override
  String get msgType14 => 'Mensaje de seguridad de difusión';

  @override
  String get msgType15 => 'Interrogación';

  @override
  String get msgType16 => 'Comando de modo de asignación';

  @override
  String get msgType17 => 'Mensaje binario de difusión DGNSS';

  @override
  String get msgType18 => 'Informe de posición CS Clase B estándar';

  @override
  String get msgType19 => 'Informe de posición de equipo Clase B ampliado';

  @override
  String get msgType20 => 'Mensaje de gestión del enlace de datos';

  @override
  String get msgType21 => 'Informe de ayuda a la navegación';

  @override
  String get msgType22 => 'Gestión de canales';

  @override
  String get msgType23 => 'Comando de asignación de grupo';

  @override
  String get msgType24 => 'Informe de datos estáticos';

  @override
  String get msgType25 => 'Mensaje binario de ranura única';

  @override
  String get msgType26 => 'Mensaje binario de ranuras múltiples';

  @override
  String get msgType27 =>
      'Informe de posición para aplicaciones de largo alcance';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String get statsFeed => 'Fuente';

  @override
  String get statsAllFeeds => 'Todas las fuentes';

  @override
  String get statsReceived => 'Recibidas';

  @override
  String get statsDecoded => 'Decodificadas';

  @override
  String get statsInvalidChecksums => 'Sumas de comprobación no válidas';

  @override
  String get statsDroppedFragments => 'Fragmentos descartados';

  @override
  String get statsParseErrors => 'Errores de análisis';

  @override
  String get statsPendingFragments => 'Fragmentos pendientes';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(todas las fuentes)';

  @override
  String get statsReceivedVsDecoded =>
      'Recibidas vs Decodificadas (últimos 60 s)';

  @override
  String get statsPerSecondLabel => 'por segundo';

  @override
  String get statsAccounting => 'Contabilidad';

  @override
  String get statsMultiPartParts => 'Partes de mensajes multiparte';

  @override
  String get statsPending => 'Pendientes';

  @override
  String get statsDropped => 'Descartadas';

  @override
  String get statsReconcile => 'Recibidas y decodificadas coinciden.';

  @override
  String get statsGapPaused =>
      'La brecha incluye oraciones recibidas mientras la decodificación estaba en pausa.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Recibidas $received = $sum';
  }

  @override
  String get statsByMessageType => 'Por tipo de mensaje';

  @override
  String get statsNoDecodedYet => 'Aún no hay mensajes decodificados';

  @override
  String statsTypeFallback(Object type) {
    return 'Tipo $type';
  }

  @override
  String get statsByFeed => 'Por fuente';

  @override
  String statsFeedFilter(Object filter) {
    return 'Fuente: $filter';
  }

  @override
  String get statsNoActivityYet => 'Aún no hay actividad en la fuente';

  @override
  String get statsCollecting => 'recopilando…';

  @override
  String get simVesselCargo => 'Carga';

  @override
  String get simVesselTanker => 'Petrolero';

  @override
  String get simVesselFishing => 'Pesca';

  @override
  String get simVesselSailing => 'Vela';

  @override
  String get simVesselPassenger => 'Pasaje';

  @override
  String get simVesselTug => 'Remolcador';

  @override
  String get simVesselHsc => 'Embarcación de alta velocidad';

  @override
  String get simVesselOther => 'Otros';

  @override
  String get simType1 => 'Informe de posición (1/2/3)';

  @override
  String get simType5 => 'Estáticos y viaje (5)';

  @override
  String get simType9 => 'Aeronave SAR (9)';

  @override
  String get simType18 => 'Posición Clase B (18)';

  @override
  String get simType19 => 'Clase B ampliado (19)';

  @override
  String get simType27 => 'Largo alcance (27)';

  @override
  String get simType4 => 'Estación base (4)';

  @override
  String get simType21 => 'Ayuda a la navegación (21)';

  @override
  String get simType8 => 'Difusión meteorológica (8)';

  @override
  String get simType11 => 'Respuesta UTC/fecha (11)';

  @override
  String get simType12 => 'Seguridad dirigida (12)';

  @override
  String get simType14 => 'Seguridad de difusión (14)';

  @override
  String get simType22 => 'Gestión de canales (22)';

  @override
  String get simType23 => 'Asignación de grupo (23)';

  @override
  String get simType24 => 'Clase B estáticos (24)';

  @override
  String get simTitle => 'Simulación';

  @override
  String get simInfoBanner =>
      'La flota se emite cuando la fuente \"Simulación\" está habilitada en la pestaña Recepción y el reenviador está en funcionamiento.';

  @override
  String get simOpenReception => 'Abrir Recepción';

  @override
  String get simFleetSection => 'Flota';

  @override
  String get simRadiusKm => 'Radio (km)';

  @override
  String get simVessels => 'Embarcaciones';

  @override
  String get simSpeedMinKn => 'Velocidad mín (nudos)';

  @override
  String get simSpeedMaxKn => 'Velocidad máx (nudos)';

  @override
  String get simIntervalS => 'Intervalo (s)';

  @override
  String get simSeed => 'Semilla';

  @override
  String get simAnchoredPct => 'Fondeadas (%)';

  @override
  String get simNamePrefix => 'Prefijo de nombre';

  @override
  String get simMmsiMid => 'País MMSI / MID';

  @override
  String get simSearchMmid => 'Busca un país o escribe un MID de 3 dígitos';

  @override
  String get simCustom => 'Personalizado';

  @override
  String get simVesselTypes => 'Tipos de embarcación';

  @override
  String get simRealisticNames => 'Nombres realistas';

  @override
  String get simRealisticDimensions => 'Dimensiones realistas';

  @override
  String get simRealisticMmsi => 'MMSI ITU realistas';

  @override
  String get simZoneSection => 'Zona y tráfico';

  @override
  String get simLocationPreset => 'Preajuste de ubicación';

  @override
  String get simSearchPort => 'Busca un puerto…';

  @override
  String get simCenterLat => 'Latitud central';

  @override
  String get simCenterLon => 'Longitud central';

  @override
  String get simZoneShape => 'Forma de la zona';

  @override
  String get simTransitPct => 'Tránsito (%)';

  @override
  String get simRegeneratePeriodically => 'Regenerar periódicamente';

  @override
  String get simRegenerateTicks => 'Regenerar (ticks)';

  @override
  String get simPresetHint =>
      'Elige un preajuste para rellenar las coordenadas, o escribe Latitud / Longitud central directamente.';

  @override
  String get simMovementSection => 'Movimiento y emisión';

  @override
  String get simVarySpeed => 'Variar la velocidad con el tiempo';

  @override
  String get simReportIntervalTicks => 'Intervalo de informe (ticks)';

  @override
  String get simWander => 'Deriva (0-3)';

  @override
  String get simSpeedByType => 'Velocidad por tipo de embarcación';

  @override
  String get simClassBSharePct => 'Cuota Clase B (%)';

  @override
  String get simHighAccuracy => 'Alta precisión';

  @override
  String get simRealisticRot => 'Velocidad de giro realista';

  @override
  String get simContentSection => 'Contenido';

  @override
  String get simSafetyTexts => 'Textos de seguridad (uno por línea)';

  @override
  String get simDestinations => 'Destinos (uno por línea)';

  @override
  String get simStationsSection => 'Estaciones';

  @override
  String get simBaseStations => 'Estaciones base';

  @override
  String get simAtoN => 'Ayudas a la navegación';

  @override
  String get simQualitySection => 'Calidad de transmisión';

  @override
  String get simInjectErrors => 'Inyectar errores';

  @override
  String get simErrorRatePct => 'Tasa de errores (%)';

  @override
  String get simTalkerId => 'Identificador de hablante';

  @override
  String get simNmea4Tag => 'Bloque de etiqueta NMEA 4.0';

  @override
  String get simMessagesSection => 'Mensajes';

  @override
  String get simApplyFleet => 'Aplicar flota';

  @override
  String get simRegenerateFleet => 'Regenerar flota';

  @override
  String get simGenerating => 'Generando…';

  @override
  String get simLiveFleet => 'Flota en vivo';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats barcos · $frames tramas emitidas';
  }

  @override
  String get mapSearchVessels => 'Buscar embarcaciones';

  @override
  String get mapSearchHint => 'Nombre, MMSI o IMO';

  @override
  String get mapNoResults => 'Sin resultados';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'Filtros';

  @override
  String mapAllLabel(Object label) {
    return 'Todos $label';
  }

  @override
  String get mapVesselType => 'Tipo de embarcación';

  @override
  String get mapNavigationStatus => 'Estado de navegación';

  @override
  String get mapCountry => 'País';

  @override
  String get mapMinSog => 'SOG mín (nudos)';

  @override
  String get mapMaxSog => 'SOG máx (nudos)';

  @override
  String get mapOnlyNamed => 'Solo embarcaciones con nombre';

  @override
  String get mapReset => 'Restablecer';

  @override
  String get mapApply => 'Aplicar';

  @override
  String get mapAutoBasemap => 'Automático (sigue el tema)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Siguiendo a $mmsi';
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
  String get basemapVoyagerLight => 'Voyager (claro)';

  @override
  String get basemapPositronLight => 'Positron (claro minimalista)';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Esri Satélite';

  @override
  String get basemapEsriStreets => 'Esri Mapa de calles mundial';

  @override
  String get decoderInputLabel => 'Pega o escribe una o más oraciones NMEA AIS';

  @override
  String get decoderValidateChecksums => 'Validar sumas de comprobación';

  @override
  String get decoderDecode => 'Decodificar';

  @override
  String get decoderDecoded => 'Decodificado';

  @override
  String decoderDecodedN(Object n) {
    return 'Decodificado ($n oraciones)';
  }

  @override
  String get decoderInvalidChecksum => 'Suma de comprobación no válida';

  @override
  String get decoderParseError => 'Error de análisis';

  @override
  String get decoderWaitingFragments => 'Esperando más fragmentos…';

  @override
  String decoderTagSource(Object id) {
    return 'fuente $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Bloque de etiqueta · $content';
  }

  @override
  String get toolDecoder => 'Decodificador NMEA';

  @override
  String get toolDecoderSub => 'Decodifica frases AIS';

  @override
  String get toolChecksum => 'Suma de comprobación';

  @override
  String get toolChecksumSub => 'Calcula XOR NMEA';

  @override
  String get toolMmsi => 'Búsqueda MMSI';

  @override
  String get toolMmsiSub => 'Valida e identifica un MMSI';

  @override
  String get toolSpeed => 'Conversor de velocidad';

  @override
  String get toolSpeedSub => 'nudos · km/h · m/s · mph';

  @override
  String get toolBinary => 'Inspector binario';

  @override
  String get toolBinarySub => 'Payload hasta los bits';

  @override
  String get toolEta => 'Calculadora de ETA';

  @override
  String get toolEtaSub => 'ETA en campos tipo 5';

  @override
  String get toolRadio => 'Alcance radio';

  @override
  String get toolRadioSub => 'Horizonte radio VHF-AIS';

  @override
  String get toolTextToBinary => 'Texto a binario';

  @override
  String get toolTextToBinarySub => 'ASCII 6-bit a hex/bits';

  @override
  String get checksumInputLabel => 'Pega una o más frases NMEA';

  @override
  String get checksumComputed => 'Calculada';

  @override
  String get checksumDeclared => 'Declarada';

  @override
  String get checksumValid => 'Suma de comprobación válida';

  @override
  String get checksumInvalid => 'Suma de comprobación incorrecta';

  @override
  String get checksumFix => 'Corregir la suma';

  @override
  String get mmsiInputLabel => 'MMSI (9 dígitos)';

  @override
  String get mmsiValid => 'MMSI válido';

  @override
  String get mmsiInvalid => 'No es un MMSI válido de 9 dígitos';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'País';

  @override
  String get mmsiCountryUnknown => 'MID desconocido';

  @override
  String get mmsiType => 'Tipo de estación';

  @override
  String get mmsiGroupCall => 'Llamada de grupo';

  @override
  String get mmsiSarAircraft => 'Aeronave SAR';

  @override
  String get mmsiCoastStation => 'Estación costera';

  @override
  String get mmsiShipStation => 'Estación de buque';

  @override
  String get mmsiHandheldVhf => 'VHF portátil';

  @override
  String get mmsiAton => 'Ayuda a la navegación (AtoN)';

  @override
  String get mmsiSar => 'Unidad SAR';

  @override
  String get mmsiOther => 'Otro';

  @override
  String get speedValue => 'Valor';

  @override
  String get speedUnit => 'Unidad';

  @override
  String get binaryInputLabel => 'Frase NMEA o payload 6-bit bruto';

  @override
  String get binaryPayload => 'Payload';

  @override
  String get binaryBits => 'Bits';

  @override
  String get binaryBinary => 'Binario';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Octetos hex';

  @override
  String get binarySixBit => 'Caracteres 6-bit';

  @override
  String get etaDistance => 'Distancia';

  @override
  String get etaUnitNm => 'millas náuticas';

  @override
  String get etaUnitKm => 'kilómetros';

  @override
  String get etaSpeed => 'Velocidad';

  @override
  String get etaDuration => 'Duración';

  @override
  String get etaEtaLocal => 'ETA (local)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'Campos ETA del tipo 5';

  @override
  String get etaMonth => 'Mes';

  @override
  String get etaDay => 'Día';

  @override
  String get etaHour => 'Hora';

  @override
  String get etaMinute => 'Minuto';

  @override
  String get etaCombined => 'MM/DD HH:MM';

  @override
  String get radioHeight1 => 'Altura antena 1';

  @override
  String get radioHeight2 => 'Altura antena 2';

  @override
  String get radioHorizon => 'Horizonte radio';

  @override
  String get radioHorizonKm => 'Horizonte radio (km)';

  @override
  String get radioFrequencies => 'Canales AIS';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Escribe un texto (alfabeto AIS 6-bit)';

  @override
  String get t2bCharTable => 'Carácter · valor · 6-bit';

  @override
  String get t2bBinary => 'Binario';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Octetos (formato editor)';

  @override
  String get t2bPayload => 'Payload blindado';

  @override
  String get t2bNote =>
      'La lista de octetos puede pegarse en el campo «Data bytes» del editor de un mensaje 6/8/25/26; el payload blindado es el campo payload exacto de la frase NMEA.';

  @override
  String editorAsmDetected(Object name) {
    return 'Mensaje específico de aplicación — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Campos del ASM coincidente. El campo bruto «Data bytes» sigue teniendo prioridad si se rellena.';

  @override
  String get fMessageType => 'Tipo de mensaje';

  @override
  String get editorAsmPreset => 'Preselección ASM';

  @override
  String get editorAsmPresetManual =>
      'Personalizado — introducir DAC/FID a mano';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'Campos ASM';

  @override
  String get asmStateInForce => 'en vigor';

  @override
  String get asmStateDeprecated => 'obsoleto';

  @override
  String get asmStateReplaced => 'reemplazado';

  @override
  String get asmStateDiscontinued => 'descontinuado';

  @override
  String get asmStateDraft => 'borrador';

  @override
  String get asmStateProposal => 'propuesta';

  @override
  String get asmStateTesting => 'en prueba';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Obsoleto desde $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'No se documenta ningún layout de bits para $name — edite los Data bytes brutos.';
  }

  @override
  String get docChapterAsm => 'Mensajes específicos de aplicación';

  @override
  String get docAsmIntro =>
      'No todos los payloads AIS son informes de posición estándar. Los tipos 6, 8, 25 y 26 llevan datos binarios específicos (ASM) cuyo significado define un Código de Área Designada (DAC) y un Identificador de Función (FID).';

  @override
  String get docAsmWhatTitle => '¿Qué es un ASM?';

  @override
  String get docAsmWhat =>
      'Un mensaje específico de aplicación es un payload estructurado publicado por una organización (OMI, IALA, administraciones nacionales, fabricantes) para un uso concreto: datos meteorológicos e hidrográficos, vigilancia de ayudas a la navegación, correcciones DGPS, servicios portuarios, etc. Los tipos 6/8 llevan la cabecera DAC/FID; los 25/26 repiten ese mismo esquema DAC/FID en los mensajes de ranura.';

  @override
  String get docAsmDacFidTitle => 'DAC y FID';

  @override
  String get docAsmDacFid1 =>
      'El DAC es un código de 10 bits que identifica la organización o el país emisor (p. ej. 001 = OMI, 002 = IALA). El FID es un código de función de 6 bits dentro del espacio de ese DAC (p. ej. 001/11 = datos meteo-hidro de la OMI).';

  @override
  String get docAsmDacFid2 =>
      'Los bytes de datos que siguen a la cabecera DAC/FID se decodifican según la norma de aplicación correspondiente. Distintos pares DAC/FID pueden interpretar los mismos bytes de forma totalmente diferente: siempre hay que conocer el par antes.';

  @override
  String get docAsmWhereTitle => 'Dónde encontrar las definiciones';

  @override
  String get docAsmWhere1 =>
      'Circulares de la OMI y ITU-R M.1371 (anexos) — fuente autorizada para el DAC 001.';

  @override
  String get docAsmWhere2 =>
      'Directrices de la IALA (p. ej. G1139) y administraciones nacionales — para los DAC regionales.';

  @override
  String get docAsmWhere3 =>
      'Documentación AIVDM de gpsd — catálogo abierto y legible por máquina de los esquemas DAC/FID más comunes.';

  @override
  String get docAsmInKikaisTitle => 'En KikAis';

  @override
  String get docAsmInKikais =>
      'El Editor conoce un conjunto curado de ASM conocidos: cuando el DAC/FID de un mensaje 6/8/25/26 coincide, el campo data se muestra como subcampos con nombre que se empaquetan automáticamente. El campo bruto «Data bytes» siempre prevalece cuando se rellena. La lista vive en asm_formats.dart y es fácil de ampliar.';

  @override
  String get docAsmExampleTitle => 'Ejemplo: meteo-hidro OMI (001/11)';

  @override
  String get docAsmExample =>
      'En el Editor, elige el tipo 8, DAC=1 y FID=11 para construir un mensaje meteorológico OMI: viento, temperaturas del aire y del agua, presión, visibilidad, corrientes y olas se editan campo a campo en lugar de como un bloque de bytes.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Indicador de repetición';

  @override
  String get fNavStatus => 'Estado de navegación';

  @override
  String get fLatitude => 'Latitud';

  @override
  String get fLongitude => 'Longitud';

  @override
  String get fSogKn => 'SOG (nudos)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Rumbo (°)';

  @override
  String get fRateOfTurn => 'Velocidad de giro';

  @override
  String get fManeuver => 'Maniobra';

  @override
  String get fTimestamp => 'Marca de tiempo';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Precisión';

  @override
  String get fEpfdFixType => 'Tipo de fijación EPFD';

  @override
  String get fSyncState => 'Estado de sincronización';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Indicativo de llamada';

  @override
  String get fVesselName => 'Nombre de la embarcación';

  @override
  String get fShipType => 'Tipo de buque';

  @override
  String get fShipTypeText => 'Tipo de buque (texto)';

  @override
  String get fDims => 'Proa/Popa/Babor/Estribor (m)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Calado (m)';

  @override
  String get fDestination => 'Destino';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'MMSI de destino';

  @override
  String get fSeqNumber => 'Número de secuencia';

  @override
  String get fRetransmit => 'Retransmitir';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Datos';

  @override
  String get fAltitudeM => 'Altitud (m)';

  @override
  String get fAssignedMode => 'Modo asignado';

  @override
  String get fRegionalReserved => 'Reservado regional';

  @override
  String get fText => 'Texto';

  @override
  String fStationN(Object n) {
    return 'Estación $n';
  }

  @override
  String fSlotN(Object n) {
    return 'Ranura $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return 'offset $offset · número $number · timeout $timeout · inc $increment';
  }

  @override
  String get fAidType => 'Tipo de ayuda';

  @override
  String get fAidTypeCode => 'Tipo de ayuda (código)';

  @override
  String get fName => 'Nombre';

  @override
  String get fNameExt => 'Extensión del nombre';

  @override
  String get fVirtualAid => 'Ayuda virtual';

  @override
  String get fOffPosition => 'Fuera de posición';

  @override
  String get fSecond => 'Segundo';

  @override
  String get fChannelA => 'Canal A';

  @override
  String get fChannelB => 'Canal B';

  @override
  String get fTxRxMode => 'Modo TX/RX';

  @override
  String get fPower => 'Potencia';

  @override
  String get fZone => 'Zona';

  @override
  String get fAddressed => 'Dirigido';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Banda A';

  @override
  String get fBandB => 'Banda B';

  @override
  String get fZoneSize => 'Tamaño de la zona';

  @override
  String get fStationType => 'Tipo de estación';

  @override
  String get fReportInterval => 'Intervalo de informe';

  @override
  String get fQuietTime => 'Tiempo de silencio';

  @override
  String get fPart => 'Parte';

  @override
  String get fVendorId => 'ID de proveedor';

  @override
  String get fUnitModel => 'Modelo de unidad';

  @override
  String get fSerialNumber => 'Número de serie';

  @override
  String get fMothershipMmsi => 'MMSI del buque nodriza';

  @override
  String get fRadioStatus => 'Estado de radio';

  @override
  String get fGnssStatus => 'Estado de la posición GNSS';

  @override
  String fDestN(Object n) {
    return 'Destino $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi sec $seq';
  }

  @override
  String get fDestIndicator => 'Indicador de destino';

  @override
  String get fBinaryDataFlag => 'Indicador de datos binarios';

  @override
  String get fApplicationId => 'ID de aplicación';

  @override
  String get fPowerHigh => 'Alta';

  @override
  String get fPowerLow => 'Baja';

  @override
  String get fPartA => 'A (nombre)';

  @override
  String get fPartB => 'B (datos del buque)';

  @override
  String get editorTitle => 'Editor de mensajes AIS';

  @override
  String get editorCompose => 'Redactar mensaje';

  @override
  String get editorMessageType => 'Tipo de mensaje';

  @override
  String get editorAddTagBlock => 'Añadir bloque de etiqueta NMEA 4.0';

  @override
  String get editorSourceId => 'ID de fuente';

  @override
  String get editorInjectToMap => 'Inyectar en el mapa';

  @override
  String get editorSendToTarget => 'Enviar al destino';

  @override
  String get editorPreview => 'Vista previa NMEA';

  @override
  String get editorNmeaCopied => 'NMEA copiado';

  @override
  String get editorInjected => 'Mensaje inyectado';

  @override
  String get editorSentToTarget => 'Mensaje enviado al destino';

  @override
  String get editorNavStatus0_15 => 'Estado de navegación (0-15)';

  @override
  String get editorYear => 'Año';

  @override
  String get editorMonth => 'Mes';

  @override
  String get editorDay => 'Día';

  @override
  String get editorHour => 'Hora';

  @override
  String get editorMinute => 'Minuto';

  @override
  String get editorSecond => 'Segundo';

  @override
  String get editorImoNumber => 'Número IMO';

  @override
  String get editorBowM => 'Proa (m)';

  @override
  String get editorSternM => 'Popa (m)';

  @override
  String get editorPortM => 'Babor (m)';

  @override
  String get editorStarboardM => 'Estribor (m)';

  @override
  String get editorEtaMonth => 'Mes de ETA';

  @override
  String get editorEtaDay => 'Día de ETA';

  @override
  String get editorEtaHour => 'Hora de ETA';

  @override
  String get editorEtaMinute => 'Minuto de ETA';

  @override
  String get editorSequence0_3 => 'Secuencia (0-3)';

  @override
  String get editorDataBytes => 'Bytes de datos (hex o 1,2,3)';

  @override
  String get editorDestMmsisComma => 'MMSI de destino (separados por coma)';

  @override
  String get editorSequencesComma => 'Secuencias (separadas por coma)';

  @override
  String get editorInterrogatedMmsi => 'MMSI interrogado';

  @override
  String get editorType1 => 'Tipo 1';

  @override
  String get editorOffset1 => 'Offset 1';

  @override
  String get editorTargetMmsi => 'MMSI de destino';

  @override
  String get editorOffset => 'Offset';

  @override
  String get editorIncrement => 'Incremento';

  @override
  String get editorNumber => 'Número';

  @override
  String get editorTimeout => 'Timeout';

  @override
  String get editorAidType0_31 => 'Tipo de ayuda (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Ayuda virtual (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Modo Tx/Rx (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Modo Tx/Rx (0-3)';

  @override
  String get editorNeLat => 'Latitud NE';

  @override
  String get editorNeLon => 'Longitud NE';

  @override
  String get editorSwLat => 'Latitud SO';

  @override
  String get editorSwLon => 'Longitud SO';

  @override
  String get editorInterval0_15 => 'Intervalo (0-15)';

  @override
  String get editorPart => 'Parte (0 = nombre A, 1 = estáticos B)';

  @override
  String get editorDestMmsiEmpty => 'MMSI de destino (vacío = difusión)';

  @override
  String get editorAppDacEmpty => 'DAC de app (vacío = ninguno)';

  @override
  String get editorAppFidEmpty => 'FID de app (vacío = ninguno)';

  @override
  String get nmeaTalker => 'Hablante';

  @override
  String get nmeaFragments => 'Fragmentos';

  @override
  String get nmeaFragmentN => 'Fragmento nº';

  @override
  String get nmeaMessageId => 'ID de mensaje';

  @override
  String get nmeaChannel => 'Canal';

  @override
  String get nmeaPayload => 'Carga útil';

  @override
  String get nmeaFillBits => 'Bits de relleno';

  @override
  String get nmeaTagBlock => 'Bloque de etiqueta';

  @override
  String get nmeaChecksum => 'Suma de comprobación';

  @override
  String get nmeaEmpty => '(vacío)';

  @override
  String get bubbleKindVessel => 'Embarcación';

  @override
  String get bubbleKindAircraft => 'Aeronave SAR';

  @override
  String get bubbleKindAton => 'Ayuda a la navegación';

  @override
  String get bubbleKindStation => 'Estación base';

  @override
  String get bubbleGeneralInfo => 'Información general';

  @override
  String get bubbleKind => 'Tipo';

  @override
  String get bubbleAidType => 'Tipo de ayuda';

  @override
  String get bubbleVirtual => 'Virtual';

  @override
  String get bubbleAltitude => 'Altitud';

  @override
  String get bubbleCallSign => 'Indicativo de llamada';

  @override
  String get bubblePosNav => 'Posición y navegación';

  @override
  String get bubbleHeading => 'Rumbo';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Detalles de la embarcación';

  @override
  String get bubbleType => 'Tipo';

  @override
  String get bubbleTypeInt => 'Tipo (Int)';

  @override
  String get bubbleDimsBowStern => 'Dimensiones proa/popa';

  @override
  String get bubbleDimsPortStarboard => 'Dimensiones babor/estribor';

  @override
  String get bubbleSpare => 'Reserva';

  @override
  String get bubbleDraught => 'Calado';

  @override
  String bubbleFrames(Object n) {
    return 'Tramas ($n)';
  }

  @override
  String get bubbleNoFrames => 'Aún no hay tramas';

  @override
  String get copied => 'Copiado';

  @override
  String get textFiles => 'Archivos de texto';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Destino $name conectado ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'No se pudo conectar el destino $name: $error';
  }

  @override
  String get logStopping => 'Deteniendo reenviador...';

  @override
  String get logStopped => 'Reenviador detenido.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Fuente añadida: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Fuente eliminada: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Fuente $name conectada.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Fuente $name desconectada. Reconectando en 5 s...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'No se pudo conectar la fuente $name: $error. Reintentando en 5 s...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Destino $name: servidor TCP escuchando en el puerto $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Destino $name: cliente conectado $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Destino $name: cliente desconectado';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Destino $name: error de cliente $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Error de envío al destino $name: $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'Abriendo dongle RTL-SDR $device...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device conectado ($freq, frecuencia de muestreo $rate, ganancia $gain, canales $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device: error $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'Flujo RTL-SDR $device cerrado.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device desconectado.';
  }

  @override
  String get docNavStatus0 => 'En marcha con motor';

  @override
  String get docNavStatus1 => 'Fondeado';

  @override
  String get docNavStatus2 => 'Sin gobierno';

  @override
  String get docNavStatus3 => 'Capacidad de maniobra restringida';

  @override
  String get docNavStatus4 => 'Restringido por su calado';

  @override
  String get docNavStatus5 => 'Amarrado';

  @override
  String get docNavStatus6 => 'Varado';

  @override
  String get docNavStatus7 => 'En faena de pesca';

  @override
  String get docNavStatus8 => 'En marcha a vela';

  @override
  String get docNavStatus9 => 'Reservado (HSC)';

  @override
  String get docNavStatus10 => 'Reservado (WIG)';

  @override
  String get docNavStatus11 => 'Remolcando a popa (regional)';

  @override
  String get docNavStatus12 => 'Empujando / remolcando en paralelo (regional)';

  @override
  String get docNavStatus13 => 'Reservado para uso futuro';

  @override
  String get docNavStatus14 => 'AIS-SART activo';

  @override
  String get docNavStatus15 => 'Indefinido (predeterminado)';

  @override
  String get docEpfd0 => 'Indefinido (predeterminado)';

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
  String get docEpfd6 => 'Sistema de navegación integrado';

  @override
  String get docEpfd7 => 'Levantado (fijo)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'GNSS interno';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · bits $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields campos · $bits bits en total · toca un segmento';
  }

  @override
  String get docTextToEncode => 'Texto a codificar';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Cada carácter es un valor de 6 bits (\"@\" = 0, espacio = 32, \"A\" = 1…). Las letras minúsculas no se pueden codificar y normalmente se envían en mayúsculas.';

  @override
  String get docChecksumBody => 'Cuerpo (sin el ! inicial ni el *XX final)';

  @override
  String get docChecksumExplanation =>
      'La suma de comprobación NMEA es el XOR de cada byte entre el \"!\" y el \"*\".';

  @override
  String get docLatitude => 'Latitud';

  @override
  String get docLongitude => 'Longitud';

  @override
  String get docLatitudeInvalid => 'Latitud: introduce un número';

  @override
  String get docLongitudeInvalid => 'Longitud: introduce un número';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Latitud → $value (entero de 27 bits con signo, grados = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Longitud → $value (entero de 28 bits con signo, grados = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Las coordenadas se almacenan en 1/10 000 de minuto: divide entre 600 000 para recuperar los grados.';

  @override
  String get docSearchShipTypes => 'Buscar tipos de buque';

  @override
  String get docShipCat0_19 => '0-19 · Reservado';

  @override
  String get docShipCat20_29 => '20-29 · Efecto suelo (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Pesca';

  @override
  String get docShipCat40_49 => '40-49 · Embarcación de alta velocidad';

  @override
  String get docShipCat50_59 => '50-59 · Embarcación especial';

  @override
  String get docShipCat60_69 => '60-69 · Pasaje';

  @override
  String get docShipCat70_79 => '70-79 · Carga';

  @override
  String get docShipCat80_89 => '80-89 · Petrolero';

  @override
  String get docShipCat90_99 => '90-99 · Otros';

  @override
  String get docSearchGlossary => 'Buscar en el glosario';

  @override
  String get docNoMatchingTerms => 'No hay términos que coincidan.';

  @override
  String get docAspect => 'Aspecto';

  @override
  String get docClassA => 'Clase A';

  @override
  String get docClassB => 'Clase B';

  @override
  String get docCheatRadio => 'Radio';

  @override
  String get docCheatFrequencies => 'Frecuencias';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulación';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bits/s';

  @override
  String get docCheatRange => 'Alcance';

  @override
  String get docCheatRangeValue =>
      '~10-20 NM de buque a buque, línea de visión';

  @override
  String get docCheatReportingRates => 'Ritmos de informe';

  @override
  String get docCheatClassAPos1 => 'Posición Clase A (1)';

  @override
  String get docCheatClassAPos1Value => 'Cada 2-10 s en marcha, 3 min fondeado';

  @override
  String get docCheatStatic5 => 'Estáticos (5)';

  @override
  String get docCheatStatic5Value => 'Cada 6 min';

  @override
  String get docCheatClassBPos18 => 'Posición Clase B (18)';

  @override
  String get docCheatClassBPos18Value => '~Cada 30 s';

  @override
  String get docCheatAtoN21 => 'Ayuda a la navegación (21)';

  @override
  String get docCheatAtoN21Value => 'Cada 3 min';

  @override
  String get docCheatNavStatus0_15 => 'Estado de navegación (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'En marcha con motor';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'Fondeado';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Capacidad de maniobra restringida';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Amarrado';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'Varado';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Pesca';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'En marcha a vela';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART activo';

  @override
  String get docCheatMmsiFormats => 'Formatos de MMSI';

  @override
  String get docCheatFixTypes => 'Tipos de fijación (EPFD)';

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
      'KikAis incluye una referencia interactiva completa en cada pestaña: el Editor puede crear cualquier mensaje, el Decodificador los lee de vuelta.';

  @override
  String get docMmsiFmtDiversRadio => 'Radio de buceador';

  @override
  String get docMmsiFmtShip => 'Buque';

  @override
  String get docMmsiFmtGroupShips =>
      'Grupo de buques (p. ej. una flota o la USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Estación costera / de tierra';

  @override
  String get docMmsiFmtSarAircraft => 'Aeronave SAR';

  @override
  String get docMmsiFmtAuxCraft =>
      'Embarcación auxiliar asociada a un buque nodriza';

  @override
  String get docMmsiFmtAtoN => 'Ayuda a la navegación';

  @override
  String get docMmsiFmtSart => 'AIS-SART (transmisor de búsqueda y rescate)';

  @override
  String get docMmsiFmtMob => 'Dispositivo MOB (hombre al agua)';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB (baliza de emergencia)';

  @override
  String get docVesselCat0_9 => 'Reservado / uso futuro';

  @override
  String get docVesselCat10_19 => 'Reservado para uso futuro';

  @override
  String get docVesselCat20_29 => 'Embarcación de efecto suelo (WIG)';

  @override
  String get docVesselCat30_39 => 'Pesca';

  @override
  String get docVesselCat40_49 => 'Embarcación de alta velocidad';

  @override
  String get docVesselCat50_59 =>
      'Embarcación especial (prácticos, remolcadores, dragas…)';

  @override
  String get docVesselCat60_69 => 'Buques de pasaje';

  @override
  String get docVesselCat70_79 => 'Buques de carga';

  @override
  String get docVesselCat80_89 => 'Petroleros';

  @override
  String get docVesselCat90_99 => 'Otros tipos';

  @override
  String get docTalkerAB => 'Estación AIS base';

  @override
  String get docTalkerAD => 'Estación base AIS dependiente';

  @override
  String get docTalkerAI => 'Estación AIS móvil';

  @override
  String get docTalkerAN => 'Estación AIS de ayuda a la navegación';

  @override
  String get docTalkerAR => 'Estación AIS receptora';

  @override
  String get docTalkerAS => 'Estación base limitada';

  @override
  String get docTalkerAT => 'Estación AIS transmisora';

  @override
  String get docTalkerAX => 'Estación AIS repetidora';

  @override
  String get docTalkerBS => 'Estación AIS base (obsoleta)';

  @override
  String get docTalkerSA => 'Estación AIS costera física';

  @override
  String get docType1Name => 'Informe de posición Clase A';

  @override
  String get docType1Family => 'Informes de posición';

  @override
  String get docType1Summary =>
      'El caballo de batalla del sistema: un transpondedor de Clase A que difunde su posición, rumbo, velocidad, proa y estado de navegación.';

  @override
  String get docType1EmittedBy => 'Transpondedores de Clase A (buques SOLAS)';

  @override
  String get docType1Cadence => 'Cada 2-10 s en marcha, cada 3 min fondeado';

  @override
  String get docType2Name => 'Informe de posición Clase A (asignado)';

  @override
  String get docType2Family => 'Informes de posición';

  @override
  String get docType2Summary =>
      'Idéntico al tipo 1, pero enviado en un calendario de ranuras asignado al buque por una estación base (modo de asignación).';

  @override
  String get docType2EmittedBy => 'Transpondedores de Clase A bajo asignación';

  @override
  String get docType2Cadence => 'Calendario asignado';

  @override
  String get docType3Name => 'Informe de posición Clase A (respuesta)';

  @override
  String get docType3Family => 'Informes de posición';

  @override
  String get docType3Summary =>
      'Idéntico al tipo 1, enviado como respuesta a una interrogación (tipo 15).';

  @override
  String get docType3EmittedBy =>
      'Transpondedores de Clase A que responden a una interrogación';

  @override
  String get docType3Cadence => 'Al ser interrogado';

  @override
  String get docType4Name => 'Informe de estación base';

  @override
  String get docType4Family => 'Estación base y red';

  @override
  String get docType4Summary =>
      'El informe periódico de una estación costera fija: su posición más la referencia de fecha y hora UTC.';

  @override
  String get docType4EmittedBy => 'Estaciones base fijas';

  @override
  String get docType4Cadence => 'Cada 10 s';

  @override
  String get docType5Name => 'Datos estáticos y de viaje';

  @override
  String get docType5Family => 'Datos estáticos y de viaje';

  @override
  String get docType5Summary =>
      'El \"carné de identidad\" de un buque: nombre, indicativo de llamada, número IMO, tipo de buque, dimensiones, calado, ETA y destino.';

  @override
  String get docType5EmittedBy => 'Transpondedores de Clase A';

  @override
  String get docType5Cadence => 'Cada 6 min y ante cambios de datos';

  @override
  String get docType6Name => 'Mensaje binario dirigido';

  @override
  String get docType6Family => 'Datos binarios';

  @override
  String get docType6Summary =>
      'Una carga útil binaria estructurada enviada a un MMSI de destino concreto (p. ej. un informe meteorológico solicitado).';

  @override
  String get docType6EmittedBy => 'Cualquier estación';

  @override
  String get docType6Cadence => 'Bajo demanda';

  @override
  String get docType7Name => 'Acuse de recibo binario';

  @override
  String get docType7Family => 'Datos binarios';

  @override
  String get docType7Summary =>
      'El acuse de recibo enviado en respuesta a un mensaje binario dirigido de tipo 6.';

  @override
  String get docType7EmittedBy =>
      'Cualquier estación que haya recibido un tipo 6';

  @override
  String get docType7Cadence => 'Al responder';

  @override
  String get docType8Name => 'Mensaje binario de difusión';

  @override
  String get docType8Family => 'Datos binarios';

  @override
  String get docType8Summary =>
      'Una carga útil binaria estructurada difundida a todos: informes meteorológicos e hidrográficos, datos regionales o mensajes privados/cifrados.';

  @override
  String get docType8EmittedBy => 'Cualquier estación';

  @override
  String get docType8Cadence => 'Bajo demanda';

  @override
  String get docType9Name => 'Informe de posición estándar de aeronave SAR';

  @override
  String get docType9Family => 'Informes de posición';

  @override
  String get docType9Summary =>
      'Un informe de posición usado por las aeronaves de búsqueda y rescate para ser visibles para los buques. Incluye altitud y un rango de MMSI especial (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'Aeronaves SAR';

  @override
  String get docType9Cadence => 'Cada 10 s en posición';

  @override
  String get docType10Name => 'Solicitud de UTC y fecha';

  @override
  String get docType10Family => 'Estación base y red';

  @override
  String get docType10Summary =>
      'Una pequeña petición que pide a una estación concreta su fecha y hora UTC.';

  @override
  String get docType10EmittedBy => 'Cualquier estación';

  @override
  String get docType10Cadence => 'Bajo demanda';

  @override
  String get docType11Name => 'Respuesta de UTC y fecha';

  @override
  String get docType11Family => 'Estación base y red';

  @override
  String get docType11Summary =>
      'Idéntico en estructura al tipo 4, enviado como respuesta a una solicitud de UTC/fecha de tipo 10.';

  @override
  String get docType11EmittedBy => 'Estaciones base';

  @override
  String get docType11Cadence => 'Al ser consultada';

  @override
  String get docType12Name => 'Mensaje de seguridad dirigido';

  @override
  String get docType12Family => 'Seguridad y texto';

  @override
  String get docType12Summary =>
      'Un mensaje de seguridad de texto libre enviado a un único MMSI de destino (p. ej. un mensaje de socorro a la estación base más cercana).';

  @override
  String get docType12EmittedBy => 'Cualquier estación';

  @override
  String get docType12Cadence => 'Bajo demanda';

  @override
  String get docType13Name => 'Acuse de recibo de seguridad';

  @override
  String get docType13Family => 'Seguridad y texto';

  @override
  String get docType13Summary =>
      'El acuse de recibo enviado en respuesta a un mensaje de seguridad dirigido de tipo 12.';

  @override
  String get docType13EmittedBy =>
      'Cualquier estación que haya recibido un tipo 12';

  @override
  String get docType13Cadence => 'Al responder';

  @override
  String get docType14Name => 'Mensaje de seguridad de difusión';

  @override
  String get docType14Family => 'Seguridad y texto';

  @override
  String get docType14Summary =>
      'Una difusión de texto libre dirigida a todos los que estén dentro del alcance: avisos de navegación, socorros o anuncios de tráfico.';

  @override
  String get docType14EmittedBy =>
      'Cualquier estación (a menudo estaciones base / VTS)';

  @override
  String get docType14Cadence => 'Bajo demanda';

  @override
  String get docType15Name => 'Interrogación';

  @override
  String get docType15Family => 'Estación base y red';

  @override
  String get docType15Summary =>
      'Una petición que pide a una o dos estaciones concretas que envíen un tipo de mensaje determinado (normalmente el 3 o el 5).';

  @override
  String get docType15EmittedBy => 'Estaciones base';

  @override
  String get docType15Cadence => 'Bajo demanda';

  @override
  String get docType16Name => 'Comando de modo de asignación';

  @override
  String get docType16Family => 'Estación base y red';

  @override
  String get docType16Summary =>
      'Instruye a hasta dos embarcaciones para que transmitan en una asignación de ranuras concreta (modo de asignación).';

  @override
  String get docType16EmittedBy => 'Estaciones base';

  @override
  String get docType16Cadence => 'Bajo demanda';

  @override
  String get docType17Name => 'Mensaje binario de difusión DGNSS';

  @override
  String get docType17Family => 'Datos binarios';

  @override
  String get docType17Summary =>
      'Datos de corrección GNSS diferencial difundidos por estaciones costeras para mejorar la precisión de posicionamiento en el área cubierta.';

  @override
  String get docType17EmittedBy => 'Estaciones de referencia DGNSS';

  @override
  String get docType17Cadence => 'Periódico';

  @override
  String get docType18Name => 'Informe de posición CS Clase B estándar';

  @override
  String get docType18Family => 'Informes de posición';

  @override
  String get docType18Summary =>
      'El informe de posición Clase B estándar. Más ligero que el de Clase A: sin estado de navegación ni velocidad de giro, pero funciona con CSTDMA.';

  @override
  String get docType18EmittedBy => 'Transpondedores de Clase B';

  @override
  String get docType18Cadence => 'Cada 30 s (o menos en algunas regiones)';

  @override
  String get docType19Name => 'Informe de posición de equipo Clase B ampliado';

  @override
  String get docType19Family => 'Informes de posición';

  @override
  String get docType19Summary =>
      'Un informe de posición Clase B más grande que también incluye el nombre de la embarcación, el tipo de buque y las dimensiones: un híbrido de estáticos + posición en un solo envío.';

  @override
  String get docType19EmittedBy => 'Transpondedores de Clase B ampliados';

  @override
  String get docType19Cadence => 'Cada 30 s';

  @override
  String get docType20Name => 'Gestión del enlace de datos';

  @override
  String get docType20Family => 'Estación base y red';

  @override
  String get docType20Summary =>
      'Un mensaje de mantenimiento de red usado para asignar y reservar ranuras de tiempo TDMA en un área.';

  @override
  String get docType20EmittedBy => 'Estaciones base';

  @override
  String get docType20Cadence => 'Gestión de red';

  @override
  String get docType21Name => 'Informe de ayuda a la navegación';

  @override
  String get docType21Family => 'Ayuda a la navegación';

  @override
  String get docType21Summary =>
      'Difunde la posición, el nombre y el estado de una ayuda a la navegación: boyas, balizas, faros o ayudas virtuales. A menudo se envía desde una posición virtual.';

  @override
  String get docType21EmittedBy => 'Estaciones AtoN (reales o virtuales)';

  @override
  String get docType21Cadence => 'Cada 3 min (o ante un evento)';

  @override
  String get docType22Name => 'Gestión de canales';

  @override
  String get docType22Family => 'Estación base y red';

  @override
  String get docType22Summary =>
      'Usado por una estación base para cambiar las estaciones a diferentes canales VHF dentro de una zona geográfica.';

  @override
  String get docType22EmittedBy => 'Estaciones base';

  @override
  String get docType22Cadence => 'Bajo demanda';

  @override
  String get docType23Name => 'Comando de asignación de grupo';

  @override
  String get docType23Family => 'Estación base y red';

  @override
  String get docType23Summary =>
      'Un comando enviado por una estación base a un grupo de embarcaciones dentro de una zona, que fija los intervalos de informe y el modo de transmisión.';

  @override
  String get docType23EmittedBy => 'Estaciones base';

  @override
  String get docType23Cadence => 'Bajo demanda';

  @override
  String get docType24Name => 'Informe de datos estáticos';

  @override
  String get docType24Family => 'Datos estáticos y de viaje';

  @override
  String get docType24Summary =>
      'El equivalente Clase B del tipo 5, dividido en Parte A (nombre) y Parte B (tipo de buque, indicativo de llamada, dimensiones).';

  @override
  String get docType24EmittedBy => 'Transpondedores de Clase B';

  @override
  String get docType24Cadence => 'Cada 6 min';

  @override
  String get docType25Name => 'Mensaje binario de ranura única';

  @override
  String get docType25Family => 'Datos binarios';

  @override
  String get docType25Summary =>
      'Un mensaje binario corto que cabe en una única ranura TDMA, con un destino y un ID de aplicación opcionales.';

  @override
  String get docType25EmittedBy => 'Cualquier estación';

  @override
  String get docType25Cadence => 'Bajo demanda';

  @override
  String get docType26Name => 'Mensaje binario de ranuras múltiples';

  @override
  String get docType26Family => 'Datos binarios';

  @override
  String get docType26Summary =>
      'Un mensaje binario más largo repartido en varias ranuras TDMA, que transporta información sobre el estado de radio.';

  @override
  String get docType26EmittedBy => 'Cualquier estación';

  @override
  String get docType26Cadence => 'Bajo demanda';

  @override
  String get docType27Name =>
      'Informe de posición para aplicaciones de largo alcance';

  @override
  String get docType27Family => 'Informes de posición';

  @override
  String get docType27Summary =>
      'Un informe de posición muy compacto diseñado para ser recibido por satélite a largas distancias, con resolución reducida.';

  @override
  String get docType27EmittedBy =>
      'Embarcaciones en modo de largo alcance (satélite)';

  @override
  String get docType27Cadence => 'Cada 3 min (modo de largo alcance)';

  @override
  String get docTimeline1990sTitle => 'Un invento sueco';

  @override
  String get docTimeline1990sText =>
      'El concepto nace en Suecia: un sistema VHF en el que cada buque se anuncia para que los demás \"vean y sean vistos\", incluso en la niebla y detrás de las islas. Se presenta a la OMI y se convierte en la semilla del AIS.';

  @override
  String get docTimeline1998Title => 'Comienza la normalización';

  @override
  String get docTimeline1998Text =>
      'La UIT y la CEI empiezan a convertir el concepto en un estándar de radio con formatos precisos a nivel de bit, basado en TDMA sobre dos canales VHF.';

  @override
  String get docTimeline2001Title => 'Se publica la UIT-R M.1371';

  @override
  String get docTimeline2001Text =>
      'La Recomendación UIT-R M.1371 \"Características técnicas de un sistema universal de identificación automática de buques\" define los 27 tipos de mensaje y su estructura de bits.';

  @override
  String get docTimeline2002Title => 'Mandato SOLAS';

  @override
  String get docTimeline2002Text =>
      'La OMI hace obligatorio el AIS para todos los buques internacionales de más de 300 toneladas brutas y para todos los buques de pasaje: unos 100 000 buques. El AIS se convierte en una ayuda anticolisión estándar junto al radar.';

  @override
  String get docTimeline2006Title => 'Llega la Clase B';

  @override
  String get docTimeline2006Text =>
      'Se publica el estándar de Clase B, abriendo la puerta a transpondedores baratos y más simples. Ese mismo año, el satélite TacSat-2 se convierte en el primero en captar señales AIS desde el espacio (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Constelaciones de satélites';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire y otros despliegan receptores AIS en órbita terrestre baja, extendiendo la cobertura mucho más allá del horizonte VHF y permitiendo un seguimiento casi global de los buques.';

  @override
  String get docTimeline2010Title => 'AIS-SART en el GMDSS';

  @override
  String get docTimeline2010Text =>
      'El transmisor de búsqueda y rescate AIS (AIS-SART, CEI 61097-14) se incorpora al Sistema mundial de socorro y seguridad marítimos, permitiendo que los botes salvavidas difundan posiciones de socorro por AIS.';

  @override
  String get docTimeline2014Title =>
      'Flotas pesqueras y vías navegables interiores';

  @override
  String get docTimeline2014Text =>
      'Las normas europeas exigen AIS de Clase A en todos los buques pesqueros de la UE de más de 15 m; el AIS de vías navegables interiores está ampliamente desplegado en los ríos europeos.';

  @override
  String get docTimeline2021Title => '1.6 millones de buques';

  @override
  String get docTimeline2021Text =>
      'Más de 1.6 millones de embarcaciones llevan AIS instalado, alimentando redes terrestres y satelitales que impulsan el seguimiento de buques, el control pesquero y la seguridad marítima en todo el mundo.';

  @override
  String get docTimelineVdesTitle => 'VDES, el sucesor';

  @override
  String get docTimelineVdesText =>
      'El Sistema de Intercambio de Datos VHF (UIT-R M.2092) se está implantando para aliviar las zonas congestionadas, añadiendo mucho más ancho de banda y servicios de e-navegación seguros.';

  @override
  String get docAppTitle => 'Documentación';

  @override
  String get docSearchChapters => 'Buscar capítulos';

  @override
  String get docChapterOverview => 'Visión general';

  @override
  String get docChapterHistory => 'Historia y normativa';

  @override
  String get docChapterHowItWorks => 'Cómo funciona';

  @override
  String get docChapterRadio => 'Radio y TDMA';

  @override
  String get docChapterClasses => 'Clases y equipos';

  @override
  String get docChapterMmsi => 'MMSI e identidad';

  @override
  String get docChapterShipTypes => 'Tipos de buque';

  @override
  String get docChapterMessages => 'Los 27 mensajes';

  @override
  String get docChapterNmea => 'NMEA y AIVDM';

  @override
  String get docChapterPayload => 'Dentro de la carga útil';

  @override
  String get docChapterSecurity => 'Seguridad y límites';

  @override
  String get docChapterFieldNotes => 'Notas de campo';

  @override
  String get docChapterKikais => 'AIS en KikAis';

  @override
  String get docChapterGlossary => 'Glosario';

  @override
  String get docChapterCheatSheet => 'Hoja de referencia';

  @override
  String get docChapterSources => 'Fuentes';

  @override
  String get docOverviewTitle => '¿Qué es el AIS?';

  @override
  String get docOverviewIntro =>
      'El Sistema de Identificación Automática (AIS) es un sistema de seguimiento usado en los buques y por los servicios de tráfico marítimo (VTS). Cada embarcación equipada difunde continuamente su identidad, posición, rumbo y velocidad por radio VHF, de modo que todos los demás buques y estaciones costeras dentro del alcance puedan \"verla\": el concepto de \"ver y ser visto\".';

  @override
  String get docOverviewRadar =>
      'El AIS no sustituye al radar marino. El radar detecta de forma independiente cualquier objeto, pero dice poco sobre qué es. El AIS te dice exactamente quién es, dónde está y hacia dónde se dirige, pero confía en lo que declara el emisor. Los dos sistemas se complementan.';

  @override
  String get docOverviewAdsBTitle => 'Piénsalo como el ADS-B marítimo';

  @override
  String get docOverviewAdsBText =>
      'Igual que el ADS-B permite que las aeronaves se anuncien al control de tráfico aéreo, el AIS permite que los buques se anuncien entre sí y hacia tierra. Los buques ven el tráfico circundante en una carta electrónica o en una pantalla tipo radar; las autoridades portuarias controlan los movimientos y la pesca.';

  @override
  String get docOverviewTransponder => 'Lo que difunde un transpondedor';

  @override
  String get docOverviewBullet1 =>
      'Identidad única: un número MMSI de 9 dígitos (cuyos tres primeros dígitos identifican el país emisor).';

  @override
  String get docOverviewBullet2 =>
      'Datos dinámicos: posición, velocidad sobre el fondo (SOG), rumbo sobre el fondo (COG), proa verdadera, velocidad de giro, estado de navegación.';

  @override
  String get docOverviewBullet3 =>
      'Datos estáticos y de viaje: nombre, indicativo de llamada, número IMO, tipo de buque, dimensiones, calado, destino, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Mensajes de seguridad y binarios: textos de socorro, informes meteorológicos, comandos de red.';

  @override
  String get docOverviewWho => 'Quién debe llevarlo';

  @override
  String get docOverviewImo =>
      'La OMI (convenio SOLAS) exige el AIS en los buques internacionales de más de 300 toneladas brutas y en todos los buques de pasaje. Las normas regionales lo amplían a flotas pesqueras, vías navegables interiores y, cada vez más, a embarcaciones de recreo mediante transpondedores de Clase B de bajo coste.';

  @override
  String get docOverviewLimits => 'Límites de un vistazo';

  @override
  String get docOverviewLimit1 =>
      'El alcance es más o menos la línea de visión: unos 10-20 millas náuticas de buque a buque, más desde estaciones costeras y satélites.';

  @override
  String get docOverviewLimit2 =>
      'El AIS no tiene autenticación: cualquiera puede difundir cualquier identidad (suplantación) o interferir el canal.';

  @override
  String get docOverviewLimit3 =>
      'La precisión depende de la fijación GNSS del emisor y de la veracidad de los datos que declara.';

  @override
  String get docHistoryIntro =>
      'El AIS creció desde una idea sueca hasta convertirse en un sistema de seguridad obligatorio en todo el mundo. Toca cualquier hito de la cronología para ver los detalles.';

  @override
  String get docHistoryStandards => 'Los estándares que lo rigen';

  @override
  String get docHistoryStd1 =>
      'UIT-R M.1371 — Características técnicas de un sistema AIS universal de a bordo (define los 27 tipos de mensaje y su estructura de bits).';

  @override
  String get docHistoryStd2 =>
      'Directrices IALA: aclaraciones y orientación para la implementación.';

  @override
  String get docHistoryStd3 =>
      'CEI 61162 / 62287 — el formato de las oraciones NMEA y los requisitos de Clase B/CSTDMA.';

  @override
  String get docHistoryStd4 =>
      'CEI 61097-14 — el transmisor de socorro AIS-SART.';

  @override
  String get docHowIntro =>
      'El AIS es un sistema de radio VHF. Cada transpondedor escucha el tráfico que lo rodea y transmite sus propios informes en ranuras de tiempo reservadas, evitando colisiones con los demás buques dentro del alcance.';

  @override
  String get docHowRadioLink => 'El enlace de radio';

  @override
  String get docHowRadioLink1 =>
      'Dos canales VHF dedicados: AIS 1 en 161.975 MHz (87B) y AIS 2 en 162.025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'FM digital de banda estrecha, a 9 600 bits por segundo.';

  @override
  String get docHowRadioLink3 =>
      'Los mensajes se organizan en tramas TDMA de 2250 ranuras de tiempo (1 minuto).';

  @override
  String get docHowSlots => 'Cómo se comparten las ranuras';

  @override
  String get docHowSotdma =>
      'Los transpondedores de Clase A usan SOTDMA (Acceso múltiple por división de tiempo autoorganizado): cada unidad reserva una ranura recurrente y la vuelve a reservar cuando cambia el panorama, de modo que los buques se coordinan continuamente sin un controlador central.';

  @override
  String get docHowCstdma =>
      'Los transpondedores de Clase B usan el CSTDMA, más simple (TDMA con detección de portadora): escuchan una ranura libre y la ocupan, por eso los informes de Clase B son menos frecuentes y pueden perderse en tráfico muy denso.';

  @override
  String get docHowRates => 'Ritmos de informe';

  @override
  String get docHowRates1 =>
      'Informe de posición Clase A (tipo 1): cada 2-10 segundos en marcha, cada 3 minutos fondeado.';

  @override
  String get docHowRates2 =>
      'Datos estáticos y de viaje (tipo 5): cada 6 minutos.';

  @override
  String get docHowRates3 =>
      'Posición Clase B (tipo 18): aproximadamente cada 30 segundos.';

  @override
  String get docHowRates4 => 'Ayuda a la navegación (tipo 21): cada 3 minutos.';

  @override
  String get docHowTerrestrial => 'Terrestre y satelital';

  @override
  String get docHowTerrestrialText =>
      'En la superficie, el alcance del AIS está limitado por el horizonte VHF (AIS-T). Desde mediados de los 2000, los satélites en órbita terrestre baja (AIS-S) reciben las mismas señales, lo que da una cobertura casi global: los satélites complementan, en lugar de sustituir, la red terrestre.';

  @override
  String get docRadioIntro =>
      'Bajo los mensajes se esconde un sistema de radio pequeño y eficiente. El AIS transmite a 9 600 bits por segundo en dos canales VHF, usando modulación por desplazamiento mínimo gaussiano (GMSK) y entramado tipo HDLC.';

  @override
  String get docRadioPhysical => 'El enlace físico';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 en 161.975 MHz y AIS 2 en 162.025 MHz (canales VHF 87B y 88B).';

  @override
  String get docRadioPhysical2 =>
      'Modulación GMSK a 9 600 baudios, lo bastante estrecha para caber en la banda VHF marítima.';

  @override
  String get docRadioPhysical3 =>
      'Entramado HDLC con relleno de bits y codificación de línea NRZI, heredado del mundo de la radio por paquetes.';

  @override
  String get docRadioFrames => 'Tramas y ranuras TDMA';

  @override
  String get docRadioFrames1 =>
      'Cada canal se divide en tramas de exactamente 1 minuto, divididas en 2 250 ranuras de tiempo de ~26.7 ms cada una.';

  @override
  String get docRadioFrames2 =>
      'Una ranura transporta un mensaje AIS (256 bits con rampas de subida/bajada y tiempo de guarda).';

  @override
  String get docRadioFrames3 =>
      'Las estaciones reutilizan las mismas ranuras en cada trama para emitir periódicamente sin colisionar.';

  @override
  String get docRadioCode =>
      '2250 ranuras/trama · 1 trama = 60 s · ranura ≈ 26.7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA: cómo se autoorganiza la Clase A';

  @override
  String get docRadioSotdmaText =>
      'Cada transpondedor de Clase A escucha las ranuras que lo rodean, elige una libre y anuncia en su campo de estado de radio cuándo transmitirá a continuación. Las estaciones van reservando de nuevo a medida que cambia el panorama de tráfico, así que no se necesita un coordinador central.';

  @override
  String get docRadioCstdma => 'CSTDMA: cómo se incorpora la Clase B';

  @override
  String get docRadioCstdmaText =>
      'Las unidades de Clase B son más simples: escuchan una ranura que esté libre en ese momento y transmiten una vez en ella. Es más barato, pero los informes de Clase B pueden perderse en tráfico muy denso donde una ranura siempre está ocupada.';

  @override
  String get docRadioVdes => 'VDES: el futuro';

  @override
  String get docRadioVdesText =>
      'El Sistema de Intercambio de Datos VHF (UIT-R M.2092) se está implantando para aliviar las aguas congestionadas: añade nuevas frecuencias, mucho más ancho de banda y datos bidireccionales seguros para la e-navegación, junto al servicio AIS existente.';

  @override
  String get docClassesIntro =>
      'El hardware AIS se presenta en distintas clases y funciones. Los dos que verás con más frecuencia son el transpondedor completo de Clase A y la unidad barata de Clase B.';

  @override
  String get docClassesComparison => 'Clase A frente a Clase B';

  @override
  String get docClassesReceivers => 'Receptores y transpondedores';

  @override
  String get docClassesReceiversText =>
      'Los transpondedores reciben y transmiten a la vez. Muchas estaciones costeras y aficionados usan solo receptores, para poder observar el tráfico sin aparecer en él.';

  @override
  String get docClassesAton => 'Ayudas a la navegación';

  @override
  String get docClassesAtonText =>
      'Las estaciones AtoN (tipo 21) difunden boyas, balizas y faros. También pueden transmitir una ayuda virtual: una marca que solo existe en las cartas, útil para avisar de un nuevo peligro.';

  @override
  String get docClassesDistress => 'Dispositivos de socorro y seguridad';

  @override
  String get docClassesDistressIntro =>
      'Además de los buques normales, el AIS transporta transmisores de socorro que todo receptor debería poder detectar:';

  @override
  String get docClassesSartNote =>
      'Un SART en acción también fija el estado de navegación 14 (\"AIS-SART activo\") en su informe de posición.';

  @override
  String get docShipTypesIntro =>
      'Los mensajes estáticos de los tipos 5 y 24 llevan un código de tipo de buque de 8 bits (0-99) que describe qué es la embarcación: carga, petrolero, pesquero, embarcación de recreo, etc. La tabla completa se muestra a continuación.';

  @override
  String get docShipTypesCategories => 'Categorías de un vistazo';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle => 'Notas de campo y peculiaridades reales';

  @override
  String get docFieldNotesIntro =>
      'El tráfico AIS real no siempre coincide con la teoría. Conocer estas peculiaridades te ayuda a confiar en lo que te muestra el decodificador... y en lo que rechaza.';

  @override
  String get docGlossaryIntro =>
      'Un diccionario consultable de los acrónimos y términos usados a lo largo de esta guía y por la comunidad AIS.';

  @override
  String get docCheatSheetIntro =>
      'Los números y códigos esenciales de un vistazo: frecuencias, ritmos de informe, códigos de estado y formatos.';

  @override
  String get docMmsiIntro =>
      'La Identidad del Servicio Móvil Marítimo (MMSI) es un número único de 9 dígitos que identifica el equipo de radio de un buque, como un número de teléfono para la embarcación. Sus tres primeros dígitos son el MID: los Dígitos de Identificación Marítima que identifican el país que lo emitió.';

  @override
  String get docMmsiFormats => 'Formatos de número';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Consultar un MMSI';

  @override
  String get docMmsiLookupHint =>
      'Introduce un MMSI de 9 dígitos a continuación para ver su clase y el país de la autoridad emisora.';

  @override
  String get docMmsiMidHeading => 'Códigos de país (MID)';

  @override
  String get docMmsiMidText =>
      'La tabla MID completa viene integrada en KikAis y se usa en cualquier lugar donde se muestre un MMSI.';

  @override
  String get docMessagesTitle => 'Los 27 tipos de mensaje';

  @override
  String get docMessagesIntro =>
      'Toda carga útil AIS empieza con un tipo de mensaje de 6 bits (del 1 al 27). El catálogo siguiente los agrupa por familia. Cada tarjeta muestra una oración NMEA real generada por el codificador de KikAis, sus campos decodificados y un botón para abrirla en el Decodificador.';

  @override
  String get docNmeaTitle => 'Entramado NMEA y AIVDM';

  @override
  String get docNmeaIntro =>
      'En el cable, los mensajes AIS viajan como oraciones NMEA 0183 que empiezan por !AIVDM (otros buques) o !AIVDO (tu propio buque). La carga útil es un vector de bits blindado en ASCII.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Campos de la oración';

  @override
  String get docNmeaField1 =>
      'Hablante y formateador: !AIVDM o !AIVDO (consulta los identificadores de hablante más abajo).';

  @override
  String get docNmeaField2 =>
      'Número de fragmentos: cuántas oraciones componen el mensaje completo (NMEA limita cada línea a ~82 caracteres).';

  @override
  String get docNmeaField3 =>
      'Número de fragmento: qué parte es esta (empieza en 1).';

  @override
  String get docNmeaField4 =>
      'ID de mensaje secuencial: une los fragmentos del mismo mensaje.';

  @override
  String get docNmeaField5 => 'Canal de radio: A o B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Carga útil de datos: la carga útil AIS blindada en seis bits.';

  @override
  String get docNmeaField7 =>
      'Bits de relleno: cuántos bits de relleno se añadieron al último grupo de 6 bits (0-5).';

  @override
  String get docNmeaField8 =>
      'Suma de comprobación: el XOR de todos los bytes anteriores al *, en hexadecimal.';

  @override
  String get docNmeaMulti => 'Mensajes de varios fragmentos';

  @override
  String get docNmeaMultiText =>
      'Los mensajes más largos que una línea (como los datos estáticos del tipo 5) se dividen: la primera oración declara un recuento de fragmentos de 2 y la segunda lo completa con el mismo ID de mensaje.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Blindaje de seis bits';

  @override
  String get docNmeaArmoringText =>
      'Cada carácter de la carga útil contiene 6 bits. Resta 48 al código ASCII y luego resta otros 8 si el resultado es mayor que 40.';

  @override
  String get docNmeaTalkers => 'Identificadores de hablante';

  @override
  String get docNmeaTalkersIntro =>
      'Los distintos identificadores de hablante NMEA 4.0 identifican el tipo de estación AIS:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Suma de comprobación';

  @override
  String get docNmeaChecksumText =>
      'La suma de comprobación final es el XOR de cada byte entre el \"!\" y el \"*\". Calcula la tuya a continuación:';

  @override
  String get docNmeaInspectorTitle => 'Pruébalo: inspector de oraciones';

  @override
  String get docNmeaInspectorText =>
      'Pega cualquier oración AIVDM/AIVDO (o usa un ejemplo de arriba) para ver sus campos desglosados y los valores decodificados.';

  @override
  String get docPayloadIntro =>
      'Una vez deshecho el blindaje de seis bits, una carga útil AIS es una secuencia de campos de bits. Los primeros seis bits son el tipo de mensaje; los dos siguientes, el indicador de repetición; y después vienen 30 bits de MMSI.';

  @override
  String get docPayloadCnb => 'El Bloque de Navegación Común (tipos 1-3)';

  @override
  String get docPayloadCnbText =>
      'La disposición más importante la comparten los informes de posición de Clase A. Usa el selector para navegar por las disposiciones de mensaje principales y toca un segmento para leer qué codifica.';

  @override
  String get docPayloadCoords => 'Coordenadas';

  @override
  String get docPayloadCoordsText =>
      'La latitud y la longitud se almacenan en 1/10 000 de minuto. Divide entre 600 000 para obtener grados: 60 minutos en un grado y 10 000 unidades por minuto. El Este y el Norte son positivos.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // p. ej. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert =>
      'Convierte tus propias coordenadas a continuación:';

  @override
  String get docPayloadSpeed => 'Velocidad, rumbo, proa';

  @override
  String get docPayloadSpeed1 =>
      'SOG: velocidad sobre el fondo en décimas de nudo (0-102.2 nudos); 1023 significa \"no disponible\".';

  @override
  String get docPayloadSpeed2 =>
      'COG: rumbo sobre el fondo en décimas de grado, relativo al norte verdadero.';

  @override
  String get docPayloadSpeed3 =>
      'Proa: proa verdadera en grados enteros; 511 significa \"no disponible\".';

  @override
  String get docPayloadSpeed4 =>
      'ROT: velocidad de giro: valor ≈ 4.733 × √(velocidad de giro en °/min), con signo (positivo = a la derecha).';

  @override
  String get docPayloadNavStatus => 'Estado de navegación';

  @override
  String get docPayloadEpfd => 'Tipo de fijación de posición (EPFD)';

  @override
  String get docPayloadText => 'Texto de seis bits';

  @override
  String get docPayloadTextIntro =>
      'Los nombres, los indicativos de llamada y los destinos usan el mismo alfabeto de seis bits que la propia carga útil. Las letras minúsculas no se pueden codificar, por eso los nombres AIS suelen ir en mayúsculas.';

  @override
  String get docSecurityTitle => 'Seguridad y calidad de los datos';

  @override
  String get docSecurityIntro =>
      'El AIS está diseñado para la cooperación, no para la seguridad. El canal de radio es abierto y sin cifrar, y no hay autenticación de quién está transmitiendo.';

  @override
  String get docSecurityThreats => 'Amenazas';

  @override
  String get docSecurityThreat1 =>
      'Suplantación: transmitir un MMSI, una posición o una identidad falsos (buques fantasma, evasión de sanciones).';

  @override
  String get docSecurityThreat2 =>
      'Interferencia: saturar los dos canales VHF para que no se pueda recibir el tráfico real.';

  @override
  String get docSecurityThreat3 =>
      'Retransmisión engañosa: reproducir señales reales desde otro lugar para confundir a los receptores.';

  @override
  String get docSecurityQuality => 'Calidad de los datos';

  @override
  String get docSecurityQuality1 =>
      'El bit de precisión de la posición distingue una fijación GNSS no aumentada (> 10 m) de una de calidad DGPS (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'Los receptores deberían verificar la coherencia de posiciones, velocidades y marcas de tiempo; alrededor del 0.3 % de los mensajes reales tienen una longitud de carga útil incorrecta.';

  @override
  String get docSecurityQuality3 =>
      'El AIS por satélite sufre colisiones ocasionalmente porque la huella del satélite es mucho mayor que una celda TDMA: una razón más para contrastar con el radar y otras fuentes.';

  @override
  String get docKikaisIntro =>
      'KikAis es un laboratorio AIS completo: recibe tráfico en vivo o simulado, lo decodifica, inspecciona y envía tus propios mensajes y crea flotas. Así es como cada pestaña se corresponde con lo que acabas de leer.';

  @override
  String get docTabReceptionText =>
      'Elige las fuentes (archivo, serie, simulación), inicia el reenviador y observa el flujo NMEA crudo y las embarcaciones decodificadas.';

  @override
  String get docTabSendText =>
      'Reenvía las oraciones recibidas a uno o más destinos TCP/UDP: así es como una estación costera distribuiría el tráfico.';

  @override
  String get docTabMapText =>
      'Observa las embarcaciones decodificadas dibujadas a partir de sus informes de posición de los tipos 1/2/3, 18, 19 y 27.';

  @override
  String get docTabEditorText =>
      'Construye a mano cualquiera de los 27 tipos de mensaje desde un formulario sencillo y envíalo: la mejor forma de aprender los campos.';

  @override
  String get docTabDecoderText =>
      'Pega cualquier oración y obtén los campos decodificados, la suma de comprobación y el manejo de fragmentos: el compañero práctico de esta guía.';

  @override
  String get docTabStatsText =>
      'Contadores de mensajes, ritmos por fuente y salud del decodificador (sumas de comprobación no válidas, fragmentos descartados).';

  @override
  String get docTabSimulationText =>
      'Genera una flota entera alrededor de cualquier ubicación: cada tipo de mensaje, esquema de MMSI, forma de zona e incluso inyección de errores.';

  @override
  String get docSourcesIntro =>
      'Esta guía sintetiza documentación pública y autorizada:';

  @override
  String get docSources1 =>
      'gpsd: decodificación del protocolo AIVDM/AIVDO, de Eric S. Raymond (la biblia técnica de facto para el formato de las oraciones y los campos de bits de la carga útil).';

  @override
  String get docSources2 =>
      'Wikipedia: Sistema de Identificación Automática (visión general, historia, aplicaciones, seguridad).';

  @override
  String get docSources3 =>
      'Centro de Navegación de la Guardia Costera de EE. UU. (NavCen): páginas sobre AIS.';

  @override
  String get docSources4 =>
      'Recomendación UIT-R M.1371: el estándar AIS que lo rige.';

  @override
  String get docSources5 => 'IALA: aclaraciones de la UIT-R M.1371.';

  @override
  String get docSources6 =>
      'CEI 61162 / CEI 62287 / CEI 61097-14: entramado NMEA, Clase B y AIS-SART.';

  @override
  String get docSourcesLearn => 'Cómo aprender más';

  @override
  String get docSourcesLearnText =>
      'La mejor forma de entender el AIS es experimentar: usa el Editor para construir mensajes, el Decodificador para leerlos de vuelta y la pestaña Simulación para observar una flota entera. Todo en esta guía está generado por el codificador y el decodificador de KikAis.';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return 'Tipo $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits bits · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return 'Emitido por: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Abrir en el Decodificador';

  @override
  String get docInspectorNmeaLabel => 'Oración NMEA';

  @override
  String get docInspectorInspect => 'Inspeccionar';

  @override
  String get docInspectorInvalidChecksum => 'Suma de comprobación no válida';

  @override
  String get docInspectorCouldNotDecode => 'No se pudo decodificar';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Decodificado: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Tipo $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 dígitos)';

  @override
  String get docMmsiLookupButton => 'Consultar';

  @override
  String get docMmsiLookupError =>
      'Introduce un MMSI de 9 dígitos (solo dígitos).';

  @override
  String get docMmsiLookupClassGroup => 'Grupo de buques (llamada de grupo)';

  @override
  String get docMmsiUnknownCountry => 'país desconocido';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Abrir';

  @override
  String get updateCheckForUpdates => 'Buscar actualizaciones';

  @override
  String get updateChecking => 'Buscando actualizaciones…';

  @override
  String updateNewVersion(Object version) {
    return 'Nueva versión $version';
  }

  @override
  String get updateUpToDate => 'Estás actualizado.';

  @override
  String get updateCheckFailed => 'Error al buscar actualizaciones.';

  @override
  String get tooltipLanguage =>
      'Cambiar el idioma de la interfaz. Los diez idiomas están totalmente traducidos; elige «Automático» para seguir el idioma del sistema.';

  @override
  String get tooltipTheme =>
      'Cambiar el tema de colores: oscuro, claro o alto contraste. El alto contraste mejora la legibilidad.';

  @override
  String get tooltipUpdate =>
      'Buscar una nueva versión. Si hay alguna, aparece una insignia verde junto al número de versión.';

  @override
  String get tooltipMapSearch =>
      'Buscar un buque por nombre, MMSI o número IMO y centrar y seguir el mapa sobre él.';

  @override
  String get tooltipMapFilters =>
      'Filtrar los buques mostrados: por tipo, estado de navegación, país (MID), velocidad o solo nombre.';

  @override
  String get tooltipMapCluster =>
      'Alternar la agrupación de buques. Cuando está activada, los buques cercanos se agrupan en un marcador con un contador.';

  @override
  String get tooltipMapTrails =>
      'Alternar las estelas. Cuando está activada, cada buque dibuja su recorrido reciente en el mapa.';

  @override
  String get tooltipMapVectors =>
      'Alternar los vectores de rumbo. Cuando está activada, cada buque muestra una flecha en su dirección.';

  @override
  String get tooltipMapSendToMap =>
      'Alternar el envío de buques decodificados al mapa. Cuando está activada, cada buque decodificado aparece como marcador.';

  @override
  String get tooltipMapClear =>
      'Borra todos los buques actualmente en el mapa.';

  @override
  String get tooltipMapBasemap =>
      'Elegir el fondo del mapa. «Automático» sigue el tema actual.';

  @override
  String get tooltipSendAdd =>
      'Añadir un destino de envío (UDP o TCP, cliente o servidor). Las tramas AIS recibidas se reenvían a cada destino activado.';

  @override
  String get tooltipSendEdit =>
      'Editar el nombre, protocolo, host, puerto y formato de trama de este destino.';

  @override
  String get tooltipSendDelete =>
      'Eliminar este destino. Esta acción no se puede deshacer.';

  @override
  String get tooltipSendToggle =>
      'Activar o desactivar el reenvío a este destino.';

  @override
  String get tooltipSendLocked =>
      'Los destinos están bloqueados mientras el reenviador está en marcha. Detén la fuente en la pestaña Recepción para editarlos.';

  @override
  String get tooltipReceptionAddSource =>
      'Añadir una fuente de datos: una fuente de red (UDP/TCP/gpsd), un archivo de sentencias NMEA grabadas o un puerto serie.';

  @override
  String get tooltipReceptionStart =>
      'Iniciar la recepción y el reenvío de tramas AIS desde todas las fuentes activadas.';

  @override
  String get tooltipReceptionStop =>
      'Detener la recepción y el reenvío de tramas AIS.';

  @override
  String get tooltipReceptionFeed => 'Activar o desactivar esta fuente AIS.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Guardar el registro de conexión en un archivo de texto.';

  @override
  String get tooltipReceptionClearLogs => 'Borrar el registro de conexión.';

  @override
  String get tooltipReceptionRemoveSource => 'Eliminar esta fuente AIS.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Cuando está activado, se rechazan las tramas con suma de comprobación NMEA no válida.';

  @override
  String get tooltipReceptionImportFormat =>
      'Cómo se normalizan las tramas recibidas antes de decodificarlas.';

  @override
  String get tooltipReceptionLoop =>
      'Cuando está activado, la reproducción del archivo vuelve a empezar tras llegar al final.';

  @override
  String get tooltipReceptionSpeed =>
      'Multiplicador de velocidad de reproducción (1x = tiempo real).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Actualizar la lista de puertos serie disponibles.';

  @override
  String get tooltipSimApply =>
      'Aplicar la configuración actual y generar la flota. Las flotas grandes se generan en segundo plano.';

  @override
  String get tooltipSimGenerate =>
      'Generar una nueva flota aleatoria con una semilla nueva y aplicarla.';

  @override
  String get tooltipSimOpenReception =>
      'Ir a la pestaña Recepción para iniciar la fuente de simulación.';

  @override
  String get tooltipSimRadius =>
      'Radio de la zona de navegación alrededor del centro, en kilómetros.';

  @override
  String get tooltipSimVessels => 'Número de buques que generar en la flota.';

  @override
  String get tooltipSimSpeedMin => 'Velocidad mínima de los buques, en nudos.';

  @override
  String get tooltipSimSpeedMax => 'Velocidad máxima de los buques, en nudos.';

  @override
  String get tooltipSimInterval => 'Retardo entre dos emisiones, en segundos.';

  @override
  String get tooltipSimSeed =>
      'Semilla aleatoria. La misma semilla siempre produce la misma flota.';

  @override
  String get tooltipSimAnchored =>
      'Porcentaje de buques anclados o amarrados en lugar de moverse.';

  @override
  String get tooltipSimNamePrefix =>
      'Prefijo usado para los nombres de los buques generados.';

  @override
  String get tooltipSimMmsiMid =>
      'Dígitos de identificación marítima (código de país de 3 cifras) para construir los MMSI.';

  @override
  String get tooltipSimCenterLat =>
      'Latitud del centro de la zona de navegación.';

  @override
  String get tooltipSimCenterLon =>
      'Longitud del centro de la zona de navegación.';

  @override
  String get tooltipSimTransit =>
      'Porcentaje de buques que cruzan la zona en ruta directa.';

  @override
  String get tooltipSimRegenEvery =>
      'Regenerar la flota cada N emisiones cuando la regeneración periódica está activada.';

  @override
  String get tooltipSimReportInterval =>
      'Intervalo máximo de informe de posición por buque, en emisiones.';

  @override
  String get tooltipSimWander =>
      'Intensidad de la deriva aleatoria del rumbo (0 = líneas rectas).';

  @override
  String get tooltipSimClassBShare =>
      'Porcentaje de informes de posición clase B frente a clase A cuando ambos están activados.';

  @override
  String get tooltipSimErrorRate =>
      'Probabilidad de corromper o duplicar cada sentencia emitida.';

  @override
  String get tooltipSimBaseStations =>
      'Número de estaciones base fijas que generar.';

  @override
  String get tooltipSimAtoN =>
      'Número de ayudas a la navegación (balizas) fijas que generar.';

  @override
  String get tooltipSimRealisticNames =>
      'Usar nombres, indicativos y destinos de buques realistas.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Escalar las dimensiones y el calado según el tipo de buque.';

  @override
  String get tooltipSimRealisticMmsi =>
      'Construir MMSI que sigan la estructura ITU según la categoría de buque.';

  @override
  String get tooltipSimVarySpeed =>
      'Dejar que la velocidad varíe suavemente dentro del rango configurado.';

  @override
  String get tooltipSimSpeedByType =>
      'Elegir la velocidad del rango típico de cada tipo de buque.';

  @override
  String get tooltipSimHighAccuracy =>
      'Activar el indicador de posición de alta precisión en los informes emitidos.';

  @override
  String get tooltipSimRealisticRot =>
      'Emitir una velocidad de giro derivada del cambio de rumbo.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Regenerar automáticamente la flota cada N emisiones para simular tráfico cambiante.';

  @override
  String get tooltipSimInjectErrors =>
      'Corromper o duplicar algunas sentencias emitidas para probar el manejo de errores.';

  @override
  String get tooltipSimNmea4Tag =>
      'Prefijar cada trama emitida con un bloque de etiqueta NMEA 4.0.';

  @override
  String get tooltipSimVesselType => 'Incluir este tipo de buque en la flota.';

  @override
  String get tooltipSimMessageType => 'Emitir este tipo de mensaje AIS.';

  @override
  String get tooltipDecoderClear =>
      'Borrar la entrada y los resultados del decodificador.';

  @override
  String get tooltipStatsDecode =>
      'Pausar o reanudar el decodificado de las tramas AIS recibidas.';

  @override
  String get tooltipStatsReset =>
      'Poner a cero todos los contadores de estadísticas.';

  @override
  String get tooltipDocOpenTab => 'Abrir esta sección en su propia pestaña.';

  @override
  String get tooltipEditorInject =>
      'Inyectar el mensaje compuesto en el decodificador como si hubiera sido recibido.';

  @override
  String get tooltipEditorSend =>
      'Enviar el mensaje compuesto a cada destino de envío activado.';

  @override
  String get tooltipCopy => 'Copiar al portapapeles.';

  @override
  String get tooltipClose => 'Cerrar este panel.';

  @override
  String get tooltipBrowse => 'Buscar un archivo.';

  @override
  String get tooltipFeedName =>
      'Una etiqueta que identifica esta fuente en la lista de fuentes.';

  @override
  String get tooltipFeedHost =>
      'Dirección del servidor que transmite sentencias AIS.';

  @override
  String get tooltipFeedPort =>
      'Puerto TCP o UDP usado para alcanzar el servidor.';

  @override
  String get tooltipFeedHeader =>
      'Bytes opcionales enviados al conectar, antes de leer (p. ej. una petición gpsd).';

  @override
  String get tooltipFeedFile =>
      'Ruta a un archivo de texto con sentencias NMEA grabadas.';

  @override
  String get tooltipFeedInterval =>
      'Retardo entre dos tramas al reproducir el archivo.';

  @override
  String get tooltipFeedLoop =>
      'Reinicia la reproducción del archivo desde el principio al llegar al final.';

  @override
  String get tooltipFeedSpeed =>
      'Multiplicador de velocidad de reproducción (1x = tiempo real).';

  @override
  String get tooltipFeedSerialPort =>
      'Puerto serie del receptor AIS (p. ej. COM3 o /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Velocidad en baudios para hablar con el receptor AIS serie.';

  @override
  String get tooltipFeedRtlDevice =>
      'El dongle RTL-SDR usado para recibir AIS en VHF.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Deja que el sintonizador ajuste su ganancia automáticamente. Recomendado para la mayoría.';

  @override
  String get tooltipFeedRtlGain =>
      'Ganancia fija del sintonizador en decibelios, usada con la ganancia automática desactivada.';

  @override
  String get tooltipFeedRtlChannels =>
      'Qué canales VHF AIS decodificar: A (161,975 MHz), B (162,025 MHz) o ambos.';

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
  String get statsChannelOccupancy => 'Ocupación del canal';

  @override
  String get statsChannelA => 'Ch A · 161,975 MHz';

  @override
  String get statsChannelB => 'Ch B · 162,025 MHz';

  @override
  String get statsChannelOther => 'Otro';

  @override
  String get statsChannelNoData => 'Sin datos de canal aún';

  @override
  String statsChannelPercent(Object percent) => '${percent} %';

  @override
  String statsChannelRate(Object rate) => '${rate}/s';
}
