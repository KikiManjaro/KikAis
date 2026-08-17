// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeHighContrast => 'Alto contraste';

  @override
  String get tabReception => 'Receção';

  @override
  String get tabSend => 'Enviar';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabEditor => 'Editor';

  @override
  String get tabTools => 'Ferramentas';

  @override
  String get tabStats => 'Estatísticas';

  @override
  String get tabSimulation => 'Simulação';

  @override
  String get tabDocs => 'Doc';

  @override
  String get protocolUdpServer => 'Servidor UDP';

  @override
  String get protocolUdpClient => 'Cliente UDP';

  @override
  String get protocolTcpClient => 'Cliente TCP';

  @override
  String get protocolTcpServer => 'Servidor TCP';

  @override
  String get formatPassthrough => 'Pass-through';

  @override
  String get formatStrip => 'Remover blocos de tag';

  @override
  String get formatTag => 'Adicionar bloco de tag';

  @override
  String get sendAddDestination => 'Adicionar destino';

  @override
  String get sendEditDestination => 'Editar destino';

  @override
  String get sendFormat => 'Formato de envio';

  @override
  String get sendSave => 'Guardar';

  @override
  String get sendLockedBanner =>
      'O forwarder está a correr — os destinos estão bloqueados.';

  @override
  String get sendEmpty =>
      'Ainda não há destinos. Adicione um para reencaminhar as tramas AIS recebidas.';

  @override
  String get fieldName => 'Nome';

  @override
  String get fieldProtocol => 'Protocolo';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Porta';

  @override
  String get fieldTagSourceId => 'ID de origem da tag';

  @override
  String get fieldFile => 'Ficheiro';

  @override
  String get fieldCancel => 'Cancelar';

  @override
  String get fieldAdd => 'Adicionar';

  @override
  String get receptionFeeds => 'Fontes';

  @override
  String get receptionValidateChecksums => 'Validar somas de verificação NMEA';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count frases descartadas',
      one: '1 frase descartada',
      zero: 'Nenhuma frase descartada',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Formato de importação de tramas';

  @override
  String get receptionStart => 'Iniciar';

  @override
  String get receptionStop => 'Parar';

  @override
  String get receptionLogs => 'Registos';

  @override
  String get receptionFrameCopied => 'Trama copiada';

  @override
  String get receptionAddSource => 'Adicionar fonte';

  @override
  String get receptionNetwork => 'Rede';

  @override
  String get receptionFile => 'Ficheiro';

  @override
  String get receptionSerial => 'Série';

  @override
  String get receptionHeaderOptional => 'Cabeçalho (opcional)';

  @override
  String get receptionPathOrBrowse => 'Caminho ou Procurar…';

  @override
  String get receptionIntervalMs => 'Intervalo entre tramas (ms)';

  @override
  String get receptionReplayTimestamps =>
      'Reproduzir usando os carimbos de data/hora do ficheiro';

  @override
  String get receptionReplayTimestampsHint =>
      'Segue os tempos registados (t: do bloco de tag ou prefixo de carimbo) em vez de um intervalo fixo';

  @override
  String get receptionSpeed => 'Velocidade';

  @override
  String get receptionReplayLoop => 'Ciclar (reproduzir desde o início)';

  @override
  String get receptionSerialPort => 'Porta série';

  @override
  String get receptionSerialPortHint => 'ex.: COM3 ou /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Débito (baud)';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'Dispositivo RTL-SDR';

  @override
  String get tooltipReceptionRtlSdrDevices =>
      'Atualizar a lista de dongles RTL-SDR';

  @override
  String get receptionRtlSdrNoDevice =>
      'Nenhum dispositivo RTL-SDR encontrado. Instale os drivers RTL-SDR (Zadig / WinUSB no Windows) e ligue o dongle.';

  @override
  String get receptionRtlSdrAutoGain => 'Ganho automático (recomendado)';

  @override
  String get receptionRtlSdrGainDb => 'Ganho do sintonizador (dB)';

  @override
  String get receptionRtlSdrSampleRate => 'Taxa de amostragem';

  @override
  String get receptionRtlSdrChannels => 'Canais';

  @override
  String get msgType1 => 'Relatório de Posição Classe A';

  @override
  String get msgType2 => 'Relatório de Posição Classe A (atribuído)';

  @override
  String get msgType3 => 'Relatório de Posição Classe A (resposta)';

  @override
  String get msgType4 => 'Estação Base';

  @override
  String get msgType5 => 'Dados Estáticos e de Viagem';

  @override
  String get msgType6 => 'Mensagem Binária Endereçada';

  @override
  String get msgType7 => 'Confirmação Binária';

  @override
  String get msgType8 => 'Mensagem Binária de Difusão';

  @override
  String get msgType9 => 'Relatório de Posição SAR de Aeronave Padrão';

  @override
  String get msgType10 => 'Pedido de UTC/Data';

  @override
  String get msgType11 => 'Resposta de UTC/Data';

  @override
  String get msgType12 => 'Mensagem de Segurança Endereçada';

  @override
  String get msgType13 => 'Confirmação de Segurança';

  @override
  String get msgType14 => 'Mensagem de Segurança de Difusão';

  @override
  String get msgType15 => 'Interrogação';

  @override
  String get msgType16 => 'Comando de Modo de Atribuição';

  @override
  String get msgType17 => 'Mensagem Binária de Difusão DGNSS';

  @override
  String get msgType18 => 'Relatório de Posição CS Classe B Padrão';

  @override
  String get msgType19 =>
      'Relatório de Posição de Equipamento Classe B Alargado';

  @override
  String get msgType20 => 'Mensagem de Gestão de Ligação de Dados';

  @override
  String get msgType21 => 'Relatório de Auxílio à Navegação';

  @override
  String get msgType22 => 'Gestão de Canais';

  @override
  String get msgType23 => 'Comando de Atribuição de Grupo';

  @override
  String get msgType24 => 'Relatório de Dados Estáticos';

  @override
  String get msgType25 => 'Mensagem Binária de Slot Único';

  @override
  String get msgType26 => 'Mensagem Binária de Múltiplos Slots';

  @override
  String get msgType27 =>
      'Relatório de Posição para Aplicações de Longo Alcance';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String get statsFeed => 'Fonte';

  @override
  String get statsAllFeeds => 'Todas as fontes';

  @override
  String get statsReceived => 'Recebidas';

  @override
  String get statsDecoded => 'Descodificadas';

  @override
  String get statsInvalidChecksums => 'Somas de verificação inválidas';

  @override
  String get statsDroppedFragments => 'Fragmentos descartados';

  @override
  String get statsParseErrors => 'Erros de análise';

  @override
  String get statsPendingFragments => 'Fragmentos pendentes';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '(todas as fontes)';

  @override
  String get statsReceivedVsDecoded =>
      'Recebidas vs Descodificadas (últimos 60 s)';

  @override
  String get statsPerSecondLabel => 'por segundo';

  @override
  String get statsAccounting => 'Contabilização';

  @override
  String get statsMultiPartParts => 'Partes de multiparte';

  @override
  String get statsPending => 'Pendentes';

  @override
  String get statsDropped => 'Descartadas';

  @override
  String get statsReconcile => 'Recebidas e descodificadas reconciliam.';

  @override
  String get statsGapPaused =>
      'A lacuna inclui frases recebidas enquanto a descodificação estava em pausa.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Recebidas $received = $sum';
  }

  @override
  String get statsByMessageType => 'Por tipo de mensagem';

  @override
  String get statsNoDecodedYet => 'Ainda sem mensagens descodificadas';

  @override
  String statsTypeFallback(Object type) {
    return 'Tipo $type';
  }

  @override
  String get statsByFeed => 'Por fonte';

  @override
  String statsFeedFilter(Object filter) {
    return 'Fonte: $filter';
  }

  @override
  String get statsNoActivityYet => 'Ainda sem atividade nas fontes';

  @override
  String get statsCollecting => 'a recolher…';

  @override
  String get simVesselCargo => 'Carga';

  @override
  String get simVesselTanker => 'Petroleiro';

  @override
  String get simVesselFishing => 'Pesca';

  @override
  String get simVesselSailing => 'Vela';

  @override
  String get simVesselPassenger => 'Passageiros';

  @override
  String get simVesselTug => 'Rebocador';

  @override
  String get simVesselHsc => 'Embarcação de alta velocidade';

  @override
  String get simVesselOther => 'Outro';

  @override
  String get simType1 => 'Relatório de posição (1/2/3)';

  @override
  String get simType5 => 'Estático & Viagem (5)';

  @override
  String get simType9 => 'Aeronave SAR (9)';

  @override
  String get simType18 => 'Posição Classe B (18)';

  @override
  String get simType19 => 'Classe B alargado (19)';

  @override
  String get simType27 => 'Longo alcance (27)';

  @override
  String get simType4 => 'Estação base (4)';

  @override
  String get simType21 => 'Auxílio à navegação (21)';

  @override
  String get simType8 => 'Difusão meteorológica (8)';

  @override
  String get simType11 => 'Resposta UTC/data (11)';

  @override
  String get simType12 => 'Segurança endereçada (12)';

  @override
  String get simType14 => 'Segurança de difusão (14)';

  @override
  String get simType22 => 'Gestão de canais (22)';

  @override
  String get simType23 => 'Atribuição de grupo (23)';

  @override
  String get simType24 => 'Classe B estático (24)';

  @override
  String get simTitle => 'Simulação';

  @override
  String get simInfoBanner =>
      'A frota é emitida quando a fonte \"Simulação\" está ativada no separador Receção e o forwarder está a correr.';

  @override
  String get simOpenReception => 'Abrir Receção';

  @override
  String get simFleetSection => 'Frota';

  @override
  String get simRadiusKm => 'Raio (km)';

  @override
  String get simVessels => 'Embarcações';

  @override
  String get simSpeedMinKn => 'Velocidade mín. (kn)';

  @override
  String get simSpeedMaxKn => 'Velocidade máx. (kn)';

  @override
  String get simIntervalS => 'Intervalo (s)';

  @override
  String get simSeed => 'Semente';

  @override
  String get simAnchoredPct => 'Fundeada (%)';

  @override
  String get simNamePrefix => 'Prefixo do nome';

  @override
  String get simMmsiMid => 'País MMSI / MID';

  @override
  String get simSearchMmid => 'Procure um país ou escreva um MID de 3 dígitos';

  @override
  String get simCustom => 'Personalizado';

  @override
  String get simVesselTypes => 'Tipos de embarcação';

  @override
  String get simRealisticNames => 'Nomes realistas';

  @override
  String get simRealisticDimensions => 'Dimensões realistas';

  @override
  String get simRealisticMmsi => 'MMSI ITU realista';

  @override
  String get simZoneSection => 'Zona & tráfego';

  @override
  String get simLocationPreset => 'Predefinição de localização';

  @override
  String get simSearchPort => 'Procure um porto…';

  @override
  String get simCenterLat => 'Latitude central';

  @override
  String get simCenterLon => 'Longitude central';

  @override
  String get simZoneShape => 'Forma da zona';

  @override
  String get simTransitPct => 'Trânsito (%)';

  @override
  String get simRegeneratePeriodically => 'Regenerar periodicamente';

  @override
  String get simRegenerateTicks => 'Regenerar (ticks)';

  @override
  String get simPresetHint =>
      'Escolha uma predefinição para preencher as coordenadas, ou escreva diretamente Latitude / Longitude central.';

  @override
  String get simMovementSection => 'Movimento & emissão';

  @override
  String get simVarySpeed => 'Variar a velocidade ao longo do tempo';

  @override
  String get simReportIntervalTicks => 'Intervalo de relatório (ticks)';

  @override
  String get simWander => 'Deriva (0-3)';

  @override
  String get simSpeedByType => 'Velocidade por tipo de embarcação';

  @override
  String get simClassBSharePct => 'Quota Classe B (%)';

  @override
  String get simHighAccuracy => 'Alta precisão';

  @override
  String get simRealisticRot => 'Taxa de rotação realista';

  @override
  String get simContentSection => 'Conteúdo';

  @override
  String get simSafetyTexts => 'Textos de segurança (um por linha)';

  @override
  String get simDestinations => 'Destinos (um por linha)';

  @override
  String get simStationsSection => 'Estações';

  @override
  String get simBaseStations => 'Estações base';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => 'Qualidade de transmissão';

  @override
  String get simInjectErrors => 'Injetar erros';

  @override
  String get simErrorRatePct => 'Taxa de erro (%)';

  @override
  String get simTalkerId => 'ID do talker';

  @override
  String get simNmea4Tag => 'Bloco de tag NMEA 4.0';

  @override
  String get simMessagesSection => 'Mensagens';

  @override
  String get simApplyFleet => 'Aplicar frota';

  @override
  String get simRegenerateFleet => 'Regenerar frota';

  @override
  String get simGenerating => 'Gerando…';

  @override
  String get simLiveFleet => 'Frota ativa';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats embarcações · $frames tramas emitidas';
  }

  @override
  String get mapSearchVessels => 'Procurar embarcações';

  @override
  String get mapSearchHint => 'Nome, MMSI ou IMO';

  @override
  String get mapNoResults => 'Sem resultados';

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
  String get mapVesselType => 'Tipo de embarcação';

  @override
  String get mapNavigationStatus => 'Estado de navegação';

  @override
  String get mapCountry => 'País';

  @override
  String get mapMinSog => 'SOG mín. (kn)';

  @override
  String get mapMaxSog => 'SOG máx. (kn)';

  @override
  String get mapOnlyNamed => 'Apenas embarcações com nome';

  @override
  String get mapReset => 'Repor';

  @override
  String get mapApply => 'Aplicar';

  @override
  String get mapAutoBasemap => 'Auto (seguir tema)';

  @override
  String mapFollowing(Object mmsi) {
    return 'A seguir $mmsi';
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
  String get basemapEsriSatellite => 'Esri Satellite';

  @override
  String get basemapEsriStreets => 'Esri World Street Map';

  @override
  String get decoderInputLabel => 'Cole ou escreva uma ou mais frases NMEA AIS';

  @override
  String get decoderValidateChecksums => 'Validar somas de verificação';

  @override
  String get decoderDecode => 'Descodificar';

  @override
  String get decoderDecoded => 'Descodificado';

  @override
  String decoderDecodedN(Object n) {
    return 'Descodificado ($n frases)';
  }

  @override
  String get decoderInvalidChecksum => 'Soma de verificação inválida';

  @override
  String get decoderParseError => 'Erro de análise';

  @override
  String get decoderWaitingFragments => 'A aguardar mais fragmentos…';

  @override
  String decoderTagSource(Object id) {
    return 'origem $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Bloco de tag · $content';
  }

  @override
  String get toolDecoder => 'Descodificador NMEA';

  @override
  String get toolDecoderSub => 'Descodificar frases AIS';

  @override
  String get toolChecksum => 'Soma de verificação';

  @override
  String get toolChecksumSub => 'Calcular XOR NMEA';

  @override
  String get toolMmsi => 'Pesquisa MMSI';

  @override
  String get toolMmsiSub => 'Validar e identificar um MMSI';

  @override
  String get toolSpeed => 'Conversor de velocidade';

  @override
  String get toolSpeedSub => 'nós · km/h · m/s · mph';

  @override
  String get toolBinary => 'Inspetor binário';

  @override
  String get toolBinarySub => 'Payload até aos bits';

  @override
  String get toolEta => 'Calculadora de ETA';

  @override
  String get toolEtaSub => 'ETA nos campos do tipo 5';

  @override
  String get toolRadio => 'Alcance de rádio';

  @override
  String get toolRadioSub => 'Horizonte de rádio VHF-AIS';

  @override
  String get toolTextToBinary => 'Texto para binário';

  @override
  String get toolTextToBinarySub => 'ASCII 6-bit para hex/bits';

  @override
  String get checksumInputLabel => 'Cole uma ou mais frases NMEA';

  @override
  String get checksumComputed => 'Calculada';

  @override
  String get checksumDeclared => 'Declarada';

  @override
  String get checksumValid => 'Soma de verificação válida';

  @override
  String get checksumInvalid => 'Soma de verificação incorreta';

  @override
  String get checksumFix => 'Corrigir soma';

  @override
  String get mmsiInputLabel => 'MMSI (9 dígitos)';

  @override
  String get mmsiValid => 'MMSI válido';

  @override
  String get mmsiInvalid => 'Não é um MMSI válido de 9 dígitos';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'País';

  @override
  String get mmsiCountryUnknown => 'MID desconhecido';

  @override
  String get mmsiType => 'Tipo de estação';

  @override
  String get mmsiGroupCall => 'Chamada de grupo';

  @override
  String get mmsiSarAircraft => 'Aeronave SAR';

  @override
  String get mmsiCoastStation => 'Estação costeira';

  @override
  String get mmsiShipStation => 'Estação de navio';

  @override
  String get mmsiHandheldVhf => 'VHF portátil';

  @override
  String get mmsiAton => 'Ajuda à navegação (AtoN)';

  @override
  String get mmsiSar => 'Unidade SAR';

  @override
  String get mmsiOther => 'Outro';

  @override
  String get speedValue => 'Valor';

  @override
  String get speedUnit => 'Unidade';

  @override
  String get binaryInputLabel => 'Frase NMEA ou payload 6-bit bruto';

  @override
  String get binaryPayload => 'Payload';

  @override
  String get binaryBits => 'Bits';

  @override
  String get binaryBinary => 'Binário';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Bytes hex';

  @override
  String get binarySixBit => 'Carateres 6-bit';

  @override
  String get etaDistance => 'Distância';

  @override
  String get etaUnitNm => 'milhas náuticas';

  @override
  String get etaUnitKm => 'quilómetros';

  @override
  String get etaSpeed => 'Velocidade';

  @override
  String get etaDuration => 'Duração';

  @override
  String get etaEtaLocal => 'ETA (local)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'Campos ETA do tipo 5';

  @override
  String get etaMonth => 'Mês';

  @override
  String get etaDay => 'Dia';

  @override
  String get etaHour => 'Hora';

  @override
  String get etaMinute => 'Minuto';

  @override
  String get etaCombined => 'MM/DD HH:MM';

  @override
  String get radioHeight1 => 'Altura da antena 1';

  @override
  String get radioHeight2 => 'Altura da antena 2';

  @override
  String get radioHorizon => 'Horizonte de rádio';

  @override
  String get radioHorizonKm => 'Horizonte de rádio (km)';

  @override
  String get radioFrequencies => 'Canais AIS';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Digite um texto (alfabeto AIS 6-bit)';

  @override
  String get t2bCharTable => 'Caráter · valor · 6-bit';

  @override
  String get t2bBinary => 'Binário';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Bytes (formato do editor)';

  @override
  String get t2bPayload => 'Payload blindado';

  @override
  String get t2bNote =>
      'A lista de bytes pode ser colada no campo «Data bytes» do editor de uma mensagem 6/8/25/26; o payload blindado é o campo payload exato da frase NMEA.';

  @override
  String editorAsmDetected(Object name) {
    return 'Mensagem específica da aplicação — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Campos do ASM correspondente. O campo bruto «Data bytes» continua a sobrepô-los quando preenchido.';

  @override
  String get fMessageType => 'Tipo de mensagem';

  @override
  String get editorAsmPreset => 'Predefinição ASM';

  @override
  String get editorAsmPresetManual =>
      'Personalizado — introduzir DAC/FID manualmente';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'Campos ASM';

  @override
  String get asmStateInForce => 'em vigor';

  @override
  String get asmStateDeprecated => 'obsoleto';

  @override
  String get asmStateReplaced => 'substituído';

  @override
  String get asmStateDiscontinued => 'descontinuado';

  @override
  String get asmStateDraft => 'rascunho';

  @override
  String get asmStateProposal => 'proposta';

  @override
  String get asmStateTesting => 'em teste';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Obsoleto desde $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'Nenhum layout de bits está documentado para $name — edite os Data bytes brutos.';
  }

  @override
  String get docChapterAsm => 'Mensagens específicas da aplicação';

  @override
  String get docAsmIntro =>
      'Nem todos os payloads AIS são relatórios de posição normais. Os tipos 6, 8, 25 e 26 transportam dados binários específicos (ASM) cujo significado define um Código de Área Designada (DAC) e um Identificador de Função (FID).';

  @override
  String get docAsmWhatTitle => 'O que é um ASM?';

  @override
  String get docAsmWhat =>
      'Uma mensagem específica da aplicação é um payload estruturado publicado por uma organização (OMI, IALA, administrações nacionais, fabricantes) para um uso concreto: dados meteorológicos e hidrográficos, monitorização de auxílios à navegação, correções DGPS, serviços portuários, etc. Os tipos 6/8 trazem o cabeçalho DAC/FID; os 25/26 repetem o mesmo esquema DAC/FID nas mensagens de slot.';

  @override
  String get docAsmDacFidTitle => 'DAC e FID';

  @override
  String get docAsmDacFid1 =>
      'O DAC é um código de 10 bits que identifica a organização ou país emissor (ex.: 001 = OMI, 002 = IALA). O FID é um código de função de 6 bits no espaço desse DAC (ex.: 001/11 = dados meteoro-hidro da OMI).';

  @override
  String get docAsmDacFid2 =>
      'Os bytes de dados que seguem o cabeçalho DAC/FID são descodificados segundo a norma de aplicação correspondente. Pares DAC/FID diferentes podem interpretar os mesmos bytes de forma totalmente diferente: é preciso conhecer sempre o par primeiro.';

  @override
  String get docAsmWhereTitle => 'Onde encontrar as definições';

  @override
  String get docAsmWhere1 =>
      'Circulares da OMI e ITU-R M.1371 (anexos) — fonte autorizada para o DAC 001.';

  @override
  String get docAsmWhere2 =>
      'Diretrizes da IALA (ex.: G1139) e administrações nacionais — para DACs regionais.';

  @override
  String get docAsmWhere3 =>
      'Documentação AIVDM do gpsd — catálogo aberto e legível por máquina dos esquemas DAC/FID mais comuns.';

  @override
  String get docAsmInKikaisTitle => 'No KikAis';

  @override
  String get docAsmInKikais =>
      'O Editor conhece um conjunto curado de ASMs conhecidos: quando o DAC/FID de uma mensagem 6/8/25/26 corresponde, o campo data é mostrado como subcampos nomeados, empacotados automaticamente. O campo bruto «Data bytes» prevalece sempre quando preenchido. A lista está em asm_formats.dart e é fácil de alargar.';

  @override
  String get docAsmExampleTitle => 'Exemplo: meteoro-hidro OMI (001/11)';

  @override
  String get docAsmExample =>
      'No Editor, escolha o tipo 8, DAC=1 e FID=11 para construir uma mensagem meteorológica da OMI: vento, temperaturas do ar e da água, pressão, visibilidade, correntes e ondas são editados campo a campo em vez de um bloco de bytes.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Indicador de repetição';

  @override
  String get fNavStatus => 'Estado de navegação';

  @override
  String get fLatitude => 'Latitude';

  @override
  String get fLongitude => 'Longitude';

  @override
  String get fSogKn => 'SOG (kn)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Proa (°)';

  @override
  String get fRateOfTurn => 'Taxa de rotação';

  @override
  String get fManeuver => 'Manobra';

  @override
  String get fTimestamp => 'Carimbo de data/hora';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Precisão';

  @override
  String get fEpfdFixType => 'Tipo de correção EPFD';

  @override
  String get fSyncState => 'Estado de sincronização';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Indicativo de chamada';

  @override
  String get fVesselName => 'Nome da embarcação';

  @override
  String get fShipType => 'Tipo de navio';

  @override
  String get fShipTypeText => 'Tipo de navio (texto)';

  @override
  String get fDims => 'Proa/Popa/Bombordo/Estibordo (m)';

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
  String get fSeqNumber => 'Número de sequência';

  @override
  String get fRetransmit => 'Retransmitir';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Dados';

  @override
  String get fAltitudeM => 'Altitude (m)';

  @override
  String get fAssignedMode => 'Modo atribuído';

  @override
  String get fRegionalReserved => 'Reservado regional';

  @override
  String get fText => 'Texto';

  @override
  String fStationN(Object n) {
    return 'Estação $n';
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
    return 'offset $offset · número $number · timeout $timeout · inc $increment';
  }

  @override
  String get fAidType => 'Tipo de auxílio';

  @override
  String get fAidTypeCode => 'Tipo de auxílio (código)';

  @override
  String get fName => 'Nome';

  @override
  String get fNameExt => 'Extensão do nome';

  @override
  String get fVirtualAid => 'Auxílio virtual';

  @override
  String get fOffPosition => 'Fora de posição';

  @override
  String get fSecond => 'Segundo';

  @override
  String get fChannelA => 'Canal A';

  @override
  String get fChannelB => 'Canal B';

  @override
  String get fTxRxMode => 'Modo TX/RX';

  @override
  String get fPower => 'Potência';

  @override
  String get fZone => 'Zona';

  @override
  String get fAddressed => 'Endereçada';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Banda A';

  @override
  String get fBandB => 'Banda B';

  @override
  String get fZoneSize => 'Tamanho da zona';

  @override
  String get fStationType => 'Tipo de estação';

  @override
  String get fReportInterval => 'Intervalo de relatório';

  @override
  String get fQuietTime => 'Tempo de silêncio';

  @override
  String get fPart => 'Parte';

  @override
  String get fVendorId => 'ID do fabricante';

  @override
  String get fUnitModel => 'Modelo da unidade';

  @override
  String get fSerialNumber => 'Número de série';

  @override
  String get fMothershipMmsi => 'MMSI do navio-mãe';

  @override
  String get fRadioStatus => 'Estado de rádio';

  @override
  String get fGnssStatus => 'Estado de posição GNSS';

  @override
  String fDestN(Object n) {
    return 'Destino $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => 'Indicador de destino';

  @override
  String get fBinaryDataFlag => 'Sinalizador de dados binários';

  @override
  String get fApplicationId => 'ID de aplicação';

  @override
  String get fPowerHigh => 'Alta';

  @override
  String get fPowerLow => 'Baixa';

  @override
  String get fPartA => 'A (nome)';

  @override
  String get fPartB => 'B (dados do navio)';

  @override
  String get editorTitle => 'Editor de Mensagens AIS';

  @override
  String get editorCompose => 'Compor mensagem';

  @override
  String get editorMessageType => 'Tipo de mensagem';

  @override
  String get editorAddTagBlock => 'Adicionar bloco de tag NMEA 4.0';

  @override
  String get editorSourceId => 'ID de origem';

  @override
  String get editorInjectToMap => 'Injetar no mapa';

  @override
  String get editorSendToTarget => 'Enviar para o destino';

  @override
  String get editorPreview => 'Pré-visualização NMEA';

  @override
  String get editorNmeaCopied => 'NMEA copiado';

  @override
  String get editorInjected => 'Mensagem injetada';

  @override
  String get editorSentToTarget => 'Mensagem enviada para o destino';

  @override
  String get editorNavStatus0_15 => 'Estado de nav (0-15)';

  @override
  String get editorYear => 'Ano';

  @override
  String get editorMonth => 'Mês';

  @override
  String get editorDay => 'Dia';

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
  String get editorPortM => 'Bombordo (m)';

  @override
  String get editorStarboardM => 'Estibordo (m)';

  @override
  String get editorEtaMonth => 'Mês ETA';

  @override
  String get editorEtaDay => 'Dia ETA';

  @override
  String get editorEtaHour => 'Hora ETA';

  @override
  String get editorEtaMinute => 'Minuto ETA';

  @override
  String get editorSequence0_3 => 'Sequência (0-3)';

  @override
  String get editorDataBytes => 'Bytes de dados (hex ou 1,2,3)';

  @override
  String get editorDestMmsisComma => 'MMSIs de destino (vírgula)';

  @override
  String get editorSequencesComma => 'Sequências (vírgula)';

  @override
  String get editorInterrogatedMmsi => 'MMSI interrogado';

  @override
  String get editorType1 => 'Tipo 1';

  @override
  String get editorOffset1 => 'Offset 1';

  @override
  String get editorTargetMmsi => 'MMSI alvo';

  @override
  String get editorOffset => 'Offset';

  @override
  String get editorIncrement => 'Incremento';

  @override
  String get editorNumber => 'Número';

  @override
  String get editorTimeout => 'Timeout';

  @override
  String get editorAidType0_31 => 'Tipo de auxílio (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Auxílio virtual (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Modo Tx/Rx (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Modo Tx/Rx (0-3)';

  @override
  String get editorNeLat => 'Latitude NE';

  @override
  String get editorNeLon => 'Longitude NE';

  @override
  String get editorSwLat => 'Latitude SW';

  @override
  String get editorSwLon => 'Longitude SW';

  @override
  String get editorInterval0_15 => 'Intervalo (0-15)';

  @override
  String get editorPart => 'Parte (0 = A nome, 1 = B estático)';

  @override
  String get editorDestMmsiEmpty => 'MMSI de destino (vazio = difusão)';

  @override
  String get editorAppDacEmpty => 'DAC de app (vazio = nenhum)';

  @override
  String get editorAppFidEmpty => 'FID de app (vazio = nenhum)';

  @override
  String get nmeaTalker => 'Talker';

  @override
  String get nmeaFragments => 'Fragmentos';

  @override
  String get nmeaFragmentN => 'Fragmento #';

  @override
  String get nmeaMessageId => 'ID de mensagem';

  @override
  String get nmeaChannel => 'Canal';

  @override
  String get nmeaPayload => 'Payload';

  @override
  String get nmeaFillBits => 'Bits de preenchimento';

  @override
  String get nmeaTagBlock => 'Bloco de tag';

  @override
  String get nmeaChecksum => 'Soma de verificação';

  @override
  String get nmeaEmpty => '(vazio)';

  @override
  String get bubbleKindVessel => 'Embarcação';

  @override
  String get bubbleKindAircraft => 'Aeronave SAR';

  @override
  String get bubbleKindAton => 'Auxílio à Navegação';

  @override
  String get bubbleKindStation => 'Estação Base';

  @override
  String get bubbleGeneralInfo => 'Informações Gerais';

  @override
  String get bubbleKind => 'Tipo';

  @override
  String get bubbleAidType => 'Tipo de Auxílio';

  @override
  String get bubbleVirtual => 'Virtual';

  @override
  String get bubbleAltitude => 'Altitude';

  @override
  String get bubbleCallSign => 'Indicativo de Chamada';

  @override
  String get bubblePosNav => 'Posição & Navegação';

  @override
  String get bubbleHeading => 'Proa';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Detalhes da Embarcação';

  @override
  String get bubbleType => 'Tipo';

  @override
  String get bubbleTypeInt => 'Tipo (Int)';

  @override
  String get bubbleDimsBowStern => 'Dimensões Proa/Popa';

  @override
  String get bubbleDimsPortStarboard => 'Dimensões Bombordo/Estibordo';

  @override
  String get bubbleSpare => 'Reserva';

  @override
  String get bubbleDraught => 'Calado';

  @override
  String bubbleFrames(Object n) {
    return 'Tramas ($n)';
  }

  @override
  String get bubbleNoFrames => 'Ainda sem tramas';

  @override
  String get copied => 'Copiado';

  @override
  String get textFiles => 'Ficheiros de Texto';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Destino $name ligado ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Falha ao ligar ao destino $name: $error';
  }

  @override
  String get logStopping => 'A parar o forwarder...';

  @override
  String get logStopped => 'Forwarder parado.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Fonte adicionada: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Fonte removida: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Fonte $name ligada.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Fonte $name desligada. A religar em 5s...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Falha ao ligar à fonte $name: $error. A tentar novamente em 5s...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Destino $name: servidor TCP à escuta na porta $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Destino $name: cliente ligado $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Destino $name: cliente desligado';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Destino $name: erro do cliente $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Erro de envio para o destino $name: $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'Abrindo dongle RTL-SDR $device...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device conectado ($freq, taxa de amostragem $rate, ganho $gain, canais $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device: erro $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'Fluxo RTL-SDR $device encerrado.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device desconectado.';
  }

  @override
  String get docNavStatus0 => 'Em marcha com motor';

  @override
  String get docNavStatus1 => 'Fundeada';

  @override
  String get docNavStatus2 => 'Sem governo';

  @override
  String get docNavStatus3 => 'Manobrabilidade restrita';

  @override
  String get docNavStatus4 => 'Limitado pelo seu calado';

  @override
  String get docNavStatus5 => 'Amarrado';

  @override
  String get docNavStatus6 => 'Encalhado';

  @override
  String get docNavStatus7 => 'Em pesca';

  @override
  String get docNavStatus8 => 'Em marcha à vela';

  @override
  String get docNavStatus9 => 'Reservado (HSC)';

  @override
  String get docNavStatus10 => 'Reservado (WIG)';

  @override
  String get docNavStatus11 => 'Rebocando pela popa (regional)';

  @override
  String get docNavStatus12 =>
      'Empurrando adiante / rebocando ao lado (regional)';

  @override
  String get docNavStatus13 => 'Reservado para uso futuro';

  @override
  String get docNavStatus14 => 'AIS-SART ativo';

  @override
  String get docNavStatus15 => 'Indefinido (predefinição)';

  @override
  String get docEpfd0 => 'Indefinido (predefinição)';

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
  String get docEpfd6 => 'Sistema de navegação integrado';

  @override
  String get docEpfd7 => 'Levantado (fixo)';

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
    return '$fields campos · $bits bits no total · toque num segmento';
  }

  @override
  String get docTextToEncode => 'Texto a codificar';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Cada carácter é um valor de 6 bits (\"@\" = 0, espaço = 32, \"A\" = 1…). As letras minúsculas não são codificáveis e são normalmente enviadas em maiúsculas.';

  @override
  String get docChecksumBody => 'Corpo (sem o ! inicial e o *XX final)';

  @override
  String get docChecksumExplanation =>
      'A soma de verificação NMEA é o XOR de todos os bytes entre o \"!\" e o \"*\".';

  @override
  String get docLatitude => 'Latitude';

  @override
  String get docLongitude => 'Longitude';

  @override
  String get docLatitudeInvalid => 'Latitude: introduza um número';

  @override
  String get docLongitudeInvalid => 'Longitude: introduza um número';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Latitude → $value (27 bits com sinal, deg = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Longitude → $value (28 bits com sinal, deg = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'As coordenadas são armazenadas em 1/10 000 de minuto: divida por 600 000 para obter os graus.';

  @override
  String get docSearchShipTypes => 'Procurar tipos de navio';

  @override
  String get docShipCat0_19 => '0-19 · Reservado';

  @override
  String get docShipCat20_29 => '20-29 · Efeito de solo (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Pesca';

  @override
  String get docShipCat40_49 => '40-49 · Embarcação de alta velocidade';

  @override
  String get docShipCat50_59 => '50-59 · Embarcação especial';

  @override
  String get docShipCat60_69 => '60-69 · Passageiros';

  @override
  String get docShipCat70_79 => '70-79 · Carga';

  @override
  String get docShipCat80_89 => '80-89 · Petroleiro';

  @override
  String get docShipCat90_99 => '90-99 · Outro';

  @override
  String get docSearchGlossary => 'Procurar no glossário';

  @override
  String get docNoMatchingTerms => 'Sem termos correspondentes.';

  @override
  String get docAspect => 'Aspeto';

  @override
  String get docClassA => 'Classe A';

  @override
  String get docClassB => 'Classe B';

  @override
  String get docCheatRadio => 'Rádio';

  @override
  String get docCheatFrequencies => 'Frequências';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => 'Modulação';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 bits/s';

  @override
  String get docCheatRange => 'Alcance';

  @override
  String get docCheatRangeValue => '~10-20 NM navio-a-navio, linha de vista';

  @override
  String get docCheatReportingRates => 'Taxas de emissão';

  @override
  String get docCheatClassAPos1 => 'Posição Classe A (1)';

  @override
  String get docCheatClassAPos1Value =>
      'A cada 2-10 s em marcha, 3 min fundeada';

  @override
  String get docCheatStatic5 => 'Estático (5)';

  @override
  String get docCheatStatic5Value => 'A cada 6 min';

  @override
  String get docCheatClassBPos18 => 'Posição Classe B (18)';

  @override
  String get docCheatClassBPos18Value => '~A cada 30 s';

  @override
  String get docCheatAtoN21 => 'Auxílio à navegação (21)';

  @override
  String get docCheatAtoN21Value => 'A cada 3 min';

  @override
  String get docCheatNavStatus0_15 => 'Estado de navegação (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'Em marcha com motor';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'Fundeada';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Manobrabilidade restrita';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'Amarrado';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'Encalhado';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Pesca';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'Em marcha à vela';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART ativo';

  @override
  String get docCheatMmsiFormats => 'Formatos MMSI';

  @override
  String get docCheatFixTypes => 'Tipos de correção (EPFD)';

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
      'O KikAis inclui uma referência interativa completa em cada separador — o Editor pode construir qualquer mensagem e o Descodificador pode lê-las.';

  @override
  String get docMmsiFmtDiversRadio => 'Rádio de mergulhador';

  @override
  String get docMmsiFmtShip => 'Navio';

  @override
  String get docMmsiFmtGroupShips =>
      'Grupo de navios (ex.: uma frota ou a USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Estação costeira / de terra';

  @override
  String get docMmsiFmtSarAircraft => 'Aeronave SAR';

  @override
  String get docMmsiFmtAuxCraft =>
      'Embarcação auxiliar associada a um navio-mãe';

  @override
  String get docMmsiFmtAtoN => 'Auxílio à navegação';

  @override
  String get docMmsiFmtSart => 'AIS-SART (transmissor de busca e salvamento)';

  @override
  String get docMmsiFmtMob => 'Dispositivo MOB (homem ao mar)';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB (baliza de emergência)';

  @override
  String get docVesselCat0_9 => 'Reservado / uso futuro';

  @override
  String get docVesselCat10_19 => 'Reservado para uso futuro';

  @override
  String get docVesselCat20_29 => 'Embarcação de efeito de solo (WIG)';

  @override
  String get docVesselCat30_39 => 'Pesca';

  @override
  String get docVesselCat40_49 => 'Embarcação de alta velocidade';

  @override
  String get docVesselCat50_59 =>
      'Embarcação especial (práticos, rebocadores, dragas…)';

  @override
  String get docVesselCat60_69 => 'Navios de passageiros';

  @override
  String get docVesselCat70_79 => 'Navios de carga';

  @override
  String get docVesselCat80_89 => 'Petroleiros';

  @override
  String get docVesselCat90_99 => 'Outros tipos';

  @override
  String get docTalkerAB => 'Estação AIS base';

  @override
  String get docTalkerAD => 'Estação AIS base dependente';

  @override
  String get docTalkerAI => 'Estação AIS móvel';

  @override
  String get docTalkerAN => 'Estação AIS de auxílio à navegação';

  @override
  String get docTalkerAR => 'Estação AIS recetora';

  @override
  String get docTalkerAS => 'Estação base limitada';

  @override
  String get docTalkerAT => 'Estação AIS transmissora';

  @override
  String get docTalkerAX => 'Estação AIS repetidora';

  @override
  String get docTalkerBS => 'Estação AIS base (obsoleto)';

  @override
  String get docTalkerSA => 'Estação AIS de terra física';

  @override
  String get docType1Name => 'Relatório de Posição Classe A';

  @override
  String get docType1Family => 'Relatórios de posição';

  @override
  String get docType1Summary =>
      'O cavalo de batalha do sistema: um transponder Classe A a transmitir posição, rumo, velocidade, proa e estado de navegação.';

  @override
  String get docType1EmittedBy => 'Transponders Classe A (navios SOLAS)';

  @override
  String get docType1Cadence =>
      'A cada 2-10 s em marcha, a cada 3 min fundeada';

  @override
  String get docType2Name => 'Relatório de Posição Classe A (atribuído)';

  @override
  String get docType2Family => 'Relatórios de posição';

  @override
  String get docType2Summary =>
      'Idêntico ao tipo 1, mas enviado num calendário de slots atribuído à embarcação por uma estação base (modo de atribuição).';

  @override
  String get docType2EmittedBy => 'Transponders Classe A em modo de atribuição';

  @override
  String get docType2Cadence => 'Calendário atribuído';

  @override
  String get docType3Name => 'Relatório de Posição Classe A (resposta)';

  @override
  String get docType3Family => 'Relatórios de posição';

  @override
  String get docType3Summary =>
      'Idêntico ao tipo 1, enviado como resposta a uma interrogação (tipo 15).';

  @override
  String get docType3EmittedBy =>
      'Transponders Classe A a responder a uma interrogação';

  @override
  String get docType3Cadence => 'Em interrogação';

  @override
  String get docType4Name => 'Relatório de Estação Base';

  @override
  String get docType4Family => 'Estação base & rede';

  @override
  String get docType4Summary =>
      'O relatório periódico de uma estação de terra fixa: a sua posição e a referência de data/hora UTC.';

  @override
  String get docType4EmittedBy => 'Estações base fixas';

  @override
  String get docType4Cadence => 'A cada 10 s';

  @override
  String get docType5Name => 'Dados Estáticos e de Viagem';

  @override
  String get docType5Family => 'Dados estáticos & de viagem';

  @override
  String get docType5Summary =>
      'O \"cartão de identidade\" de um navio: nome, indicativo de chamada, número IMO, tipo de navio, dimensões, calado, ETA e destino.';

  @override
  String get docType5EmittedBy => 'Transponders Classe A';

  @override
  String get docType5Cadence => 'A cada 6 min e em alteração de dados';

  @override
  String get docType6Name => 'Mensagem Binária Endereçada';

  @override
  String get docType6Family => 'Dados binários';

  @override
  String get docType6Summary =>
      'Um payload binário estruturado enviado para um MMSI de destino específico (ex.: um relatório meteorológico pedido).';

  @override
  String get docType6EmittedBy => 'Qualquer estação';

  @override
  String get docType6Cadence => 'A pedido';

  @override
  String get docType7Name => 'Confirmação Binária';

  @override
  String get docType7Family => 'Dados binários';

  @override
  String get docType7Summary =>
      'A confirmação enviada em resposta a uma mensagem binária endereçada do tipo 6.';

  @override
  String get docType7EmittedBy => 'Qualquer estação que recebeu um tipo 6';

  @override
  String get docType7Cadence => 'Em resposta';

  @override
  String get docType8Name => 'Mensagem Binária de Difusão';

  @override
  String get docType8Family => 'Dados binários';

  @override
  String get docType8Summary =>
      'Um payload binário estruturado difundido a todos — relatórios meteorológicos e hidrográficos, dados regionais ou mensagens privadas/encriptadas.';

  @override
  String get docType8EmittedBy => 'Qualquer estação';

  @override
  String get docType8Cadence => 'A pedido';

  @override
  String get docType9Name => 'Relatório de Posição Padrão de Aeronave SAR';

  @override
  String get docType9Family => 'Relatórios de posição';

  @override
  String get docType9Summary =>
      'Um relatório de posição usado por aeronaves de busca e salvamento para serem visíveis para os navios. Transporta altitude e uma gama MMSI especial (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'Aeronaves SAR';

  @override
  String get docType9Cadence => 'A cada 10 s em serviço';

  @override
  String get docType10Name => 'Pedido de UTC e Data';

  @override
  String get docType10Family => 'Estação base & rede';

  @override
  String get docType10Summary =>
      'Um pequeno pedido que solicita a uma estação específica a sua data e hora UTC.';

  @override
  String get docType10EmittedBy => 'Qualquer estação';

  @override
  String get docType10Cadence => 'A pedido';

  @override
  String get docType11Name => 'Resposta de UTC e Data';

  @override
  String get docType11Family => 'Estação base & rede';

  @override
  String get docType11Summary =>
      'Idêntico em estrutura ao tipo 4, enviado como resposta a um pedido UTC/data do tipo 10.';

  @override
  String get docType11EmittedBy => 'Estações base';

  @override
  String get docType11Cadence => 'Em pedido';

  @override
  String get docType12Name => 'Mensagem de Segurança Endereçada';

  @override
  String get docType12Family => 'Segurança & texto';

  @override
  String get docType12Summary =>
      'Uma mensagem de segurança em texto livre enviada para um único MMSI de destino (ex.: uma mensagem de socorro para a estação base mais próxima).';

  @override
  String get docType12EmittedBy => 'Qualquer estação';

  @override
  String get docType12Cadence => 'A pedido';

  @override
  String get docType13Name => 'Confirmação de Segurança';

  @override
  String get docType13Family => 'Segurança & texto';

  @override
  String get docType13Summary =>
      'A confirmação enviada em resposta a uma mensagem de segurança endereçada do tipo 12.';

  @override
  String get docType13EmittedBy => 'Qualquer estação que recebeu um tipo 12';

  @override
  String get docType13Cadence => 'Em resposta';

  @override
  String get docType14Name => 'Mensagem de Segurança de Difusão';

  @override
  String get docType14Family => 'Segurança & texto';

  @override
  String get docType14Summary =>
      'Uma difusão em texto livre dirigida a todos os que estão em alcance — avisos à navegação, socorro ou anúncios de tráfego.';

  @override
  String get docType14EmittedBy =>
      'Qualquer estação (frequentemente estações base / VTS)';

  @override
  String get docType14Cadence => 'A pedido';

  @override
  String get docType15Name => 'Interrogação';

  @override
  String get docType15Family => 'Estação base & rede';

  @override
  String get docType15Summary =>
      'Um pedido que solicita a uma ou duas estações específicas o envio de um determinado tipo de mensagem (normalmente o tipo 3 ou 5).';

  @override
  String get docType15EmittedBy => 'Estações base';

  @override
  String get docType15Cadence => 'A pedido';

  @override
  String get docType16Name => 'Comando de Modo de Atribuição';

  @override
  String get docType16Family => 'Estação base & rede';

  @override
  String get docType16Summary =>
      'Instrui até duas embarcações a transmitir numa atribuição de slots específica (modo de atribuição).';

  @override
  String get docType16EmittedBy => 'Estações base';

  @override
  String get docType16Cadence => 'A pedido';

  @override
  String get docType17Name => 'Mensagem Binária de Difusão DGNSS';

  @override
  String get docType17Family => 'Dados binários';

  @override
  String get docType17Summary =>
      'Dados de correção GNSS diferenciais difundidos por estações costeiras para melhorar a precisão de posicionamento na área coberta.';

  @override
  String get docType17EmittedBy => 'Estações de referência DGNSS';

  @override
  String get docType17Cadence => 'Periódico';

  @override
  String get docType18Name => 'Relatório de Posição CS Classe B Padrão';

  @override
  String get docType18Family => 'Relatórios de posição';

  @override
  String get docType18Summary =>
      'O relatório de posição Classe B padrão. Mais leve que o Classe A: sem estado de navegação nem taxa de rotação, mas funciona com CSTDMA.';

  @override
  String get docType18EmittedBy => 'Transponders Classe B';

  @override
  String get docType18Cadence => 'A cada 30 s (ou menos em algumas regiões)';

  @override
  String get docType19Name =>
      'Relatório de Posição Alargado de Equipamento Classe B';

  @override
  String get docType19Family => 'Relatórios de posição';

  @override
  String get docType19Summary =>
      'Um relatório de posição Classe B maior que também transporta o nome da embarcação, tipo de navio e dimensões — um híbrido estático+posição de envio único.';

  @override
  String get docType19EmittedBy => 'Transponders Classe B alargados';

  @override
  String get docType19Cadence => 'A cada 30 s';

  @override
  String get docType20Name => 'Gestão de Ligação de Dados';

  @override
  String get docType20Family => 'Estação base & rede';

  @override
  String get docType20Summary =>
      'Uma mensagem de manutenção da rede usada para alocar e reservar slots de tempo TDMA numa área.';

  @override
  String get docType20EmittedBy => 'Estações base';

  @override
  String get docType20Cadence => 'Gestão de rede';

  @override
  String get docType21Name => 'Relatório de Auxílio à Navegação';

  @override
  String get docType21Family => 'Auxílio à navegação';

  @override
  String get docType21Summary =>
      'Difunde a posição, o nome e o estado de um auxílio à navegação — bóias, balizas, faróis ou auxílios virtuais. Frequentemente enviado a partir de uma posição virtual.';

  @override
  String get docType21EmittedBy => 'Estações AtoN (reais ou virtuais)';

  @override
  String get docType21Cadence => 'A cada 3 min (ou em evento)';

  @override
  String get docType22Name => 'Gestão de Canais';

  @override
  String get docType22Family => 'Estação base & rede';

  @override
  String get docType22Summary =>
      'Usado por uma estação base para mudar as estações para canais VHF diferentes dentro de uma zona geográfica.';

  @override
  String get docType22EmittedBy => 'Estações base';

  @override
  String get docType22Cadence => 'A pedido';

  @override
  String get docType23Name => 'Comando de Atribuição de Grupo';

  @override
  String get docType23Family => 'Estação base & rede';

  @override
  String get docType23Summary =>
      'Um comando enviado por uma estação base a um grupo de embarcações dentro de uma zona, definindo intervalos de relatório e o modo de transmissão.';

  @override
  String get docType23EmittedBy => 'Estações base';

  @override
  String get docType23Cadence => 'A pedido';

  @override
  String get docType24Name => 'Relatório de Dados Estáticos';

  @override
  String get docType24Family => 'Dados estáticos & de viagem';

  @override
  String get docType24Summary =>
      'O equivalente Classe B do tipo 5, dividido em Parte A (nome) e Parte B (tipo de navio, indicativo de chamada, dimensões).';

  @override
  String get docType24EmittedBy => 'Transponders Classe B';

  @override
  String get docType24Cadence => 'A cada 6 min';

  @override
  String get docType25Name => 'Mensagem Binária de Slot Único';

  @override
  String get docType25Family => 'Dados binários';

  @override
  String get docType25Summary =>
      'Uma mensagem binária curta que cabe num único slot TDMA, com um destino e ID de aplicação opcionais.';

  @override
  String get docType25EmittedBy => 'Qualquer estação';

  @override
  String get docType25Cadence => 'A pedido';

  @override
  String get docType26Name => 'Mensagem Binária de Múltiplos Slots';

  @override
  String get docType26Family => 'Dados binários';

  @override
  String get docType26Summary =>
      'Uma mensagem binária mais longa repartida por vários slots TDMA, transportando informação de estado de rádio.';

  @override
  String get docType26EmittedBy => 'Qualquer estação';

  @override
  String get docType26Cadence => 'A pedido';

  @override
  String get docType27Name =>
      'Relatório de Posição para Aplicações de Longo Alcance';

  @override
  String get docType27Family => 'Relatórios de posição';

  @override
  String get docType27Summary =>
      'Um relatório de posição muito compacto concebido para ser recebido por satélite a longas distâncias, com resolução reduzida.';

  @override
  String get docType27EmittedBy =>
      'Embarcações em modo de longo alcance (satélite)';

  @override
  String get docType27Cadence => 'A cada 3 min (modo de longo alcance)';

  @override
  String get docTimeline1990sTitle => 'Uma invenção sueca';

  @override
  String get docTimeline1990sText =>
      'O conceito nasce na Suécia: um sistema VHF em que cada navio se anuncia para que os outros \"vejam e sejam vistos\", mesmo no nevoeiro e atrás de ilhas. É apresentado à IMO e torna-se a semente do AIS.';

  @override
  String get docTimeline1998Title => 'Começa a normalização';

  @override
  String get docTimeline1998Text =>
      'A ITU e a IEC começam a transformar o conceito num padrão de rádio com formatos de bit precisos, baseado em TDMA em dois canais VHF.';

  @override
  String get docTimeline2001Title => 'ITU-R M.1371 publicada';

  @override
  String get docTimeline2001Text =>
      'A recomendação ITU-R M.1371 \"Technical characteristics for a universal shipborne automatic identification system\" define os 27 tipos de mensagem e a sua disposição de bits.';

  @override
  String get docTimeline2002Title => 'Mandato SOLAS';

  @override
  String get docTimeline2002Text =>
      'A IMO torna o AIS obrigatório para todos os navios internacionais com arqueação bruta superior a 300 toneladas e todos os navios de passageiros — cerca de 100 000 embarcações. O AIS torna-se um auxílio anticolisão padrão juntamente com o radar.';

  @override
  String get docTimeline2006Title => 'Chega a Classe B';

  @override
  String get docTimeline2006Text =>
      'O padrão Classe B é publicado, abrindo a porta a transponders baratos e simples. No mesmo ano, o satélite TacSat-2 torna-se o primeiro a captar sinais AIS do espaço (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Constelações de satélites';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire e outros implementam recetores AIS em órbita terrestre baixa, alargando a cobertura muito para além do horizonte VHF e permitindo o seguimento quase global de embarcações.';

  @override
  String get docTimeline2010Title => 'AIS-SART no GMDSS';

  @override
  String get docTimeline2010Text =>
      'O transmissor de busca e salvamento AIS (AIS-SART, IEC 61097-14) junta-se ao Sistema Global de Socorro e Segurança Marítima, permitindo que os botes salva-vidas transmitam posições de socorro via AIS.';

  @override
  String get docTimeline2014Title => 'Pesca e frotas interiores';

  @override
  String get docTimeline2014Text =>
      'As regras europeias exigem AIS Classe A em todos os navios de pesca da UE com mais de 15 m; o AIS de vias navegáveis interiores está amplamente implementado nos rios europeus.';

  @override
  String get docTimeline2021Title => '1,6 milhões de navios';

  @override
  String get docTimeline2021Text =>
      'Mais de 1,6 milhões de embarcações estão equipadas com AIS, alimentando redes terrestres e de satélite que suportam o seguimento de navios, o controlo da pesca e a segurança marítima em todo o mundo.';

  @override
  String get docTimelineVdesTitle => 'VDES — o sucessor';

  @override
  String get docTimelineVdesText =>
      'O VHF Data Exchange System (ITU-R M.2092) está a ser implementado para aliviar áreas congestionadas, acrescentando muito mais largura de banda e serviços seguros de e-navegação.';

  @override
  String get docAppTitle => 'Documentação';

  @override
  String get docSearchChapters => 'Procurar capítulos';

  @override
  String get docChapterOverview => 'Visão Geral';

  @override
  String get docChapterHistory => 'História & regulamentação';

  @override
  String get docChapterHowItWorks => 'Como funciona';

  @override
  String get docChapterRadio => 'Rádio & TDMA';

  @override
  String get docChapterClasses => 'Classes & equipamento';

  @override
  String get docChapterMmsi => 'MMSI & identidade';

  @override
  String get docChapterShipTypes => 'Tipos de navio';

  @override
  String get docChapterMessages => 'As 27 mensagens';

  @override
  String get docChapterNmea => 'NMEA & AIVDM';

  @override
  String get docChapterPayload => 'Dentro do payload';

  @override
  String get docChapterSecurity => 'Segurança & limites';

  @override
  String get docChapterFieldNotes => 'Notas de campo';

  @override
  String get docChapterKikais => 'AIS no KikAis';

  @override
  String get docChapterGlossary => 'Glossário';

  @override
  String get docChapterCheatSheet => 'Folha de consulta rápida';

  @override
  String get docChapterSources => 'Fontes';

  @override
  String get docOverviewTitle => 'O que é o AIS?';

  @override
  String get docOverviewIntro =>
      'O Sistema de Identificação Automática (AIS) é um sistema de seguimento usado em navios e pelos serviços de tráfego de embarcações (VTS). Toda a embarcação equipada transmite continuamente a sua identidade, posição, rumo e velocidade por rádio VHF, para que todos os outros navios e estações de terra em alcance possam \"vê-lo\" — o conceito de \"ver e ser visto\".';

  @override
  String get docOverviewRadar =>
      'O AIS não substitui o radar marítimo. O radar deteta independentemente qualquer objeto, mas diz-lhe pouco sobre quem é. O AIS diz-lhe exatamente quem, onde e para onde vai — mas confia no que o emissor declara. Os dois sistemas complementam-se.';

  @override
  String get docOverviewAdsBTitle => 'Pense nisso como o ADS-B marítimo';

  @override
  String get docOverviewAdsBText =>
      'Tal como o ADS-B permite que as aeronaves se anunciem ao controlo de tráfego aéreo, o AIS permite que os navios se anunciem uns aos outros e à costa. Os navios veem o tráfego circundante num chartplotter ou num ecrã semelhante a radar; as autoridades portuárias monitorizam os movimentos e a pesca.';

  @override
  String get docOverviewTransponder => 'O que um transponder transmite';

  @override
  String get docOverviewBullet1 =>
      'Identidade única: um número MMSI de 9 dígitos (cujos três primeiros dígitos identificam o país emissor).';

  @override
  String get docOverviewBullet2 =>
      'Dados dinâmicos: posição, velocidade sobre o fundo (SOG), rumo sobre o fundo (COG), proa verdadeira, taxa de rotação, estado de navegação.';

  @override
  String get docOverviewBullet3 =>
      'Dados estáticos & de viagem: nome, indicativo de chamada, número IMO, tipo de navio, dimensões, calado, destino, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Mensagens de segurança e binárias: textos de socorro, relatórios meteorológicos, comandos de rede.';

  @override
  String get docOverviewWho => 'Quem o deve transportar';

  @override
  String get docOverviewImo =>
      'A IMO (convenção SOLAS) exige AIS em navios internacionais com arqueação bruta superior a 300 toneladas e em todos os navios de passageiros. Regras regionais alargam isto a frotas de pesca, vias navegáveis interiores e cada vez mais a embarcações de recreio através de transponders Classe B de baixo custo.';

  @override
  String get docOverviewLimits => 'Limites numa vista de olhos';

  @override
  String get docOverviewLimit1 =>
      'O alcance é aproximadamente linha de vista: cerca de 10-20 milhas náuticas entre navios, mais a partir de estações costeiras e satélites.';

  @override
  String get docOverviewLimit2 =>
      'O AIS não tem autenticação: qualquer pessoa pode transmitir qualquer identidade (spoofing) ou interferir no canal.';

  @override
  String get docOverviewLimit3 =>
      'A precisão depende da correção GNSS do emissor e da honestidade dos dados que declara.';

  @override
  String get docHistoryIntro =>
      'O AIS cresceu de uma ideia sueca para um sistema de segurança obrigatório em todo o mundo. Toque em qualquer marco do cronograma para obter detalhes.';

  @override
  String get docHistoryStandards => 'As normas que o regem';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — Technical characteristics for a universal shipborne AIS (define os 27 tipos de mensagem e a sua disposição de bits).';

  @override
  String get docHistoryStd2 =>
      'Diretrizes da IALA — esclarecimentos e orientação de implementação.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — o enquadramento das frases NMEA e os requisitos Classe B/CSTDMA.';

  @override
  String get docHistoryStd4 =>
      'IEC 61097-14 — o transmissor de socorro AIS-SART.';

  @override
  String get docHowIntro =>
      'O AIS é um sistema de rádio VHF. Cada transponder ouve o tráfego à sua volta e transmite os seus próprios relatórios em slots de tempo reservados, evitando colisões com os outros navios em alcance.';

  @override
  String get docHowRadioLink => 'A ligação de rádio';

  @override
  String get docHowRadioLink1 =>
      'Dois canais VHF dedicados: AIS 1 a 161.975 MHz (87B) e AIS 2 a 162.025 MHz (88B).';

  @override
  String get docHowRadioLink2 =>
      'FM digital de banda estreita, a 9 600 bits por segundo.';

  @override
  String get docHowRadioLink3 =>
      'As mensagens são organizadas em tramas TDMA de 2250 slots de tempo (1 minuto).';

  @override
  String get docHowSlots => 'Como os slots são partilhados';

  @override
  String get docHowSotdma =>
      'Os transponders Classe A usam SOTDMA (Self-Organizing Time Division Multiple Access): cada unidade reserva um slot repetido e re-reserva quando a imagem muda, para que os navios se coordenem continuamente sem um controlador central.';

  @override
  String get docHowCstdma =>
      'Os transponders Classe B usam o CSTDMA mais simples (Carrier Sense TDMA): ouvem à procura de um slot livre e apropriam-se dele, razão pela qual os relatórios Classe B são menos frequentes e podem perder-se em tráfego muito denso.';

  @override
  String get docHowRates => 'Taxas de emissão';

  @override
  String get docHowRates1 =>
      'Relatório de posição Classe A (tipo 1): a cada 2-10 segundos em marcha, a cada 3 minutos fundeada.';

  @override
  String get docHowRates2 =>
      'Dados estáticos & de viagem (tipo 5): a cada 6 minutos.';

  @override
  String get docHowRates3 =>
      'Posição Classe B (tipo 18): aproximadamente a cada 30 segundos.';

  @override
  String get docHowRates4 => 'Auxílio à navegação (tipo 21): a cada 3 minutos.';

  @override
  String get docHowTerrestrial => 'Terrestre e satélite';

  @override
  String get docHowTerrestrialText =>
      'À superfície, o alcance do AIS é limitado pelo horizonte VHF (T-AIS). Desde meados dos anos 2000, satélites em órbita terrestre baixa (S-AIS) recebem os mesmos sinais, dando uma cobertura quase global — os satélites aumentam, em vez de substituir, a rede terrestre.';

  @override
  String get docRadioIntro =>
      'Por baixo das mensagens encontra-se um sistema de rádio pequeno e eficiente. O AIS transmite a 9 600 bits por segundo em dois canais VHF, usando modulação de deslocamento mínimo gaussiano (GMSK) e enquadramento ao estilo HDLC.';

  @override
  String get docRadioPhysical => 'A ligação física';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 a 161.975 MHz e AIS 2 a 162.025 MHz (canais VHF 87B e 88B).';

  @override
  String get docRadioPhysical2 =>
      'Modulação GMSK a 9 600 baud — estreita o suficiente para caber na banda VHF marítima.';

  @override
  String get docRadioPhysical3 =>
      'Enquadramento HDLC com inserção de bits e codificação de linha NRZI, herdados do mundo do rádio de pacotes.';

  @override
  String get docRadioFrames => 'Tramas e slots TDMA';

  @override
  String get docRadioFrames1 =>
      'Cada canal é dividido em tramas de exatamente 1 minuto, subdivididas em 2 250 slots de tempo de ~26.7 ms cada.';

  @override
  String get docRadioFrames2 =>
      'Um slot transporta uma mensagem AIS (256 bits com subida/descida e tempo de guarda).';

  @override
  String get docRadioFrames3 =>
      'As estações reutilizam os mesmos slots em cada trama, pelo que transmitem periodicamente sem colidir.';

  @override
  String get docRadioCode =>
      '2250 slots/trama · 1 trama = 60 s · slot ≈ 26.7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — como o Classe A se auto-organiza';

  @override
  String get docRadioSotdmaText =>
      'Cada transponder Classe A ouve os slots à sua volta, escolhe um livre e anuncia no seu campo de estado de rádio quando vai transmitir a seguir. As estações re-reservam continuamente à medida que a imagem do tráfego muda, pelo que não é necessário nenhum coordenador central.';

  @override
  String get docRadioCstdma => 'CSTDMA — como o Classe B se junta';

  @override
  String get docRadioCstdmaText =>
      'As unidades Classe B são mais simples: ouvem à procura de um slot que esteja livre e transmitem uma vez nele. Isto é mais barato, mas os relatórios Classe B podem perder-se em tráfego muito denso, onde um slot está sempre ocupado.';

  @override
  String get docRadioVdes => 'VDES — o futuro';

  @override
  String get docRadioVdesText =>
      'O VHF Data Exchange System (ITU-R M.2092) está a ser implementado para aliviar águas congestionadas: acrescenta novas frequências, muito mais largura de banda e dados bidirecionais seguros para a e-navegação, juntamente com o serviço AIS existente.';

  @override
  String get docClassesIntro =>
      'O hardware AIS existe em diferentes classes e funções. As duas que encontrará com mais frequência são o transponder Classe A completo e a unidade Classe B barata.';

  @override
  String get docClassesComparison => 'Classe A vs Classe B';

  @override
  String get docClassesReceivers => 'Recetores e transponders';

  @override
  String get docClassesReceiversText =>
      'Os transponders recebem e transmitem. Muitas estações costeiras e amadores usam apenas recetores, para poderem observar o tráfego sem aparecerem nele.';

  @override
  String get docClassesAton => 'Auxílios à navegação';

  @override
  String get docClassesAtonText =>
      'As estações AtoN (tipo 21) transmitem bóias, balizas e faróis. Também podem transmitir um auxílio virtual — um marcador que só existe nos mapas, útil para avisar de um novo perigo.';

  @override
  String get docClassesDistress => 'Dispositivos de socorro & segurança';

  @override
  String get docClassesDistressIntro =>
      'Para além dos navios comuns, o AIS transporta transmissores de socorro que todos os recetores devem ser capazes de detetar:';

  @override
  String get docClassesSartNote =>
      'Um SART em ação também define o estado de navegação 14 (\"AIS-SART ativo\") no seu relatório de posição.';

  @override
  String get docShipTypesIntro =>
      'As mensagens estáticas dos tipos 5 e 24 transportam um código de tipo de navio de 8 bits (0-99) que descreve o que a embarcação é — carga, petroleiro, barco de pesca, embarcação de recreio e assim por diante. A tabela completa é mostrada abaixo.';

  @override
  String get docShipTypesCategories => 'Categorias numa vista de olhos';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle =>
      'Notas de campo e particularidades do mundo real';

  @override
  String get docFieldNotesIntro =>
      'O tráfego AIS real nem sempre corresponde à teoria. Conhecer estas particularidades ajuda-o a confiar no que o descodificador lhe mostra — e no que rejeita.';

  @override
  String get docGlossaryIntro =>
      'Um dicionário pesquisável dos acrónimos e termos usados ao longo deste guia e pela comunidade AIS.';

  @override
  String get docCheatSheetIntro =>
      'Os números e códigos essenciais numa vista de olhos — frequências, taxas de emissão, códigos de estado e formatos.';

  @override
  String get docMmsiIntro =>
      'A Identidade de Serviço Móvel Marítimo (MMSI) é um número único de 9 dígitos que identifica o equipamento de rádio de um navio, como um número de telefone para a embarcação. Os seus três primeiros dígitos são o MID — os Dígitos de Identificação Marítima que identificam o país que o emitiu.';

  @override
  String get docMmsiFormats => 'Formatos de número';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Pesquisar um MMSI';

  @override
  String get docMmsiLookupHint =>
      'Introduza um MMSI de 9 dígitos abaixo para ver a sua classe e o país da autoridade emissora.';

  @override
  String get docMmsiMidHeading => 'Códigos de país (MID)';

  @override
  String get docMmsiMidText =>
      'A tabela MID completa está incluída no KikAis e é usada em todo o lado onde um MMSI é apresentado.';

  @override
  String get docMessagesTitle => 'Os 27 tipos de mensagem';

  @override
  String get docMessagesIntro =>
      'Todo o payload AIS começa com um tipo de mensagem de 6 bits (1 a 27). O catálogo abaixo agrupa-os por família. Cada cartão mostra uma frase NMEA real gerada pelo próprio codificador do KikAis, os seus campos descodificados e um botão para a abrir no Descodificador.';

  @override
  String get docNmeaTitle => 'Enquadramento NMEA & AIVDM';

  @override
  String get docNmeaIntro =>
      'Na ligação, as mensagens AIS viajam como frases NMEA 0183 que começam por !AIVDM (outros navios) ou !AIVDO (o seu próprio navio). O payload é um vetor de bits protegido em ASCII.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Campos da frase';

  @override
  String get docNmeaField1 =>
      'Talker e formatador — !AIVDM ou !AIVDO (veja os IDs de talker abaixo).';

  @override
  String get docNmeaField2 =>
      'Contagem de fragmentos — quantas frases compõem a mensagem completa (o NMEA limita cada linha a ~82 caracteres).';

  @override
  String get docNmeaField3 =>
      'Número do fragmento — qual a parte de que se trata (a partir de 1).';

  @override
  String get docNmeaField4 =>
      'ID de mensagem sequencial — liga os fragmentos da mesma mensagem.';

  @override
  String get docNmeaField5 => 'Canal de rádio — A ou B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Payload de dados — o payload AIS protegido de seis bits.';

  @override
  String get docNmeaField7 =>
      'Bits de preenchimento — quantos bits de preenchimento foram adicionados ao último grupo de 6 bits (0-5).';

  @override
  String get docNmeaField8 =>
      'Soma de verificação — o XOR de todos os bytes antes do *, em hexadecimal.';

  @override
  String get docNmeaMulti => 'Mensagens com múltiplos fragmentos';

  @override
  String get docNmeaMultiText =>
      'As mensagens mais longas do que uma linha (como os dados estáticos do tipo 5) são divididas: a primeira frase reporta uma contagem de fragmentos de 2 e a segunda completa-a com o mesmo ID de mensagem.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Proteção de seis bits';

  @override
  String get docNmeaArmoringText =>
      'Cada carácter do payload contém 6 bits. Subtraia 48 ao código ASCII e subtraia mais 8 se o resultado estiver acima de 40.';

  @override
  String get docNmeaTalkers => 'IDs de talker';

  @override
  String get docNmeaTalkersIntro =>
      'Diferentes IDs de talker NMEA 4.0 identificam o tipo de estação AIS:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Soma de verificação';

  @override
  String get docNmeaChecksumText =>
      'A soma de verificação final é o XOR de todos os bytes entre o \"!\" e o \"*\". Calcule a sua abaixo:';

  @override
  String get docNmeaInspectorTitle => 'Experimente: inspetor de frases';

  @override
  String get docNmeaInspectorText =>
      'Cole qualquer frase AIVDM/AIVDO (ou use um dos exemplos acima) para ver os seus campos divididos e os valores descodificados.';

  @override
  String get docPayloadIntro =>
      'Depois de desfeita a proteção de seis bits, um payload AIS é uma sequência de campos de bits. Os primeiros seis bits são o tipo de mensagem; os dois seguintes são o indicador de repetição; depois vêm 30 bits de MMSI.';

  @override
  String get docPayloadCnb => 'O Bloco Comum de Navegação (tipos 1-3)';

  @override
  String get docPayloadCnbText =>
      'A disposição mais importante é partilhada pelos relatórios de posição Classe A. Use o seletor para percorrer as principais disposições de mensagens e clique num segmento para ler o que codifica.';

  @override
  String get docPayloadCoords => 'Coordenadas';

  @override
  String get docPayloadCoordsText =>
      'A latitude e a longitude são armazenadas em 1/10 000 de minuto. Divida por 600 000 para obter graus: 60 minutos num grau e 10 000 unidades por minuto. Este/Norte são positivos.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert =>
      'Converta as suas próprias coordenadas abaixo:';

  @override
  String get docPayloadSpeed => 'Velocidade, rumo, proa';

  @override
  String get docPayloadSpeed1 =>
      'SOG — velocidade sobre o fundo em décimos de nó (0-102.2 kn); 1023 significa \"não disponível\".';

  @override
  String get docPayloadSpeed2 =>
      'COG — rumo sobre o fundo em décimos de grau, relativo ao norte verdadeiro.';

  @override
  String get docPayloadSpeed3 =>
      'Proa — proa verdadeira em graus inteiros; 511 significa \"não disponível\".';

  @override
  String get docPayloadSpeed4 =>
      'ROT — taxa de rotação: valor ≈ 4.733 × √(taxa de rotação em °/min), com sinal (positivo = direita).';

  @override
  String get docPayloadNavStatus => 'Estado de navegação';

  @override
  String get docPayloadEpfd => 'Tipo de correção de posição (EPFD)';

  @override
  String get docPayloadText => 'Texto de seis bits';

  @override
  String get docPayloadTextIntro =>
      'Nomes, indicativos de chamada e destinos usam o mesmo alfabeto de seis bits que o próprio payload. As letras minúsculas não podem ser codificadas, razão pela qual os nomes AIS são normalmente em maiúsculas.';

  @override
  String get docSecurityTitle => 'Segurança & qualidade dos dados';

  @override
  String get docSecurityIntro =>
      'O AIS é concebido para cooperação, não para segurança. O canal de rádio é aberto e não encriptado, e não há autenticação de quem está a transmitir.';

  @override
  String get docSecurityThreats => 'Ameaças';

  @override
  String get docSecurityThreat1 =>
      'Spoofing — transmitir um MMSI, posição ou identidade falsos (navios-fantasma, evasão de sanções).';

  @override
  String get docSecurityThreat2 =>
      'Interferência — inundar os dois canais VHF para que o tráfego real não possa ser recebido.';

  @override
  String get docSecurityThreat3 =>
      'Meaconing — reproduzir sinais reais de outro local para confundir os recetores.';

  @override
  String get docSecurityQuality => 'Qualidade dos dados';

  @override
  String get docSecurityQuality1 =>
      'O bit de precisão de posição distingue uma correção GNSS não aumentada (> 10 m) de uma correção de qualidade DGPS (< 10 m).';

  @override
  String get docSecurityQuality2 =>
      'Os recetores devem verificar a plausibilidade das posições, velocidades e carimbos de data/hora; cerca de 0.3% das mensagens reais têm um comprimento de payload inválido.';

  @override
  String get docSecurityQuality3 =>
      'O AIS por satélite sofre ocasionalmente de colisões porque a pegada do satélite é muito maior do que uma célula TDMA — mais uma razão para correlacionar com radar e outras fontes.';

  @override
  String get docKikaisIntro =>
      'O KikAis é um laboratório AIS completo: receba tráfego real ou simulado, descodifique-o, inspecione e envie as suas próprias mensagens e construa frotas. Eis como cada separador corresponde ao que acabou de ler.';

  @override
  String get docTabReceptionText =>
      'Escolha fontes (ficheiro, série, simulação), inicie o forwarder e observe o fluxo NMEA bruto e as embarcações descodificadas.';

  @override
  String get docTabSendText =>
      'Reencaminhe as frases recebidas para um ou mais destinos TCP/UDP — como uma estação costeira distribuiria o tráfego.';

  @override
  String get docTabMapText =>
      'Veja as embarcações descodificadas traçadas a partir dos seus relatórios de posição dos tipos 1/2/3, 18, 19 e 27.';

  @override
  String get docTabEditorText =>
      'Construa qualquer um dos 27 tipos de mensagem à mão a partir de um formulário amigável e envie-o — a melhor forma de aprender os campos.';

  @override
  String get docTabDecoderText =>
      'Cole qualquer frase e obtenha os campos descodificados, a soma de verificação e o tratamento de fragmentos — o companheiro prático deste guia.';

  @override
  String get docTabStatsText =>
      'Contadores de mensagens, taxas por fonte e saúde do descodificador (somas de verificação inválidas, fragmentos descartados).';

  @override
  String get docTabSimulationText =>
      'Gere uma frota inteira em qualquer localização — todos os tipos de mensagem, esquemas MMSI, formas de zona e até injeção de erros.';

  @override
  String get docSourcesIntro =>
      'Este guia sintetiza documentação pública e autorizada:';

  @override
  String get docSources1 =>
      'gpsd — descodificação do protocolo AIVDM/AIVDO, por Eric S. Raymond (a bíblia técnica de facto para o formato das frases e os campos de bits do payload).';

  @override
  String get docSources2 =>
      'Wikipedia — Automatic Identification System (visão geral, história, aplicações, segurança).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — páginas sobre AIS.';

  @override
  String get docSources4 =>
      'Recomendação ITU-R M.1371 — a norma AIS que o rege.';

  @override
  String get docSources5 => 'IALA — esclarecimentos da ITU-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — enquadramento NMEA, Classe B e AIS-SART.';

  @override
  String get docSourcesLearn => 'Como aprender mais';

  @override
  String get docSourcesLearnText =>
      'A melhor forma de compreender o AIS é experimentar: use o Editor para construir mensagens, o Descodificador para as ler e o separador Simulação para observar uma frota inteira. Tudo neste guia é gerado pelo próprio codificador e descodificador do KikAis.';

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
  String get docOpenInDecoder => 'Abrir no Descodificador';

  @override
  String get docInspectorNmeaLabel => 'Frase NMEA';

  @override
  String get docInspectorInspect => 'Inspecionar';

  @override
  String get docInspectorInvalidChecksum => 'Soma de verificação inválida';

  @override
  String get docInspectorCouldNotDecode => 'Não foi possível descodificar';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Descodificado: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Tipo $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 dígitos)';

  @override
  String get docMmsiLookupButton => 'Pesquisar';

  @override
  String get docMmsiLookupError =>
      'Introduza um MMSI de 9 dígitos (apenas dígitos).';

  @override
  String get docMmsiLookupClassGroup => 'Grupo de navios (chamada de grupo)';

  @override
  String get docMmsiUnknownCountry => 'país desconhecido';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Abrir';

  @override
  String get updateCheckForUpdates => 'Procurar atualizações';

  @override
  String get updateChecking => 'A procurar atualizações…';

  @override
  String updateNewVersion(Object version) {
    return 'Nova versão $version';
  }

  @override
  String get updateUpToDate => 'Está atualizado.';

  @override
  String get updateCheckFailed => 'Falha ao procurar atualizações.';

  @override
  String get tooltipLanguage =>
      'Alterar o idioma da interface. Os dez idiomas estão totalmente traduzidos; escolha \"Auto\" para seguir o idioma do sistema.';

  @override
  String get tooltipTheme =>
      'Alterar o tema de cores: escuro, claro ou alto contraste. O alto contraste melhora a legibilidade.';

  @override
  String get tooltipUpdate =>
      'Verificar se existe uma nova versão. Se houver, um selo verde aparece junto ao número da versão.';

  @override
  String get tooltipMapSearch =>
      'Procurar uma embarcação por nome, MMSI ou número IMO e centrar e seguir o mapa nela.';

  @override
  String get tooltipMapFilters =>
      'Filtrar as embarcações apresentadas: por tipo, estado de navegação, país (MID), velocidade ou apenas nome.';

  @override
  String get tooltipMapCluster =>
      'Alternar o agrupamento de embarcações. Quando ativado, as embarcações próximas são agrupadas num único marcador com contagem.';

  @override
  String get tooltipMapTrails =>
      'Alternar as trilhas. Quando ativado, cada embarcação desenha o seu percurso recente no mapa.';

  @override
  String get tooltipMapVectors =>
      'Alternar os vetores de rumo. Quando ativado, cada embarcação mostra uma seta na sua direção.';

  @override
  String get tooltipMapSendToMap =>
      'Alternar o envio de embarcações descodificadas para o mapa. Quando ativado, cada embarcação descodificada aparece como marcador.';

  @override
  String get tooltipMapClear =>
      'Remove todas as embarcações atualmente no mapa.';

  @override
  String get tooltipMapBasemap =>
      'Escolher o fundo do mapa. \"Auto\" segue o tema atual.';

  @override
  String get tooltipSendAdd =>
      'Adicionar um destino de envio (UDP ou TCP, cliente ou servidor). As tramas AIS recebidas são reencaminhadas para cada destino ativado.';

  @override
  String get tooltipSendEdit =>
      'Editar o nome, protocolo, anfitrião, porta e formato de trama deste destino.';

  @override
  String get tooltipSendDelete =>
      'Eliminar este destino. Esta ação não pode ser anulada.';

  @override
  String get tooltipSendToggle =>
      'Ativar ou desativar o reencaminhamento para este destino.';

  @override
  String get tooltipSendLocked =>
      'Os destinos estão bloqueados enquanto o reencaminhador está em execução. Pare a fonte no separador Receção para os editar.';

  @override
  String get tooltipReceptionAddSource =>
      'Adicionar uma fonte de dados: um feed de rede (UDP/TCP/gpsd), um ficheiro de sentenças NMEA gravadas ou uma porta série.';

  @override
  String get tooltipReceptionStart =>
      'Iniciar a receção e o reencaminhamento de tramas AIS de todas as fontes ativadas.';

  @override
  String get tooltipReceptionStop =>
      'Parar a receção e o reencaminhamento de tramas AIS.';

  @override
  String get tooltipReceptionFeed => 'Ativar ou desativar esta fonte AIS.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Guardar o registo de ligação num ficheiro de texto.';

  @override
  String get tooltipReceptionClearLogs => 'Apagar o registo de ligação.';

  @override
  String get tooltipReceptionRemoveSource => 'Remover esta fonte AIS.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Quando ativado, as tramas com soma de verificação NMEA inválida são rejeitadas.';

  @override
  String get tooltipReceptionImportFormat =>
      'Como as tramas recebidas são normalizadas antes da descodificação.';

  @override
  String get tooltipReceptionLoop =>
      'Quando ativado, a reprodução do ficheiro recomeça do início após chegar ao fim.';

  @override
  String get tooltipReceptionSpeed =>
      'Multiplicador de velocidade de reprodução (1x = tempo real).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Atualizar a lista de portas série disponíveis.';

  @override
  String get tooltipSimApply =>
      'Aplicar as definições atuais e gerar a frota. As frotas grandes são geradas em segundo plano.';

  @override
  String get tooltipSimGenerate =>
      'Gerar uma nova frota aleatória com uma nova semente e aplicá-la.';

  @override
  String get tooltipSimOpenReception =>
      'Ir para o separador Receção para iniciar o feed de simulação.';

  @override
  String get tooltipSimRadius =>
      'Raio da zona de navegação em torno do centro, em quilómetros.';

  @override
  String get tooltipSimVessels => 'Número de embarcações a gerar na frota.';

  @override
  String get tooltipSimSpeedMin => 'Velocidade mínima das embarcações, em nós.';

  @override
  String get tooltipSimSpeedMax => 'Velocidade máxima das embarcações, em nós.';

  @override
  String get tooltipSimInterval => 'Atraso entre duas emissões, em segundos.';

  @override
  String get tooltipSimSeed =>
      'Semente aleatória. A mesma semente produz sempre a mesma frota.';

  @override
  String get tooltipSimAnchored =>
      'Percentagem de embarcações fundeadas ou atracadas em vez de em movimento.';

  @override
  String get tooltipSimNamePrefix =>
      'Prefixo usado para os nomes das embarcações geradas.';

  @override
  String get tooltipSimMmsiMid =>
      'Dígitos de identificação marítima (código de país de 3 dígitos) para construir os MMSI.';

  @override
  String get tooltipSimCenterLat => 'Latitude do centro da zona de navegação.';

  @override
  String get tooltipSimCenterLon => 'Longitude do centro da zona de navegação.';

  @override
  String get tooltipSimTransit =>
      'Percentagem de embarcações que atravessam a zona em rota direta.';

  @override
  String get tooltipSimRegenEvery =>
      'Regenerar a frota a cada N emissões quando a regeneração periódica está ativada.';

  @override
  String get tooltipSimReportInterval =>
      'Intervalo máximo do relatório de posição por embarcação, em emissões.';

  @override
  String get tooltipSimWander =>
      'Intensidade da deriva aleatória do rumo (0 = linhas retas).';

  @override
  String get tooltipSimClassBShare =>
      'Percentagem de relatórios de posição classe B face à classe A quando ambos estão ativados.';

  @override
  String get tooltipSimErrorRate =>
      'Probabilidade de corromper ou duplicar cada sentença emitida.';

  @override
  String get tooltipSimBaseStations => 'Número de estações base fixas a gerar.';

  @override
  String get tooltipSimAtoN =>
      'Número de ajudas à navegação (balizas) fixas a gerar.';

  @override
  String get tooltipSimRealisticNames =>
      'Usar nomes, indicativos e destinos de embarcações realistas.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Escalar as dimensões e o calado consoante o tipo de embarcação.';

  @override
  String get tooltipSimRealisticMmsi =>
      'Construir MMSI que sigam a estrutura ITU por categoria de embarcação.';

  @override
  String get tooltipSimVarySpeed =>
      'Deixar a velocidade variar suavemente dentro do intervalo configurado.';

  @override
  String get tooltipSimSpeedByType =>
      'Escolher a velocidade do intervalo típico de cada tipo de embarcação.';

  @override
  String get tooltipSimHighAccuracy =>
      'Definir o indicador de posição de alta precisão nos relatórios emitidos.';

  @override
  String get tooltipSimRealisticRot =>
      'Emitir uma taxa de rotação derivada da alteração de rumo.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Regenerar automaticamente a frota a cada N emissões para simular tráfego variável.';

  @override
  String get tooltipSimInjectErrors =>
      'Corromper ou duplicar algumas sentenças emitidas para testar o tratamento de erros.';

  @override
  String get tooltipSimNmea4Tag =>
      'Prefaciar cada trama emitida com um bloco de etiqueta NMEA 4.0.';

  @override
  String get tooltipSimVesselType =>
      'Incluir este tipo de embarcação na frota.';

  @override
  String get tooltipSimMessageType => 'Emitir este tipo de mensagem AIS.';

  @override
  String get tooltipDecoderClear =>
      'Limpar a entrada e os resultados do descodificador.';

  @override
  String get tooltipStatsDecode =>
      'Pausar ou retomar a descodificação das tramas AIS recebidas.';

  @override
  String get tooltipStatsReset =>
      'Repor todos os contadores de estatísticas a zero.';

  @override
  String get tooltipDocOpenTab => 'Abrir esta secção no seu próprio separador.';

  @override
  String get tooltipEditorInject =>
      'Injetar a mensagem composta no descodificador como se tivesse sido recebida.';

  @override
  String get tooltipEditorSend =>
      'Enviar a mensagem composta para cada destino de envio ativado.';

  @override
  String get tooltipCopy => 'Copiar para a área de transferência.';

  @override
  String get tooltipClose => 'Fechar este painel.';

  @override
  String get tooltipBrowse => 'Procurar um ficheiro.';

  @override
  String get tooltipFeedName =>
      'Um rótulo que identifica esta fonte na lista de feeds.';

  @override
  String get tooltipFeedHost =>
      'Endereço do servidor que transmite sentenças AIS.';

  @override
  String get tooltipFeedPort =>
      'Porta TCP ou UDP usada para alcançar o servidor.';

  @override
  String get tooltipFeedHeader =>
      'Bytes opcionais enviados ao conectar, antes de ler (ex. um pedido gpsd).';

  @override
  String get tooltipFeedFile =>
      'Caminho para um arquivo de texto com sentenças NMEA gravadas.';

  @override
  String get tooltipFeedInterval =>
      'Atraso entre dois quadros ao reproduzir o arquivo.';

  @override
  String get tooltipFeedLoop =>
      'Reinicia a reprodução do arquivo desde o início quando o fim é alcançado.';

  @override
  String get tooltipFeedSpeed =>
      'Multiplicador de velocidade de reprodução (1x = tempo real).';

  @override
  String get tooltipFeedSerialPort =>
      'Porta serial do receptor AIS (ex. COM3 ou /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Baud rate usado para falar com o receptor AIS serial.';

  @override
  String get tooltipFeedRtlDevice =>
      'O dongle RTL-SDR usado para receber AIS em VHF.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Deixa o sintonizador ajustar o ganho automaticamente. Recomendado para a maioria.';

  @override
  String get tooltipFeedRtlGain =>
      'Ganho fixo do sintonizador em decibéis, usado com o ganho automático desativado.';

  @override
  String get tooltipFeedRtlChannels =>
      'Quais canais VHF AIS decodificar: A (161,975 MHz), B (162,025 MHz) ou ambos.';

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
