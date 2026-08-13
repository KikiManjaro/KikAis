// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get languageSystem => '自動（システム）';

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
  String get themeDark => 'ダーク';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeHighContrast => 'ハイコントラスト';

  @override
  String get tabReception => '受信';

  @override
  String get tabSend => '送信';

  @override
  String get tabMap => '地図';

  @override
  String get tabEditor => 'エディタ';

  @override
  String get tabDecoder => 'デコーダ';

  @override
  String get tabStats => '統計';

  @override
  String get tabSimulation => 'シミュレーション';

  @override
  String get tabDocs => 'ドキュメント';

  @override
  String get protocolUdpServer => 'UDP サーバー';

  @override
  String get protocolUdpClient => 'UDP クライアント';

  @override
  String get protocolTcpClient => 'TCP クライアント';

  @override
  String get protocolTcpServer => 'TCP サーバー';

  @override
  String get formatPassthrough => 'そのまま（パススルー）';

  @override
  String get formatStrip => 'タグブロックを除去';

  @override
  String get formatTag => 'タグブロックを追加';

  @override
  String get sendAddDestination => '送信先を追加';

  @override
  String get sendEditDestination => '送信先を編集';

  @override
  String get sendFormat => '送信形式';

  @override
  String get sendSave => '保存';

  @override
  String get sendLockedBanner => 'フォワーダーが実行中です — 送信先はロックされています。';

  @override
  String get sendEmpty => '送信先はまだありません。受信した AIS フレームを転送するには送信先を追加してください。';

  @override
  String get fieldName => '名前';

  @override
  String get fieldProtocol => 'プロトコル';

  @override
  String get fieldHost => 'ホスト';

  @override
  String get fieldPort => 'ポート';

  @override
  String get fieldTagSourceId => 'タグのソース ID';

  @override
  String get fieldFile => 'ファイル';

  @override
  String get fieldCancel => 'キャンセル';

  @override
  String get fieldAdd => '追加';

  @override
  String get receptionFeeds => 'フィード';

  @override
  String get receptionValidateChecksums => 'NMEA チェックサムを検証';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 文を破棄しました',
      one: '1 文を破棄',
      zero: '破棄された文はありません',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'インポートのフレーム形式';

  @override
  String get receptionStart => '開始';

  @override
  String get receptionStop => '停止';

  @override
  String get receptionLogs => 'ログ';

  @override
  String get receptionFrameCopied => 'フレームをコピーしました';

  @override
  String get receptionAddSource => 'ソースを追加';

  @override
  String get receptionNetwork => 'ネットワーク';

  @override
  String get receptionFile => 'ファイル';

  @override
  String get receptionSerial => 'シリアル';

  @override
  String get receptionHeaderOptional => 'ヘッダー（任意）';

  @override
  String get receptionPathOrBrowse => 'パスまたは参照…';

  @override
  String get receptionIntervalMs => 'フレーム間隔（ms）';

  @override
  String get receptionReplayTimestamps => 'ファイルのタイムスタンプを使用して再生';

  @override
  String get receptionReplayTimestampsHint =>
      '固定間隔ではなく、記録された時刻（タグブロックの t: またはタイムスタンププレフィックス）に従います';

  @override
  String get receptionSpeed => '速度';

  @override
  String get receptionReplayLoop => 'ループ（先頭から再生）';

  @override
  String get receptionSerialPort => 'シリアルポート';

  @override
  String get receptionSerialPortHint => '例: COM3 または /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'ボーレート';

  @override
  String get msgType1 => '位置情報レポート クラス A';

  @override
  String get msgType2 => '位置情報レポート クラス A（割当）';

  @override
  String get msgType3 => '位置情報レポート クラス A（応答）';

  @override
  String get msgType4 => '基地局';

  @override
  String get msgType5 => '静的データおよび航海関連データ';

  @override
  String get msgType6 => 'バイナリ宛先メッセージ';

  @override
  String get msgType7 => 'バイナリ確認応答';

  @override
  String get msgType8 => 'バイナリブロードキャストメッセージ';

  @override
  String get msgType9 => '標準 SAR 航空機位置レポート';

  @override
  String get msgType10 => 'UTC/日付照会';

  @override
  String get msgType11 => 'UTC/日付応答';

  @override
  String get msgType12 => '宛先指定安全関連メッセージ';

  @override
  String get msgType13 => '安全確認応答';

  @override
  String get msgType14 => '安全ブロードキャストメッセージ';

  @override
  String get msgType15 => 'インタロゲーション';

  @override
  String get msgType16 => '割当モードコマンド';

  @override
  String get msgType17 => 'DGNSS バイナリブロードキャストメッセージ';

  @override
  String get msgType18 => '標準クラス B CS 位置レポート';

  @override
  String get msgType19 => '拡張クラス B 機器位置レポート';

  @override
  String get msgType20 => 'データリンク管理メッセージ';

  @override
  String get msgType21 => '航路標識レポート';

  @override
  String get msgType22 => 'チャンネル管理';

  @override
  String get msgType23 => 'グループ割当コマンド';

  @override
  String get msgType24 => '静的データレポート';

  @override
  String get msgType25 => 'シングルスロットバイナリメッセージ';

  @override
  String get msgType26 => 'マルチスロットバイナリメッセージ';

  @override
  String get msgType27 => '長距離アプリケーション用位置レポート';

  @override
  String get statsTitle => '統計';

  @override
  String get statsFeed => 'フィード';

  @override
  String get statsAllFeeds => 'すべてのフィード';

  @override
  String get statsReceived => '受信';

  @override
  String get statsDecoded => 'デコード済み';

  @override
  String get statsInvalidChecksums => '不正なチェックサム';

  @override
  String get statsDroppedFragments => '破棄されたフラグメント';

  @override
  String get statsParseErrors => 'パースエラー';

  @override
  String get statsPendingFragments => '保留中のフラグメント';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/s';
  }

  @override
  String get statsAllFeedsShort => '（全フィード）';

  @override
  String get statsReceivedVsDecoded => '受信 vs デコード（直近 60 秒）';

  @override
  String get statsPerSecondLabel => '1 秒あたり';

  @override
  String get statsAccounting => '集計';

  @override
  String get statsMultiPartParts => 'マルチパートの部品';

  @override
  String get statsPending => '保留中';

  @override
  String get statsDropped => '破棄';

  @override
  String get statsReconcile => '受信数とデコード数は一致しています。';

  @override
  String get statsGapPaused => '差には、デコードを一時停止中に受信した文も含まれます。';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return '受信 $received = $sum';
  }

  @override
  String get statsByMessageType => 'メッセージタイプ別';

  @override
  String get statsNoDecodedYet => 'デコードされたメッセージはまだありません';

  @override
  String statsTypeFallback(Object type) {
    return 'タイプ $type';
  }

  @override
  String get statsByFeed => 'フィード別';

  @override
  String statsFeedFilter(Object filter) {
    return 'フィード: $filter';
  }

  @override
  String get statsNoActivityYet => 'フィードのアクティビティはまだありません';

  @override
  String get statsCollecting => '収集中…';

  @override
  String get simVesselCargo => '貨物船';

  @override
  String get simVesselTanker => 'タンカー';

  @override
  String get simVesselFishing => '漁船';

  @override
  String get simVesselSailing => '帆船';

  @override
  String get simVesselPassenger => '旅客船';

  @override
  String get simVesselTug => 'タグボート';

  @override
  String get simVesselHsc => '高速船';

  @override
  String get simVesselOther => 'その他';

  @override
  String get simType1 => '位置レポート（1/2/3）';

  @override
  String get simType5 => '静的 & 航海（5）';

  @override
  String get simType9 => 'SAR 航空機（9）';

  @override
  String get simType18 => 'クラス B 位置（18）';

  @override
  String get simType19 => 'クラス B 拡張（19）';

  @override
  String get simType27 => '長距離（27）';

  @override
  String get simType4 => '基地局（4）';

  @override
  String get simType21 => '航路標識（21）';

  @override
  String get simType8 => '気象ブロードキャスト（8）';

  @override
  String get simType11 => 'UTC/日付応答（11）';

  @override
  String get simType12 => '安全宛先指定（12）';

  @override
  String get simType14 => '安全ブロードキャスト（14）';

  @override
  String get simType22 => 'チャンネル管理（22）';

  @override
  String get simType23 => 'グループ割当（23）';

  @override
  String get simType24 => 'クラス B 静的（24）';

  @override
  String get simTitle => 'シミュレーション';

  @override
  String get simInfoBanner =>
      '受信タブで「シミュレーション」フィードを有効にし、フォワーダーが実行されると船団が送信されます。';

  @override
  String get simOpenReception => '受信を開く';

  @override
  String get simFleetSection => '船団';

  @override
  String get simRadiusKm => '半径（km）';

  @override
  String get simVessels => '船舶数';

  @override
  String get simSpeedMinKn => '最小速度（kn）';

  @override
  String get simSpeedMaxKn => '最大速度（kn）';

  @override
  String get simIntervalS => '間隔（s）';

  @override
  String get simSeed => 'シード';

  @override
  String get simAnchoredPct => '停泊中（%）';

  @override
  String get simNamePrefix => '名前プレフィックス';

  @override
  String get simMmsiMid => 'MMSI 国 / MID';

  @override
  String get simSearchMmid => '国を検索するか、3 桁の MID を入力してください';

  @override
  String get simCustom => 'カスタム';

  @override
  String get simVesselTypes => '船舶タイプ';

  @override
  String get simRealisticNames => '現実的な名前';

  @override
  String get simRealisticDimensions => '現実的な寸法';

  @override
  String get simRealisticMmsi => '現実的な ITU MMSI';

  @override
  String get simZoneSection => 'ゾーン & 交通';

  @override
  String get simLocationPreset => '位置プリセット';

  @override
  String get simSearchPort => '港を検索…';

  @override
  String get simCenterLat => '中心緯度';

  @override
  String get simCenterLon => '中心経度';

  @override
  String get simZoneShape => 'ゾーン形状';

  @override
  String get simTransitPct => '航行中（%）';

  @override
  String get simRegeneratePeriodically => '定期的に再生成';

  @override
  String get simRegenerateTicks => '再生成（ティック）';

  @override
  String get simPresetHint => 'プリセットを選んで座標を入力するか、中心緯度 / 経度を直接入力してください。';

  @override
  String get simMovementSection => '移動 & 発信';

  @override
  String get simVarySpeed => '時間とともに速度を変化させる';

  @override
  String get simReportIntervalTicks => 'レポート間隔（ティック）';

  @override
  String get simWander => 'ウォンダー（0-3）';

  @override
  String get simSpeedByType => '船舶タイプ別の速度';

  @override
  String get simClassBSharePct => 'クラス B の割合（%）';

  @override
  String get simHighAccuracy => '高精度';

  @override
  String get simRealisticRot => '現実的な回頭率';

  @override
  String get simContentSection => 'コンテンツ';

  @override
  String get simSafetyTexts => '安全テキスト（1 行に 1 つ）';

  @override
  String get simDestinations => '目的地（1 行に 1 つ）';

  @override
  String get simStationsSection => '局';

  @override
  String get simBaseStations => '基地局';

  @override
  String get simAtoN => 'AtoN';

  @override
  String get simQualitySection => '伝送品質';

  @override
  String get simInjectErrors => 'エラーを注入';

  @override
  String get simErrorRatePct => 'エラー率（%）';

  @override
  String get simTalkerId => 'トーカー ID';

  @override
  String get simNmea4Tag => 'NMEA 4.0 タグブロック';

  @override
  String get simMessagesSection => 'メッセージ';

  @override
  String get simApplyFleet => '船団を適用';

  @override
  String get simRegenerateFleet => '船団を再生成';

  @override
  String get simLiveFleet => 'ライブ船団';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats 隻 · $frames フレームを送信';
  }

  @override
  String get mapSearchVessels => '船舶を検索';

  @override
  String get mapSearchHint => '名前、MMSI、または IMO';

  @override
  String get mapNoResults => '結果なし';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'フィルター';

  @override
  String mapAllLabel(Object label) {
    return 'すべての $label';
  }

  @override
  String get mapVesselType => '船舶タイプ';

  @override
  String get mapNavigationStatus => '航行状態';

  @override
  String get mapCountry => '国';

  @override
  String get mapMinSog => '最小 SOG（kn）';

  @override
  String get mapMaxSog => '最大 SOG（kn）';

  @override
  String get mapOnlyNamed => '名前のある船舶のみ';

  @override
  String get mapReset => 'リセット';

  @override
  String get mapApply => '適用';

  @override
  String get mapAutoBasemap => '自動（テーマに従う）';

  @override
  String mapFollowing(Object mmsi) {
    return '$mmsi を追跡中';
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
  String get basemapVoyagerLight => 'Voyager（ライト）';

  @override
  String get basemapPositronLight => 'Positron（ライト最小限）';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Esri 衛星画像';

  @override
  String get basemapEsriStreets => 'Esri ワールドストリートマップ';

  @override
  String get decoderInputLabel => '1 つ以上の NMEA AIS 文を貼り付けるか入力してください';

  @override
  String get decoderValidateChecksums => 'チェックサムを検証';

  @override
  String get decoderDecode => 'デコード';

  @override
  String get decoderDecoded => 'デコード済み';

  @override
  String decoderDecodedN(Object n) {
    return 'デコード済み（$n 文）';
  }

  @override
  String get decoderInvalidChecksum => '不正なチェックサム';

  @override
  String get decoderParseError => 'パースエラー';

  @override
  String get decoderWaitingFragments => '追加のフラグメントを待機中…';

  @override
  String decoderTagSource(Object id) {
    return 'ソース $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'タグブロック · $content';
  }

  @override
  String get fMessageType => 'メッセージタイプ';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'リピートインジケーター';

  @override
  String get fNavStatus => '航行状態';

  @override
  String get fLatitude => '緯度';

  @override
  String get fLongitude => '経度';

  @override
  String get fSogKn => 'SOG（kn）';

  @override
  String get fCogDeg => 'COG（°）';

  @override
  String get fHeadingDeg => '船首方位（°）';

  @override
  String get fRateOfTurn => '回頭率';

  @override
  String get fManeuver => '操縦';

  @override
  String get fTimestamp => 'タイムスタンプ';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => '精度';

  @override
  String get fEpfdFixType => 'EPFD 測位タイプ';

  @override
  String get fSyncState => '同期状態';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'コールサイン';

  @override
  String get fVesselName => '船名';

  @override
  String get fShipType => '船舶タイプ';

  @override
  String get fShipTypeText => '船舶タイプ（テキスト）';

  @override
  String get fDims => '船首/船尾/左舷/右舷（m）';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => '喫水（m）';

  @override
  String get fDestination => '目的地';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => '宛先 MMSI';

  @override
  String get fSeqNumber => 'シーケンス番号';

  @override
  String get fRetransmit => '再送信';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'データ';

  @override
  String get fAltitudeM => '高度（m）';

  @override
  String get fAssignedMode => '割当モード';

  @override
  String get fRegionalReserved => '地域予約';

  @override
  String get fText => 'テキスト';

  @override
  String fStationN(Object n) {
    return '局 $n';
  }

  @override
  String fSlotN(Object n) {
    return 'スロット $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return 'オフセット $offset · 番号 $number · タイムアウト $timeout · 増分 $increment';
  }

  @override
  String get fAidType => '航路標識タイプ';

  @override
  String get fAidTypeCode => '航路標識タイプ（コード）';

  @override
  String get fName => '名前';

  @override
  String get fNameExt => '名前の拡張';

  @override
  String get fVirtualAid => '仮想航路標識';

  @override
  String get fOffPosition => '位置外れ';

  @override
  String get fSecond => '秒';

  @override
  String get fChannelA => 'チャンネル A';

  @override
  String get fChannelB => 'チャンネル B';

  @override
  String get fTxRxMode => 'TX/RX モード';

  @override
  String get fPower => '電力';

  @override
  String get fZone => 'ゾーン';

  @override
  String get fAddressed => '宛先指定';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'バンド A';

  @override
  String get fBandB => 'バンド B';

  @override
  String get fZoneSize => 'ゾーンサイズ';

  @override
  String get fStationType => '局タイプ';

  @override
  String get fReportInterval => 'レポート間隔';

  @override
  String get fQuietTime => 'クワイエットタイム';

  @override
  String get fPart => 'パート';

  @override
  String get fVendorId => 'ベンダー ID';

  @override
  String get fUnitModel => 'ユニットモデル';

  @override
  String get fSerialNumber => 'シリアル番号';

  @override
  String get fMothershipMmsi => '母船 MMSI';

  @override
  String get fRadioStatus => '無線状態';

  @override
  String get fGnssStatus => 'GNSS 位置状態';

  @override
  String fDestN(Object n) {
    return '宛先 $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi seq $seq';
  }

  @override
  String get fDestIndicator => '宛先インジケーター';

  @override
  String get fBinaryDataFlag => 'バイナリデータフラグ';

  @override
  String get fApplicationId => 'アプリケーション ID';

  @override
  String get fPowerHigh => '高';

  @override
  String get fPowerLow => '低';

  @override
  String get fPartA => 'A（名前）';

  @override
  String get fPartB => 'B（船舶データ）';

  @override
  String get editorTitle => 'AIS メッセージエディタ';

  @override
  String get editorCompose => 'メッセージを作成';

  @override
  String get editorMessageType => 'メッセージタイプ';

  @override
  String get editorAddTagBlock => 'NMEA 4.0 タグブロックを追加';

  @override
  String get editorSourceId => 'ソース ID';

  @override
  String get editorInjectToMap => '地図に注入';

  @override
  String get editorSendToTarget => '送信先に送信';

  @override
  String get editorPreview => 'NMEA プレビュー';

  @override
  String get editorNmeaCopied => 'NMEA をコピーしました';

  @override
  String get editorInjected => 'メッセージを注入しました';

  @override
  String get editorSentToTarget => 'メッセージを送信先に送信しました';

  @override
  String get editorNavStatus0_15 => '航行状態（0-15）';

  @override
  String get editorYear => '年';

  @override
  String get editorMonth => '月';

  @override
  String get editorDay => '日';

  @override
  String get editorHour => '時';

  @override
  String get editorMinute => '分';

  @override
  String get editorSecond => '秒';

  @override
  String get editorImoNumber => 'IMO 番号';

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
  String get editorEtaHour => 'ETA 時';

  @override
  String get editorEtaMinute => 'ETA 分';

  @override
  String get editorSequence0_3 => 'シーケンス（0-3）';

  @override
  String get editorDataBytes => 'データバイト（hex または 1,2,3）';

  @override
  String get editorDestMmsisComma => '宛先 MMSI（カンマ区切り）';

  @override
  String get editorSequencesComma => 'シーケンス（カンマ区切り）';

  @override
  String get editorInterrogatedMmsi => 'インタロゲート対象 MMSI';

  @override
  String get editorType1 => 'タイプ 1';

  @override
  String get editorOffset1 => 'オフセット 1';

  @override
  String get editorTargetMmsi => 'ターゲット MMSI';

  @override
  String get editorOffset => 'オフセット';

  @override
  String get editorIncrement => '増分';

  @override
  String get editorNumber => '番号';

  @override
  String get editorTimeout => 'タイムアウト';

  @override
  String get editorAidType0_31 => '航路標識タイプ（0-31）';

  @override
  String get editorVirtualAid0_1 => '仮想航路標識（0/1）';

  @override
  String get editorTxRxMode0_15 => 'Tx/Rx モード（0-15）';

  @override
  String get editorTxRxMode0_3 => 'Tx/Rx モード（0-3）';

  @override
  String get editorNeLat => '北東緯度';

  @override
  String get editorNeLon => '北東経度';

  @override
  String get editorSwLat => '南西緯度';

  @override
  String get editorSwLon => '南西経度';

  @override
  String get editorInterval0_15 => '間隔（0-15）';

  @override
  String get editorPart => 'パート（0 = A 名前、1 = B 静的）';

  @override
  String get editorDestMmsiEmpty => '宛先 MMSI（空 = ブロードキャスト）';

  @override
  String get editorAppDacEmpty => 'アプリ DAC（空 = なし）';

  @override
  String get editorAppFidEmpty => 'アプリ FID（空 = なし）';

  @override
  String get nmeaTalker => 'トーカー';

  @override
  String get nmeaFragments => 'フラグメント';

  @override
  String get nmeaFragmentN => 'フラグメント #';

  @override
  String get nmeaMessageId => 'メッセージ ID';

  @override
  String get nmeaChannel => 'チャンネル';

  @override
  String get nmeaPayload => 'ペイロード';

  @override
  String get nmeaFillBits => 'フィルビット';

  @override
  String get nmeaTagBlock => 'タグブロック';

  @override
  String get nmeaChecksum => 'チェックサム';

  @override
  String get nmeaEmpty => '（空）';

  @override
  String get bubbleKindVessel => '船舶';

  @override
  String get bubbleKindAircraft => 'SAR 航空機';

  @override
  String get bubbleKindAton => '航路標識';

  @override
  String get bubbleKindStation => '基地局';

  @override
  String get bubbleGeneralInfo => '一般情報';

  @override
  String get bubbleKind => '種類';

  @override
  String get bubbleAidType => '航路標識タイプ';

  @override
  String get bubbleVirtual => '仮想';

  @override
  String get bubbleAltitude => '高度';

  @override
  String get bubbleCallSign => 'コールサイン';

  @override
  String get bubblePosNav => '位置 & 航行';

  @override
  String get bubbleHeading => '船首方位';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => '船舶の詳細';

  @override
  String get bubbleType => 'タイプ';

  @override
  String get bubbleTypeInt => 'タイプ（整数）';

  @override
  String get bubbleDimsBowStern => '寸法 船首/船尾';

  @override
  String get bubbleDimsPortStarboard => '寸法 左舷/右舷';

  @override
  String get bubbleSpare => '予備';

  @override
  String get bubbleDraught => '喫水';

  @override
  String bubbleFrames(Object n) {
    return 'フレーム（$n）';
  }

  @override
  String get bubbleNoFrames => 'フレームはまだありません';

  @override
  String get copied => 'コピーしました';

  @override
  String get textFiles => 'テキストファイル';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'ターゲット $name が接続されました（$protocol $host:$port）。';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'ターゲット $name に接続できませんでした: $error';
  }

  @override
  String get logStopping => 'フォワーダーを停止しています...';

  @override
  String get logStopped => 'フォワーダーを停止しました。';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'フィードを追加しました: $name（$host:$port）';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'フィードを削除しました: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'フィード $name が接続されました。';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'フィード $name が切断されました。5 秒後に再接続します...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'フィード $name への接続に失敗しました: $error。5 秒後に再試行します...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'ターゲット $name: TCP サーバーがポート $port で待機中';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'ターゲット $name: クライアントが接続しました $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'ターゲット $name: クライアントが切断されました';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'ターゲット $name: クライアントエラー $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'ターゲット $name の送信エラー: $error';
  }

  @override
  String get docNavStatus0 => '機関使用航行中';

  @override
  String get docNavStatus1 => '停泊中';

  @override
  String get docNavStatus2 => '操船不能';

  @override
  String get docNavStatus3 => '操縦性能制限中';

  @override
  String get docNavStatus4 => '喫水により制限';

  @override
  String get docNavStatus5 => '係留中';

  @override
  String get docNavStatus6 => '座礁';

  @override
  String get docNavStatus7 => '漁労従事中';

  @override
  String get docNavStatus8 => '帆走中';

  @override
  String get docNavStatus9 => '予約（HSC）';

  @override
  String get docNavStatus10 => '予約（WIG）';

  @override
  String get docNavStatus11 => '曳航中（後方）（地域）';

  @override
  String get docNavStatus12 => '押送 / 側面曳航（地域）';

  @override
  String get docNavStatus13 => '将来の使用のために予約';

  @override
  String get docNavStatus14 => 'AIS-SART 作動中';

  @override
  String get docNavStatus15 => '未定義（既定）';

  @override
  String get docEpfd0 => '未定義（既定）';

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
  String get docEpfd6 => '統合航法システム';

  @override
  String get docEpfd7 => '実測（固定）';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => '内部 GNSS';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · ビット $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields フィールド · 合計 $bits ビット · セグメントをタップ';
  }

  @override
  String get docTextToEncode => 'エンコードするテキスト';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      '各文字は 1 つの 6 ビット値です（\"@\" = 0、空白 = 32、\"A\" = 1…）。小文字はエンコードできず、通常は大文字として送信されます。';

  @override
  String get docChecksumBody => '本体（先頭の ! と末尾の *XX を除く）';

  @override
  String get docChecksumExplanation =>
      'NMEA チェックサムは、「!」と「*」の間のすべてのバイトの XOR です。';

  @override
  String get docLatitude => '緯度';

  @override
  String get docLongitude => '経度';

  @override
  String get docLatitudeInvalid => '緯度: 数値を入力してください';

  @override
  String get docLongitudeInvalid => '経度: 数値を入力してください';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return '緯度 → $value（27 ビット符号付き、deg = $deg / 600000）';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return '経度 → $value（28 ビット符号付き、deg = $deg / 600000）';
  }

  @override
  String get docCoordsExplanation =>
      '座標は分の 1/10 000 単位で格納されます。度数に戻すには 600 000 で割ります。';

  @override
  String get docSearchShipTypes => '船舶タイプを検索';

  @override
  String get docShipCat0_19 => '0-19 · 予約';

  @override
  String get docShipCat20_29 => '20-29 · 地表効果機（WIG）';

  @override
  String get docShipCat30_39 => '30-39 · 漁船';

  @override
  String get docShipCat40_49 => '40-49 · 高速船';

  @override
  String get docShipCat50_59 => '50-59 · 特殊船舶';

  @override
  String get docShipCat60_69 => '60-69 · 旅客船';

  @override
  String get docShipCat70_79 => '70-79 · 貨物船';

  @override
  String get docShipCat80_89 => '80-89 · タンカー';

  @override
  String get docShipCat90_99 => '90-99 · その他';

  @override
  String get docSearchGlossary => '用語集を検索';

  @override
  String get docNoMatchingTerms => '一致する用語はありません。';

  @override
  String get docAspect => '態様';

  @override
  String get docClassA => 'クラス A';

  @override
  String get docClassB => 'クラス B';

  @override
  String get docCheatRadio => '無線';

  @override
  String get docCheatFrequencies => '周波数';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 MHz（87B）· AIS2 162.025 MHz（88B）';

  @override
  String get docCheatModulation => '変調';

  @override
  String get docCheatModulationValue => 'GMSK、9 600 bits/s';

  @override
  String get docCheatRange => '到達距離';

  @override
  String get docCheatRangeValue => '船間で約 10-20 NM、見通し距離';

  @override
  String get docCheatReportingRates => 'レポート頻度';

  @override
  String get docCheatClassAPos1 => 'クラス A 位置（1）';

  @override
  String get docCheatClassAPos1Value => '航行中は 2-10 秒ごと、停泊中は 3 分ごと';

  @override
  String get docCheatStatic5 => '静的（5）';

  @override
  String get docCheatStatic5Value => '6 分ごと';

  @override
  String get docCheatClassBPos18 => 'クラス B 位置（18）';

  @override
  String get docCheatClassBPos18Value => '約 30 秒ごと';

  @override
  String get docCheatAtoN21 => '航路標識（21）';

  @override
  String get docCheatAtoN21Value => '3 分ごと';

  @override
  String get docCheatNavStatus0_15 => '航行状態（0-15）';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => '機関使用航行中';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => '停泊中';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => '操縦性能制限中';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => '係留中';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => '座礁';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => '漁労中';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => '帆走中';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART 作動中';

  @override
  String get docCheatMmsiFormats => 'MMSI 形式';

  @override
  String get docCheatFixTypes => '測位タイプ（EPFD）';

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
  String get docCheatEpfd15Value => '内部 GNSS';

  @override
  String get docCheatFooter =>
      'KikAis はすべてのタブで完全な対話型リファレンスを提供しています — エディタで任意のメッセージを組み立て、デコーダでそれを読み戻せます。';

  @override
  String get docMmsiFmtDiversRadio => '潜水士用無線機';

  @override
  String get docMmsiFmtShip => '船舶';

  @override
  String get docMmsiFmtGroupShips => '船舶グループ（例: 船団や米国沿岸警備隊）';

  @override
  String get docMmsiFmtCoastalShore => '沿岸 / 岸局';

  @override
  String get docMmsiFmtSarAircraft => 'SAR 航空機';

  @override
  String get docMmsiFmtAuxCraft => '親船に付随する補助船舶';

  @override
  String get docMmsiFmtAtoN => '航路標識';

  @override
  String get docMmsiFmtSart => 'AIS-SART（遭難救助用送信機）';

  @override
  String get docMmsiFmtMob => 'MOB（海中転落）機器';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB（緊急ビーコン）';

  @override
  String get docVesselCat0_9 => '予約 / 将来の使用';

  @override
  String get docVesselCat10_19 => '将来の使用のために予約';

  @override
  String get docVesselCat20_29 => '地表効果機（WIG）';

  @override
  String get docVesselCat30_39 => '漁船';

  @override
  String get docVesselCat40_49 => '高速船';

  @override
  String get docVesselCat50_59 => '特殊船舶（水先人、タグボート、浚渫船など…）';

  @override
  String get docVesselCat60_69 => '旅客船';

  @override
  String get docVesselCat70_79 => '貨物船';

  @override
  String get docVesselCat80_89 => 'タンカー';

  @override
  String get docVesselCat90_99 => 'その他のタイプ';

  @override
  String get docTalkerAB => '基地 AIS 局';

  @override
  String get docTalkerAD => '依存型 AIS 基地局';

  @override
  String get docTalkerAI => '移動 AIS 局';

  @override
  String get docTalkerAN => '航路標識 AIS 局';

  @override
  String get docTalkerAR => 'AIS 受信局';

  @override
  String get docTalkerAS => '限定基地局';

  @override
  String get docTalkerAT => 'AIS 送信局';

  @override
  String get docTalkerAX => 'AIS 中継局';

  @override
  String get docTalkerBS => '基地 AIS 局（非推奨）';

  @override
  String get docTalkerSA => '物理的な陸上 AIS 局';

  @override
  String get docType1Name => '位置レポート クラス A';

  @override
  String get docType1Family => '位置レポート';

  @override
  String get docType1Summary =>
      'このシステムの主力: 位置、針路、速度、船首方位、航行状態をブロードキャストするクラス A トランスポンダ。';

  @override
  String get docType1EmittedBy => 'クラス A トランスポンダ（SOLAS 船舶）';

  @override
  String get docType1Cadence => '航行中は 2-10 秒ごと、停泊中は 3 分ごと';

  @override
  String get docType2Name => '位置レポート クラス A（割当）';

  @override
  String get docType2Family => '位置レポート';

  @override
  String get docType2Summary =>
      'タイプ 1 と同じですが、基地局によって船舶に割り当てられたスロットスケジュール（割当モード）で送信されます。';

  @override
  String get docType2EmittedBy => '割当下のクラス A トランスポンダ';

  @override
  String get docType2Cadence => '割当スケジュール';

  @override
  String get docType3Name => '位置レポート クラス A（応答）';

  @override
  String get docType3Family => '位置レポート';

  @override
  String get docType3Summary => 'タイプ 1 と同じで、インタロゲーション（タイプ 15）への応答として送信されます。';

  @override
  String get docType3EmittedBy => 'インタロゲーションに応答するクラス A トランスポンダ';

  @override
  String get docType3Cadence => 'インタロゲーション時';

  @override
  String get docType4Name => '基地局レポート';

  @override
  String get docType4Family => '基地局 & ネットワーク';

  @override
  String get docType4Summary => '固定岸局の定期レポート: その位置と UTC の日付・時刻リファレンス。';

  @override
  String get docType4EmittedBy => '固定基地局';

  @override
  String get docType4Cadence => '10 秒ごと';

  @override
  String get docType5Name => '静的データおよび航海関連データ';

  @override
  String get docType5Family => '静的 & 航海データ';

  @override
  String get docType5Summary =>
      '船舶の「身分証明書」: 名前、コールサイン、IMO 番号、船舶タイプ、寸法、喫水、ETA、目的地。';

  @override
  String get docType5EmittedBy => 'クラス A トランスポンダ';

  @override
  String get docType5Cadence => '6 分ごと、およびデータ変更時';

  @override
  String get docType6Name => 'バイナリ宛先メッセージ';

  @override
  String get docType6Family => 'バイナリデータ';

  @override
  String get docType6Summary =>
      '特定の宛先 MMSI に送信される構造化バイナリペイロード（例: 要求された気象レポート）。';

  @override
  String get docType6EmittedBy => '任意の局';

  @override
  String get docType6Cadence => '要求時';

  @override
  String get docType7Name => 'バイナリ確認応答';

  @override
  String get docType7Family => 'バイナリデータ';

  @override
  String get docType7Summary => 'タイプ 6 のバイナリ宛先メッセージへの返信として送信される確認応答。';

  @override
  String get docType7EmittedBy => 'タイプ 6 を受信した任意の局';

  @override
  String get docType7Cadence => '返信時';

  @override
  String get docType8Name => 'バイナリブロードキャストメッセージ';

  @override
  String get docType8Family => 'バイナリデータ';

  @override
  String get docType8Summary =>
      '全員にブロードキャストされる構造化バイナリペイロード — 気象・水路レポート、地域データ、または民間・暗号化メッセージ。';

  @override
  String get docType8EmittedBy => '任意の局';

  @override
  String get docType8Cadence => '要求時';

  @override
  String get docType9Name => '標準 SAR 航空機位置レポート';

  @override
  String get docType9Family => '位置レポート';

  @override
  String get docType9Summary =>
      '捜索救助機が船舶から見えるように使用する位置レポート。高度と特別な MMSI 範囲（111MIDXXX）を運びます。';

  @override
  String get docType9EmittedBy => 'SAR 航空機';

  @override
  String get docType9Cadence => '任務中は 10 秒ごと';

  @override
  String get docType10Name => 'UTC および日付照会';

  @override
  String get docType10Family => '基地局 & ネットワーク';

  @override
  String get docType10Summary => '特定の局に UTC の日付と時刻を尋ねる小さな要求。';

  @override
  String get docType10EmittedBy => '任意の局';

  @override
  String get docType10Cadence => '要求時';

  @override
  String get docType11Name => 'UTC および日付応答';

  @override
  String get docType11Family => '基地局 & ネットワーク';

  @override
  String get docType11Summary => 'タイプ 4 と同じ構造で、タイプ 10 の UTC/日付照会への回答として送信されます。';

  @override
  String get docType11EmittedBy => '基地局';

  @override
  String get docType11Cadence => '照会時';

  @override
  String get docType12Name => '宛先指定安全関連メッセージ';

  @override
  String get docType12Family => '安全 & テキスト';

  @override
  String get docType12Summary =>
      '単一の宛先 MMSI に送信される自由文の安全メッセージ（例: 最寄りの基地局への遭難メッセージ）。';

  @override
  String get docType12EmittedBy => '任意の局';

  @override
  String get docType12Cadence => '要求時';

  @override
  String get docType13Name => '安全関連確認応答';

  @override
  String get docType13Family => '安全 & テキスト';

  @override
  String get docType13Summary => 'タイプ 12 の宛先指定安全メッセージへの返信として送信される確認応答。';

  @override
  String get docType13EmittedBy => 'タイプ 12 を受信した任意の局';

  @override
  String get docType13Cadence => '返信時';

  @override
  String get docType14Name => '安全関連ブロードキャストメッセージ';

  @override
  String get docType14Family => '安全 & テキスト';

  @override
  String get docType14Summary => '範囲内の全員に向けた自由文のブロードキャスト — 航行警報、遭難、または交通の案内。';

  @override
  String get docType14EmittedBy => '任意の局（多くの場合、基地局 / VTS）';

  @override
  String get docType14Cadence => '要求時';

  @override
  String get docType15Name => 'インタロゲーション';

  @override
  String get docType15Family => '基地局 & ネットワーク';

  @override
  String get docType15Summary =>
      '1 つまたは 2 つの特定の局に特定のメッセージタイプ（通常はタイプ 3 または 5）の送信を求める要求。';

  @override
  String get docType15EmittedBy => '基地局';

  @override
  String get docType15Cadence => '要求時';

  @override
  String get docType16Name => '割当モードコマンド';

  @override
  String get docType16Family => '基地局 & ネットワーク';

  @override
  String get docType16Summary => '最大 2 隻の船舶に特定のスロット割当（割当モード）での送信を指示します。';

  @override
  String get docType16EmittedBy => '基地局';

  @override
  String get docType16Cadence => '要求時';

  @override
  String get docType17Name => 'DGNSS バイナリブロードキャストメッセージ';

  @override
  String get docType17Family => 'バイナリデータ';

  @override
  String get docType17Summary =>
      '対象エリアの測位精度を向上させるため、岸局がブロードキャストする差分 GNSS 補正データ。';

  @override
  String get docType17EmittedBy => 'DGNSS 基準局';

  @override
  String get docType17Cadence => '定期';

  @override
  String get docType18Name => '標準クラス B CS 位置レポート';

  @override
  String get docType18Family => '位置レポート';

  @override
  String get docType18Summary =>
      '標準のクラス B 位置レポート。クラス A より軽量: 航行状態や回頭率はありませんが、CSTDMA と併用できます。';

  @override
  String get docType18EmittedBy => 'クラス B トランスポンダ';

  @override
  String get docType18Cadence => '30 秒ごと（地域によってはそれ以下）';

  @override
  String get docType19Name => '拡張クラス B 機器位置レポート';

  @override
  String get docType19Family => '位置レポート';

  @override
  String get docType19Summary =>
      '船名、船舶タイプ、寸法も運ぶ拡張クラス B 位置レポート — 静的データと位置を兼ねたワンショットハイブリッド。';

  @override
  String get docType19EmittedBy => '拡張クラス B トランスポンダ';

  @override
  String get docType19Cadence => '30 秒ごと';

  @override
  String get docType20Name => 'データリンク管理';

  @override
  String get docType20Family => '基地局 & ネットワーク';

  @override
  String get docType20Summary =>
      'エリア内の TDMA タイムスロットを割り当て・予約するためのネットワーク保守メッセージ。';

  @override
  String get docType20EmittedBy => '基地局';

  @override
  String get docType20Cadence => 'ネットワーク管理';

  @override
  String get docType21Name => '航路標識レポート';

  @override
  String get docType21Family => '航路標識';

  @override
  String get docType21Summary =>
      '航路標識 — ブイ、灯標、灯台、または仮想標識 — の位置、名前、状態をブロードキャストします。仮想位置から送信されることもよくあります。';

  @override
  String get docType21EmittedBy => 'AtoN 局（実物または仮想）';

  @override
  String get docType21Cadence => '3 分ごと（またはイベント時）';

  @override
  String get docType22Name => 'チャンネル管理';

  @override
  String get docType22Family => '基地局 & ネットワーク';

  @override
  String get docType22Summary => '基地局が地理的ゾーン内の局を異なる VHF チャンネルに切り替えるために使用します。';

  @override
  String get docType22EmittedBy => '基地局';

  @override
  String get docType22Cadence => '要求時';

  @override
  String get docType23Name => 'グループ割当コマンド';

  @override
  String get docType23Family => '基地局 & ネットワーク';

  @override
  String get docType23Summary => '基地局がゾーン内の船舶グループに対してレポート間隔と送信モードを設定するコマンド。';

  @override
  String get docType23EmittedBy => '基地局';

  @override
  String get docType23Cadence => '要求時';

  @override
  String get docType24Name => '静的データレポート';

  @override
  String get docType24Family => '静的 & 航海データ';

  @override
  String get docType24Summary =>
      'タイプ 5 のクラス B 版。パート A（名前）とパート B（船舶タイプ、コールサイン、寸法）に分かれています。';

  @override
  String get docType24EmittedBy => 'クラス B トランスポンダ';

  @override
  String get docType24Cadence => '6 分ごと';

  @override
  String get docType25Name => 'シングルスロットバイナリメッセージ';

  @override
  String get docType25Family => 'バイナリデータ';

  @override
  String get docType25Summary =>
      '単一の TDMA スロットに収まる短いバイナリメッセージ。宛先とアプリケーション ID は任意です。';

  @override
  String get docType25EmittedBy => '任意の局';

  @override
  String get docType25Cadence => '要求時';

  @override
  String get docType26Name => 'マルチスロットバイナリメッセージ';

  @override
  String get docType26Family => 'バイナリデータ';

  @override
  String get docType26Summary => '複数の TDMA スロットにまたがる長いバイナリメッセージで、無線状態情報を運びます。';

  @override
  String get docType26EmittedBy => '任意の局';

  @override
  String get docType26Cadence => '要求時';

  @override
  String get docType27Name => '長距離アプリケーション用位置レポート';

  @override
  String get docType27Family => '位置レポート';

  @override
  String get docType27Summary => '分解能を落として長距離での衛星受信を想定した、非常にコンパクトな位置レポート。';

  @override
  String get docType27EmittedBy => '長距離（衛星）モードの船舶';

  @override
  String get docType27Cadence => '3 分ごと（長距離モード）';

  @override
  String get docTimeline1990sTitle => 'スウェーデンの発明';

  @override
  String get docTimeline1990sText =>
      'その概念はスウェーデンで生まれた: 霧や島の背後でも、すべての船舶が自らを名乗り「見る、見られる」を実現する VHF システム。IMO に提示され、AIS の種となります。';

  @override
  String get docTimeline1998Title => '標準化の始まり';

  @override
  String get docTimeline1998Text =>
      'ITU と IEC が、2 つの VHF チャンネル上の TDMA に基づく精密なビットレベルの形式を持つ無線標準として、この概念の開発を開始します。';

  @override
  String get docTimeline2001Title => 'ITU-R M.1371 が発行';

  @override
  String get docTimeline2001Text =>
      '勧告 ITU-R M.1371「汎用船舶搭載自動識別システムの技術的特性」が、27 のメッセージタイプとそのビットレイアウトを定義します。';

  @override
  String get docTimeline2002Title => 'SOLAS による義務化';

  @override
  String get docTimeline2002Text =>
      'IMO は総トン数 300 トン以上の国際航海船舶すべてと、全旅客船に AIS を義務付けます — 約 100,000 隻。AIS はレーダーと並ぶ標準の衝突防止支援となります。';

  @override
  String get docTimeline2006Title => 'クラス B の登場';

  @override
  String get docTimeline2006Text =>
      'クラス B 標準が発行され、安価でシンプルなトランスポンダへの道が開かれます。同年、TacSat-2 衛星が宇宙から AIS 信号を捕捉した最初の衛星になります（S-AIS）。';

  @override
  String get docTimeline2008_2015Title => '衛星コンステレーション';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth、ORBCOMM、Spire などが低軌道に AIS 受信機を配備し、VHF の地平線をはるかに超えてカバレッジを広げ、ほぼ地球規模の船舶追跡を可能にします。';

  @override
  String get docTimeline2010Title => 'GMDSS における AIS-SART';

  @override
  String get docTimeline2010Text =>
      'AIS 捜索救助用送信機（AIS-SART、IEC 61097-14）が世界海上遭難安全システムに加わり、救命ボートが遭難位置を AIS でブロードキャストできるようになります。';

  @override
  String get docTimeline2014Title => '漁業船団と内陸船団';

  @override
  String get docTimeline2014Text =>
      'EU の規則により、15 m を超えるすべての EU 漁船にクラス A AIS が義務付けられます。また、内陸水路の AIS はヨーロッパの河川で広く展開されています。';

  @override
  String get docTimeline2021Title => '160 万隻の船舶';

  @override
  String get docTimeline2021Text =>
      '160 万隻を超える船舶に AIS が搭載され、世界中の船舶追跡、漁業管理、海上保安を支える陸上・衛星ネットワークにデータを供給しています。';

  @override
  String get docTimelineVdesTitle => 'VDES — 後継者';

  @override
  String get docTimelineVdesText =>
      'VHF データ交換システム（ITU-R M.2092）が混雑海域の緩和に向けて展開されており、はるかに広い帯域と安全な e-navigation サービスを追加します。';

  @override
  String get docAppTitle => 'ドキュメント';

  @override
  String get docSearchChapters => '章を検索';

  @override
  String get docChapterOverview => '概要';

  @override
  String get docChapterHistory => '歴史 & 規制';

  @override
  String get docChapterHowItWorks => '仕組み';

  @override
  String get docChapterRadio => '無線 & TDMA';

  @override
  String get docChapterClasses => 'クラス & 機器';

  @override
  String get docChapterMmsi => 'MMSI & 識別';

  @override
  String get docChapterShipTypes => '船舶タイプ';

  @override
  String get docChapterMessages => '27 のメッセージ';

  @override
  String get docChapterNmea => 'NMEA & AIVDM';

  @override
  String get docChapterPayload => 'ペイロードの中身';

  @override
  String get docChapterSecurity => 'セキュリティ & 限界';

  @override
  String get docChapterFieldNotes => '現場ノート';

  @override
  String get docChapterKikais => 'KikAis での AIS';

  @override
  String get docChapterGlossary => '用語集';

  @override
  String get docChapterCheatSheet => 'チートシート';

  @override
  String get docChapterSources => '出典';

  @override
  String get docOverviewTitle => 'AIS とは？';

  @override
  String get docOverviewIntro =>
      '自動識別システム（AIS）は、船舶と船舶交通サービス（VTS）で使用される追跡システムです。装備されたすべての船舶は、自分の識別情報、位置、針路、速度を VHF 無線で継続的にブロードキャストし、範囲内の他のすべての船舶と岸局がそれを「見る」ことができます — これが「見る、見られる」の概念です。';

  @override
  String get docOverviewRadar =>
      'AIS は船舶レーダーに取って代わるものではありません。レーダーはあらゆる物体を独立して検出しますが、それが誰であるかはほとんど教えてくれません。AIS は誰が、どこに、どこへ向かっているのかを正確に教えてくれます — ただし、送信者が申告した内容を信頼します。この 2 つのシステムは相互に補完します。';

  @override
  String get docOverviewAdsBTitle => '海上の ADS-B と考えてください';

  @override
  String get docOverviewAdsBText =>
      'ADS-B が航空機を航空管制に自己申告させるように、AIS は船舶を互いに、そして陸上に自己申告させます。船舶は周囲の交通をチャートプロッターやレーダー風の表示で確認し、港湾当局は動きと漁業を監視します。';

  @override
  String get docOverviewTransponder => 'トランスポンダがブロードキャストするもの';

  @override
  String get docOverviewBullet1 => '一意の識別情報: 9 桁の MMSI 番号（先頭 3 桁が発行国を識別します）。';

  @override
  String get docOverviewBullet2 =>
      '動的データ: 位置、対地速度（SOG）、対地針路（COG）、真船首方位、回頭率、航行状態。';

  @override
  String get docOverviewBullet3 =>
      '静的 & 航海データ: 名前、コールサイン、IMO 番号、船舶タイプ、寸法、喫水、目的地、ETA。';

  @override
  String get docOverviewBullet4 => '安全・バイナリメッセージ: 遭難テキスト、気象レポート、ネットワークコマンド。';

  @override
  String get docOverviewWho => '搭載義務があるもの';

  @override
  String get docOverviewImo =>
      'IMO（SOLAS 条約）は、総トン数 300 トン以上の国際航海船舶とすべての旅客船に AIS を義務付けています。地域規則はこれを漁業船団、内陸水路、さらに低価格のクラス B トランスポンダを通じたレジャーボートにも拡大しています。';

  @override
  String get docOverviewLimits => '限界の概要';

  @override
  String get docOverviewLimit1 =>
      '到達距離はほぼ見通し距離: 船間で約 10-20 海里、沿岸局と衛星からはさらに遠くなります。';

  @override
  String get docOverviewLimit2 =>
      'AIS には認証がありません: 誰でも任意の識別情報を送信（スプーフィング）したり、チャンネルを妨害したりできます。';

  @override
  String get docOverviewLimit3 => '精度は送信者の GNSS 測位と、それが申告するデータの正確さに依存します。';

  @override
  String get docHistoryIntro =>
      'AIS はスウェーデンのアイデアから世界規模の義務的な安全システムへと成長しました。詳細はタイムライン上のマイルストーンをタップしてください。';

  @override
  String get docHistoryStandards => '規定する標準';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — 汎用船舶搭載 AIS の技術的特性（27 のメッセージタイプとそのビットレイアウトを定義）。';

  @override
  String get docHistoryStd2 => 'IALA ガイドライン — 明確化と実装ガイダンス。';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — NMEA 文のフレーミングとクラス B/CSTDMA の要件。';

  @override
  String get docHistoryStd4 => 'IEC 61097-14 — AIS-SART 遭難送信機。';

  @override
  String get docHowIntro =>
      'AIS は VHF 無線システムです。各トランスポンダは周囲の交通を聞き、予約したタイムスロットで自分のレポートを送信し、範囲内の他の船舶との衝突を回避します。';

  @override
  String get docHowRadioLink => '無線リンク';

  @override
  String get docHowRadioLink1 =>
      '専用の 2 つの VHF チャンネル: 161.975 MHz（87B）の AIS 1 と 162.025 MHz（88B）の AIS 2。';

  @override
  String get docHowRadioLink2 => 'デジタル狭帯域 FM、毎秒 9 600 ビット。';

  @override
  String get docHowRadioLink3 =>
      'メッセージは 2250 のタイムスロット（1 分）からなる TDMA フレームに編成されます。';

  @override
  String get docHowSlots => 'スロットの共有方法';

  @override
  String get docHowSotdma =>
      'クラス A トランスポンダは SOTDMA（自己組織化時分割多元接続）を使用します: 各ユニットが繰り返しのスロットを予約し、状況が変わると再予約するため、中央の制御装置なしで船舶が継続的に調整し合います。';

  @override
  String get docHowCstdma =>
      'クラス B トランスポンダはより単純な CSTDMA（キャリアセンス TDMA）を使用します: 空きスロットを聞いて確保するため、クラス B のレポートは頻度が低くなり、非常に混雑した交通では失われることがあります。';

  @override
  String get docHowRates => 'レポート頻度';

  @override
  String get docHowRates1 => 'クラス A 位置レポート（タイプ 1）: 航行中は 2-10 秒ごと、停泊中は 3 分ごと。';

  @override
  String get docHowRates2 => '静的 & 航海データ（タイプ 5）: 6 分ごと。';

  @override
  String get docHowRates3 => 'クラス B 位置（タイプ 18）: およそ 30 秒ごと。';

  @override
  String get docHowRates4 => '航路標識（タイプ 21）: 3 分ごと。';

  @override
  String get docHowTerrestrial => '地上と衛星';

  @override
  String get docHowTerrestrialText =>
      '地表では、AIS の到達距離は VHF の地平線（T-AIS）によって制限されます。2000 年代半ば以降、低軌道の衛星（S-AIS）が同じ信号を受信し、ほぼ地球規模のカバレッジを提供しています — 衛星は地上ネットワークを補強するものであり、置き換えるものではありません。';

  @override
  String get docRadioIntro =>
      'メッセージの下には、小型で効率的な無線システムがあります。AIS は 2 つの VHF チャンネルで毎秒 9 600 ビットを送信し、ガウス最小偏移変調（GMSK）と HDLC スタイルのフレーミングを使用します。';

  @override
  String get docRadioPhysical => '物理リンク';

  @override
  String get docRadioPhysical1 =>
      '161.975 MHz の AIS 1 と 162.025 MHz の AIS 2（VHF チャンネル 87B と 88B）。';

  @override
  String get docRadioPhysical2 => '9 600 ボーの GMSK 変調 — 海上 VHF 帯域に収まるほど狭帯域。';

  @override
  String get docRadioPhysical3 =>
      'ビットスタッフィングを伴う HDLC フレーミングと、パケット無線の世界から受け継がれた NRZI ラインハコーディング。';

  @override
  String get docRadioFrames => 'TDMA フレームとスロット';

  @override
  String get docRadioFrames1 =>
      '各チャンネルは正確に 1 分のフレームに分割され、約 26.7 ms の 2 250 タイムスロットに分かれます。';

  @override
  String get docRadioFrames2 =>
      '1 スロットが 1 つの AIS メッセージを運びます（ランプアップ/ダウンとガードタイムを含む 256 ビット）。';

  @override
  String get docRadioFrames3 =>
      '局は毎フレーム同じスロットを再利用するため、衝突することなく定期的にブロードキャストします。';

  @override
  String get docRadioCode =>
      '2250 スロット/フレーム · 1 フレーム = 60 s · スロット ≈ 26.7 ms · 9600 bit/s';

  @override
  String get docRadioSotdma => 'SOTDMA — クラス A の自己組織化';

  @override
  String get docRadioSotdmaText =>
      '各クラス A トランスポンダは周囲のスロットを聞き、空きを選んで次にいつ送信するかを無線状態フィールドで通知します。局は交通状況が変わるにつれて継続的に再予約するため、中央の調整者は不要です。';

  @override
  String get docRadioCstdma => 'CSTDMA — クラス B の参加方法';

  @override
  String get docRadioCstdmaText =>
      'クラス B ユニットはより単純です: 現在空いているスロットを聞いて、その中で一度だけ送信します。これは安価ですが、スロットが常に塞がっている非常に混雑した交通ではクラス B のレポートが失われることがあります。';

  @override
  String get docRadioVdes => 'VDES — 未来';

  @override
  String get docRadioVdesText =>
      'VHF データ交換システム（ITU-R M.2092）が混雑海域の緩和に向けて展開されています: 既存の AIS サービスに加えて、新しい周波数、はるかに広い帯域、e-navigation のための安全な双方向データを追加します。';

  @override
  String get docClassesIntro =>
      'AIS ハードウェアにはさまざまなクラスと役割があります。最もよく目にするのは、フル機能のクラス A トランスポンダと低価格のクラス B ユニットでしょう。';

  @override
  String get docClassesComparison => 'クラス A とクラス B の比較';

  @override
  String get docClassesReceivers => '受信機とトランスポンダ';

  @override
  String get docClassesReceiversText =>
      'トランスポンダは受信と送信の両方を行います。多くの岸局や趣味のユーザーは受信のみを実行しており、自分の姿を表示せずに交通を監視できます。';

  @override
  String get docClassesAton => '航路標識';

  @override
  String get docClassesAtonText =>
      'AtoN 局（タイプ 21）はブイ、灯標、灯台をブロードキャストします。また、海図上にのみ存在するマーカーである仮想標識を送信することもでき、新しい危険を警告するのに役立ちます。';

  @override
  String get docClassesDistress => '遭難 & 安全機器';

  @override
  String get docClassesDistressIntro =>
      '通常の船舶に加えて、AIS はすべての受信機が認識できるはずの遭難送信機を運びます:';

  @override
  String get docClassesSartNote =>
      '作動中の SART は、その位置レポートの航行状態 14（「AIS-SART 作動中」）も設定します。';

  @override
  String get docShipTypesIntro =>
      'タイプ 5 と 24 の静的メッセージは、船舶が何であるかを表す 8 ビットの船舶タイプコード（0-99）を運びます — 貨物船、タンカー、漁船、プレジャーボートなど。完全な表は以下に示します。';

  @override
  String get docShipTypesCategories => 'カテゴリの概要';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle => '現場ノート & 実際の癖';

  @override
  String get docFieldNotesIntro =>
      '実際の AIS 交通は理論どおりとは限りません。これらの癖を知ることは、デコーダが表示する内容と拒否する内容の両方を信頼する助けになります。';

  @override
  String get docGlossaryIntro => 'このガイド全体と AIS コミュニティで使用される頭字語と用語の検索可能な辞書です。';

  @override
  String get docCheatSheetIntro => '重要な数値とコードの概要 — 周波数、レポート頻度、状態コード、形式。';

  @override
  String get docMmsiIntro =>
      '海上移動業務識別（MMSI）は、船舶の無線機器を識別する一意の 9 桁の番号で、船舶にとっての電話番号のようなものです。先頭 3 桁は MID — 発行国を識別する海上識別桁です。';

  @override
  String get docMmsiFormats => '番号形式';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'MMSI を調べる';

  @override
  String get docMmsiLookupHint => '以下に 9 桁の MMSI を入力すると、そのクラスと発行機関の国が表示されます。';

  @override
  String get docMmsiMidHeading => '国コード（MID）';

  @override
  String get docMmsiMidText =>
      '完全な MID テーブルは KikAis に同梱されており、MMSI が表示されるすべての場所で使用されます。';

  @override
  String get docMessagesTitle => '27 のメッセージタイプ';

  @override
  String get docMessagesIntro =>
      'すべての AIS ペイロードは 6 ビットのメッセージタイプ（1 から 27）で始まります。以下のカタログはファミリーごとにグループ化されています。各カードには、KikAis 自身のエンコーダで生成された実際の NMEA 文、そのデコード済みフィールド、およびデコーダで開くボタンが表示されます。';

  @override
  String get docNmeaTitle => 'NMEA & AIVDM フレーミング';

  @override
  String get docNmeaIntro =>
      '回線上では、AIS メッセージは !AIVDM（他船）または !AIVDO（自船）で始まる NMEA 0183 文として伝送されます。ペイロードは ASCII アーマリングされたビットベクトルです。';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => '文のフィールド';

  @override
  String get docNmeaField1 =>
      'トーカー & フォーマッター — !AIVDM または !AIVDO（以下のトーカー ID を参照）。';

  @override
  String get docNmeaField2 =>
      'フラグメント数 — 完全なメッセージを構成する文の数（NMEA は各行を約 82 文字に制限します）。';

  @override
  String get docNmeaField3 => 'フラグメント番号 — これが何番目の部分か（1 から始まります）。';

  @override
  String get docNmeaField4 => 'シーケンシャルメッセージ ID — 同じメッセージのフラグメントを結び付けます。';

  @override
  String get docNmeaField5 => '無線チャンネル — A または B（AIS1 / AIS2）。';

  @override
  String get docNmeaField6 => 'データペイロード — 6 ビットアーマリングされた AIS ペイロード。';

  @override
  String get docNmeaField7 => 'フィルビット — 最後の 6 ビットグループに追加されたパッドビットの数（0-5）。';

  @override
  String get docNmeaField8 => 'チェックサム — * より前のすべてのバイトの XOR（16 進数）。';

  @override
  String get docNmeaMulti => 'マルチフラグメントメッセージ';

  @override
  String get docNmeaMultiText =>
      '1 行より長いメッセージ（タイプ 5 の静的データなど）は分割されます: 最初の文はフラグメント数 2 を報告し、2 番目が同じメッセージ ID で完成させます。';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => '6 ビットアーマリング';

  @override
  String get docNmeaArmoringText =>
      '各ペイロード文字は 6 ビットを保持します。ASCII コードから 48 を引き、結果が 40 を超える場合はさらに 8 を引きます。';

  @override
  String get docNmeaTalkers => 'トーカー ID';

  @override
  String get docNmeaTalkersIntro => '異なる NMEA 4.0 トーカー ID が AIS 局のタイプを識別します:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'チェックサム';

  @override
  String get docNmeaChecksumText =>
      '末尾のチェックサムは、「!」と「*」の間のすべてのバイトの XOR です。以下で自分で計算できます:';

  @override
  String get docNmeaInspectorTitle => '試してみる: 文インスペクター';

  @override
  String get docNmeaInspectorText =>
      '任意の AIVDM/AIVDO 文を貼り付けて（または上のサンプルを使用して）、そのフィールドの分解とデコード済みの値を確認します。';

  @override
  String get docPayloadIntro =>
      '6 ビットのアーマリングを元に戻すと、AIS ペイロードはビットフィールドのシーケンスになります。最初の 6 ビットはメッセージタイプ、次の 2 ビットはリピートインジケーター、その後は 30 ビットの MMSI です。';

  @override
  String get docPayloadCnb => '共通ナビゲーションブロック（タイプ 1-3）';

  @override
  String get docPayloadCnbText =>
      '最も重要なレイアウトはクラス A 位置レポートで共有されています。セレクターを使用して主要なメッセージレイアウトを参照し、セグメントをクリックしてそれが何をエンコードするかを読んでください。';

  @override
  String get docPayloadCoords => '座標';

  @override
  String get docPayloadCoordsText =>
      '緯度と経度は分の 1/10 000 単位で格納されます。度数にするには 600 000 で割ります: 1 度は 60 分、1 分は 10 000 単位。東と北が正になります。';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // 例: -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert => '以下で自分の座標を変換します:';

  @override
  String get docPayloadSpeed => '速度、針路、船首方位';

  @override
  String get docPayloadSpeed1 =>
      'SOG — ノットの 10 分の 1 単位の対地速度（0-102.2 kn）。1023 は「利用不可」を意味します。';

  @override
  String get docPayloadSpeed2 => 'COG — 真北を基準とした 10 分の 1 度単位の対地針路。';

  @override
  String get docPayloadSpeed3 => '船首方位 — 整数度の真船首方位。511 は「利用不可」を意味します。';

  @override
  String get docPayloadSpeed4 =>
      'ROT — 回頭率: 値 ≈ 4.733 × √（°/分の回頭率）、符号付き（正 = 右）。';

  @override
  String get docPayloadNavStatus => '航行状態';

  @override
  String get docPayloadEpfd => '測位タイプ（EPFD）';

  @override
  String get docPayloadText => '6 ビットテキスト';

  @override
  String get docPayloadTextIntro =>
      '名前、コールサイン、目的地はペイロード自体と同じ 6 ビットアルファベットを使用します。小文字はエンコードできないため、AIS の名前は通常大文字です。';

  @override
  String get docSecurityTitle => 'セキュリティ & データ品質';

  @override
  String get docSecurityIntro =>
      'AIS は協調を目的として設計されており、セキュリティのためではありません。無線チャンネルはオープンで暗号化されておらず、誰がブロードキャストしているかの認証もありません。';

  @override
  String get docSecurityThreats => '脅威';

  @override
  String get docSecurityThreat1 => 'スプーフィング — 偽の MMSI、位置、または識別情報の送信（幽霊船、制裁回避）。';

  @override
  String get docSecurityThreat2 =>
      '妨害 — 2 つの VHF チャンネルを氾濫させ、実際の交通を受信できないようにする。';

  @override
  String get docSecurityThreat3 => 'メアコニング — 他地域からの実際の信号を再生して受信機を混乱させる。';

  @override
  String get docSecurityQuality => 'データ品質';

  @override
  String get docSecurityQuality1 =>
      '位置精度ビットは、未補正の GNSS 測位（> 10 m）と DGPS 品質の測位（< 10 m）を区別します。';

  @override
  String get docSecurityQuality2 =>
      '受信機は位置、速度、タイムスタンプを健全性チェックする必要があります。実際のメッセージの約 0.3% はペイロード長が不正です。';

  @override
  String get docSecurityQuality3 =>
      '衛星 AIS は、衛星のフットプリントが TDMA セルよりはるかに大きいため、衝突が時折発生します — レーダーや他の情報源と照合するもう 1 つの理由です。';

  @override
  String get docKikaisIntro =>
      'KikAis は完全な AIS ラボです: ライブまたはシミュレーションの交通を受信し、デコードし、独自のメッセージを検査・送信し、船団を構築できます。各タブが今読んだ内容にどのように対応するかを以下に示します。';

  @override
  String get docTabReceptionText =>
      'フィード（ファイル、シリアル、シミュレーション）を選択し、フォワーダーを開始して、生の NMEA ストリームとデコード済みの船舶を確認します。';

  @override
  String get docTabSendText =>
      '受信した文を 1 つ以上の TCP/UDP ターゲットに転送します — 岸局がどのように交通を配信するかと同じ方法です。';

  @override
  String get docTabMapText =>
      'タイプ 1/2/3、18、19、27 の位置レポートからデコード済みの船舶がプロットされているのを確認します。';

  @override
  String get docTabEditorText =>
      '27 のメッセージタイプをすべて使いやすいフォームから手動で組み立てて送信できます — フィールドを学ぶのに最適な方法です。';

  @override
  String get docTabDecoderText =>
      '任意の文を貼り付けて、デコード済みフィールド、チェックサム、フラグメント処理を取得できます — このガイドの実用的なパートナーです。';

  @override
  String get docTabStatsText =>
      'メッセージカウンター、フィードごとのレート、デコーダの健全性（不正なチェックサム、破棄されたフラグメント）。';

  @override
  String get docTabSimulationText =>
      '任意の場所の周囲に船団全体を生成できます — すべてのメッセージタイプ、MMSI スキーム、ゾーン形状、エラー注入まで。';

  @override
  String get docSourcesIntro => 'このガイドは、公開されている信頼できるドキュメントを総合したものです:';

  @override
  String get docSources1 =>
      'gpsd — AIVDM/AIVDO プロトコルデコード（Eric S. Raymond 著。文形式とペイロードビットフィールドに関する事実上の技術書）。';

  @override
  String get docSources2 => 'Wikipedia — 自動識別システム（概要、歴史、応用、セキュリティ）。';

  @override
  String get docSources3 => '米国沿岸警備隊ナビゲーションセンター（NavCen） — AIS のページ。';

  @override
  String get docSources4 => 'ITU-R 勧告 M.1371 — 規定する AIS 標準。';

  @override
  String get docSources5 => 'IALA — ITU-R M.1371 の明確化。';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — NMEA フレーミング、クラス B、AIS-SART。';

  @override
  String get docSourcesLearn => 'さらに学ぶ方法';

  @override
  String get docSourcesLearnText =>
      'AIS を理解する最良の方法は実験です: エディタでメッセージを組み立て、デコーダで読み戻し、シミュレーションタブで船団全体を観察してください。このガイドのすべては KikAis 自身のエンコーダとデコーダによって生成されています。';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return 'タイプ $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits ビット · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return '送信元: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'デコーダで開く';

  @override
  String get docInspectorNmeaLabel => 'NMEA 文';

  @override
  String get docInspectorInspect => '検査';

  @override
  String get docInspectorInvalidChecksum => '不正なチェックサム';

  @override
  String get docInspectorCouldNotDecode => 'デコードできませんでした';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'デコード済み: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'タイプ $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI（9 桁）';

  @override
  String get docMmsiLookupButton => '調べる';

  @override
  String get docMmsiLookupError => '9 桁の MMSI を入力してください（数字のみ）。';

  @override
  String get docMmsiLookupClassGroup => '船舶グループ（グループコール）';

  @override
  String get docMmsiUnknownCountry => '不明な国';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid（$country）';
  }

  @override
  String get docTabOpen => '開く';

  @override
  String get updateCheckForUpdates => '更新を確認';

  @override
  String get updateChecking => '更新を確認中…';

  @override
  String updateNewVersion(Object version) {
    return '新しいバージョン $version';
  }

  @override
  String get updateUpToDate => '最新バージョンです。';

  @override
  String get updateCheckFailed => '更新の確認に失敗しました。';
}
