// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get languageSystem => '自动（系统）';

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
  String get themeDark => '深色';

  @override
  String get themeLight => '浅色';

  @override
  String get themeHighContrast => '高对比度';

  @override
  String get tabReception => '接收';

  @override
  String get tabSend => '发送';

  @override
  String get tabMap => '地图';

  @override
  String get tabEditor => '编辑器';

  @override
  String get tabDecoder => '解码器';

  @override
  String get tabStats => '统计';

  @override
  String get tabSimulation => '仿真';

  @override
  String get tabDocs => '文档';

  @override
  String get protocolUdpServer => 'UDP 服务器';

  @override
  String get protocolUdpClient => 'UDP 客户端';

  @override
  String get protocolTcpClient => 'TCP 客户端';

  @override
  String get protocolTcpServer => 'TCP 服务器';

  @override
  String get formatPassthrough => '直通';

  @override
  String get formatStrip => '去除标签块';

  @override
  String get formatTag => '添加标签块';

  @override
  String get sendAddDestination => '添加目标';

  @override
  String get sendEditDestination => '编辑目标';

  @override
  String get sendFormat => '发送格式';

  @override
  String get sendSave => '保存';

  @override
  String get sendLockedBanner => '转发器正在运行 — 目标已锁定。';

  @override
  String get sendEmpty => '尚无目标。添加一个以转发接收到的 AIS 报文。';

  @override
  String get fieldName => '名称';

  @override
  String get fieldProtocol => '协议';

  @override
  String get fieldHost => '主机';

  @override
  String get fieldPort => '端口';

  @override
  String get fieldTagSourceId => '标签源 ID';

  @override
  String get fieldFile => '文件';

  @override
  String get fieldCancel => '取消';

  @override
  String get fieldAdd => '添加';

  @override
  String get receptionFeeds => '数据源';

  @override
  String get receptionValidateChecksums => '校验 NMEA 校验和';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '丢弃 $count 条语句',
      one: '丢弃 1 条语句',
      zero: '无语句被丢弃',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => '导入帧格式';

  @override
  String get receptionStart => '开始';

  @override
  String get receptionStop => '停止';

  @override
  String get receptionLogs => '日志';

  @override
  String get receptionFrameCopied => '帧已复制';

  @override
  String get receptionAddSource => '添加数据源';

  @override
  String get receptionNetwork => '网络';

  @override
  String get receptionFile => '文件';

  @override
  String get receptionSerial => '串口';

  @override
  String get receptionHeaderOptional => '头部（可选）';

  @override
  String get receptionPathOrBrowse => '路径或浏览…';

  @override
  String get receptionIntervalMs => '帧间隔（毫秒）';

  @override
  String get receptionReplayTimestamps => '按文件时间戳回放';

  @override
  String get receptionReplayTimestampsHint => '按记录的时间（标签块 t: 或时间戳前缀）播放，而非固定间隔';

  @override
  String get receptionSpeed => '速度';

  @override
  String get receptionReplayLoop => '循环（从头回放）';

  @override
  String get receptionSerialPort => '串口端口';

  @override
  String get receptionSerialPortHint => '例如 COM3 或 /dev/ttyUSB0';

  @override
  String get receptionBaudRate => '波特率';

  @override
  String get msgType1 => 'A 类位置报告';

  @override
  String get msgType2 => 'A 类位置报告（指派）';

  @override
  String get msgType3 => 'A 类位置报告（应答）';

  @override
  String get msgType4 => '基站';

  @override
  String get msgType5 => '静态与航次相关数据';

  @override
  String get msgType6 => '二进制定向报文';

  @override
  String get msgType7 => '二进制应答';

  @override
  String get msgType8 => '二进制广播报文';

  @override
  String get msgType9 => '标准搜救飞机位置报告';

  @override
  String get msgType10 => 'UTC/日期查询';

  @override
  String get msgType11 => 'UTC/日期应答';

  @override
  String get msgType12 => '定向安全相关报文';

  @override
  String get msgType13 => '安全应答';

  @override
  String get msgType14 => '安全广播报文';

  @override
  String get msgType15 => '询问';

  @override
  String get msgType16 => '指派模式命令';

  @override
  String get msgType17 => 'DGNSS 二进制广播报文';

  @override
  String get msgType18 => '标准 B 类 CS 位置报告';

  @override
  String get msgType19 => '扩展 B 类设备位置报告';

  @override
  String get msgType20 => '数据链路管理报文';

  @override
  String get msgType21 => '助航设施报告';

  @override
  String get msgType22 => '信道管理';

  @override
  String get msgType23 => '组指派命令';

  @override
  String get msgType24 => '静态数据报告';

  @override
  String get msgType25 => '单时隙二进制报文';

  @override
  String get msgType26 => '多时隙二进制报文';

  @override
  String get msgType27 => '远距离应用位置报告';

  @override
  String get statsTitle => '统计';

  @override
  String get statsFeed => '数据源';

  @override
  String get statsAllFeeds => '所有数据源';

  @override
  String get statsReceived => '已接收';

  @override
  String get statsDecoded => '已解码';

  @override
  String get statsInvalidChecksums => '无效校验和';

  @override
  String get statsDroppedFragments => '丢弃的分段';

  @override
  String get statsParseErrors => '解析错误';

  @override
  String get statsPendingFragments => '待处理分段';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '（所有数据源）';

  @override
  String get statsReceivedVsDecoded => '接收 vs 解码（最近 60 秒）';

  @override
  String get statsPerSecondLabel => '每秒';

  @override
  String get statsAccounting => '统计口径';

  @override
  String get statsMultiPartParts => '多段部分';

  @override
  String get statsPending => '待处理';

  @override
  String get statsDropped => '已丢弃';

  @override
  String get statsReconcile => '接收与解码数量一致。';

  @override
  String get statsGapPaused => '差额包含解码暂停期间接收的语句。';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return '接收 $received = $sum';
  }

  @override
  String get statsByMessageType => '按报文类型';

  @override
  String get statsNoDecodedYet => '暂无已解码报文';

  @override
  String statsTypeFallback(Object type) {
    return '类型 $type';
  }

  @override
  String get statsByFeed => '按数据源';

  @override
  String statsFeedFilter(Object filter) {
    return '数据源：$filter';
  }

  @override
  String get statsNoActivityYet => '暂无数据源活动';

  @override
  String get statsCollecting => '采集中…';

  @override
  String get simVesselCargo => '货船';

  @override
  String get simVesselTanker => '油轮';

  @override
  String get simVesselFishing => '渔船';

  @override
  String get simVesselSailing => '帆船';

  @override
  String get simVesselPassenger => '客船';

  @override
  String get simVesselTug => '拖轮';

  @override
  String get simVesselHsc => '高速船';

  @override
  String get simVesselOther => '其他';

  @override
  String get simType1 => '位置报告（1/2/3）';

  @override
  String get simType5 => '静态与航次（5）';

  @override
  String get simType9 => '搜救飞机（9）';

  @override
  String get simType18 => 'B 类位置（18）';

  @override
  String get simType19 => 'B 类扩展（19）';

  @override
  String get simType27 => '远距离（27）';

  @override
  String get simType4 => '基站（4）';

  @override
  String get simType21 => '助航设施（21）';

  @override
  String get simType8 => '气象广播（8）';

  @override
  String get simType11 => 'UTC/日期应答（11）';

  @override
  String get simType12 => '安全定向（12）';

  @override
  String get simType14 => '安全广播（14）';

  @override
  String get simType22 => '信道管理（22）';

  @override
  String get simType23 => '组指派（23）';

  @override
  String get simType24 => 'B 类静态（24）';

  @override
  String get simTitle => '仿真';

  @override
  String get simInfoBanner => '当在“接收”选项卡启用“仿真”数据源且转发器正在运行时，即会发出舰队。';

  @override
  String get simOpenReception => '打开接收';

  @override
  String get simFleetSection => '舰队';

  @override
  String get simRadiusKm => '半径（千米）';

  @override
  String get simVessels => '船舶数量';

  @override
  String get simSpeedMinKn => '最低航速（kn）';

  @override
  String get simSpeedMaxKn => '最高航速（kn）';

  @override
  String get simIntervalS => '间隔（秒）';

  @override
  String get simSeed => '随机种子';

  @override
  String get simAnchoredPct => '锚泊比例（%）';

  @override
  String get simNamePrefix => '名称前缀';

  @override
  String get simMmsiMid => 'MMSI 国家 / MID';

  @override
  String get simSearchMmid => '搜索国家或输入 3 位 MID';

  @override
  String get simCustom => '自定义';

  @override
  String get simVesselTypes => '船舶类型';

  @override
  String get simRealisticNames => '真实风格名称';

  @override
  String get simRealisticDimensions => '真实尺寸';

  @override
  String get simRealisticMmsi => '符合 ITU 规范的 MMSI';

  @override
  String get simZoneSection => '区域与交通';

  @override
  String get simLocationPreset => '位置预设';

  @override
  String get simSearchPort => '搜索港口…';

  @override
  String get simCenterLat => '中心纬度';

  @override
  String get simCenterLon => '中心经度';

  @override
  String get simZoneShape => '区域形状';

  @override
  String get simTransitPct => '过境比例（%）';

  @override
  String get simRegeneratePeriodically => '定期重新生成';

  @override
  String get simRegenerateTicks => '重新生成（tick 数）';

  @override
  String get simPresetHint => '选择预设以填充坐标，或直接输入中心纬度 / 经度。';

  @override
  String get simMovementSection => '运动与发射';

  @override
  String get simVarySpeed => '随时间变化航速';

  @override
  String get simReportIntervalTicks => '报告间隔（tick 数）';

  @override
  String get simWander => '漂移幅度（0-3）';

  @override
  String get simSpeedByType => '按船舶类型设定航速';

  @override
  String get simClassBSharePct => 'B 类占比（%）';

  @override
  String get simHighAccuracy => '高精度';

  @override
  String get simRealisticRot => '真实回转速率';

  @override
  String get simContentSection => '内容';

  @override
  String get simSafetyTexts => '安全文本（每行一条）';

  @override
  String get simDestinations => '目的港（每行一条）';

  @override
  String get simStationsSection => '台站';

  @override
  String get simBaseStations => '基站';

  @override
  String get simAtoN => '助航设施';

  @override
  String get simQualitySection => '传输质量';

  @override
  String get simInjectErrors => '注入错误';

  @override
  String get simErrorRatePct => '错误率（%）';

  @override
  String get simTalkerId => '通话器 ID';

  @override
  String get simNmea4Tag => 'NMEA 4.0 标签块';

  @override
  String get simMessagesSection => '报文';

  @override
  String get simApplyFleet => '应用舰队';

  @override
  String get simRegenerateFleet => '重新生成舰队';

  @override
  String get simGenerating => '正在生成…';

  @override
  String get simLiveFleet => '实时舰队';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats 艘船 · 发出 $frames 帧';
  }

  @override
  String get mapSearchVessels => '搜索船舶';

  @override
  String get mapSearchHint => '名称、MMSI 或 IMO';

  @override
  String get mapNoResults => '无结果';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => '筛选';

  @override
  String mapAllLabel(Object label) {
    return '全部 $label';
  }

  @override
  String get mapVesselType => '船舶类型';

  @override
  String get mapNavigationStatus => '航行状态';

  @override
  String get mapCountry => '国家';

  @override
  String get mapMinSog => '最小 SOG（kn）';

  @override
  String get mapMaxSog => '最大 SOG（kn）';

  @override
  String get mapOnlyNamed => '仅显示有名称的船舶';

  @override
  String get mapReset => '重置';

  @override
  String get mapApply => '应用';

  @override
  String get mapAutoBasemap => '自动（跟随主题）';

  @override
  String mapFollowing(Object mmsi) {
    return '正在跟踪 $mmsi';
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
  String get basemapVoyagerLight => 'Voyager（浅色）';

  @override
  String get basemapPositronLight => 'Positron（浅色极简）';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Esri 卫星影像';

  @override
  String get basemapEsriStreets => 'Esri 世界街道地图';

  @override
  String get decoderInputLabel => '粘贴或输入一条或多条 NMEA AIS 语句';

  @override
  String get decoderValidateChecksums => '校验校验和';

  @override
  String get decoderDecode => '解码';

  @override
  String get decoderDecoded => '已解码';

  @override
  String decoderDecodedN(Object n) {
    return '已解码（$n 条语句）';
  }

  @override
  String get decoderInvalidChecksum => '无效校验和';

  @override
  String get decoderParseError => '解析错误';

  @override
  String get decoderWaitingFragments => '等待更多分段…';

  @override
  String decoderTagSource(Object id) {
    return '源 $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return '标签块 · $content';
  }

  @override
  String get fMessageType => '报文类型';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => '重复指示器';

  @override
  String get fNavStatus => '航行状态';

  @override
  String get fLatitude => '纬度';

  @override
  String get fLongitude => '经度';

  @override
  String get fSogKn => 'SOG（kn）';

  @override
  String get fCogDeg => 'COG（°）';

  @override
  String get fHeadingDeg => '航向（°）';

  @override
  String get fRateOfTurn => '回转速率';

  @override
  String get fManeuver => '操纵状态';

  @override
  String get fTimestamp => '时间戳';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => '精度';

  @override
  String get fEpfdFixType => 'EPFD 定位类型';

  @override
  String get fSyncState => '同步状态';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => '呼号';

  @override
  String get fVesselName => '船名';

  @override
  String get fShipType => '船舶类型';

  @override
  String get fShipTypeText => '船舶类型（文本）';

  @override
  String get fDims => '船首/船尾/左舷/右舷（m）';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => '吃水（m）';

  @override
  String get fDestination => '目的港';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => '目的 MMSI';

  @override
  String get fSeqNumber => '序号';

  @override
  String get fRetransmit => '重发';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => '数据';

  @override
  String get fAltitudeM => '高度（m）';

  @override
  String get fAssignedMode => '指派模式';

  @override
  String get fRegionalReserved => '区域保留';

  @override
  String get fText => '文本';

  @override
  String fStationN(Object n) {
    return '台站 $n';
  }

  @override
  String fSlotN(Object n) {
    return '时隙 $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return '偏移 $offset · 数量 $number · 超时 $timeout · 增量 $increment';
  }

  @override
  String get fAidType => '助航类型';

  @override
  String get fAidTypeCode => '助航类型（代码）';

  @override
  String get fName => '名称';

  @override
  String get fNameExt => '名称扩展';

  @override
  String get fVirtualAid => '虚拟助航';

  @override
  String get fOffPosition => '偏移位置';

  @override
  String get fSecond => '秒';

  @override
  String get fChannelA => '信道 A';

  @override
  String get fChannelB => '信道 B';

  @override
  String get fTxRxMode => 'TX/RX 模式';

  @override
  String get fPower => '功率';

  @override
  String get fZone => '区域';

  @override
  String get fAddressed => '定向';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => '频段 A';

  @override
  String get fBandB => '频段 B';

  @override
  String get fZoneSize => '区域大小';

  @override
  String get fStationType => '台站类型';

  @override
  String get fReportInterval => '报告间隔';

  @override
  String get fQuietTime => '静默时间';

  @override
  String get fPart => '部分';

  @override
  String get fVendorId => '厂商 ID';

  @override
  String get fUnitModel => '设备型号';

  @override
  String get fSerialNumber => '序列号';

  @override
  String get fMothershipMmsi => '母船 MMSI';

  @override
  String get fRadioStatus => '无线电状态';

  @override
  String get fGnssStatus => 'GNSS 位置状态';

  @override
  String fDestN(Object n) {
    return '目的 $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi 序号 $seq';
  }

  @override
  String get fDestIndicator => '目的指示器';

  @override
  String get fBinaryDataFlag => '二进制数据标志';

  @override
  String get fApplicationId => '应用 ID';

  @override
  String get fPowerHigh => '高';

  @override
  String get fPowerLow => '低';

  @override
  String get fPartA => 'A（名称）';

  @override
  String get fPartB => 'B（船舶数据）';

  @override
  String get editorTitle => 'AIS 报文编辑器';

  @override
  String get editorCompose => '编写报文';

  @override
  String get editorMessageType => '报文类型';

  @override
  String get editorAddTagBlock => '添加 NMEA 4.0 标签块';

  @override
  String get editorSourceId => '源 ID';

  @override
  String get editorInjectToMap => '注入地图';

  @override
  String get editorSendToTarget => '发送到目标';

  @override
  String get editorPreview => 'NMEA 预览';

  @override
  String get editorNmeaCopied => 'NMEA 已复制';

  @override
  String get editorInjected => '报文已注入';

  @override
  String get editorSentToTarget => '报文已发送到目标';

  @override
  String get editorNavStatus0_15 => '航行状态（0-15）';

  @override
  String get editorYear => '年';

  @override
  String get editorMonth => '月';

  @override
  String get editorDay => '日';

  @override
  String get editorHour => '时';

  @override
  String get editorMinute => '分';

  @override
  String get editorSecond => '秒';

  @override
  String get editorImoNumber => 'IMO 编号';

  @override
  String get editorBowM => '船首（m）';

  @override
  String get editorSternM => '船尾（m）';

  @override
  String get editorPortM => '左舷（m）';

  @override
  String get editorStarboardM => '右舷（m）';

  @override
  String get editorEtaMonth => 'ETA 月';

  @override
  String get editorEtaDay => 'ETA 日';

  @override
  String get editorEtaHour => 'ETA 时';

  @override
  String get editorEtaMinute => 'ETA 分';

  @override
  String get editorSequence0_3 => '序号（0-3）';

  @override
  String get editorDataBytes => '数据字节（十六进制或 1,2,3）';

  @override
  String get editorDestMmsisComma => '目的 MMSI（逗号分隔）';

  @override
  String get editorSequencesComma => '序号（逗号分隔）';

  @override
  String get editorInterrogatedMmsi => '被询问 MMSI';

  @override
  String get editorType1 => '类型 1';

  @override
  String get editorOffset1 => '偏移 1';

  @override
  String get editorTargetMmsi => '目标 MMSI';

  @override
  String get editorOffset => '偏移';

  @override
  String get editorIncrement => '增量';

  @override
  String get editorNumber => '数量';

  @override
  String get editorTimeout => '超时';

  @override
  String get editorAidType0_31 => '助航类型（0-31）';

  @override
  String get editorVirtualAid0_1 => '虚拟助航（0/1）';

  @override
  String get editorTxRxMode0_15 => 'Tx/Rx 模式（0-15）';

  @override
  String get editorTxRxMode0_3 => 'Tx/Rx 模式（0-3）';

  @override
  String get editorNeLat => '东北纬度';

  @override
  String get editorNeLon => '东北经度';

  @override
  String get editorSwLat => '西南纬度';

  @override
  String get editorSwLon => '西南经度';

  @override
  String get editorInterval0_15 => '间隔（0-15）';

  @override
  String get editorPart => '部分（0 = A 名称，1 = B 静态）';

  @override
  String get editorDestMmsiEmpty => '目的 MMSI（空 = 广播）';

  @override
  String get editorAppDacEmpty => '应用 DAC（空 = 无）';

  @override
  String get editorAppFidEmpty => '应用 FID（空 = 无）';

  @override
  String get nmeaTalker => '通话器';

  @override
  String get nmeaFragments => '分段';

  @override
  String get nmeaFragmentN => '分段 #';

  @override
  String get nmeaMessageId => '报文 ID';

  @override
  String get nmeaChannel => '信道';

  @override
  String get nmeaPayload => '载荷';

  @override
  String get nmeaFillBits => '填充位';

  @override
  String get nmeaTagBlock => '标签块';

  @override
  String get nmeaChecksum => '校验和';

  @override
  String get nmeaEmpty => '（空）';

  @override
  String get bubbleKindVessel => '船舶';

  @override
  String get bubbleKindAircraft => '搜救飞机';

  @override
  String get bubbleKindAton => '助航设施';

  @override
  String get bubbleKindStation => '基站';

  @override
  String get bubbleGeneralInfo => '基本信息';

  @override
  String get bubbleKind => '类型';

  @override
  String get bubbleAidType => '助航类型';

  @override
  String get bubbleVirtual => '虚拟';

  @override
  String get bubbleAltitude => '高度';

  @override
  String get bubbleCallSign => '呼号';

  @override
  String get bubblePosNav => '位置与导航';

  @override
  String get bubbleHeading => '航向';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => '船舶详情';

  @override
  String get bubbleType => '类型';

  @override
  String get bubbleTypeInt => '类型（整数）';

  @override
  String get bubbleDimsBowStern => '尺寸 船首/船尾';

  @override
  String get bubbleDimsPortStarboard => '尺寸 左舷/右舷';

  @override
  String get bubbleSpare => '备用';

  @override
  String get bubbleDraught => '吃水';

  @override
  String bubbleFrames(Object n) {
    return '帧（$n）';
  }

  @override
  String get bubbleNoFrames => '暂无帧';

  @override
  String get copied => '已复制';

  @override
  String get textFiles => '文本文件';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return '目标 $name 已连接（$protocol $host:$port）。';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return '连接目标 $name 失败：$error';
  }

  @override
  String get logStopping => '正在停止转发器…';

  @override
  String get logStopped => '转发器已停止。';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return '已添加数据源：$name（$host:$port）';
  }

  @override
  String logFeedRemoved(Object name) {
    return '已移除数据源：$name';
  }

  @override
  String logFeedConnected(Object name) {
    return '数据源 $name 已连接。';
  }

  @override
  String logFeedDisconnected(Object name) {
    return '数据源 $name 已断开。5 秒后重新连接…';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return '连接数据源 $name 失败：$error。5 秒后重试…';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return '目标 $name：TCP 服务器正在监听端口 $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return '目标 $name：客户端已连接 $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return '目标 $name：客户端已断开';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return '目标 $name：客户端错误 $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return '目标 $name 发送错误：$error';
  }

  @override
  String get docNavStatus0 => '使用发动机航行';

  @override
  String get docNavStatus1 => '锚泊';

  @override
  String get docNavStatus2 => '失控';

  @override
  String get docNavStatus3 => '操纵受限';

  @override
  String get docNavStatus4 => '受吃水限制';

  @override
  String get docNavStatus5 => '系泊';

  @override
  String get docNavStatus6 => '搁浅';

  @override
  String get docNavStatus7 => '捕捞作业中';

  @override
  String get docNavStatus8 => '航行中（帆船）';

  @override
  String get docNavStatus9 => '保留（高速船）';

  @override
  String get docNavStatus10 => '保留（地效翼船）';

  @override
  String get docNavStatus11 => '船尾拖带（区域）';

  @override
  String get docNavStatus12 => '顶推 / 并排拖带（区域）';

  @override
  String get docNavStatus13 => '保留备用';

  @override
  String get docNavStatus14 => 'AIS-SART 激活';

  @override
  String get docNavStatus15 => '未定义（默认）';

  @override
  String get docEpfd0 => '未定义（默认）';

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
  String get docEpfd6 => '综合导航系统';

  @override
  String get docEpfd7 => '已测量（固定）';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => '内置 GNSS';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · 位 $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '共 $fields 个字段 · 共 $bits 位 · 点按某一段';
  }

  @override
  String get docTextToEncode => '要编码的文本';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      '每个字符对应一个 6 位值（\"@\" = 0，空格 = 32，\"A\" = 1…）。小写字母无法编码，通常以大写形式发送。';

  @override
  String get docChecksumBody => '报文主体（不含开头的 ! 和结尾的 *XX）';

  @override
  String get docChecksumExplanation => 'NMEA 校验和是 \"!\" 与 \"*\" 之间每个字节的异或。';

  @override
  String get docLatitude => '纬度';

  @override
  String get docLongitude => '经度';

  @override
  String get docLatitudeInvalid => '纬度：请输入数字';

  @override
  String get docLongitudeInvalid => '经度：请输入数字';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return '纬度 → $value（27 位有符号，度 = $deg / 600000）';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return '经度 → $value（28 位有符号，度 = $deg / 600000）';
  }

  @override
  String get docCoordsExplanation => '坐标以分的 1/10 000 存储：除以 600 000 即可换算为度。';

  @override
  String get docSearchShipTypes => '搜索船舶类型';

  @override
  String get docShipCat0_19 => '0-19 · 保留';

  @override
  String get docShipCat20_29 => '20-29 · 地效翼船（WIG）';

  @override
  String get docShipCat30_39 => '30-39 · 渔船';

  @override
  String get docShipCat40_49 => '40-49 · 高速船';

  @override
  String get docShipCat50_59 => '50-59 · 特种船舶';

  @override
  String get docShipCat60_69 => '60-69 · 客船';

  @override
  String get docShipCat70_79 => '70-79 · 货船';

  @override
  String get docShipCat80_89 => '80-89 · 油轮';

  @override
  String get docShipCat90_99 => '90-99 · 其他';

  @override
  String get docSearchGlossary => '搜索术语表';

  @override
  String get docNoMatchingTerms => '没有匹配的术语。';

  @override
  String get docAspect => '方面';

  @override
  String get docClassA => 'A 类';

  @override
  String get docClassB => 'B 类';

  @override
  String get docCheatRadio => '无线电';

  @override
  String get docCheatFrequencies => '频率';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz (87B) · AIS2 162.025 MHz (88B)';

  @override
  String get docCheatModulation => '调制';

  @override
  String get docCheatModulationValue => 'GMSK，9 600 bit/s';

  @override
  String get docCheatRange => '作用距离';

  @override
  String get docCheatRangeValue => '船对船约 10-20 海里，视距范围';

  @override
  String get docCheatReportingRates => '报告频率';

  @override
  String get docCheatClassAPos1 => 'A 类位置（1）';

  @override
  String get docCheatClassAPos1Value => '航行中每 2-10 秒，锚泊时每 3 分钟';

  @override
  String get docCheatStatic5 => '静态（5）';

  @override
  String get docCheatStatic5Value => '每 6 分钟';

  @override
  String get docCheatClassBPos18 => 'B 类位置（18）';

  @override
  String get docCheatClassBPos18Value => '约每 30 秒';

  @override
  String get docCheatAtoN21 => '助航设施（21）';

  @override
  String get docCheatAtoN21Value => '每 3 分钟';

  @override
  String get docCheatNavStatus0_15 => '航行状态（0-15）';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => '使用发动机航行';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => '锚泊';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => '操纵受限';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => '系泊';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => '搁浅';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => '捕捞作业';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => '航行中（帆船）';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART 激活';

  @override
  String get docCheatMmsiFormats => 'MMSI 格式';

  @override
  String get docCheatFixTypes => '定位类型（EPFD）';

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
  String get docCheatEpfd15Value => '内置 GNSS';

  @override
  String get docCheatFooter =>
      'KikAis 在每个选项卡中都内置了完整的交互式参考 — 编辑器可构建任何报文，解码器可将其读回。';

  @override
  String get docMmsiFmtDiversRadio => '潜水员电台';

  @override
  String get docMmsiFmtShip => '船舶';

  @override
  String get docMmsiFmtGroupShips => '船舶组（例如船队或美国海岸警卫队）';

  @override
  String get docMmsiFmtCoastalShore => '海岸 / 岸站';

  @override
  String get docMmsiFmtSarAircraft => '搜救飞机';

  @override
  String get docMmsiFmtAuxCraft => '与母船关联的辅助船艇';

  @override
  String get docMmsiFmtAtoN => '助航设施';

  @override
  String get docMmsiFmtSart => 'AIS-SART（搜救发射机）';

  @override
  String get docMmsiFmtMob => 'MOB（落水人员）设备';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB（应急示位标）';

  @override
  String get docVesselCat0_9 => '保留 / 备用';

  @override
  String get docVesselCat10_19 => '保留备用';

  @override
  String get docVesselCat20_29 => '地效翼船（WIG）';

  @override
  String get docVesselCat30_39 => '渔船';

  @override
  String get docVesselCat40_49 => '高速船';

  @override
  String get docVesselCat50_59 => '特种船舶（引航船、拖轮、挖泥船…）';

  @override
  String get docVesselCat60_69 => '客船';

  @override
  String get docVesselCat70_79 => '货船';

  @override
  String get docVesselCat80_89 => '油轮';

  @override
  String get docVesselCat90_99 => '其他类型';

  @override
  String get docTalkerAB => 'AIS 基站';

  @override
  String get docTalkerAD => '从属 AIS 基站';

  @override
  String get docTalkerAI => 'AIS 移动台站';

  @override
  String get docTalkerAN => '助航 AIS 台站';

  @override
  String get docTalkerAR => 'AIS 接收台站';

  @override
  String get docTalkerAS => '受限基站';

  @override
  String get docTalkerAT => 'AIS 发射台站';

  @override
  String get docTalkerAX => 'AIS 中继台站';

  @override
  String get docTalkerBS => 'AIS 基站（已弃用）';

  @override
  String get docTalkerSA => '实体岸上 AIS 台站';

  @override
  String get docType1Name => 'A 类位置报告';

  @override
  String get docType1Family => '位置报告';

  @override
  String get docType1Summary => '系统的核心主力：A 类应答机广播其位置、航向、航速、船艏向和航行状态。';

  @override
  String get docType1EmittedBy => 'A 类应答机（SOLAS 船舶）';

  @override
  String get docType1Cadence => '航行中每 2-10 秒，锚泊时每 3 分钟';

  @override
  String get docType2Name => 'A 类位置报告（指派）';

  @override
  String get docType2Family => '位置报告';

  @override
  String get docType2Summary => '与类型 1 相同，但按基站分配给船舶的时隙计划发送（指派模式）。';

  @override
  String get docType2EmittedBy => '处于指派模式下的 A 类应答机';

  @override
  String get docType2Cadence => '指派计划';

  @override
  String get docType3Name => 'A 类位置报告（应答）';

  @override
  String get docType3Family => '位置报告';

  @override
  String get docType3Summary => '与类型 1 相同，作为对询问（类型 15）的应答而发送。';

  @override
  String get docType3EmittedBy => '应答询问的 A 类应答机';

  @override
  String get docType3Cadence => '应询问发送';

  @override
  String get docType4Name => '基站报告';

  @override
  String get docType4Family => '基站与网络';

  @override
  String get docType4Summary => '固定岸站的周期性报告：其位置以及 UTC 日期时间参考。';

  @override
  String get docType4EmittedBy => '固定基站';

  @override
  String get docType4Cadence => '每 10 秒';

  @override
  String get docType5Name => '静态与航次相关数据';

  @override
  String get docType5Family => '静态与航次数据';

  @override
  String get docType5Summary => '船舶的\"身份证\"：名称、呼号、IMO 编号、船舶类型、尺寸、吃水、ETA 和目的港。';

  @override
  String get docType5EmittedBy => 'A 类应答机';

  @override
  String get docType5Cadence => '每 6 分钟及数据变化时';

  @override
  String get docType6Name => '二进制定向报文';

  @override
  String get docType6Family => '二进制数据';

  @override
  String get docType6Summary => '发送给某个特定目的 MMSI 的结构化二进制载荷（例如请求的气象报告）。';

  @override
  String get docType6EmittedBy => '任何台站';

  @override
  String get docType6Cadence => '按需发送';

  @override
  String get docType7Name => '二进制应答';

  @override
  String get docType7Family => '二进制数据';

  @override
  String get docType7Summary => '对类型 6 二进制定向报文的应答。';

  @override
  String get docType7EmittedBy => '任何收到类型 6 的台站';

  @override
  String get docType7Cadence => '回复时发送';

  @override
  String get docType8Name => '二进制广播报文';

  @override
  String get docType8Family => '二进制数据';

  @override
  String get docType8Summary => '广播给所有人的结构化二进制载荷 — 气象和水文报告、区域数据或私有/加密报文。';

  @override
  String get docType8EmittedBy => '任何台站';

  @override
  String get docType8Cadence => '按需发送';

  @override
  String get docType9Name => '标准搜救飞机位置报告';

  @override
  String get docType9Family => '位置报告';

  @override
  String get docType9Summary =>
      '搜救飞机使用的位置报告，以便船舶能看到它们。包含高度和特殊 MMSI 段（111MIDXXX）。';

  @override
  String get docType9EmittedBy => '搜救飞机';

  @override
  String get docType9Cadence => '在任务区域时每 10 秒';

  @override
  String get docType10Name => 'UTC 与日期查询';

  @override
  String get docType10Family => '基站与网络';

  @override
  String get docType10Summary => '向特定台站请求其 UTC 日期和时间的简短请求。';

  @override
  String get docType10EmittedBy => '任何台站';

  @override
  String get docType10Cadence => '按需发送';

  @override
  String get docType11Name => 'UTC 与日期应答';

  @override
  String get docType11Family => '基站与网络';

  @override
  String get docType11Summary => '结构与类型 4 相同，作为对类型 10 UTC/日期查询的答复发送。';

  @override
  String get docType11EmittedBy => '基站';

  @override
  String get docType11Cadence => '应查询发送';

  @override
  String get docType12Name => '定向安全相关报文';

  @override
  String get docType12Family => '安全与文本';

  @override
  String get docType12Summary => '发送给单个目的 MMSI 的自由文本安全报文（例如向最近的基站发送遇险报文）。';

  @override
  String get docType12EmittedBy => '任何台站';

  @override
  String get docType12Cadence => '按需发送';

  @override
  String get docType13Name => '安全相关应答';

  @override
  String get docType13Family => '安全与文本';

  @override
  String get docType13Summary => '对类型 12 定向安全报文的应答。';

  @override
  String get docType13EmittedBy => '任何收到类型 12 的台站';

  @override
  String get docType13Cadence => '回复时发送';

  @override
  String get docType14Name => '安全相关广播报文';

  @override
  String get docType14Family => '安全与文本';

  @override
  String get docType14Summary => '面向范围内所有人的自由文本广播 — 航行警告、遇险或交通通告。';

  @override
  String get docType14EmittedBy => '任何台站（通常是基站 / VTS）';

  @override
  String get docType14Cadence => '按需发送';

  @override
  String get docType15Name => '询问';

  @override
  String get docType15Family => '基站与网络';

  @override
  String get docType15Summary => '请求一个或两个特定台站发送特定报文类型（通常是类型 3 或 5）。';

  @override
  String get docType15EmittedBy => '基站';

  @override
  String get docType15Cadence => '按需发送';

  @override
  String get docType16Name => '指派模式命令';

  @override
  String get docType16Family => '基站与网络';

  @override
  String get docType16Summary => '指示最多两艘船舶在指定的时隙分配上发射（指派模式）。';

  @override
  String get docType16EmittedBy => '基站';

  @override
  String get docType16Cadence => '按需发送';

  @override
  String get docType17Name => 'DGNSS 二进制广播报文';

  @override
  String get docType17Family => '二进制数据';

  @override
  String get docType17Summary => '岸站广播的差分 GNSS 修正数据，用于提高覆盖区域内的定位精度。';

  @override
  String get docType17EmittedBy => 'DGNSS 基准站';

  @override
  String get docType17Cadence => '周期性发送';

  @override
  String get docType18Name => '标准 B 类 CS 位置报告';

  @override
  String get docType18Family => '位置报告';

  @override
  String get docType18Summary =>
      '标准的 B 类位置报告。比 A 类更简单：不包含航行状态或回转速率，但使用 CSTDMA。';

  @override
  String get docType18EmittedBy => 'B 类应答机';

  @override
  String get docType18Cadence => '每 30 秒（某些地区更频繁）';

  @override
  String get docType19Name => '扩展 B 类设备位置报告';

  @override
  String get docType19Family => '位置报告';

  @override
  String get docType19Summary => '更长的 B 类位置报告，还包含船名、船舶类型和尺寸 — 一次性的静态+位置混合报告。';

  @override
  String get docType19EmittedBy => '扩展 B 类应答机';

  @override
  String get docType19Cadence => '每 30 秒';

  @override
  String get docType20Name => '数据链路管理';

  @override
  String get docType20Family => '基站与网络';

  @override
  String get docType20Summary => '用于在区域内分配和预留 TDMA 时隙的网络维护报文。';

  @override
  String get docType20EmittedBy => '基站';

  @override
  String get docType20Cadence => '网络管理';

  @override
  String get docType21Name => '助航设施报告';

  @override
  String get docType21Family => '助航设施';

  @override
  String get docType21Summary => '广播助航设施的位置、名称和状态 — 浮标、信标、灯塔或虚拟助航设施。通常从虚拟位置发送。';

  @override
  String get docType21EmittedBy => '助航台站（实体或虚拟）';

  @override
  String get docType21Cadence => '每 3 分钟（或事件触发时）';

  @override
  String get docType22Name => '信道管理';

  @override
  String get docType22Family => '基站与网络';

  @override
  String get docType22Summary => '基站用于在地理区域内将台站切换到不同的 VHF 信道。';

  @override
  String get docType22EmittedBy => '基站';

  @override
  String get docType22Cadence => '按需发送';

  @override
  String get docType23Name => '组指派命令';

  @override
  String get docType23Family => '基站与网络';

  @override
  String get docType23Summary => '基站向区域内一组船舶发送的命令，设置报告间隔和发射模式。';

  @override
  String get docType23EmittedBy => '基站';

  @override
  String get docType23Cadence => '按需发送';

  @override
  String get docType24Name => '静态数据报告';

  @override
  String get docType24Family => '静态与航次数据';

  @override
  String get docType24Summary =>
      'B 类中与类型 5 对应的报告，分为 A 部分（名称）和 B 部分（船舶类型、呼号、尺寸）。';

  @override
  String get docType24EmittedBy => 'B 类应答机';

  @override
  String get docType24Cadence => '每 6 分钟';

  @override
  String get docType25Name => '单时隙二进制报文';

  @override
  String get docType25Family => '二进制数据';

  @override
  String get docType25Summary => '适合放入单个 TDMA 时隙的短二进制报文，可包含可选的目的和应用 ID。';

  @override
  String get docType25EmittedBy => '任何台站';

  @override
  String get docType25Cadence => '按需发送';

  @override
  String get docType26Name => '多时隙二进制报文';

  @override
  String get docType26Family => '二进制数据';

  @override
  String get docType26Summary => '分布在多个 TDMA 时隙上的较长二进制报文，包含无线电状态信息。';

  @override
  String get docType26EmittedBy => '任何台站';

  @override
  String get docType26Cadence => '按需发送';

  @override
  String get docType27Name => '远距离应用位置报告';

  @override
  String get docType27Family => '位置报告';

  @override
  String get docType27Summary => '专为卫星远距离接收设计的极紧凑位置报告，分辨率有所降低。';

  @override
  String get docType27EmittedBy => '处于远距离（卫星）模式的船舶';

  @override
  String get docType27Cadence => '每 3 分钟（远距离模式）';

  @override
  String get docTimeline1990sTitle => '源自瑞典的发明';

  @override
  String get docTimeline1990sText =>
      '这一概念诞生于瑞典：一种 VHF 系统，让每艘船都自我播报，使其他船只\"看到并被看到\"，即使在雾中或岛屿遮挡下也是如此。该方案提交给 IMO，成为 AIS 的雏形。';

  @override
  String get docTimeline1998Title => '标准化启动';

  @override
  String get docTimeline1998Text =>
      'ITU 和 IEC 开始将这一概念转化为具有精确位级格式的无线电标准，基于两个 VHF 信道上的 TDMA。';

  @override
  String get docTimeline2001Title => 'ITU-R M.1371 发布';

  @override
  String get docTimeline2001Text =>
      '建议书 ITU-R M.1371《通用船载自动识别系统的技术特性》定义了 27 种报文类型及其位布局。';

  @override
  String get docTimeline2002Title => 'SOLAS 强制要求';

  @override
  String get docTimeline2002Text =>
      'IMO 要求所有总吨位超过 300 的国际航行船舶和所有客船强制安装 AIS — 约 10 万艘船舶。AIS 与雷达一起成为标准的防碰撞辅助手段。';

  @override
  String get docTimeline2006Title => 'B 类问世';

  @override
  String get docTimeline2006Text =>
      'B 类标准发布，为廉价、简单的应答机打开了大门。同年，TacSat-2 卫星成为首个从太空捕获 AIS 信号的卫星（S-AIS）。';

  @override
  String get docTimeline2008_2015Title => '卫星星座';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth、ORBCOMM、Spire 等公司在地球低轨道部署 AIS 接收机，将覆盖范围扩展到 VHF 视距之外，实现近乎全球的船舶跟踪。';

  @override
  String get docTimeline2010Title => 'AIS-SART 纳入 GMDSS';

  @override
  String get docTimeline2010Text =>
      'AIS 搜救发射机（AIS-SART，IEC 61097-14）被纳入全球海上遇险与安全系统，使救生艇能够通过 AIS 播报遇险位置。';

  @override
  String get docTimeline2014Title => '渔业与内河船队';

  @override
  String get docTimeline2014Text =>
      '欧洲法规要求所有超过 15 米的欧盟渔船安装 A 类 AIS；内河 AIS 已在欧洲河流上广泛部署。';

  @override
  String get docTimeline2021Title => '160 万艘船舶';

  @override
  String get docTimeline2021Text =>
      '超过 160 万艘船舶安装了 AIS，为陆地和卫星网络提供数据，推动全球船舶跟踪、渔业监管和海上安全。';

  @override
  String get docTimelineVdesTitle => 'VDES — 继任者';

  @override
  String get docTimelineVdesText =>
      'VHF 数据交换系统（ITU-R M.2092）正在推广，以缓解拥堵区域，提供更大的带宽和安全的电子导航服务。';

  @override
  String get docAppTitle => '文档';

  @override
  String get docSearchChapters => '搜索章节';

  @override
  String get docChapterOverview => '概述';

  @override
  String get docChapterHistory => '历史与法规';

  @override
  String get docChapterHowItWorks => '工作原理';

  @override
  String get docChapterRadio => '无线电与 TDMA';

  @override
  String get docChapterClasses => '类别与设备';

  @override
  String get docChapterMmsi => 'MMSI 与身份';

  @override
  String get docChapterShipTypes => '船舶类型';

  @override
  String get docChapterMessages => '27 种报文';

  @override
  String get docChapterNmea => 'NMEA 与 AIVDM';

  @override
  String get docChapterPayload => '载荷详解';

  @override
  String get docChapterSecurity => '安全与限制';

  @override
  String get docChapterFieldNotes => '实战笔记';

  @override
  String get docChapterKikais => 'KikAis 中的 AIS';

  @override
  String get docChapterGlossary => '术语表';

  @override
  String get docChapterCheatSheet => '速查表';

  @override
  String get docChapterSources => '参考资料';

  @override
  String get docOverviewTitle => '什么是 AIS？';

  @override
  String get docOverviewIntro =>
      '自动识别系统（AIS）是一种用于船舶和船舶交通服务（VTS）的跟踪系统。每艘装有该设备的船舶都通过 VHF 无线电持续广播其身份、位置、航向和航速，使范围内所有其他船舶和岸站都能\"看到\"它 — 即\"看到并被看到\"的概念。';

  @override
  String get docOverviewRadar =>
      'AIS 不能替代船用雷达。雷达能独立探测任何物体，但对\"它是谁\"所知甚少。AIS 能准确告诉你\"是谁、在哪里、要去哪里\" — 但它信任发送方所声明的内容。两者相辅相成。';

  @override
  String get docOverviewAdsBTitle => '把它看作海上版的 ADS-B';

  @override
  String get docOverviewAdsBText =>
      '正如 ADS-B 让飞机向空中交通管制播报自己一样，AIS 让船舶互相之间以及向岸上播报自己。船舶在海图仪或类似雷达的显示屏上查看周边交通；港口当局则监控船舶动态和渔业活动。';

  @override
  String get docOverviewTransponder => '应答机广播的内容';

  @override
  String get docOverviewBullet1 => '唯一身份：9 位 MMSI 编号（前三位标识颁发国家）。';

  @override
  String get docOverviewBullet2 =>
      '动态数据：位置、对地航速（SOG）、对地航向（COG）、真船艏向、回转速率、航行状态。';

  @override
  String get docOverviewBullet3 => '静态与航次数据：名称、呼号、IMO 编号、船舶类型、尺寸、吃水、目的港、ETA。';

  @override
  String get docOverviewBullet4 => '安全与二进制报文：遇险文本、气象报告、网络命令。';

  @override
  String get docOverviewWho => '谁必须配备';

  @override
  String get docOverviewImo =>
      'IMO（SOLAS 公约）要求总吨位超过 300 的国际航行船舶和所有客船配备 AIS。区域性法规将其扩展至渔船船队、内河航道，并越来越多地通过低成本的 B 类应答机扩展到休闲船舶。';

  @override
  String get docOverviewLimits => '局限一览';

  @override
  String get docOverviewLimit1 => '作用距离约为视距：船对船约 10-20 海里，岸站和卫星可更远。';

  @override
  String get docOverviewLimit2 => 'AIS 没有认证机制：任何人都可以播报任意身份（欺骗）或干扰信道。';

  @override
  String get docOverviewLimit3 => '精度取决于发送方的 GNSS 定位质量及其所声明数据的真实性。';

  @override
  String get docHistoryIntro => 'AIS 从一个瑞典的点子发展为全球强制性的安全系统。点按时间线上的任意里程碑可查看详情。';

  @override
  String get docHistoryStandards => '相关标准';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — 通用船载 AIS 的技术特性（定义 27 种报文类型及其位布局）。';

  @override
  String get docHistoryStd2 => 'IALA 指南 — 澄清与实施指导。';

  @override
  String get docHistoryStd3 => 'IEC 61162 / 62287 — NMEA 语句封装以及 B 类/CSTDMA 要求。';

  @override
  String get docHistoryStd4 => 'IEC 61097-14 — AIS-SART 遇险发射机。';

  @override
  String get docHowIntro =>
      'AIS 是一种 VHF 无线电系统。每台应答机监听周围的流量，并在预留的时隙中发射自己的报告，从而避免与范围内其他船舶冲突。';

  @override
  String get docHowRadioLink => '无线电链路';

  @override
  String get docHowRadioLink1 =>
      '两个专用 VHF 信道：AIS 1 位于 161.975 MHz（87B），AIS 2 位于 162.025 MHz（88B）。';

  @override
  String get docHowRadioLink2 => '数字窄带调频，每秒 9 600 比特。';

  @override
  String get docHowRadioLink3 => '报文按 TDMA 帧组织，每帧含 2250 个时隙（1 分钟）。';

  @override
  String get docHowSlots => '时隙如何共享';

  @override
  String get docHowSotdma =>
      'A 类应答机使用 SOTDMA（自组织时分多址）：每台设备预留一个重复使用的时隙，并在情况变化时重新预留，因此船舶无需中央控制器即可持续协调。';

  @override
  String get docHowCstdma =>
      'B 类应答机使用更简单的 CSTDMA（载波侦听 TDMA）：它们侦听空闲时隙并抢占使用，因此 B 类报告频率较低，在非常密集的流量下可能丢失。';

  @override
  String get docHowRates => '报告频率';

  @override
  String get docHowRates1 => 'A 类位置报告（类型 1）：航行中每 2-10 秒，锚泊时每 3 分钟。';

  @override
  String get docHowRates2 => '静态与航次数据（类型 5）：每 6 分钟。';

  @override
  String get docHowRates3 => 'B 类位置（类型 18）：约每 30 秒。';

  @override
  String get docHowRates4 => '助航设施（类型 21）：每 3 分钟。';

  @override
  String get docHowTerrestrial => '陆地与卫星';

  @override
  String get docHowTerrestrialText =>
      '在地面，AIS 的作用距离受 VHF 视距限制（T-AIS）。自 2000 年代中期以来，地球低轨道卫星（S-AIS）接收相同的信号，提供近乎全球的覆盖 — 卫星是对地面网络的补充而非替代。';

  @override
  String get docRadioIntro =>
      '在报文之下是一个小巧高效的无线电系统。AIS 在两个 VHF 信道上以每秒 9 600 比特的速率发射，采用高斯最小频移键控（GMSK）和类 HDLC 帧格式。';

  @override
  String get docRadioPhysical => '物理链路';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 at 161.975 MHz and AIS 2 at 162.025 MHz (VHF channels 87B and 88B).';

  @override
  String get docRadioPhysical2 => 'GMSK 调制，9 600 波特 — 带宽足够窄，可容纳在海上 VHF 频段内。';

  @override
  String get docRadioPhysical3 => '采用位填充的 HDLC 帧格式和 NRZI 线路编码，源自分组无线电领域。';

  @override
  String get docRadioFrames => 'TDMA 帧与时隙';

  @override
  String get docRadioFrames1 => '每个信道被划分为恰好 1 分钟的帧，再分成 2 250 个时隙，每个约 26.7 毫秒。';

  @override
  String get docRadioFrames2 => '一个时隙承载一条 AIS 报文（256 比特，含升降沿和保护时间）。';

  @override
  String get docRadioFrames3 => '台站每帧复用相同的时隙，从而周期性广播而不发生碰撞。';

  @override
  String get docRadioCode =>
      '2250 slots/frame · 1 frame = 60 s · slot ≈ 26.7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — A 类如何自组织';

  @override
  String get docRadioSotdmaText =>
      '每台 A 类应答机监听周围时隙，选取一个空闲时隙，并在其无线电状态字段中预告下一次发射时间。随着流量变化，台站持续重新预留，因此无需中央协调器。';

  @override
  String get docRadioCstdma => 'CSTDMA — B 类如何参与';

  @override
  String get docRadioCstdmaText =>
      'B 类设备更简单：它们侦听当前空闲的时隙并发射一次。这更便宜，但在时隙始终繁忙的极密集流量下，B 类报告可能丢失。';

  @override
  String get docRadioVdes => 'VDES — 未来';

  @override
  String get docRadioVdesText =>
      'VHF 数据交换系统（ITU-R M.2092）正在推广以缓解拥堵水域：它在现有 AIS 服务之外，增加了新频率、更大的带宽以及用于电子导航的安全双向数据。';

  @override
  String get docClassesIntro =>
      'AIS 硬件有不同的类别和角色。你最常遇到的两类是完整的 A 类应答机和廉价的 B 类设备。';

  @override
  String get docClassesComparison => 'A 类与 B 类对比';

  @override
  String get docClassesReceivers => '接收机与应答机';

  @override
  String get docClassesReceiversText =>
      '应答机既能接收也能发射。许多岸站和爱好者只运行接收机，这样他们可以观察交通而无需在系统中露面。';

  @override
  String get docClassesAton => '助航设施';

  @override
  String get docClassesAtonText =>
      '助航台站（类型 21）播报浮标、信标和灯塔。它们也可以发射虚拟助航设施 — 仅存在于海图上的标记，用于警示新的危险。';

  @override
  String get docClassesDistress => '遇险与安全设备';

  @override
  String get docClassesDistressIntro => '除普通船舶外，AIS 还承载遇险发射机，每台接收机都应能识别：';

  @override
  String get docClassesSartNote =>
      '工作中的 SART 还会在其位置报告中将航行状态设为 14（\"AIS-SART 激活\"）。';

  @override
  String get docShipTypesIntro =>
      '类型 5 和 24 静态报文携带一个描述船舶类型的 8 位船舶类型代码（0-99）— 货船、油轮、渔船、游艇等。完整表格如下所示。';

  @override
  String get docShipTypesCategories => '类别一览';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle => '实战笔记与真实世界的怪癖';

  @override
  String get docFieldNotesIntro =>
      '真实的 AIS 流量并不总是与理论一致。了解这些怪癖有助于你信任解码器显示的内容 — 以及它拒绝的内容。';

  @override
  String get docGlossaryIntro => '本指南及 AIS 社区所用的缩写词和术语的可搜索字典。';

  @override
  String get docCheatSheetIntro => '必备数字与代码一览 — 频率、报告频率、状态代码和格式。';

  @override
  String get docMmsiIntro =>
      '海上移动业务标识（MMSI）是标识船舶无线电设备的唯一 9 位数字，类似于船舶的电话号码。其前三位为 MID — 即海上标识数字，用于标识颁发国家。';

  @override
  String get docMmsiFormats => '号码格式';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => '查询 MMSI';

  @override
  String get docMmsiLookupHint => '在下方输入 9 位 MMSI，查看其类别和颁发机构所在国家。';

  @override
  String get docMmsiMidHeading => '国家代码（MID）';

  @override
  String get docMmsiMidText => '完整的 MID 表随 KikAis 附带，并在所有显示 MMSI 的地方使用。';

  @override
  String get docMessagesTitle => '27 种报文类型';

  @override
  String get docMessagesIntro =>
      '每条 AIS 载荷都以 6 位报文类型（1 到 27）开头。下面的目录按类别对它们分组。每张卡片显示由 KikAis 自己的编码器生成的真实 NMEA 语句、其解码字段，以及一个在解码器中打开的按钮。';

  @override
  String get docNmeaTitle => 'NMEA 与 AIVDM 封装';

  @override
  String get docNmeaIntro =>
      '在线路上，AIS 报文以 NMEA 0183 语句形式传输，以 !AIVDM（其他船舶）或 !AIVDO（本船）开头。载荷是一个 ASCII 编码的位向量。';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => '语句字段';

  @override
  String get docNmeaField1 => '通话器与格式化器 — !AIVDM 或 !AIVDO（参见下方的通话器 ID）。';

  @override
  String get docNmeaField2 => '分段数量 — 构成完整报文的语句条数（NMEA 将每行限制在约 82 个字符）。';

  @override
  String get docNmeaField3 => '分段编号 — 这是第几段（从 1 开始）。';

  @override
  String get docNmeaField4 => '顺序报文 ID — 用于关联同一报文的各分段。';

  @override
  String get docNmeaField5 => '无线电信道 — A 或 B（AIS1 / AIS2）。';

  @override
  String get docNmeaField6 => '数据载荷 — 六位编码的 AIS 载荷。';

  @override
  String get docNmeaField7 => '填充位 — 添加到最后一个 6 位组的填充位数（0-5）。';

  @override
  String get docNmeaField8 => '校验和 — * 之前所有字节的异或，以十六进制表示。';

  @override
  String get docNmeaMulti => '多分段报文';

  @override
  String get docNmeaMultiText =>
      '超过一行的报文（如类型 5 静态数据）会被拆分：第一条语句报告分段数为 2，第二条使用相同的报文 ID 完成它。';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => '六位编码';

  @override
  String get docNmeaArmoringText =>
      '每个载荷字符包含 6 位。将 ASCII 码减去 48，若结果大于 40 再减去 8。';

  @override
  String get docNmeaTalkers => '通话器 ID';

  @override
  String get docNmeaTalkersIntro => '不同的 NMEA 4.0 通话器 ID 用于标识 AIS 台站的类型：';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => '校验和';

  @override
  String get docNmeaChecksumText =>
      '尾部的校验和是 \"!\" 与 \"*\" 之间每个字节的异或。在下方计算你自己的校验和：';

  @override
  String get docNmeaInspectorTitle => '试一试：语句检查器';

  @override
  String get docNmeaInspectorText =>
      '粘贴任意 AIVDM/AIVDO 语句（或使用上方的示例），查看其字段分解和已解码的值。';

  @override
  String get docPayloadIntro =>
      '解除六位编码后，AIS 载荷是一系列位字段。前六位是报文类型；接下来两位是重复指示器；然后是 30 位的 MMSI。';

  @override
  String get docPayloadCnb => '通用导航块（类型 1-3）';

  @override
  String get docPayloadCnbText =>
      '最重要的布局由 A 类位置报告共享。使用选择器浏览主要报文布局，点击某一段可查看其编码内容。';

  @override
  String get docPayloadCoords => '坐标';

  @override
  String get docPayloadCoordsText =>
      '纬度和经度以分的 1/10 000 存储。除以 600 000 得到度数：每度 60 分，每分 10 000 单位。东经/北纬为正。';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // e.g. -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert => '在下方转换你自己的坐标：';

  @override
  String get docPayloadSpeed => '航速、航向、船艏向';

  @override
  String get docPayloadSpeed1 =>
      'SOG — 对地航速，单位为节的十分之一（0-102.2 kn）；1023 表示\"不可用\"。';

  @override
  String get docPayloadSpeed2 => 'COG — 对地航向，单位为度的十分之一，相对真北。';

  @override
  String get docPayloadSpeed3 => '船艏向 — 真船艏向，整度数；511 表示\"不可用\"。';

  @override
  String get docPayloadSpeed4 =>
      'ROT — 回转速率：数值 ≈ 4.733 × √(回转速率，单位为 °/min)，带符号（正值 = 右转）。';

  @override
  String get docPayloadNavStatus => '航行状态';

  @override
  String get docPayloadEpfd => '定位类型（EPFD）';

  @override
  String get docPayloadText => '六位文本';

  @override
  String get docPayloadTextIntro =>
      '名称、呼号和目的港使用与载荷本身相同的六位字母表。小写字母无法编码，这就是 AIS 名称通常为大写的原因。';

  @override
  String get docSecurityTitle => '安全与数据质量';

  @override
  String get docSecurityIntro => 'AIS 是为协作而设计，而非为安全设计。无线电信道开放且不加密，也不认证广播者的身份。';

  @override
  String get docSecurityThreats => '威胁';

  @override
  String get docSecurityThreat1 => '欺骗 — 播报虚假的 MMSI、位置或身份（幽灵船、规避制裁）。';

  @override
  String get docSecurityThreat2 => '干扰 — 淹没两个 VHF 信道，使真实流量无法被接收。';

  @override
  String get docSecurityThreat3 => '转播欺骗 — 重放来自他处的真实信号以迷惑接收机。';

  @override
  String get docSecurityQuality => '数据质量';

  @override
  String get docSecurityQuality1 =>
      '位置精度位用于区分未增强的 GNSS 定位（> 10 m）与 DGPS 级定位（< 10 m）。';

  @override
  String get docSecurityQuality2 => '接收机应检查位置、航速和时间戳的合理性；现实中约有 0.3% 的报文载荷长度异常。';

  @override
  String get docSecurityQuality3 =>
      '卫星 AIS 偶尔会发生碰撞，因为卫星覆盖范围远大于 TDMA 单元 — 这也是需要与雷达和其他数据源交叉验证的又一原因。';

  @override
  String get docKikaisIntro =>
      'KikAis 是一个完整的 AIS 实验室：接收实时或模拟流量、解码、检查并发送你自己的报文，以及构建舰队。以下说明每个选项卡与你刚读到的内容的对应关系。';

  @override
  String get docTabReceptionText => '选择数据源（文件、串口、仿真），启动转发器，查看原始 NMEA 流和解码后的船舶。';

  @override
  String get docTabSendText => '将接收到的语句转发到一个或多个 TCP/UDP 目标 — 就像岸站分发流量那样。';

  @override
  String get docTabMapText => '查看根据类型 1/2/3、18、19 和 27 位置报告绘制出的已解码船舶。';

  @override
  String get docTabEditorText =>
      '通过友好的表单手工构建 27 种报文类型中的任意一种并发送 — 这是学习各字段的最佳方式。';

  @override
  String get docTabDecoderText => '粘贴任意语句，即可获得已解码的字段、校验和与分段处理 — 本指南的实用伴侣。';

  @override
  String get docTabStatsText => '报文计数、各数据源速率以及解码器健康状况（无效校验和、丢弃的分段）。';

  @override
  String get docTabSimulationText =>
      '在任意位置生成整个舰队 — 包含所有报文类型、MMSI 方案、区域形状，甚至错误注入。';

  @override
  String get docSourcesIntro => '本指南综合了公开可用的权威资料：';

  @override
  String get docSources1 =>
      'gpsd — AIVDM/AIVDO 协议解码，作者 Eric S. Raymond（语句格式与载荷位字段的事实性技术圣经）。';

  @override
  String get docSources2 => '维基百科 — 自动识别系统（概述、历史、应用、安全）。';

  @override
  String get docSources3 => '美国海岸警卫队导航中心（NavCen）— AIS 页面。';

  @override
  String get docSources4 => 'ITU-R 建议书 M.1371 — AIS 管理标准。';

  @override
  String get docSources5 => 'IALA — 对 ITU-R M.1371 的澄清。';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA 封装、B 类与 AIS-SART。';

  @override
  String get docSourcesLearn => '如何进一步学习';

  @override
  String get docSourcesLearnText =>
      '理解 AIS 的最佳方式是动手实验：用编辑器构建报文，用解码器读回它们，用仿真选项卡观察整个舰队。本指南中的所有内容均由 KikAis 自己的编码器和解码器生成。';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return '类型 $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits 位 · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return '由以下设备发出：$emittedBy';
  }

  @override
  String get docOpenInDecoder => '在解码器中打开';

  @override
  String get docInspectorNmeaLabel => 'NMEA 语句';

  @override
  String get docInspectorInspect => '检查';

  @override
  String get docInspectorInvalidChecksum => '无效校验和';

  @override
  String get docInspectorCouldNotDecode => '无法解码';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return '已解码：T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return '类型 $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI（9 位）';

  @override
  String get docMmsiLookupButton => '查询';

  @override
  String get docMmsiLookupError => '请输入 9 位 MMSI（仅数字）。';

  @override
  String get docMmsiLookupClassGroup => '船舶组（组呼）';

  @override
  String get docMmsiUnknownCountry => '未知国家';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid（$country）';
  }

  @override
  String get docTabOpen => '打开';

  @override
  String get updateCheckForUpdates => '检查更新';

  @override
  String get updateChecking => '正在检查更新…';

  @override
  String updateNewVersion(Object version) {
    return '新版本 $version';
  }

  @override
  String get updateUpToDate => '您已是最新版本。';

  @override
  String get updateCheckFailed => '检查更新失败。';

  @override
  String get tooltipLanguage => '更改界面语言。十种语言均已完整翻译；选择「自动」可跟随操作系统语言。';

  @override
  String get tooltipTheme => '更改配色主题：深色、浅色或高对比度。高对比度可提高可读性。';

  @override
  String get tooltipUpdate => '检查是否有新版本。如果有，版本号旁边会出现一个绿色徽章。';

  @override
  String get tooltipMapSearch => '按名称、MMSI 或 IMO 编号搜索船舶，然后在地图上居中并跟踪该船。';

  @override
  String get tooltipMapFilters => '筛选显示的船舶：按类型、航行状态、国家（MID）、速度或仅限名称。';

  @override
  String get tooltipMapCluster => '切换船舶聚合。启用后，附近的船舶会合并为一个带计数的标记。';

  @override
  String get tooltipMapTrails => '切换航迹。启用后，每艘船都会在地图上绘制其最近路线。';

  @override
  String get tooltipMapVectors => '切换航向矢量。启用后，每艘船都会显示一个沿航向的箭头。';

  @override
  String get tooltipMapSendToMap => '切换是否将解码后的船舶发送到地图。启用后，每艘解码的船舶都会显示为标记。';

  @override
  String get tooltipMapBasemap => '选择地图底图。「自动」跟随当前主题。';

  @override
  String get tooltipSendAdd =>
      '添加新的发送目标（UDP 或 TCP，客户端或服务器）。收到的 AIS 帧会转发到每个已启用的目标。';

  @override
  String get tooltipSendEdit => '编辑此目标的名称、协议、主机、端口和帧格式。';

  @override
  String get tooltipSendDelete => '删除此目标。此操作无法撤销。';

  @override
  String get tooltipSendToggle => '启用或禁用转发到此目标。';

  @override
  String get tooltipSendLocked => '转发器运行时目标被锁定。请先停止「接收」标签页中的源，再编辑它们。';

  @override
  String get tooltipReceptionAddSource =>
      '添加数据源：网络源（UDP/TCP/gpsd）、录制的 NMEA 语句文件或串行端口。';

  @override
  String get tooltipReceptionStart => '开始接收所有已启用来源的 AIS 帧并转发。';

  @override
  String get tooltipReceptionStop => '停止接收和转发 AIS 帧。';

  @override
  String get tooltipReceptionFeed => '启用或禁用此 AIS 源。';

  @override
  String get tooltipReceptionSaveLogs => '将连接日志保存到文本文件。';

  @override
  String get tooltipReceptionClearLogs => '清除连接日志。';

  @override
  String get tooltipReceptionRemoveSource => '移除此 AIS 源。';

  @override
  String get tooltipReceptionValidateChecksums => '启用后，校验和无效的 NMEA 帧将被拒绝。';

  @override
  String get tooltipReceptionImportFormat => '接收到的帧在解码前如何规范化。';

  @override
  String get tooltipReceptionLoop => '启用后，文件回放在到达末尾后从头开始。';

  @override
  String get tooltipReceptionSpeed => '回放速度倍率（1x = 实时）。';

  @override
  String get tooltipReceptionSerialPorts => '刷新可用串行端口列表。';

  @override
  String get tooltipSimApply => '应用当前设置并生成船队。大型船队在后台生成。';

  @override
  String get tooltipSimGenerate => '使用新种子生成新的随机船队，然后应用。';

  @override
  String get tooltipSimOpenReception => '前往「接收」标签页以启动模拟源。';

  @override
  String get tooltipSimRadius => '导航区域围绕中心的半径，以公里为单位。';

  @override
  String get tooltipSimVessels => '要生成到船队中的船舶数量。';

  @override
  String get tooltipSimSpeedMin => '船舶最小速度，以节为单位。';

  @override
  String get tooltipSimSpeedMax => '船舶最大速度，以节为单位。';

  @override
  String get tooltipSimInterval => '两次发射之间的延迟，以秒为单位。';

  @override
  String get tooltipSimSeed => '随机种子。相同的种子始终产生相同的船队。';

  @override
  String get tooltipSimAnchored => '保持锚泊或系泊而不是移动的船舶百分比。';

  @override
  String get tooltipSimNamePrefix => '用于生成的船舶名称的前缀。';

  @override
  String get tooltipSimMmsiMid => '用于构建 MMSI 的海事识别码（3 位国家代码）。';

  @override
  String get tooltipSimCenterLat => '导航区域中心的纬度。';

  @override
  String get tooltipSimCenterLon => '导航区域中心的经度。';

  @override
  String get tooltipSimTransit => '沿直线过境路线穿越该区域的船舶百分比。';

  @override
  String get tooltipSimRegenEvery => '启用定期重新生成时，每 N 个刻度重新生成船队。';

  @override
  String get tooltipSimReportInterval => '每艘船舶的最大位置报告间隔，以刻度为单位。';

  @override
  String get tooltipSimWander => '随机航向漂移强度（0 = 直线）。';

  @override
  String get tooltipSimClassBShare => '当两者都启用时，B 类与 A 类位置报告的比例。';

  @override
  String get tooltipSimErrorRate => '损坏或重复每条发射语句的概率。';

  @override
  String get tooltipSimBaseStations => '要生成的固定基站数量。';

  @override
  String get tooltipSimAtoN => '要生成的固定助航设备（航标）数量。';

  @override
  String get tooltipSimRealisticNames => '使用真实的船舶名称、呼号和目的地。';

  @override
  String get tooltipSimRealisticDimensions => '按船舶类型缩放船舶尺寸和吃水。';

  @override
  String get tooltipSimRealisticMmsi => '按船舶类别构建符合 ITU 结构的 MMSI。';

  @override
  String get tooltipSimVarySpeed => '让船舶速度在配置范围内轻微漂移。';

  @override
  String get tooltipSimSpeedByType => '从每种船舶类型的典型范围中选择速度。';

  @override
  String get tooltipSimHighAccuracy => '在发射的报告上设置高精度位置标志。';

  @override
  String get tooltipSimRealisticRot => '发射由航向变化导出的转向速率。';

  @override
  String get tooltipSimRegeneratePeriodically => '每 N 个刻度自动重新生成船队，以模拟变化的交通。';

  @override
  String get tooltipSimInjectErrors => '损坏或重复一些发射的语句以测试错误处理。';

  @override
  String get tooltipSimNmea4Tag => '为每个发射的帧添加 NMEA 4.0 标签块前缀。';

  @override
  String get tooltipSimVesselType => '将此船舶类型包含在船队中。';

  @override
  String get tooltipSimMessageType => '发射此 AIS 消息类型。';

  @override
  String get tooltipDecoderClear => '清除解码器输入和结果。';

  @override
  String get tooltipStatsDecode => '暂停或恢复对收到的 AIS 帧的解码。';

  @override
  String get tooltipStatsReset => '将所有统计计数器归零。';

  @override
  String get tooltipDocOpenTab => '在自己的标签页中打开此部分。';

  @override
  String get tooltipEditorInject => '将组成的消息注入解码器，就像它被接收到一样。';

  @override
  String get tooltipEditorSend => '将组成的消息发送到每个已启用的发送目标。';

  @override
  String get tooltipCopy => '复制到剪贴板。';

  @override
  String get tooltipClose => '关闭此面板。';

  @override
  String get tooltipBrowse => '浏览选择文件。';
}
