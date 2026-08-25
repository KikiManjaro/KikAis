// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get languageSystem => 'Авто (система)';

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
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeHighContrast => 'Высокий контраст';

  @override
  String get tabReception => 'Приём';

  @override
  String get tabSend => 'Отправка';

  @override
  String get tabMap => 'Карта';

  @override
  String get tabEditor => 'Редактор';

  @override
  String get tabTools => 'Инструменты';

  @override
  String get tabStats => 'Статистика';

  @override
  String get tabSimulation => 'Симуляция';

  @override
  String get tabDocs => 'Справка';

  @override
  String get protocolUdpServer => 'UDP-сервер';

  @override
  String get protocolUdpClient => 'UDP-клиент';

  @override
  String get protocolTcpClient => 'TCP-клиент';

  @override
  String get protocolTcpServer => 'TCP-сервер';

  @override
  String get formatPassthrough => 'Без изменений';

  @override
  String get formatStrip => 'Убрать тег-блоки';

  @override
  String get formatTag => 'Добавить тег-блок';

  @override
  String get sendAddDestination => 'Добавить назначение';

  @override
  String get sendEditDestination => 'Изменить назначение';

  @override
  String get sendFormat => 'Формат отправки';

  @override
  String get sendSave => 'Сохранить';

  @override
  String get sendLockedBanner =>
      'Пересыльщик запущен — назначения заблокированы.';

  @override
  String get sendEmpty =>
      'Назначений пока нет. Добавьте одно, чтобы пересылать принятые кадры AIS.';

  @override
  String get fieldName => 'Название';

  @override
  String get fieldProtocol => 'Протокол';

  @override
  String get fieldHost => 'Хост';

  @override
  String get fieldPort => 'Порт';

  @override
  String get fieldTagSourceId => 'ID источника тега';

  @override
  String get fieldFile => 'Файл';

  @override
  String get fieldCancel => 'Отмена';

  @override
  String get fieldAdd => 'Добавить';

  @override
  String get receptionFeeds => 'Потоки';

  @override
  String get receptionValidateChecksums => 'Проверять контрольные суммы NMEA';

  @override
  String receptionDroppedSentences(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отброшено $count предложений',
      many: 'Отброшено $count предложений',
      few: 'Отброшено $count предложения',
      one: 'Отброшено $count предложение',
      zero: 'Ни одного предложения не отброшено',
    );
    return '$_temp0';
  }

  @override
  String get receptionImportFormat => 'Формат импорта кадров';

  @override
  String get receptionStart => 'Запуск';

  @override
  String get receptionStop => 'Остановка';

  @override
  String get receptionLogs => 'Журнал';

  @override
  String get receptionFrameCopied => 'Кадр скопирован';

  @override
  String get receptionAddSource => 'Добавить источник';

  @override
  String get receptionNetwork => 'Сеть';

  @override
  String get receptionFile => 'Файл';

  @override
  String get receptionSerial => 'Последовательный';

  @override
  String get receptionHeaderOptional => 'Заголовок (необязательно)';

  @override
  String get receptionPathOrBrowse => 'Путь или Обзор…';

  @override
  String get receptionIntervalMs => 'Интервал между кадрами (мс)';

  @override
  String get receptionReplayTimestamps =>
      'Воспроизводить по временным меткам файла';

  @override
  String get receptionReplayTimestampsHint =>
      'Следует записанным временам (тег-блок t: или префикс времени) вместо фиксированного интервала';

  @override
  String get receptionSpeed => 'Скорость';

  @override
  String get receptionReplayLoop => 'Зациклить (повторять с начала)';

  @override
  String get receptionSerialPort => 'Последовательный порт';

  @override
  String get receptionSerialPortHint => 'например, COM3 или /dev/ttyUSB0';

  @override
  String get receptionBaudRate => 'Скорость передачи (бод)';

  @override
  String get receptionRtlSdr => 'RTL-SDR';

  @override
  String get receptionRtlSdrDevice => 'Устройство RTL-SDR';

  @override
  String get tooltipReceptionRtlSdrDevices => 'Обновить список тюнеров RTL-SDR';

  @override
  String get receptionRtlSdrNoDevice =>
      'Устройство RTL-SDR не найдено. Установите драйверы RTL-SDR (Zadig / WinUSB на Windows) и подключите тюнер.';

  @override
  String get receptionRtlSdrAutoGain =>
      'Автоматическое усиление (рекомендуется)';

  @override
  String get receptionRtlSdrGainDb => 'Усиление тюнера (дБ)';

  @override
  String get receptionRtlSdrSampleRate => 'Частота дискретизации';

  @override
  String get receptionRtlSdrChannels => 'Каналы';

  @override
  String get msgType1 => 'Сообщение о местоположении, класс A';

  @override
  String get msgType2 => 'Сообщение о местоположении, класс A (назначенное)';

  @override
  String get msgType3 => 'Сообщение о местоположении, класс A (ответ)';

  @override
  String get msgType4 => 'Базовая станция';

  @override
  String get msgType5 => 'Статические и рейсовые данные';

  @override
  String get msgType6 => 'Адресованное двоичное сообщение';

  @override
  String get msgType7 => 'Двоичное подтверждение';

  @override
  String get msgType8 => 'Широковещательное двоичное сообщение';

  @override
  String get msgType9 => 'Стандартный отчёт о местоположении SAR-самолёта';

  @override
  String get msgType10 => 'Запрос UTC/даты';

  @override
  String get msgType11 => 'Ответ UTC/даты';

  @override
  String get msgType12 => 'Адресованное сообщение по безопасности';

  @override
  String get msgType13 => 'Подтверждение безопасности';

  @override
  String get msgType14 => 'Широковещательное сообщение по безопасности';

  @override
  String get msgType15 => 'Опрос (интеррогация)';

  @override
  String get msgType16 => 'Команда режима назначения';

  @override
  String get msgType17 => 'Широковещательное двоичное сообщение DGNSS';

  @override
  String get msgType18 => 'Стандартное сообщение о местоположении класса B CS';

  @override
  String get msgType19 =>
      'Расширенное сообщение о местоположении оборудования класса B';

  @override
  String get msgType20 => 'Сообщение управления каналом данных';

  @override
  String get msgType21 => 'Отчёт о навигационном средстве';

  @override
  String get msgType22 => 'Управление каналом';

  @override
  String get msgType23 => 'Команда группового назначения';

  @override
  String get msgType24 => 'Отчёт о статических данных';

  @override
  String get msgType25 => 'Двоичное сообщение в одном слоте';

  @override
  String get msgType26 => 'Двоичное сообщение в нескольких слотах';

  @override
  String get msgType27 => 'Сообщение о местоположении для дальнего радиуса';

  @override
  String get statsTitle => 'Статистика';

  @override
  String get statsFeed => 'Поток';

  @override
  String get statsAllFeeds => 'Все потоки';

  @override
  String get statsReceived => 'Получено';

  @override
  String get statsDecoded => 'Декодировано';

  @override
  String get statsInvalidChecksums => 'Неверные контрольные суммы';

  @override
  String get statsDroppedFragments => 'Отброшенные фрагменты';

  @override
  String get statsParseErrors => 'Ошибки разбора';

  @override
  String get statsPendingFragments => 'Ожидающие фрагменты';

  @override
  String statsPerSecond(Object rate) {
    return '$rate/с';
  }

  @override
  String get statsAllFeedsShort => '(все потоки)';

  @override
  String get statsReceivedVsDecoded =>
      'Получено и декодировано (последние 60 с)';

  @override
  String get statsPerSecondLabel => 'в секунду';

  @override
  String get statsAccounting => 'Учёт';

  @override
  String get statsMultiPartParts => 'Части многочастных сообщений';

  @override
  String get statsPending => 'В ожидании';

  @override
  String get statsDropped => 'Отброшено';

  @override
  String get statsReconcile => 'Полученное и декодированное сходится.';

  @override
  String get statsGapPaused =>
      'Разрыв включает предложения, полученные, пока декодирование было приостановлено.';

  @override
  String statsReceivedAmountEquals(Object received, Object sum) {
    return 'Получено $received = $sum';
  }

  @override
  String get statsByMessageType => 'По типу сообщения';

  @override
  String get statsNoDecodedYet => 'Декодированных сообщений пока нет';

  @override
  String statsTypeFallback(Object type) {
    return 'Тип $type';
  }

  @override
  String get statsByFeed => 'По потоку';

  @override
  String statsFeedFilter(Object filter) {
    return 'Поток: $filter';
  }

  @override
  String get statsNoActivityYet => 'Активности потоков пока нет';

  @override
  String get statsCollecting => 'сбор…';

  @override
  String get simVesselCargo => 'Грузовое';

  @override
  String get simVesselTanker => 'Танкер';

  @override
  String get simVesselFishing => 'Рыболовное';

  @override
  String get simVesselSailing => 'Парусное';

  @override
  String get simVesselPassenger => 'Пассажирское';

  @override
  String get simVesselTug => 'Буксир';

  @override
  String get simVesselHsc => 'Скоростное судно';

  @override
  String get simVesselOther => 'Другое';

  @override
  String get simType1 => 'Отчёт о местоположении (1/2/3)';

  @override
  String get simType5 => 'Статические и рейсовые данные (5)';

  @override
  String get simType9 => 'SAR-самолёт (9)';

  @override
  String get simType18 => 'Местоположение класса B (18)';

  @override
  String get simType19 => 'Класс B расширенный (19)';

  @override
  String get simType27 => 'Дальний радиус (27)';

  @override
  String get simType4 => 'Базовая станция (4)';

  @override
  String get simType21 => 'Навигационное средство (21)';

  @override
  String get simType8 => 'Метеовещание (8)';

  @override
  String get simType11 => 'Ответ UTC/даты (11)';

  @override
  String get simType12 => 'Безопасность, адресованное (12)';

  @override
  String get simType14 => 'Безопасность, широковещательное (14)';

  @override
  String get simType22 => 'Управление каналом (22)';

  @override
  String get simType23 => 'Групповое назначение (23)';

  @override
  String get simType24 => 'Класс B статические (24)';

  @override
  String get simTitle => 'Симуляция';

  @override
  String get simInfoBanner =>
      'Флот передаётся, когда поток «Симуляция» включён на вкладке «Приём» и пересыльщик запущен.';

  @override
  String get simOpenReception => 'Открыть «Приём»';

  @override
  String get simFleetSection => 'Флот';

  @override
  String get simRadiusKm => 'Радиус (км)';

  @override
  String get simVessels => 'Суда';

  @override
  String get simSpeedMinKn => 'Скорость мин (kn)';

  @override
  String get simSpeedMaxKn => 'Скорость макс (kn)';

  @override
  String get simIntervalS => 'Интервал (с)';

  @override
  String get simSeed => 'Сид';

  @override
  String get simAnchoredPct => 'На якоре (%)';

  @override
  String get simNamePrefix => 'Префикс названия';

  @override
  String get simMmsiMid => 'Страна MMSI / MID';

  @override
  String get simSearchMmid => 'Найдите страну или введите 3-значный MID';

  @override
  String get simCustom => 'Свой';

  @override
  String get simVesselTypes => 'Типы судов';

  @override
  String get simRealisticNames => 'Реалистичные названия';

  @override
  String get simRealisticDimensions => 'Реалистичные габариты';

  @override
  String get simRealisticMmsi => 'Реалистичные MMSI ITU';

  @override
  String get simZoneSection => 'Зона и движение';

  @override
  String get simLocationPreset => 'Пресет местоположения';

  @override
  String get simSearchPort => 'Найти порт…';

  @override
  String get simCenterLat => 'Широта центра';

  @override
  String get simCenterLon => 'Долгота центра';

  @override
  String get simZoneShape => 'Форма зоны';

  @override
  String get simTransitPct => 'Транзит (%)';

  @override
  String get simRegeneratePeriodically => 'Периодически перегенерировать';

  @override
  String get simRegenerateTicks => 'Перегенерация (тики)';

  @override
  String get simPresetHint =>
      'Выберите пресет, чтобы заполнить координаты, или введите широту/долготу центра напрямую.';

  @override
  String get simMovementSection => 'Движение и передача';

  @override
  String get simVarySpeed => 'Менять скорость со временем';

  @override
  String get simReportIntervalTicks => 'Интервал отчётов (тики)';

  @override
  String get simWander => 'Дрейф (0-3)';

  @override
  String get simSpeedByType => 'Скорость по типу судна';

  @override
  String get simClassBSharePct => 'Доля класса B (%)';

  @override
  String get simHighAccuracy => 'Высокая точность';

  @override
  String get simRealisticRot => 'Реалистичная скорость поворота';

  @override
  String get simContentSection => 'Содержимое';

  @override
  String get simSafetyTexts => 'Тексты безопасности (по одному в строке)';

  @override
  String get simDestinations => 'Пункты назначения (по одному в строке)';

  @override
  String get simStationsSection => 'Станции';

  @override
  String get simBaseStations => 'Базовые станции';

  @override
  String get simAtoN => 'Навигационные средства';

  @override
  String get simQualitySection => 'Качество передачи';

  @override
  String get simInjectErrors => 'Вносить ошибки';

  @override
  String get simErrorRatePct => 'Частота ошибок (%)';

  @override
  String get simTalkerId => 'ID источника (talker)';

  @override
  String get simNmea4Tag => 'Тег-блок NMEA 4.0';

  @override
  String get simMessagesSection => 'Сообщения';

  @override
  String get simApplyFleet => 'Применить флот';

  @override
  String get simRegenerateFleet => 'Перегенерировать флот';

  @override
  String get simGenerating => 'Генерация…';

  @override
  String get simLiveFleet => 'Живой флот';

  @override
  String simFleetSummary(Object boats, Object frames) {
    return '$boats судов · передано $frames кадров';
  }

  @override
  String get mapSearchVessels => 'Поиск судов';

  @override
  String get mapSearchHint => 'Название, MMSI или IMO';

  @override
  String get mapNoResults => 'Результатов нет';

  @override
  String mapMmsi(Object mmsi) {
    return 'MMSI $mmsi';
  }

  @override
  String mapImo(Object imo) {
    return 'IMO $imo';
  }

  @override
  String get mapFilters => 'Фильтры';

  @override
  String mapAllLabel(Object label) {
    return 'Все $label';
  }

  @override
  String get mapVesselType => 'Тип судна';

  @override
  String get mapNavigationStatus => 'Навигационный статус';

  @override
  String get mapCountry => 'Страна';

  @override
  String get mapMinSog => 'Мин SOG (kn)';

  @override
  String get mapMaxSog => 'Макс SOG (kn)';

  @override
  String get mapOnlyNamed => 'Только суда с названием';

  @override
  String get mapReset => 'Сброс';

  @override
  String get mapApply => 'Применить';

  @override
  String get mapAutoBasemap => 'Авто (по теме)';

  @override
  String mapFollowing(Object mmsi) {
    return 'Слежение $mmsi';
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
  String get basemapVoyagerLight => 'Voyager (светлая)';

  @override
  String get basemapPositronLight => 'Positron (светлая минимальная)';

  @override
  String get basemapDarkMatter => 'Dark Matter';

  @override
  String get basemapOsm => 'OpenStreetMap';

  @override
  String get basemapOpenTopo => 'OpenTopoMap';

  @override
  String get basemapEsriSatellite => 'Спутник Esri';

  @override
  String get basemapEsriStreets => 'Esri World Street Map';

  @override
  String get decoderInputLabel =>
      'Вставьте или введите одно или несколько предложений NMEA AIS';

  @override
  String get decoderValidateChecksums => 'Проверять контрольные суммы';

  @override
  String get decoderDecode => 'Декодировать';

  @override
  String get decoderDecoded => 'Декодировано';

  @override
  String decoderDecodedN(Object n) {
    return 'Декодировано ($n предложений)';
  }

  @override
  String get decoderInvalidChecksum => 'Неверная контрольная сумма';

  @override
  String get decoderParseError => 'Ошибка разбора';

  @override
  String get decoderWaitingFragments => 'Ожидание дополнительных фрагментов…';

  @override
  String decoderTagSource(Object id) {
    return 'источник $id';
  }

  @override
  String decoderTagBlock(Object content) {
    return 'Тег-блок · $content';
  }

  @override
  String get toolDecoder => 'Декодер NMEA';

  @override
  String get toolDecoderSub => 'Декодировать AIS';

  @override
  String get toolChecksum => 'Контрольная сумма';

  @override
  String get toolChecksumSub => 'Расчёт XOR NMEA';

  @override
  String get toolMmsi => 'Поиск MMSI';

  @override
  String get toolMmsiSub => 'Проверка и идентификация MMSI';

  @override
  String get toolSpeed => 'Конвертер скорости';

  @override
  String get toolSpeedSub => 'уз · км/ч · м/с · миль/ч';

  @override
  String get toolBinary => 'Бинарный инспектор';

  @override
  String get toolBinarySub => 'Полезная нагрузка до битов';

  @override
  String get toolEta => 'Расчёт ETA';

  @override
  String get toolEtaSub => 'ETA в полях типа 5';

  @override
  String get toolRadio => 'Радиодальность';

  @override
  String get toolRadioSub => 'Радиогоризонт VHF-AIS';

  @override
  String get toolTextToBinary => 'Текст в бинарное';

  @override
  String get toolTextToBinarySub => '6-бит ASCII в hex/биты';

  @override
  String get checksumInputLabel =>
      'Вставьте одно или несколько предложений NMEA';

  @override
  String get checksumComputed => 'Вычислено';

  @override
  String get checksumDeclared => 'Указано';

  @override
  String get checksumValid => 'Контрольная сумма верна';

  @override
  String get checksumInvalid => 'Контрольная сумма не совпадает';

  @override
  String get checksumFix => 'Исправить сумму';

  @override
  String get mmsiInputLabel => 'MMSI (9 цифр)';

  @override
  String get mmsiValid => 'Действительный MMSI';

  @override
  String get mmsiInvalid => 'Не является 9-значным MMSI';

  @override
  String get mmsiMid => 'MID';

  @override
  String get mmsiCountry => 'Страна';

  @override
  String get mmsiCountryUnknown => 'Неизвестный MID';

  @override
  String get mmsiType => 'Тип станции';

  @override
  String get mmsiGroupCall => 'Групповой вызов';

  @override
  String get mmsiSarAircraft => 'Спасательное ВС';

  @override
  String get mmsiCoastStation => 'Береговая станция';

  @override
  String get mmsiShipStation => 'Судовая станция';

  @override
  String get mmsiHandheldVhf => 'Портативная УКВ';

  @override
  String get mmsiAton => 'Средство навигации (AtoN)';

  @override
  String get mmsiSar => 'Спасательная единица';

  @override
  String get mmsiOther => 'Другое';

  @override
  String get speedValue => 'Значение';

  @override
  String get speedUnit => 'Единица';

  @override
  String get binaryInputLabel => 'Предложение NMEA или сырой 6-бит payload';

  @override
  String get binaryPayload => 'Полезная нагрузка';

  @override
  String get binaryBits => 'Биты';

  @override
  String get binaryBinary => 'Двоичный';

  @override
  String get binaryHex => 'Hex';

  @override
  String get binaryHexBytes => 'Hex-байты';

  @override
  String get binarySixBit => '6-битные символы';

  @override
  String get etaDistance => 'Дистанция';

  @override
  String get etaUnitNm => 'морские мили';

  @override
  String get etaUnitKm => 'километры';

  @override
  String get etaSpeed => 'Скорость';

  @override
  String get etaDuration => 'Продолжительность';

  @override
  String get etaEtaLocal => 'ETA (местное)';

  @override
  String get etaEtaUtc => 'ETA (UTC)';

  @override
  String get etaAisFields => 'Поля ETA типа 5';

  @override
  String get etaMonth => 'Месяц';

  @override
  String get etaDay => 'День';

  @override
  String get etaHour => 'Час';

  @override
  String get etaMinute => 'Минута';

  @override
  String get etaCombined => 'ММ/ДД ЧЧ:ММ';

  @override
  String get radioHeight1 => 'Высота антенны 1';

  @override
  String get radioHeight2 => 'Высота антенны 2';

  @override
  String get radioHorizon => 'Радиогоризонт';

  @override
  String get radioHorizonKm => 'Радиогоризонт (км)';

  @override
  String get radioFrequencies => 'Каналы AIS';

  @override
  String get radioAis1 => 'AIS 1';

  @override
  String get radioAis2 => 'AIS 2';

  @override
  String get t2bInputLabel => 'Введите текст (алфавит AIS 6-бит)';

  @override
  String get t2bCharTable => 'Символ · значение · 6 бит';

  @override
  String get t2bBinary => 'Двоичный';

  @override
  String get t2bHex => 'Hex';

  @override
  String get t2bBytes => 'Байты (формат редактора)';

  @override
  String get t2bPayload => 'Защищённый payload';

  @override
  String get t2bNote =>
      'Список байтов можно вставить в поле «Data bytes» редактора для сообщений 6/8/25/26; защищённый payload — это точное поле payload предложения NMEA.';

  @override
  String editorAsmDetected(Object name) {
    return 'Специальное прикладное сообщение — $name';
  }

  @override
  String get editorAsmRawHint =>
      'Поля распознанного ASM. Поле «Data bytes» по-прежнему имеет приоритет при заполнении.';

  @override
  String get fMessageType => 'Тип сообщения';

  @override
  String get editorAsmPreset => 'Предустановка ASM';

  @override
  String get editorAsmPresetManual => 'Вручную — ввести DAC/FID';

  @override
  String get editorDataSourceRaw => 'Data bytes';

  @override
  String get editorDataSourceAsm => 'Поля ASM';

  @override
  String get asmStateInForce => 'действует';

  @override
  String get asmStateDeprecated => 'устарел';

  @override
  String get asmStateReplaced => 'заменён';

  @override
  String get asmStateDiscontinued => 'прекращён';

  @override
  String get asmStateDraft => 'черновик';

  @override
  String get asmStateProposal => 'предложение';

  @override
  String get asmStateTesting => 'тестируется';

  @override
  String asmDeprecatedSince(Object note) {
    return 'Устарел с $note';
  }

  @override
  String asmLayoutUnknown(Object name) {
    return 'Для $name макет битов не задокументирован — редактируйте необработанные Data bytes.';
  }

  @override
  String get docChapterAsm => 'Специальные прикладные сообщения';

  @override
  String get docAsmIntro =>
      'Не каждый полезный AIS-нагрузки является стандартным отчётом о позиции. Типы 6, 8, 25 и 26 несут прикладные двоичные данные (ASM), смысл которых задаётся двумя числами: кодом района (DAC) и идентификатором функции (FID).';

  @override
  String get docAsmWhatTitle => 'Что такое ASM?';

  @override
  String get docAsmWhat =>
      'Специальное прикладное сообщение — это структурированная нагрузка, опубликованная организацией (ИМО, МАМС, национальные администрации, производители) для конкретного применения: метео- и гидрографические данные, мониторинг средств навигации, поправки DGPS, портовые службы и другое. Типы 6/8 несут заголовок DAC/FID; 25/26 повторяют ту же схему в слотовых сообщениях.';

  @override
  String get docAsmDacFidTitle => 'DAC и FID';

  @override
  String get docAsmDacFid1 =>
      'DAC — 10-битный код, идентифицирующий организацию или страну (например, 001 = ИМО, 002 = МАМС). FID — 6-битный код функции внутри пространства этого DAC (например, 001/11 = метео- и гидроданные ИМО).';

  @override
  String get docAsmDacFid2 =>
      'Байты данных после заголовка DAC/FID декодируются по соответствующему прикладному стандарту. Разные пары DAC/FID могут интерпретировать одни и те же байты совершенно по-разному — пару нужно знать заранее.';

  @override
  String get docAsmWhereTitle => 'Где найти определения';

  @override
  String get docAsmWhere1 =>
      'Циркуляры ИМО и ITU-R M.1371 (приложения) — авторитетный источник для DAC 001.';

  @override
  String get docAsmWhere2 =>
      'Руководства МАМС (например, G1139) и национальных администраций — для региональных DAC.';

  @override
  String get docAsmWhere3 =>
      'Документация AIVDM от gpsd — открытый, машиночитаемый каталог наиболее распространённых схем DAC/FID.';

  @override
  String get docAsmInKikaisTitle => 'В KikAis';

  @override
  String get docAsmInKikais =>
      'Редактор знает курируемый набор известных ASM: когда DAC/FID сообщения 6/8/25/26 совпадает, поле данных показывается как именованные подполя, которые упаковываются автоматически. Сырое поле «Data bytes» всегда имеет приоритет при заполнении. Список находится в asm_formats.dart и легко расширяется.';

  @override
  String get docAsmExampleTitle => 'Пример: метео-гидро ИМО (001/11)';

  @override
  String get docAsmExample =>
      'В редакторе выберите тип 8, DAC=1 и FID=11, чтобы собрать метеосообщение ИМО: ветер, температуры воздуха и воды, давление, видимость, течения и волны редактируются по полям, а не как блок байтов.';

  @override
  String get fMmsi => 'MMSI';

  @override
  String get fRepeatIndicator => 'Индикатор повтора';

  @override
  String get fNavStatus => 'Навигационный статус';

  @override
  String get fLatitude => 'Широта';

  @override
  String get fLongitude => 'Долгота';

  @override
  String get fSogKn => 'SOG (kn)';

  @override
  String get fCogDeg => 'COG (°)';

  @override
  String get fHeadingDeg => 'Курс (°)';

  @override
  String get fRateOfTurn => 'Скорость поворота';

  @override
  String get fManeuver => 'Манёвр';

  @override
  String get fTimestamp => 'Временная метка';

  @override
  String get fRaim => 'RAIM';

  @override
  String get fUtc => 'UTC';

  @override
  String get fAccuracy => 'Точность';

  @override
  String get fEpfdFixType => 'Тип фиксации EPFD';

  @override
  String get fSyncState => 'Состояние синхронизации';

  @override
  String get fImo => 'IMO';

  @override
  String get fCallSign => 'Позывной';

  @override
  String get fVesselName => 'Название судна';

  @override
  String get fShipType => 'Тип судна';

  @override
  String get fShipTypeText => 'Тип судна (текст)';

  @override
  String get fDims => 'Нос/корма/левый/правый борт (м)';

  @override
  String get fEta => 'ETA';

  @override
  String get fDraughtM => 'Осадка (м)';

  @override
  String get fDestination => 'Пункт назначения';

  @override
  String get fDte => 'DTE';

  @override
  String get fDestMmsi => 'MMSI назначения';

  @override
  String get fSeqNumber => 'Порядковый номер';

  @override
  String get fRetransmit => 'Повторная передача';

  @override
  String get fDac => 'DAC';

  @override
  String get fFid => 'FID';

  @override
  String get fData => 'Данные';

  @override
  String get fAltitudeM => 'Высота (м)';

  @override
  String get fAssignedMode => 'Режим назначения';

  @override
  String get fRegionalReserved => 'Региональный резерв';

  @override
  String get fText => 'Текст';

  @override
  String fStationN(Object n) {
    return 'Станция $n';
  }

  @override
  String fSlotN(Object n) {
    return 'Слот $n';
  }

  @override
  String fSlotDetail(
    Object increment,
    Object number,
    Object offset,
    Object timeout,
  ) {
    return 'смещение $offset · номер $number · таймаут $timeout · приращение $increment';
  }

  @override
  String get fAidType => 'Тип средства';

  @override
  String get fAidTypeCode => 'Тип средства (код)';

  @override
  String get fName => 'Название';

  @override
  String get fNameExt => 'Расширение названия';

  @override
  String get fVirtualAid => 'Виртуальное средство';

  @override
  String get fOffPosition => 'Смещено с позиции';

  @override
  String get fSecond => 'Секунда';

  @override
  String get fChannelA => 'Канал A';

  @override
  String get fChannelB => 'Канал B';

  @override
  String get fTxRxMode => 'Режим TX/RX';

  @override
  String get fPower => 'Мощность';

  @override
  String get fZone => 'Зона';

  @override
  String get fAddressed => 'Адресованное';

  @override
  String get fMmsi1 => 'MMSI 1';

  @override
  String get fMmsi2 => 'MMSI 2';

  @override
  String get fBandA => 'Диапазон A';

  @override
  String get fBandB => 'Диапазон B';

  @override
  String get fZoneSize => 'Размер зоны';

  @override
  String get fStationType => 'Тип станции';

  @override
  String get fReportInterval => 'Интервал отчётов';

  @override
  String get fQuietTime => 'Время тишины';

  @override
  String get fPart => 'Часть';

  @override
  String get fVendorId => 'ID производителя';

  @override
  String get fUnitModel => 'Модель устройства';

  @override
  String get fSerialNumber => 'Серийный номер';

  @override
  String get fMothershipMmsi => 'MMSI судна-носителя';

  @override
  String get fRadioStatus => 'Статус радио';

  @override
  String get fGnssStatus => 'Статус позиции GNSS';

  @override
  String fDestN(Object n) {
    return 'Назначение $n';
  }

  @override
  String fDestDetail(Object mmsi, Object seq) {
    return '$mmsi посл. $seq';
  }

  @override
  String get fDestIndicator => 'Индикатор назначения';

  @override
  String get fBinaryDataFlag => 'Флаг двоичных данных';

  @override
  String get fApplicationId => 'ID приложения';

  @override
  String get fPowerHigh => 'Высокая';

  @override
  String get fPowerLow => 'Низкая';

  @override
  String get fPartA => 'A (название)';

  @override
  String get fPartB => 'B (данные судна)';

  @override
  String get editorTitle => 'Редактор сообщений AIS';

  @override
  String get editorCompose => 'Составить сообщение';

  @override
  String get editorMessageType => 'Тип сообщения';

  @override
  String get editorAddTagBlock => 'Добавить тег-блок NMEA 4.0';

  @override
  String get editorSourceId => 'ID источника';

  @override
  String get editorInjectToMap => 'Ввести на карту';

  @override
  String get editorSendToTarget => 'Отправить в назначение';

  @override
  String get editorPreview => 'Предпросмотр NMEA';

  @override
  String get editorNmeaCopied => 'NMEA скопировано';

  @override
  String get editorInjected => 'Сообщение введено';

  @override
  String get editorSentToTarget => 'Сообщение отправлено в назначение';

  @override
  String get editorNavStatus0_15 => 'Нав. статус (0-15)';

  @override
  String get editorYear => 'Год';

  @override
  String get editorMonth => 'Месяц';

  @override
  String get editorDay => 'День';

  @override
  String get editorHour => 'Час';

  @override
  String get editorMinute => 'Минута';

  @override
  String get editorSecond => 'Секунда';

  @override
  String get editorImoNumber => 'Номер IMO';

  @override
  String get editorBowM => 'Нос (м)';

  @override
  String get editorSternM => 'Корма (м)';

  @override
  String get editorPortM => 'Борт левый (м)';

  @override
  String get editorStarboardM => 'Борт правый (м)';

  @override
  String get editorEtaMonth => 'Месяц ETA';

  @override
  String get editorEtaDay => 'День ETA';

  @override
  String get editorEtaHour => 'Час ETA';

  @override
  String get editorEtaMinute => 'Минута ETA';

  @override
  String get editorSequence0_3 => 'Последовательность (0-3)';

  @override
  String get editorDataBytes => 'Байты данных (hex или 1,2,3)';

  @override
  String get editorDestMmsisComma => 'MMSI назначений (через запятую)';

  @override
  String get editorSequencesComma => 'Последовательности (через запятую)';

  @override
  String get editorInterrogatedMmsi => 'Опрошенный MMSI';

  @override
  String get editorType1 => 'Тип 1';

  @override
  String get editorOffset1 => 'Смещение 1';

  @override
  String get editorTargetMmsi => 'Целевой MMSI';

  @override
  String get editorOffset => 'Смещение';

  @override
  String get editorIncrement => 'Приращение';

  @override
  String get editorNumber => 'Номер';

  @override
  String get editorTimeout => 'Таймаут';

  @override
  String get editorAidType0_31 => 'Тип средства (0-31)';

  @override
  String get editorVirtualAid0_1 => 'Виртуальное средство (0/1)';

  @override
  String get editorTxRxMode0_15 => 'Режим Tx/Rx (0-15)';

  @override
  String get editorTxRxMode0_3 => 'Режим Tx/Rx (0-3)';

  @override
  String get editorNeLat => 'Широта СВ';

  @override
  String get editorNeLon => 'Долгота СВ';

  @override
  String get editorSwLat => 'Широта ЮЗ';

  @override
  String get editorSwLon => 'Долгота ЮЗ';

  @override
  String get editorInterval0_15 => 'Интервал (0-15)';

  @override
  String get editorPart => 'Часть (0 = название A, 1 = статические B)';

  @override
  String get editorDestMmsiEmpty =>
      'MMSI назначения (пусто = широковещательное)';

  @override
  String get editorAppDacEmpty => 'App DAC (пусто = нет)';

  @override
  String get editorAppFidEmpty => 'App FID (пусто = нет)';

  @override
  String get nmeaTalker => 'Источник (talker)';

  @override
  String get nmeaFragments => 'Фрагменты';

  @override
  String get nmeaFragmentN => 'Фрагмент №';

  @override
  String get nmeaMessageId => 'ID сообщения';

  @override
  String get nmeaChannel => 'Канал';

  @override
  String get nmeaPayload => 'Полезная нагрузка';

  @override
  String get nmeaFillBits => 'Биты заполнения';

  @override
  String get nmeaTagBlock => 'Тег-блок';

  @override
  String get nmeaChecksum => 'Контрольная сумма';

  @override
  String get nmeaEmpty => '(пусто)';

  @override
  String get bubbleKindVessel => 'Судно';

  @override
  String get bubbleKindAircraft => 'SAR-самолёт';

  @override
  String get bubbleKindAton => 'Навигационное средство';

  @override
  String get bubbleKindStation => 'Базовая станция';

  @override
  String get bubbleGeneralInfo => 'Общая информация';

  @override
  String get bubbleKind => 'Вид';

  @override
  String get bubbleAidType => 'Тип средства';

  @override
  String get bubbleVirtual => 'Виртуальное';

  @override
  String get bubbleAltitude => 'Высота';

  @override
  String get bubbleCallSign => 'Позывной';

  @override
  String get bubblePosNav => 'Позиция и навигация';

  @override
  String get bubbleHeading => 'Курс';

  @override
  String get bubbleCog => 'COG';

  @override
  String get bubbleSog => 'SOG';

  @override
  String get bubbleVesselDetails => 'Данные судна';

  @override
  String get bubbleType => 'Тип';

  @override
  String get bubbleTypeInt => 'Тип (Int)';

  @override
  String get bubbleDimsBowStern => 'Габариты нос/корма';

  @override
  String get bubbleDimsPortStarboard => 'Габариты борт левый/правый';

  @override
  String get bubbleSpare => 'Резерв';

  @override
  String get bubbleDraught => 'Осадка';

  @override
  String bubbleFrames(Object n) {
    return 'Кадры ($n)';
  }

  @override
  String get bubbleNoFrames => 'Кадров пока нет';

  @override
  String get copied => 'Скопировано';

  @override
  String get textFiles => 'Текстовые файлы';

  @override
  String logTargetConnected(
    Object host,
    Object name,
    Object port,
    Object protocol,
  ) {
    return 'Назначение $name подключено ($protocol $host:$port).';
  }

  @override
  String logTargetConnectFailed(Object error, Object name) {
    return 'Не удалось подключить назначение $name: $error';
  }

  @override
  String get logStopping => 'Остановка пересыльщика...';

  @override
  String get logStopped => 'Пересыльщик остановлен.';

  @override
  String logFeedAdded(Object host, Object name, Object port) {
    return 'Поток добавлен: $name ($host:$port)';
  }

  @override
  String logFeedRemoved(Object name) {
    return 'Поток удалён: $name';
  }

  @override
  String logFeedConnected(Object name) {
    return 'Поток $name подключён.';
  }

  @override
  String logFeedDisconnected(Object name) {
    return 'Поток $name отключён. Повторное подключение через 5 с...';
  }

  @override
  String logFeedConnectFailed(Object error, Object name) {
    return 'Не удалось подключить поток $name: $error. Повтор через 5 с...';
  }

  @override
  String logTcpListening(Object name, Object port) {
    return 'Назначение $name: TCP-сервер слушает порт $port';
  }

  @override
  String logTcpClientConnected(Object address, Object name, Object port) {
    return 'Назначение $name: клиент подключён $address:$port';
  }

  @override
  String logTcpClientDisconnected(Object name) {
    return 'Назначение $name: клиент отключён';
  }

  @override
  String logTcpClientError(Object error, Object name) {
    return 'Назначение $name: ошибка клиента $error';
  }

  @override
  String logSendError(Object error, Object name) {
    return 'Назначение $name: ошибка отправки $error';
  }

  @override
  String logRtlSdrOpening(Object device) {
    return 'Открытие RTL-SDR-приёмника $device...';
  }

  @override
  String logRtlSdrConnected(
    Object channels,
    Object device,
    Object freq,
    Object gain,
    Object rate,
  ) {
    return 'RTL-SDR $device подключён ($freq, частота дискретизации $rate, усиление $gain, каналы $channels).';
  }

  @override
  String logRtlSdrError(Object device, Object error) {
    return 'RTL-SDR $device: ошибка $error';
  }

  @override
  String logRtlSdrStreamClosed(Object device) {
    return 'Поток RTL-SDR $device закрыт.';
  }

  @override
  String logRtlSdrDisconnected(Object device) {
    return 'RTL-SDR $device отключён.';
  }

  @override
  String get docNavStatus0 => 'Идёт на моторном ходу';

  @override
  String get docNavStatus1 => 'На якоре';

  @override
  String get docNavStatus2 => 'Лишено возможности управляться';

  @override
  String get docNavStatus3 => 'Ограниченная возможность манёвра';

  @override
  String get docNavStatus4 => 'Стеснено своей осадкой';

  @override
  String get docNavStatus5 => 'У причала';

  @override
  String get docNavStatus6 => 'На мели';

  @override
  String get docNavStatus7 => 'Занято ловом рыбы';

  @override
  String get docNavStatus8 => 'Идёт под парусом';

  @override
  String get docNavStatus9 => 'Резерв (HSC)';

  @override
  String get docNavStatus10 => 'Резерв (WIG)';

  @override
  String get docNavStatus11 => 'Буксировка кормой (региональное)';

  @override
  String get docNavStatus12 =>
      'Толкает впереди / буксирует лагом (региональное)';

  @override
  String get docNavStatus13 => 'Зарезервировано для будущего использования';

  @override
  String get docNavStatus14 => 'AIS-SART активен';

  @override
  String get docNavStatus15 => 'Не определено (по умолчанию)';

  @override
  String get docEpfd0 => 'Не определено (по умолчанию)';

  @override
  String get docEpfd1 => 'GPS';

  @override
  String get docEpfd2 => 'GLONASS';

  @override
  String get docEpfd3 => 'GPS + GLONASS';

  @override
  String get docEpfd4 => 'Loran-C';

  @override
  String get docEpfd5 => 'Чайка';

  @override
  String get docEpfd6 => 'Интегрированная навигационная система';

  @override
  String get docEpfd7 => 'Обследовано (фиксировано)';

  @override
  String get docEpfd8 => 'Galileo';

  @override
  String get docEpfd15 => 'Внутренний GNSS';

  @override
  String docBitFieldBits(Object end, Object name, Object start) {
    return '$name · биты $start-$end';
  }

  @override
  String docBitLayoutSummary(Object bits, Object fields) {
    return '$fields полей · всего $bits бит · коснитесь сегмента';
  }

  @override
  String get docTextToEncode => 'Текст для кодирования';

  @override
  String get docSixBitUnencodable => '—';

  @override
  String get docSixBitExplanation =>
      'Каждый символ — одно 6-битное значение (\"@\" = 0, пробел = 32, \"A\" = 1…). Строчные буквы закодировать нельзя, их обычно передают заглавными.';

  @override
  String get docChecksumBody => 'Тело (без начального ! и конечного *XX)';

  @override
  String get docChecksumExplanation =>
      'Контрольная сумма NMEA — это XOR каждого байта между \"!\" и \"*\".';

  @override
  String get docLatitude => 'Широта';

  @override
  String get docLongitude => 'Долгота';

  @override
  String get docLatitudeInvalid => 'Широта: введите число';

  @override
  String get docLongitudeInvalid => 'Долгота: введите число';

  @override
  String docCoordLatitudeValue(Object deg, Object value) {
    return 'Широта → $value (27-битное со знаком, град = $deg / 600000)';
  }

  @override
  String docCoordLongitudeValue(Object deg, Object value) {
    return 'Долгота → $value (28-битное со знаком, град = $deg / 600000)';
  }

  @override
  String get docCoordsExplanation =>
      'Координаты хранятся в 1/10 000 минуты: разделите на 600 000, чтобы получить градусы.';

  @override
  String get docSearchShipTypes => 'Поиск типов судов';

  @override
  String get docShipCat0_19 => '0-19 · Резерв';

  @override
  String get docShipCat20_29 => '20-29 · Экранопланы (WIG)';

  @override
  String get docShipCat30_39 => '30-39 · Рыболовные';

  @override
  String get docShipCat40_49 => '40-49 · Скоростные';

  @override
  String get docShipCat50_59 => '50-59 · Специальные суда';

  @override
  String get docShipCat60_69 => '60-69 · Пассажирские';

  @override
  String get docShipCat70_79 => '70-79 · Грузовые';

  @override
  String get docShipCat80_89 => '80-89 · Танкеры';

  @override
  String get docShipCat90_99 => '90-99 · Другие';

  @override
  String get docSearchGlossary => 'Поиск по глоссарию';

  @override
  String get docNoMatchingTerms => 'Нет подходящих терминов.';

  @override
  String get docAspect => 'Аспект';

  @override
  String get docClassA => 'Класс A';

  @override
  String get docClassB => 'Класс B';

  @override
  String get docCheatRadio => 'Радио';

  @override
  String get docCheatFrequencies => 'Частоты';

  @override
  String get docCheatFrequenciesValue =>
      'AIS1 161.975 МГц (87B) · AIS2 162.025 МГц (88B)';

  @override
  String get docCheatModulation => 'Модуляция';

  @override
  String get docCheatModulationValue => 'GMSK, 9 600 бит/с';

  @override
  String get docCheatRange => 'Дальность';

  @override
  String get docCheatRangeValue =>
      '~10-20 морских миль судно-судно, прямая видимость';

  @override
  String get docCheatReportingRates => 'Частота отчётов';

  @override
  String get docCheatClassAPos1 => 'Позиция класса A (1)';

  @override
  String get docCheatClassAPos1Value => 'Каждые 2-10 с в пути, 3 мин на якоре';

  @override
  String get docCheatStatic5 => 'Статические (5)';

  @override
  String get docCheatStatic5Value => 'Каждые 6 мин';

  @override
  String get docCheatClassBPos18 => 'Позиция класса B (18)';

  @override
  String get docCheatClassBPos18Value => '~Каждые 30 с';

  @override
  String get docCheatAtoN21 => 'Навигационное средство (21)';

  @override
  String get docCheatAtoN21Value => 'Каждые 3 мин';

  @override
  String get docCheatNavStatus0_15 => 'Навигационный статус (0-15)';

  @override
  String get docCheatNavStatus0 => '0';

  @override
  String get docCheatNavStatus0Value => 'Идёт на моторном ходу';

  @override
  String get docCheatNavStatus1 => '1';

  @override
  String get docCheatNavStatus1Value => 'На якоре';

  @override
  String get docCheatNavStatus3 => '3';

  @override
  String get docCheatNavStatus3Value => 'Ограниченная возможность манёвра';

  @override
  String get docCheatNavStatus5 => '5';

  @override
  String get docCheatNavStatus5Value => 'У причала';

  @override
  String get docCheatNavStatus6 => '6';

  @override
  String get docCheatNavStatus6Value => 'На мели';

  @override
  String get docCheatNavStatus7 => '7';

  @override
  String get docCheatNavStatus7Value => 'Рыболовство';

  @override
  String get docCheatNavStatus8 => '8';

  @override
  String get docCheatNavStatus8Value => 'Идёт под парусом';

  @override
  String get docCheatNavStatus14 => '14';

  @override
  String get docCheatNavStatus14Value => 'AIS-SART активен';

  @override
  String get docCheatMmsiFormats => 'Форматы MMSI';

  @override
  String get docCheatFixTypes => 'Типы фиксации (EPFD)';

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
  String get docCheatEpfd15Value => 'Внутренний GNSS';

  @override
  String get docCheatFooter =>
      'KikAis содержит полный интерактивный справочник на каждой вкладке — Редактор может собрать любое сообщение, Декодер читает их обратно.';

  @override
  String get docMmsiFmtDiversRadio => 'Радио дайвера';

  @override
  String get docMmsiFmtShip => 'Судно';

  @override
  String get docMmsiFmtGroupShips => 'Группа судов (например, флот или USCG)';

  @override
  String get docMmsiFmtCoastalShore => 'Береговая / береговая станция';

  @override
  String get docMmsiFmtSarAircraft => 'SAR-самолёт';

  @override
  String get docMmsiFmtAuxCraft =>
      'Вспомогательное судно, связанное с судном-носителем';

  @override
  String get docMmsiFmtAtoN => 'Навигационное средство';

  @override
  String get docMmsiFmtSart => 'AIS-SART (поисково-спасательный передатчик)';

  @override
  String get docMmsiFmtMob => 'Устройство MOB (человек за бортом)';

  @override
  String get docMmsiFmtEpirb => 'AIS EPIRB (аварийный маяк)';

  @override
  String get docVesselCat0_9 => 'Резерв / будущее использование';

  @override
  String get docVesselCat10_19 => 'Зарезервировано для будущего использования';

  @override
  String get docVesselCat20_29 => 'Экранопланы (WIG)';

  @override
  String get docVesselCat30_39 => 'Рыболовные';

  @override
  String get docVesselCat40_49 => 'Скоростные';

  @override
  String get docVesselCat50_59 =>
      'Специальные суда (лоцманские, буксиры, земснаряды…)';

  @override
  String get docVesselCat60_69 => 'Пассажирские суда';

  @override
  String get docVesselCat70_79 => 'Грузовые суда';

  @override
  String get docVesselCat80_89 => 'Танкеры';

  @override
  String get docVesselCat90_99 => 'Другие типы';

  @override
  String get docTalkerAB => 'Базовая станция AIS';

  @override
  String get docTalkerAD => 'Зависимая базовая станция AIS';

  @override
  String get docTalkerAI => 'Мобильная станция AIS';

  @override
  String get docTalkerAN => 'Станция AIS навигационного средства';

  @override
  String get docTalkerAR => 'Приёмная станция AIS';

  @override
  String get docTalkerAS => 'Ограниченная базовая станция';

  @override
  String get docTalkerAT => 'Передающая станция AIS';

  @override
  String get docTalkerAX => 'Повторительная станция AIS';

  @override
  String get docTalkerBS => 'Базовая станция AIS (устаревшее)';

  @override
  String get docTalkerSA => 'Физическая береговая станция AIS';

  @override
  String get docType1Name => 'Сообщение о местоположении, класс A';

  @override
  String get docType1Family => 'Сообщения о местоположении';

  @override
  String get docType1Summary =>
      'Рабочая лошадка системы: транспондер класса A передаёт свою позицию, курс, скорость, направление и навигационный статус.';

  @override
  String get docType1EmittedBy => 'Транспондеры класса A (суда SOLAS)';

  @override
  String get docType1Cadence => 'Каждые 2-10 с в пути, каждые 3 мин на якоре';

  @override
  String get docType2Name =>
      'Сообщение о местоположении, класс A (назначенное)';

  @override
  String get docType2Family => 'Сообщения о местоположении';

  @override
  String get docType2Summary =>
      'Идентично типу 1, но передаётся по расписанию слотов, назначенному судну базовой станцией (режим назначения).';

  @override
  String get docType2EmittedBy => 'Транспондеры класса A в режиме назначения';

  @override
  String get docType2Cadence => 'Назначенное расписание';

  @override
  String get docType3Name => 'Сообщение о местоположении, класс A (ответ)';

  @override
  String get docType3Family => 'Сообщения о местоположении';

  @override
  String get docType3Summary =>
      'Идентично типу 1, передаётся как ответ на опрос (тип 15).';

  @override
  String get docType3EmittedBy => 'Транспондеры класса A, отвечающие на опрос';

  @override
  String get docType3Cadence => 'По опросу';

  @override
  String get docType4Name => 'Отчёт базовой станции';

  @override
  String get docType4Family => 'Базовая станция и сеть';

  @override
  String get docType4Summary =>
      'Периодический отчёт фиксированной береговой станции: её позиция, а также эталон UTC-даты и времени.';

  @override
  String get docType4EmittedBy => 'Фиксированные базовые станции';

  @override
  String get docType4Cadence => 'Каждые 10 с';

  @override
  String get docType5Name => 'Статические и рейсовые данные';

  @override
  String get docType5Family => 'Статические и рейсовые данные';

  @override
  String get docType5Summary =>
      '«Удостоверение личности» судна: название, позывной, номер IMO, тип судна, габариты, осадка, ETA и пункт назначения.';

  @override
  String get docType5EmittedBy => 'Транспондеры класса A';

  @override
  String get docType5Cadence => 'Каждые 6 мин и при изменении данных';

  @override
  String get docType6Name => 'Адресованное двоичное сообщение';

  @override
  String get docType6Family => 'Двоичные данные';

  @override
  String get docType6Summary =>
      'Структурированная двоичная нагрузка, отправляемая одному конкретному MMSI назначения (например, запрошенный метеоотчёт).';

  @override
  String get docType6EmittedBy => 'Любая станция';

  @override
  String get docType6Cadence => 'По запросу';

  @override
  String get docType7Name => 'Двоичное подтверждение';

  @override
  String get docType7Family => 'Двоичные данные';

  @override
  String get docType7Summary =>
      'Подтверждение, отправляемое в ответ на адресованное двоичное сообщение типа 6.';

  @override
  String get docType7EmittedBy => 'Любая станция, получившая тип 6';

  @override
  String get docType7Cadence => 'В ответ';

  @override
  String get docType8Name => 'Широковещательное двоичное сообщение';

  @override
  String get docType8Family => 'Двоичные данные';

  @override
  String get docType8Summary =>
      'Структурированная двоичная нагрузка, передаваемая всем — метео- и гидрологические отчёты, региональные данные или частные/шифрованные сообщения.';

  @override
  String get docType8EmittedBy => 'Любая станция';

  @override
  String get docType8Cadence => 'По запросу';

  @override
  String get docType9Name => 'Стандартный отчёт о местоположении SAR-самолёта';

  @override
  String get docType9Family => 'Сообщения о местоположении';

  @override
  String get docType9Summary =>
      'Отчёт о местоположении, используемый поисково-спасательными самолётами, чтобы быть видимыми судам. Несёт высоту и особый диапазон MMSI (111MIDXXX).';

  @override
  String get docType9EmittedBy => 'SAR-самолёты';

  @override
  String get docType9Cadence => 'Каждые 10 с на станции';

  @override
  String get docType10Name => 'Запрос UTC и даты';

  @override
  String get docType10Family => 'Базовая станция и сеть';

  @override
  String get docType10Summary =>
      'Небольшой запрос, просящий конкретную станцию сообщить её UTC-дату и время.';

  @override
  String get docType10EmittedBy => 'Любая станция';

  @override
  String get docType10Cadence => 'По запросу';

  @override
  String get docType11Name => 'Ответ UTC и даты';

  @override
  String get docType11Family => 'Базовая станция и сеть';

  @override
  String get docType11Summary =>
      'Идентичен по структуре типу 4, передаётся как ответ на запрос UTC/даты типа 10.';

  @override
  String get docType11EmittedBy => 'Базовые станции';

  @override
  String get docType11Cadence => 'По запросу';

  @override
  String get docType12Name => 'Адресованное сообщение по безопасности';

  @override
  String get docType12Family => 'Безопасность и текст';

  @override
  String get docType12Summary =>
      'Свободное текстовое сообщение по безопасности, отправляемое одному MMSI назначения (например, сигнал бедствия ближайшей базовой станции).';

  @override
  String get docType12EmittedBy => 'Любая станция';

  @override
  String get docType12Cadence => 'По запросу';

  @override
  String get docType13Name => 'Подтверждение по безопасности';

  @override
  String get docType13Family => 'Безопасность и текст';

  @override
  String get docType13Summary =>
      'Подтверждение, отправляемое в ответ на адресованное сообщение по безопасности типа 12.';

  @override
  String get docType13EmittedBy => 'Любая станция, получившая тип 12';

  @override
  String get docType13Cadence => 'В ответ';

  @override
  String get docType14Name => 'Широковещательное сообщение по безопасности';

  @override
  String get docType14Family => 'Безопасность и текст';

  @override
  String get docType14Summary =>
      'Свободный текстовый широковещательный запрос ко всем в радиусе — навигационные предупреждения, сигналы бедствия или уведомления о движении.';

  @override
  String get docType14EmittedBy =>
      'Любая станция (часто базовые станции / VTS)';

  @override
  String get docType14Cadence => 'По запросу';

  @override
  String get docType15Name => 'Опрос';

  @override
  String get docType15Family => 'Базовая станция и сеть';

  @override
  String get docType15Summary =>
      'Запрос, просящий одну или две конкретные станции отправить сообщение определённого типа (обычно тип 3 или 5).';

  @override
  String get docType15EmittedBy => 'Базовые станции';

  @override
  String get docType15Cadence => 'По запросу';

  @override
  String get docType16Name => 'Команда режима назначения';

  @override
  String get docType16Family => 'Базовая станция и сеть';

  @override
  String get docType16Summary =>
      'Предписывает до двух судов передавать в определённом выделении слотов (режим назначения).';

  @override
  String get docType16EmittedBy => 'Базовые станции';

  @override
  String get docType16Cadence => 'По запросу';

  @override
  String get docType17Name => 'Широковещательное двоичное сообщение DGNSS';

  @override
  String get docType17Family => 'Двоичные данные';

  @override
  String get docType17Summary =>
      'Дифференциальные коррекционные данные GNSS, передаваемые береговыми станциями для повышения точности позиционирования в обслуживаемой зоне.';

  @override
  String get docType17EmittedBy => 'Справочные станции DGNSS';

  @override
  String get docType17Cadence => 'Периодически';

  @override
  String get docType18Name =>
      'Стандартное сообщение о местоположении класса B CS';

  @override
  String get docType18Family => 'Сообщения о местоположении';

  @override
  String get docType18Summary =>
      'Стандартный отчёт о местоположении класса B. Легче, чем класс A: без навигационного статуса и скорости поворота, но работает с CSTDMA.';

  @override
  String get docType18EmittedBy => 'Транспондеры класса B';

  @override
  String get docType18Cadence => 'Каждые 30 с (или реже в некоторых регионах)';

  @override
  String get docType19Name =>
      'Расширенное сообщение о местоположении оборудования класса B';

  @override
  String get docType19Family => 'Сообщения о местоположении';

  @override
  String get docType19Summary =>
      'Более крупный отчёт о местоположении класса B, который также несёт название судна, тип и габариты — одноразовый гибрид статики и позиции.';

  @override
  String get docType19EmittedBy => 'Расширенные транспондеры класса B';

  @override
  String get docType19Cadence => 'Каждые 30 с';

  @override
  String get docType20Name => 'Управление каналом данных';

  @override
  String get docType20Family => 'Базовая станция и сеть';

  @override
  String get docType20Summary =>
      'Сетевое служебное сообщение, используемое для выделения и резервирования TDMA-слотов в зоне.';

  @override
  String get docType20EmittedBy => 'Базовые станции';

  @override
  String get docType20Cadence => 'Сетевое управление';

  @override
  String get docType21Name => 'Отчёт о навигационном средстве';

  @override
  String get docType21Family => 'Навигационные средства';

  @override
  String get docType21Summary =>
      'Передаёт позицию, название и статус навигационного средства — буёв, маяков, маячных огней или виртуальных средств. Часто отправляется с виртуальной позиции.';

  @override
  String get docType21EmittedBy => 'Станции AtoN (реальные или виртуальные)';

  @override
  String get docType21Cadence => 'Каждые 3 мин (или по событию)';

  @override
  String get docType22Name => 'Управление каналом';

  @override
  String get docType22Family => 'Базовая станция и сеть';

  @override
  String get docType22Summary =>
      'Используется базовой станцией для перевода станций на другие VHF-каналы в пределах географической зоны.';

  @override
  String get docType22EmittedBy => 'Базовые станции';

  @override
  String get docType22Cadence => 'По запросу';

  @override
  String get docType23Name => 'Команда группового назначения';

  @override
  String get docType23Family => 'Базовая станция и сеть';

  @override
  String get docType23Summary =>
      'Команда базовой станции группе судов в зоне, задающая интервалы отчётов и режим передачи.';

  @override
  String get docType23EmittedBy => 'Базовые станции';

  @override
  String get docType23Cadence => 'По запросу';

  @override
  String get docType24Name => 'Отчёт о статических данных';

  @override
  String get docType24Family => 'Статические и рейсовые данные';

  @override
  String get docType24Summary =>
      'Эквивалент типа 5 для класса B, разделён на часть A (название) и часть B (тип судна, позывной, габариты).';

  @override
  String get docType24EmittedBy => 'Транспондеры класса B';

  @override
  String get docType24Cadence => 'Каждые 6 мин';

  @override
  String get docType25Name => 'Двоичное сообщение в одном слоте';

  @override
  String get docType25Family => 'Двоичные данные';

  @override
  String get docType25Summary =>
      'Короткое двоичное сообщение, помещающееся в один TDMA-слот, с опциональным назначением и ID приложения.';

  @override
  String get docType25EmittedBy => 'Любая станция';

  @override
  String get docType25Cadence => 'По запросу';

  @override
  String get docType26Name => 'Двоичное сообщение в нескольких слотах';

  @override
  String get docType26Family => 'Двоичные данные';

  @override
  String get docType26Summary =>
      'Более длинное двоичное сообщение, распределённое по нескольким TDMA-слотам, несущее информацию о радиостатусе.';

  @override
  String get docType26EmittedBy => 'Любая станция';

  @override
  String get docType26Cadence => 'По запросу';

  @override
  String get docType27Name => 'Сообщение о местоположении для дальнего радиуса';

  @override
  String get docType27Family => 'Сообщения о местоположении';

  @override
  String get docType27Summary =>
      'Очень компактный отчёт о местоположении, разработанный для приёма спутниками на больших дальностях, с пониженным разрешением.';

  @override
  String get docType27EmittedBy =>
      'Суда в режиме дальнего (спутникового) радиуса';

  @override
  String get docType27Cadence => 'Каждые 3 мин (режим дальнего радиуса)';

  @override
  String get docTimeline1990sTitle => 'Шведское изобретение';

  @override
  String get docTimeline1990sText =>
      'Концепция рождается в Швеции: VHF-система, где каждое судно сообщает о себе, чтобы другие «видели и были видимы», даже в тумане и за островами. Она представлена IMO и становится основой AIS.';

  @override
  String get docTimeline1998Title => 'Начинается стандартизация';

  @override
  String get docTimeline1998Text =>
      'ITU и IEC начинают превращать концепцию в радиостандарт с точными битовыми форматами, основанный на TDMA на двух VHF-каналах.';

  @override
  String get docTimeline2001Title => 'Опубликована ITU-R M.1371';

  @override
  String get docTimeline2001Text =>
      'Рекомендация ITU-R M.1371 «Технические характеристики универсальной судовой системы автоматической идентификации» определяет 27 типов сообщений и их битовую структуру.';

  @override
  String get docTimeline2002Title => 'Требование SOLAS';

  @override
  String get docTimeline2002Text =>
      'IMO делает AIS обязательной для всех международных судов валовой вместимостью более 300 тонн и всех пассажирских судов — примерно 100 000 судов. AIS становится стандартным средством предотвращения столкновений наряду с радаром.';

  @override
  String get docTimeline2006Title => 'Появляется класс B';

  @override
  String get docTimeline2006Text =>
      'Опубликован стандарт класса B, открывающий путь дешёвым, более простым транспондерам. В том же году спутник TacSat-2 первым захватывает сигналы AIS из космоса (S-AIS).';

  @override
  String get docTimeline2008_2015Title => 'Спутниковые группировки';

  @override
  String get docTimeline2008_2015Text =>
      'exactEarth, ORBCOMM, Spire и другие развёртывают приёмники AIS на низкой околоземной орбите, расширяя покрытие далеко за пределы VHF-горизонта и обеспечивая почти глобальное отслеживание судов.';

  @override
  String get docTimeline2010Title => 'AIS-SART в GMDSS';

  @override
  String get docTimeline2010Text =>
      'Поисково-спасательный передатчик AIS (AIS-SART, IEC 61097-14) входит в Глобальную морскую систему связи при бедствии, позволяя спасательным шлюпкам передавать координаты бедствия по AIS.';

  @override
  String get docTimeline2014Title => 'Рыболовные и внутренние флоты';

  @override
  String get docTimeline2014Text =>
      'Европейские правила требуют AIS класса A на всех рыболовных судах ЕС длиной более 15 м; AIS для внутренних водных путей широко развёрнута на европейских реках.';

  @override
  String get docTimeline2021Title => '1,6 миллиона судов';

  @override
  String get docTimeline2021Text =>
      'Более 1,6 миллиона судов оснащены AIS, питая наземные и спутниковые сети, которые обеспечивают отслеживание судов, контроль рыболовства и морскую безопасность по всему миру.';

  @override
  String get docTimelineVdesTitle => 'VDES — преемник';

  @override
  String get docTimelineVdesText =>
      'VHF Data Exchange System (ITU-R M.2092) внедряется для разгрузки перегруженных районов, добавляя гораздо больше полосы пропускания и защищённые услуги электронной навигации.';

  @override
  String get docAppTitle => 'Документация';

  @override
  String get docSearchChapters => 'Поиск по разделам';

  @override
  String get docChapterOverview => 'Обзор';

  @override
  String get docChapterHistory => 'История и регулирование';

  @override
  String get docChapterHowItWorks => 'Как это работает';

  @override
  String get docChapterRadio => 'Радио и TDMA';

  @override
  String get docChapterClasses => 'Классы и оборудование';

  @override
  String get docChapterMmsi => 'MMSI и идентичность';

  @override
  String get docChapterShipTypes => 'Типы судов';

  @override
  String get docChapterMessages => '27 сообщений';

  @override
  String get docChapterNmea => 'NMEA и AIVDM';

  @override
  String get docChapterPayload => 'Внутри нагрузки';

  @override
  String get docChapterSecurity => 'Безопасность и ограничения';

  @override
  String get docChapterFieldNotes => 'Полевые заметки';

  @override
  String get docChapterKikais => 'AIS в KikAis';

  @override
  String get docChapterGlossary => 'Глоссарий';

  @override
  String get docChapterCheatSheet => 'Шпаргалка';

  @override
  String get docChapterSources => 'Источники';

  @override
  String get docOverviewTitle => 'Что такое AIS?';

  @override
  String get docOverviewIntro =>
      'Система автоматической идентификации (AIS) — это система отслеживания, используемая на судах и службами движения судов (VTS). Каждое оснащённое судно непрерывно передаёт по VHF-радио свою идентичность, позицию, курс и скорость, чтобы каждое другое судно и береговая станция в зоне действия могли его «видеть» — концепция «видеть и быть видимым».';

  @override
  String get docOverviewRadar =>
      'AIS не заменяет судовой радар. Радар независимо обнаруживает любой объект, но мало говорит о том, кто это. AIS точно сообщает, кто, где и куда направляется — но доверяет тому, что заявляет отправитель. Две системы дополняют друг друга.';

  @override
  String get docOverviewAdsBTitle => 'Думайте о ней как о морском ADS-B';

  @override
  String get docOverviewAdsBText =>
      'Как ADS-B позволяет самолётам сообщать о себе службам управления воздушным движением, так AIS позволяет судам сообщать о себе друг другу и береговым службам. Суда видят окружающее движение на картплоттере или дисплее, подобном радару; портовые власти следят за движением и рыболовством.';

  @override
  String get docOverviewTransponder => 'Что передаёт транспондер';

  @override
  String get docOverviewBullet1 =>
      'Уникальная идентичность: 9-значный номер MMSI (первые три цифры которого определяют выдающую страну).';

  @override
  String get docOverviewBullet2 =>
      'Динамические данные: позиция, скорость над грунтом (SOG), курс над грунтом (COG), истинный курс, скорость поворота, навигационный статус.';

  @override
  String get docOverviewBullet3 =>
      'Статические и рейсовые данные: название, позывной, номер IMO, тип судна, габариты, осадка, пункт назначения, ETA.';

  @override
  String get docOverviewBullet4 =>
      'Сообщения по безопасности и двоичные: тексты бедствия, метеоотчёты, сетевые команды.';

  @override
  String get docOverviewWho => 'Кто обязан его носить';

  @override
  String get docOverviewImo =>
      'IMO (конвенция SOLAS) обязывает использовать AIS на международных судах валовой вместимостью более 300 тонн и на всех пассажирских судах. Региональные правила расширяют это на рыболовные флоты, внутренние водные пути и всё чаще на прогулочные суда через недорогие транспондеры класса B.';

  @override
  String get docOverviewLimits => 'Ограничения вкратце';

  @override
  String get docOverviewLimit1 =>
      'Дальность примерно прямая видимость: около 10-20 морских миль судно-судно, больше от береговых станций и спутников.';

  @override
  String get docOverviewLimit2 =>
      'В AIS нет аутентификации: любой может передавать любое удостоверение (спуфинг) или глушить канал.';

  @override
  String get docOverviewLimit3 =>
      'Точность зависит от GNSS-фиксации отправителя и от честности заявляемых данных.';

  @override
  String get docHistoryIntro =>
      'AIS выросла из шведской идеи во всемирно обязательную систему безопасности. Коснитесь любой вехи на шкале времени для подробностей.';

  @override
  String get docHistoryStandards => 'Управляющие стандарты';

  @override
  String get docHistoryStd1 =>
      'ITU-R M.1371 — Технические характеристики универсальной судовой AIS (определяет 27 типов сообщений и их битовую структуру).';

  @override
  String get docHistoryStd2 =>
      'Рекомендации IALA — уточнения и руководство по внедрению.';

  @override
  String get docHistoryStd3 =>
      'IEC 61162 / 62287 — формат предложений NMEA и требования класса B/CSTDMA.';

  @override
  String get docHistoryStd4 => 'IEC 61097-14 — передатчик бедствия AIS-SART.';

  @override
  String get docHowIntro =>
      'AIS — это VHF-радиосистема. Каждый транспондер слушает окружающее движение и передаёт собственные отчёты в зарезервированных временных слотах, избегая столкновений с другими судами в зоне действия.';

  @override
  String get docHowRadioLink => 'Радиоканал';

  @override
  String get docHowRadioLink1 =>
      'Два выделенных VHF-канала: AIS 1 на 161.975 МГц (87B) и AIS 2 на 162.025 МГц (88B).';

  @override
  String get docHowRadioLink2 =>
      'Цифровая узкополосная ЧМ, 9 600 бит в секунду.';

  @override
  String get docHowRadioLink3 =>
      'Сообщения организованы в TDMA-кадры по 2250 временных слотов (1 минута).';

  @override
  String get docHowSlots => 'Как распределяются слоты';

  @override
  String get docHowSotdma =>
      'Транспондеры класса A используют SOTDMA (Self-Organizing Time Division Multiple Access): каждый блок резервирует повторяющийся слот и перерезервирует его при изменении картины, так что суда непрерывно координируются без центрального контроллера.';

  @override
  String get docHowCstdma =>
      'Транспондеры класса B используют более простую CSTDMA (Carrier Sense TDMA): они слушают свободный слот и захватывают его, поэтому отчёты класса B менее частые и могут теряться при очень плотном движении.';

  @override
  String get docHowRates => 'Частота отчётов';

  @override
  String get docHowRates1 =>
      'Сообщение о местоположении класса A (тип 1): каждые 2-10 секунд в пути, каждые 3 минуты на якоре.';

  @override
  String get docHowRates2 =>
      'Статические и рейсовые данные (тип 5): каждые 6 минут.';

  @override
  String get docHowRates3 =>
      'Позиция класса B (тип 18): примерно каждые 30 секунд.';

  @override
  String get docHowRates4 =>
      'Навигационное средство (тип 21): каждые 3 минуты.';

  @override
  String get docHowTerrestrial => 'Наземный и спутниковый';

  @override
  String get docHowTerrestrialText =>
      'На поверхности дальность AIS ограничена VHF-горизонтом (T-AIS). С середины 2000-х спутники на низкой околоземной орбите (S-AIS) принимают те же сигналы, обеспечивая почти глобальное покрытие — спутники дополняют, а не заменяют наземную сеть.';

  @override
  String get docRadioIntro =>
      'Под сообщениями лежит небольшая эффективная радиосистема. AIS передаёт на 9 600 бит в секунду на двух VHF-каналах, используя гауссовскую частотную манипуляцию с минимальным сдвигом (GMSK) и кадрирование в стиле HDLC.';

  @override
  String get docRadioPhysical => 'Физический канал';

  @override
  String get docRadioPhysical1 =>
      'AIS 1 на 161.975 МГц и AIS 2 на 162.025 МГц (VHF-каналы 87B и 88B).';

  @override
  String get docRadioPhysical2 =>
      'Модуляция GMSK на 9 600 бод — достаточно узкая, чтобы поместиться в морскую VHF-полосу.';

  @override
  String get docRadioPhysical3 =>
      'HDLC-кадрирование с битстаффингом и линейное кодирование NRZI, унаследованные из мира пакетного радио.';

  @override
  String get docRadioFrames => 'TDMA-кадры и слоты';

  @override
  String get docRadioFrames1 =>
      'Каждый канал делится на кадры ровно по 1 минуте, разделённые на 2 250 временных слотов по ~26.7 мс каждый.';

  @override
  String get docRadioFrames2 =>
      'Один слот несёт одно сообщение AIS (256 бит с временем нарастания/спада и защитным временем).';

  @override
  String get docRadioFrames3 =>
      'Станции повторно используют одни и те же слоты каждый кадр, передавая периодически без столкновений.';

  @override
  String get docRadioCode =>
      '2250 слотов/кадр · 1 кадр = 60 с · слот ≈ 26.7 мс · 9600 бит/с';

  @override
  String get docRadioSotdma => 'SOTDMA — как класс A самоорганизуется';

  @override
  String get docRadioSotdmaText =>
      'Каждый транспондер класса A слушает слоты вокруг, выбирает свободный и сообщает в поле радиостатуса, когда передаст следующим. Станции непрерывно перерезервируют слоты при изменении картины движения, поэтому центральный координатор не нужен.';

  @override
  String get docRadioCstdma => 'CSTDMA — как подключается класс B';

  @override
  String get docRadioCstdmaText =>
      'Блоки класса B проще: они слушают слот, который в данный момент свободен, и передают в нём один раз. Это дешевле, но отчёты класса B могут теряться при очень плотном движении, где слот всегда занят.';

  @override
  String get docRadioVdes => 'VDES — будущее';

  @override
  String get docRadioVdesText =>
      'VHF Data Exchange System (ITU-R M.2092) внедряется для разгрузки перегруженных вод: она добавляет новые частоты, гораздо больше полосы пропускания и защищённый двусторонний обмен для электронной навигации, наряду с существующей службой AIS.';

  @override
  String get docClassesIntro =>
      'Оборудование AIS бывает разных классов и ролей. Два, которые вы чаще всего встретите, — это полноценный транспондер класса A и недорогой блок класса B.';

  @override
  String get docClassesComparison => 'Класс A против класса B';

  @override
  String get docClassesReceivers => 'Приёмники и транспондеры';

  @override
  String get docClassesReceiversText =>
      'Транспондеры и принимают, и передают. Многие береговые станции и энтузиасты используют только приёмники, чтобы наблюдать за движением, не появляясь в нём.';

  @override
  String get docClassesAton => 'Навигационные средства';

  @override
  String get docClassesAtonText =>
      'Станции AtoN (тип 21) передают буи, маяки и маячные огни. Они также могут передавать виртуальное средство — маркер, существующий только на картах, полезный для предупреждения о новой опасности.';

  @override
  String get docClassesDistress => 'Устройства бедствия и безопасности';

  @override
  String get docClassesDistressIntro =>
      'Помимо обычных судов, AIS несёт передатчики бедствия, которые должен уметь распознать каждый приёмник:';

  @override
  String get docClassesSartNote =>
      'Работающий SART также устанавливает навигационный статус 14 («AIS-SART активен») в своём отчёте о местоположении.';

  @override
  String get docShipTypesIntro =>
      'Статические сообщения типов 5 и 24 несут 8-битный код типа судна (0-99), описывающий, чем является судно — грузовым, танкером, рыболовным, прогулочным и так далее. Полная таблица приведена ниже.';

  @override
  String get docShipTypesCategories => 'Категории вкратце';

  @override
  String docVesselCatRow(Object label, Object range) {
    return '$range — $label';
  }

  @override
  String get docFieldNotesTitle =>
      'Полевые заметки и особенности реального мира';

  @override
  String get docFieldNotesIntro =>
      'Реальное движение AIS не всегда соответствует теории. Знание этих особенностей поможет вам доверять тому, что показывает декодер — и тому, что он отвергает.';

  @override
  String get docGlossaryIntro =>
      'Поисковый словарь аббревиатур и терминов, используемых в этом руководстве и сообществом AIS.';

  @override
  String get docCheatSheetIntro =>
      'Основные числа и коды вкратце — частоты, частота отчётов, коды статусов и форматы.';

  @override
  String get docMmsiIntro =>
      'Идентичность морской подвижной службы (MMSI) — это уникальный 9-значный номер, идентифицирующий радиооборудование судна, как телефонный номер для судна. Его первые три цифры — это MID — Maritime Identification Digits, определяющие страну, выдавшую номер.';

  @override
  String get docMmsiFormats => 'Форматы номеров';

  @override
  String docMmsiFmtRow(Object format, Object label) {
    return '$format — $label';
  }

  @override
  String get docMmsiLookupHeading => 'Поиск MMSI';

  @override
  String get docMmsiLookupHint =>
      'Введите ниже 9-значный MMSI, чтобы увидеть его класс и страну выдавшего органа.';

  @override
  String get docMmsiMidHeading => 'Коды стран (MID)';

  @override
  String get docMmsiMidText =>
      'Полная таблица MID входит в комплект KikAis и используется везде, где отображается MMSI.';

  @override
  String get docMessagesTitle => '27 типов сообщений';

  @override
  String get docMessagesIntro =>
      'Каждая нагрузка AIS начинается с 6-битного типа сообщения (от 1 до 27). Каталог ниже группирует их по семействам. Каждая карточка показывает реальное предложение NMEA, сгенерированное собственным кодировщиком KikAis, его декодированные поля и кнопку для открытия в Декодере.';

  @override
  String get docNmeaTitle => 'Кадрирование NMEA и AIVDM';

  @override
  String get docNmeaIntro =>
      'В канале сообщения AIS передаются как предложения NMEA 0183, начинающиеся с !AIVDM (другие суда) или !AIVDO (ваше собственное судно). Нагрузка — это ASCII-армированный вектор битов.';

  @override
  String get docNmeaSampleSingle =>
      '!AIVDM,1,1,,B,177KQJ5000G?tO`K>RA1wUbN0TKH,0*5C';

  @override
  String get docNmeaFields => 'Поля предложения';

  @override
  String get docNmeaField1 =>
      'Источник и форматтер — !AIVDM или !AIVDO (см. ID источников ниже).';

  @override
  String get docNmeaField2 =>
      'Количество фрагментов — из скольких предложений состоит полное сообщение (NMEA ограничивает каждую строку ~82 символами).';

  @override
  String get docNmeaField3 =>
      'Номер фрагмента — какая это часть (начиная с 1).';

  @override
  String get docNmeaField4 =>
      'Последовательный ID сообщения — связывает фрагменты одного сообщения.';

  @override
  String get docNmeaField5 => 'Радиоканал — A или B (AIS1 / AIS2).';

  @override
  String get docNmeaField6 =>
      'Полезная нагрузка — шестибитовый армированный payload AIS.';

  @override
  String get docNmeaField7 =>
      'Биты заполнения — сколько битов заполнения добавлено к последней 6-битовой группе (0-5).';

  @override
  String get docNmeaField8 =>
      'Контрольная сумма — XOR всех байтов до *, в шестнадцатеричном виде.';

  @override
  String get docNmeaMulti => 'Многофрагментные сообщения';

  @override
  String get docNmeaMultiText =>
      'Сообщения длиннее одной строки (например, статические данные типа 5) разбиваются: первое предложение сообщает количество фрагментов 2, а второе завершает его с тем же ID сообщения.';

  @override
  String get docNmeaSampleMulti =>
      '!AIVDM,2,1,3,B,55P5TL01VIaAL@7WKO@mBplU@<PDhh000000001S;AJ::4A80?4i@E53,0*3E\n!AIVDM,2,2,3,B,1@0000000000000,2*55';

  @override
  String get docNmeaArmoring => 'Шестибитовое армирование';

  @override
  String get docNmeaArmoringText =>
      'Каждый символ нагрузки содержит 6 бит. Вычтите 48 из кода ASCII, затем вычтите ещё 8, если результат больше 40.';

  @override
  String get docNmeaTalkers => 'ID источников';

  @override
  String get docNmeaTalkersIntro =>
      'Различные ID источников NMEA 4.0 определяют тип станции AIS:';

  @override
  String docTalkerRow(Object label, Object talker) {
    return '!$talker — $label';
  }

  @override
  String get docNmeaChecksum => 'Контрольная сумма';

  @override
  String get docNmeaChecksumText =>
      'Завершающая контрольная сумма — это XOR каждого байта между \"!\" и \"*\". Рассчитайте свою ниже:';

  @override
  String get docNmeaInspectorTitle => 'Попробуйте: инспектор предложений';

  @override
  String get docNmeaInspectorText =>
      'Вставьте любое предложение AIVDM/AIVDO (или используйте пример выше), чтобы увидеть его поля в разборе и декодированные значения.';

  @override
  String get docPayloadIntro =>
      'Как только шестибитовое армирование снято, нагрузка AIS — это последовательность битовых полей. Первые шесть бит — тип сообщения; следующие два — индикатор повтора; затем идут 30 бит MMSI.';

  @override
  String get docPayloadCnb => 'Общий навигационный блок (типы 1-3)';

  @override
  String get docPayloadCnbText =>
      'Самый важный формат используется отчётами о местоположении класса A. Используйте селектор, чтобы просмотреть основные форматы сообщений, и кликните сегмент, чтобы прочитать, что он кодирует.';

  @override
  String get docPayloadCoords => 'Координаты';

  @override
  String get docPayloadCoordsText =>
      'Широта и долгота хранятся в 1/10 000 минуты. Разделите на 600 000, чтобы получить градусы: 60 минут в градусе и 10 000 единиц на минуту. Восток/Север положительные.';

  @override
  String get docPayloadCoordsCode =>
      'lon = rawLongitude / 600000.0   // например, -26940000 -> -44.9°';

  @override
  String get docPayloadCoordsConvert => 'Преобразуйте свои координаты ниже:';

  @override
  String get docPayloadSpeed => 'Скорость, курс, направление';

  @override
  String get docPayloadSpeed1 =>
      'SOG — скорость над грунтом в десятых долях узла (0-102.2 kn); 1023 означает «недоступно».';

  @override
  String get docPayloadSpeed2 =>
      'COG — курс над грунтом в десятых долях градуса относительно истинного севера.';

  @override
  String get docPayloadSpeed3 =>
      'Курс — истинный курс в целых градусах; 511 означает «недоступно».';

  @override
  String get docPayloadSpeed4 =>
      'ROT — скорость поворота: значение ≈ 4.733 × √(скорость поворота в °/мин), со знаком (положительное = вправо).';

  @override
  String get docPayloadNavStatus => 'Навигационный статус';

  @override
  String get docPayloadEpfd => 'Тип фиксации позиции (EPFD)';

  @override
  String get docPayloadText => 'Шестибитовый текст';

  @override
  String get docPayloadTextIntro =>
      'Названия, позывные и пункты назначения используют тот же шестибитовый алфавит, что и сама нагрузка. Строчные буквы закодировать нельзя, поэтому названия AIS обычно заглавные.';

  @override
  String get docSecurityTitle => 'Безопасность и качество данных';

  @override
  String get docSecurityIntro =>
      'AIS создана для сотрудничества, а не для безопасности. Радиоканал открыт и не шифруется, и нет аутентификации того, кто передаёт.';

  @override
  String get docSecurityThreats => 'Угрозы';

  @override
  String get docSecurityThreat1 =>
      'Спуфинг — передача поддельного MMSI, позиции или идентичности (фантомные суда, уклонение от санкций).';

  @override
  String get docSecurityThreat2 =>
      'Глушение — заполнение двух VHF-каналов так, что реальное движение невозможно принять.';

  @override
  String get docSecurityThreat3 =>
      'Миконинг — повторная передача реальных сигналов из других мест для обмана приёмников.';

  @override
  String get docSecurityQuality => 'Качество данных';

  @override
  String get docSecurityQuality1 =>
      'Бит точности позиции отличает фиксацию GNSS без дополнений (> 10 м) от фиксации качества DGPS (< 10 м).';

  @override
  String get docSecurityQuality2 =>
      'Приёмники должны проверять правдоподобность позиций, скоростей и временных меток; около 0.3% реальных сообщений имеют неверную длину нагрузки.';

  @override
  String get docSecurityQuality3 =>
      'Спутниковая AIS иногда страдает от коллизий, потому что спутниковое пятно покрытия намного больше ячейки TDMA — ещё одна причина сверяться с радаром и другими источниками.';

  @override
  String get docKikaisIntro =>
      'KikAis — это полноценная AIS-лаборатория: принимайте живой или симулированный поток, декодируйте его, просматривайте и отправляйте собственные сообщения, создавайте флоты. Вот как каждая вкладка соотносится с тем, что вы только что прочитали.';

  @override
  String get docTabReceptionText =>
      'Выбирайте источники (файл, последовательный порт, симуляция), запускайте пересыльщик и смотрите сырой поток NMEA и декодированные суда.';

  @override
  String get docTabSendText =>
      'Пересылайте принятые предложения на один или несколько TCP/UDP-целей — так береговая станция распространяла бы поток.';

  @override
  String get docTabMapText =>
      'Смотрите декодированные суда, нанесённые из их отчётов о местоположении типов 1/2/3, 18, 19 и 27.';

  @override
  String get docTabEditorText =>
      'Собирайте любой из 27 типов сообщений вручную в удобной форме и отправляйте его — лучший способ изучить поля.';

  @override
  String get docTabDecoderText =>
      'Вставьте любое предложение и получите декодированные поля, контрольную сумму и обработку фрагментов — практический спутник этого руководства.';

  @override
  String get docTabStatsText =>
      'Счётчики сообщений, частоты по потокам и состояние декодера (неверные контрольные суммы, отброшенные фрагменты).';

  @override
  String get docTabSimulationText =>
      'Сгенерируйте целый флот вокруг любого места — каждый тип сообщения, схема MMSI, форма зоны и даже внесение ошибок.';

  @override
  String get docSourcesIntro =>
      'Это руководство синтезирует общедоступную авторитетную документацию:';

  @override
  String get docSources1 =>
      'gpsd — декодирование протокола AIVDM/AIVDO, автор Эрик С. Рэймонд (de-facto техническая библия формата предложений и битовых полей нагрузки).';

  @override
  String get docSources2 =>
      'Wikipedia — Automatic Identification System (обзор, история, применение, безопасность).';

  @override
  String get docSources3 =>
      'US Coast Guard Navigation Center (NavCen) — страницы AIS.';

  @override
  String get docSources4 =>
      'ITU-R Recommendation M.1371 — управляющий стандарт AIS.';

  @override
  String get docSources5 => 'IALA — уточнения ITU-R M.1371.';

  @override
  String get docSources6 =>
      'IEC 61162 / IEC 62287 / IEC 61097-14 — кадрирование NMEA, класс B и AIS-SART.';

  @override
  String get docSourcesLearn => 'Как узнать больше';

  @override
  String get docSourcesLearnText =>
      'Лучший способ понять AIS — экспериментировать: используйте Редактор для сборки сообщений, Декодер для их чтения, а вкладку «Симуляция» для наблюдения за целым флотом. Всё в этом руководстве генерируется собственными кодировщиком и декодером KikAis.';

  @override
  String docTypeCardTitle(Object name, Object type) {
    return 'Тип $type — $name';
  }

  @override
  String docTypeCardSubtitle(Object bits, Object cadence) {
    return '$bits бит · $cadence';
  }

  @override
  String docTypeCardEmittedBy(Object emittedBy) {
    return 'Передаёт: $emittedBy';
  }

  @override
  String get docOpenInDecoder => 'Открыть в Декодере';

  @override
  String get docInspectorNmeaLabel => 'Предложение NMEA';

  @override
  String get docInspectorInspect => 'Проверить';

  @override
  String get docInspectorInvalidChecksum => 'Неверная контрольная сумма';

  @override
  String get docInspectorCouldNotDecode => 'Не удалось декодировать';

  @override
  String docInspectorDecoded(Object label, Object type) {
    return 'Декодировано: T$type · $label';
  }

  @override
  String docInspectorTypeFallback(Object type) {
    return 'Тип $type';
  }

  @override
  String get docMmsiLookupLabel => 'MMSI (9 цифр)';

  @override
  String get docMmsiLookupButton => 'Найти';

  @override
  String get docMmsiLookupError => 'Введите 9-значный MMSI (только цифры).';

  @override
  String get docMmsiLookupClassGroup => 'Группа судов (групповой вызов)';

  @override
  String get docMmsiUnknownCountry => 'неизвестная страна';

  @override
  String docMmsiLookupResult(Object cls, Object country, Object mid) {
    return '$cls — MID $mid ($country)';
  }

  @override
  String get docTabOpen => 'Открыть';

  @override
  String get updateCheckForUpdates => 'Проверить обновления';

  @override
  String get updateChecking => 'Проверка обновлений…';

  @override
  String updateNewVersion(Object version) {
    return 'Новая версия $version';
  }

  @override
  String get updateUpToDate => 'У вас актуальная версия.';

  @override
  String get updateCheckFailed => 'Не удалось проверить обновления.';

  @override
  String get tooltipLanguage =>
      'Изменить язык интерфейса. Все десять языков полностью переведены; выберите «Авто», чтобы следовать языку системы.';

  @override
  String get tooltipTheme =>
      'Изменить цветовую тему: тёмная, светлая или высокая контрастность. Высокая контрастность улучшает читаемость.';

  @override
  String get tooltipUpdate =>
      'Проверить наличие новой версии. Если она есть, рядом с номером версии появится зелёный значок.';

  @override
  String get tooltipMapSearch =>
      'Найти судно по имени, MMSI или номеру IMO и центрировать/следить за ним на карте.';

  @override
  String get tooltipMapFilters =>
      'Фильтровать отображаемые суда: по типу, статусу движения, стране (MID), скорости или только по имени.';

  @override
  String get tooltipMapCluster =>
      'Переключить группировку судов. Когда включено, близкие суда объединяются в один маркер со счётчиком.';

  @override
  String get tooltipMapTrails =>
      'Переключить следы. Когда включено, каждое судно рисует свой недавний маршрут на карте.';

  @override
  String get tooltipMapVectors =>
      'Переключить векторы курса. Когда включено, каждое судно показывает стрелку по направлению движения.';

  @override
  String get tooltipMapSendToMap =>
      'Переключить отправку декодированных судов на карту. Когда включено, каждое декодированное судно отображается маркером.';

  @override
  String get tooltipMapClear =>
      'Удаляет все суда, находящиеся в данный момент на карте.';

  @override
  String get tooltipMapBasemap =>
      'Выбрать подложку карты. «Авто» следует текущей теме.';

  @override
  String get tooltipSendAdd =>
      'Добавить пункт назначения (UDP или TCP, клиент или сервер). Входящие кадры AIS пересылаются на каждый включённый пункт.';

  @override
  String get tooltipSendEdit =>
      'Изменить имя, протокол, хост, порт и формат кадров этого пункта назначения.';

  @override
  String get tooltipSendDelete =>
      'Удалить этот пункт назначения. Действие нельзя отменить.';

  @override
  String get tooltipSendToggle =>
      'Включить или отключить пересылку на этот пункт назначения.';

  @override
  String get tooltipSendLocked =>
      'Пункты назначения заблокированы, пока работает пересылка. Остановите источник на вкладке «Приём», чтобы изменить их.';

  @override
  String get tooltipReceptionAddSource =>
      'Добавить источник данных: сетевой поток (UDP/TCP/gpsd), файл с записанными предложениями NMEA или последовательный порт.';

  @override
  String get tooltipReceptionStart =>
      'Запустить приём и пересылку кадров AIS со всех включённых источников.';

  @override
  String get tooltipReceptionStop => 'Остановить приём и пересылку кадров AIS.';

  @override
  String get tooltipReceptionFeed =>
      'Включить или отключить этот источник AIS.';

  @override
  String get tooltipReceptionSaveLogs =>
      'Сохранить журнал подключений в текстовый файл.';

  @override
  String get tooltipReceptionClearLogs => 'Очистить журнал подключений.';

  @override
  String get tooltipReceptionRemoveSource => 'Удалить этот источник AIS.';

  @override
  String get tooltipReceptionValidateChecksums =>
      'Когда включено, кадры с неверной контрольной суммой NMEA отклоняются.';

  @override
  String get tooltipReceptionImportFormat =>
      'Как полученные кадры нормализуются перед декодированием.';

  @override
  String get tooltipReceptionLoop =>
      'Когда включено, воспроизведение файла начинается заново после достижения конца.';

  @override
  String get tooltipReceptionSpeed =>
      'Множитель скорости воспроизведения (1x = реальное время).';

  @override
  String get tooltipReceptionSerialPorts =>
      'Обновить список доступных последовательных портов.';

  @override
  String get tooltipSimApply =>
      'Применить текущие настройки и сгенерировать флот. Крупные флоты генерируются в фоновом режиме.';

  @override
  String get tooltipSimGenerate =>
      'Сгенерировать новый случайный флот с новым зерном и применить его.';

  @override
  String get tooltipSimOpenReception =>
      'Перейти на вкладку «Приём», чтобы запустить источник симуляции.';

  @override
  String get tooltipSimRadius =>
      'Радиус зоны плавания вокруг центра, в километрах.';

  @override
  String get tooltipSimVessels => 'Количество судов для генерации во флоте.';

  @override
  String get tooltipSimSpeedMin => 'Минимальная скорость судов, в узлах.';

  @override
  String get tooltipSimSpeedMax => 'Максимальная скорость судов, в узлах.';

  @override
  String get tooltipSimInterval =>
      'Задержка между двумя тактами передачи, в секундах.';

  @override
  String get tooltipSimSeed =>
      'Случайное зерно. Одно и то же зерно всегда даёт один и тот же флот.';

  @override
  String get tooltipSimAnchored =>
      'Доля судов, остающихся на якоре или у причала вместо движения.';

  @override
  String get tooltipSimNamePrefix => 'Префикс для генерируемых имён судов.';

  @override
  String get tooltipSimMmsiMid =>
      'Морские идентификационные цифры (3-значный код страны) для построения MMSI.';

  @override
  String get tooltipSimCenterLat => 'Широта центра зоны плавания.';

  @override
  String get tooltipSimCenterLon => 'Долгота центра зоны плавания.';

  @override
  String get tooltipSimTransit =>
      'Доля судов, пересекающих зону по прямому транзитному маршруту.';

  @override
  String get tooltipSimRegenEvery =>
      'Перегенерировать флот каждые N тактов, если включена периодическая перегенерация.';

  @override
  String get tooltipSimReportInterval =>
      'Максимальный интервал позиционного донесения на судно, в тактах.';

  @override
  String get tooltipSimWander =>
      'Сила случайного дрейфа курса (0 = прямые линии).';

  @override
  String get tooltipSimClassBShare =>
      'Доля позиционных донесений класса B по сравнению с классом A, когда включены оба.';

  @override
  String get tooltipSimErrorRate =>
      'Вероятность повреждения или дублирования каждого передаваемого предложения.';

  @override
  String get tooltipSimBaseStations =>
      'Количество генерируемых фиксированных базовых станций.';

  @override
  String get tooltipSimAtoN =>
      'Количество генерируемых фиксированных средств навигации (маяков).';

  @override
  String get tooltipSimRealisticNames =>
      'Использовать реалистичные имена, позывные и пункты назначения судов.';

  @override
  String get tooltipSimRealisticDimensions =>
      'Масштабировать размеры и осадку судна по его типу.';

  @override
  String get tooltipSimRealisticMmsi =>
      'Строить MMSI по структуре ITU в зависимости от категории судна.';

  @override
  String get tooltipSimVarySpeed =>
      'Позволить скорости слегка колебаться в заданном диапазоне.';

  @override
  String get tooltipSimSpeedByType =>
      'Выбирать скорость из типичного диапазона каждого типа судна.';

  @override
  String get tooltipSimHighAccuracy =>
      'Устанавливать флаг высокой точности позиции на передаваемые донесения.';

  @override
  String get tooltipSimRealisticRot =>
      'Передавать скорость поворота, рассчитанную по изменению курса.';

  @override
  String get tooltipSimRegeneratePeriodically =>
      'Автоматически перегенерировать флот каждые N тактов для имитации изменяющегося трафика.';

  @override
  String get tooltipSimInjectErrors =>
      'Повреждать или дублировать некоторые передаваемые предложения для проверки обработки ошибок.';

  @override
  String get tooltipSimNmea4Tag =>
      'Добавлять к каждому передаваемому кадру префикс с блоком тегов NMEA 4.0.';

  @override
  String get tooltipSimVesselType => 'Включить этот тип судна во флот.';

  @override
  String get tooltipSimMessageType => 'Передавать этот тип сообщения AIS.';

  @override
  String get tooltipDecoderClear => 'Очистить ввод и результаты декодера.';

  @override
  String get tooltipStatsDecode =>
      'Приостановить или возобновить декодирование входящих кадров AIS.';

  @override
  String get tooltipStatsReset => 'Сбросить все счётчики статистики в ноль.';

  @override
  String get tooltipDocOpenTab => 'Открыть этот раздел в отдельной вкладке.';

  @override
  String get tooltipEditorInject =>
      'Вставить составленное сообщение в декодер, как если бы оно было получено.';

  @override
  String get tooltipEditorSend =>
      'Отправить составленное сообщение на каждый включённый пункт назначения.';

  @override
  String get tooltipCopy => 'Скопировать в буфер обмена.';

  @override
  String get tooltipClose => 'Закрыть эту панель.';

  @override
  String get tooltipBrowse => 'Выбрать файл.';

  @override
  String get tooltipFeedName =>
      'Метка, идентифицирующая этот источник в списке каналов.';

  @override
  String get tooltipFeedHost => 'Адрес сервера, передающего AIS-предложения.';

  @override
  String get tooltipFeedPort => 'Порт TCP или UDP для подключения к серверу.';

  @override
  String get tooltipFeedHeader =>
      'Необязательные байты, отправляемые при подключении перед чтением (например, запрос gpsd).';

  @override
  String get tooltipFeedFile =>
      'Путь к текстовому файлу с записанными NMEA-предложениями.';

  @override
  String get tooltipFeedInterval =>
      'Задержка между двумя кадрами при воспроизведении файла.';

  @override
  String get tooltipFeedLoop =>
      'Начинает воспроизведение файла заново при достижении конца.';

  @override
  String get tooltipFeedSpeed =>
      'Множитель скорости воспроизведения (1x = реальное время).';

  @override
  String get tooltipFeedSerialPort =>
      'Последовательный порт AIS-приёмника (например, COM3 или /dev/ttyUSB0).';

  @override
  String get tooltipFeedBaudRate =>
      'Скорость в бодах для связи с последовательным AIS-приёмником.';

  @override
  String get tooltipFeedRtlDevice =>
      'RTL-SDR-приёмник, используемый для приёма AIS на УКВ.';

  @override
  String get tooltipFeedRtlAutoGain =>
      'Позволяет тюнеру автоматически регулировать усиление. Рекомендуется для большинства настроек.';

  @override
  String get tooltipFeedRtlGain =>
      'Фиксированное усиление тюнера в децибелах, используемое при выключенном автоматическом усилении.';

  @override
  String get tooltipFeedRtlChannels =>
      'Какие УКВ AIS-каналы декодировать: A (161,975 МГц), B (162,025 МГц) или оба.';

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
  String get statsChannelOccupancy => 'Загрузка каналов';

  @override
  String get statsChannelA => 'Канал A · 161,975 МГц';

  @override
  String get statsChannelB => 'Канал B · 162,025 МГц';

  @override
  String get statsChannelOther => 'Другое';

  @override
  String get statsChannelNoData => 'Данные по каналам отсутствуют';

  @override
  String statsChannelPercent(Object percent) => '${percent} %';

  @override
  String statsChannelRate(Object rate) => '${rate}/s';
}
