import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ais/ais_decoder.dart' show NmeaFormat;
import 'feed_def.dart';
import 'forwarder_service.dart';
import 'sim_fleet.dart';
import 'target_config.dart';
import 'themes.dart';

class AppSettings extends ChangeNotifier {
  static const _kHost = 'targetHost';
  static const _kPort = 'targetPort';
  static const _kProtocol = 'protocol';
  static const _kTargets = 'targets';
  static const _kCluster = 'mapClusterEnabled';
  static const _kSendToMap = 'sendToMap';
  static const _kDecodeEnabled = 'decodeEnabled';
  static const _kValidateChecksum = 'validateChecksum';
  static const _kTheme = 'theme';
  static const _kBasemap = 'basemap';
  static const _kShowTrails = 'showTrails';
  static const _kShowVectors = 'showVectors';
  static const _kCustomFeeds = 'customFeeds';
  static const _kFeedPrefix = 'feedEnabled.';
  static const _kSimulation = 'simulation';
  static const _kImportFormat = 'nmeaImportFormat';
  static const _kImportTagSource = 'nmeaImportTagSource';
  static const _kLocale = 'locale';
  static const _kClassicWebSdr = 'classicWebSdrAudio';

  bool mapClusterEnabled = true;
  bool sendToMap = false;
  bool decodeEnabled = true;
  bool validateChecksum = true;
  AppTheme appTheme = AppTheme.dark;

  /// The ISO 639-1 language code of the selected UI language, or `null` to
  /// follow the operating system language. See docs/i18n.md.
  String? localeCode;

  /// Empty string means "auto" (follow the current theme).
  String basemapId = '';
  bool showTrails = true;
  bool showVectors = true;
  bool enableClassicWebSdrAudio = true;

  List<TargetConfig> targets = [];
  final Map<String, bool> feedEnabled = {};
  List<FeedDef> customFeeds = [];
  SimFleetConfig simConfig = SimFleetConfig();

  /// How frames are normalized when received (all sources: network, file,
  /// serial and simulation).
  NmeaFormat nmeaImportFormat = NmeaFormat.passthrough;

  /// Source id used when [nmeaImportFormat] is [NmeaFormat.tag].
  String nmeaImportTagSource = 'KIKAIS';

  void setImportFormat(NmeaFormat format, String tagSource) {
    if (nmeaImportFormat == format && nmeaImportTagSource == tagSource) {
      return;
    }
    nmeaImportFormat = format;
    nmeaImportTagSource = tagSource;
    notifyListeners();
    save();
  }

  void setTheme(AppTheme theme) {
    if (appTheme == theme) return;
    appTheme = theme;
    notifyListeners();
    saveTheme(theme);
  }

  /// Sets the UI language ([localeCode] is an ISO 639-1 code, `null` = system).
  void setLocale(String? code) {
    if (localeCode == code) return;
    localeCode = code;
    notifyListeners();
    saveLocale(code);
  }

  void setBasemap(String id) {
    if (basemapId == id) return;
    basemapId = id;
    notifyListeners();
    saveBasemap(id);
  }

  void setShowTrails(bool value) {
    if (showTrails == value) return;
    showTrails = value;
    notifyListeners();
    saveShowTrails(value);
  }

  void setShowVectors(bool value) {
    if (showVectors == value) return;
    showVectors = value;
    notifyListeners();
    saveShowVectors(value);
  }

  void setClassicWebSdrAudio(bool value) {
    if (enableClassicWebSdrAudio == value) return;
    enableClassicWebSdrAudio = value;
    notifyListeners();
    saveClassicWebSdrAudio(value);
  }

  void setTargets(List<TargetConfig> value) {
    if (identical(targets, value)) return;
    targets = value;
    notifyListeners();
    saveTargets(value);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    mapClusterEnabled = prefs.getBool(_kCluster) ?? true;
    sendToMap = prefs.getBool(_kSendToMap) ?? false;
    decodeEnabled = prefs.getBool(_kDecodeEnabled) ?? true;
    validateChecksum = prefs.getBool(_kValidateChecksum) ?? true;
    final themeName = prefs.getString(_kTheme);
    if (themeName != null) {
      appTheme = AppTheme.values.firstWhere(
        (t) => t.name == themeName,
        orElse: () => AppTheme.dark,
      );
    }
    basemapId = prefs.getString(_kBasemap) ?? '';
    showTrails = prefs.getBool(_kShowTrails) ?? true;
    showVectors = prefs.getBool(_kShowVectors) ?? true;
    enableClassicWebSdrAudio = prefs.getBool(_kClassicWebSdr) ?? true;

    final rawTargets = prefs.getString(_kTargets);
    if (rawTargets != null && rawTargets.isNotEmpty) {
      targets = (jsonDecode(rawTargets) as List)
          .map((e) => TargetConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (prefs.getString(_kHost) != null) {
      targets = [
        TargetConfig(
          id: TargetConfig.newId(),
          name: 'Default',
          protocol: _legacyProtocol(prefs.getString(_kProtocol)),
          host: prefs.getString(_kHost) ?? '127.0.0.1',
          port: prefs.getInt(_kPort) ?? 33333,
          enabled: true,
        ),
      ];
    } else {
      targets = [
        TargetConfig(
          id: TargetConfig.newId(),
          name: 'Default',
          protocol: ForwardProtocol.udpServer,
          host: '127.0.0.1',
          port: 33333,
          enabled: false,
        ),
      ];
    }

    feedEnabled
      ..clear()
      ..addAll({
        for (final k in prefs.getKeys().where((k) => k.startsWith(_kFeedPrefix)))
          k.substring(_kFeedPrefix.length): prefs.getBool(k) ?? false,
      });

    final raw = prefs.getString(_kCustomFeeds);
    customFeeds = raw == null
        ? []
        : (jsonDecode(raw) as List)
            .map((e) => FeedDef.fromJson(e as Map<String, dynamic>))
            .toList();

    final simRaw = prefs.getString(_kSimulation);
    if (simRaw != null && simRaw.isNotEmpty) {
      simConfig =
          SimFleetConfig.fromJson(jsonDecode(simRaw) as Map<String, dynamic>);
    }

    nmeaImportFormat = NmeaFormat.values.firstWhere(
      (f) => f.name == prefs.getString(_kImportFormat),
      orElse: () => NmeaFormat.passthrough,
    );
    nmeaImportTagSource = prefs.getString(_kImportTagSource) ?? 'KIKAIS';
    localeCode = prefs.getString(_kLocale);

    notifyListeners();
  }

  ForwardProtocol _legacyProtocol(String? name) {
    if (name == null) return ForwardProtocol.udpServer;
    return ForwardProtocol.values.firstWhere(
      (p) => p.name == name,
      orElse: () => ForwardProtocol.udpServer,
    );
  }

  /// Persists only the enabled state of a single feed. Toggling a feed from
  /// the UI is a hot path: a full [save] rewrites every preference, and on
  /// Windows each write is synchronous disk I/O on the UI isolate, which
  /// visibly stalls the frame.
  Future<void> saveFeedEnabled(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kFeedPrefix + key, value);
  }

  Future<void> saveTheme(AppTheme value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTheme, value.name);
  }

  Future<void> saveLocale(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove(_kLocale);
    } else {
      await prefs.setString(_kLocale, value);
    }
  }

  Future<void> saveBasemap(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kBasemap, value);
  }

  Future<void> saveShowTrails(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kShowTrails, value);
  }

  Future<void> saveShowVectors(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kShowVectors, value);
  }

  Future<void> saveClassicWebSdrAudio(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kClassicWebSdr, value);
  }

  Future<void> saveMapClusterEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCluster, value);
  }

  Future<void> saveSendToMap(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSendToMap, value);
  }

  Future<void> saveTargets(List<TargetConfig> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kTargets,
      jsonEncode(value.map((t) => t.toJson()).toList()),
    );
  }

  Future<void> saveSimConfig(SimFleetConfig value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSimulation, jsonEncode(value.toJson()));
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCluster, mapClusterEnabled);
    await prefs.setBool(_kSendToMap, sendToMap);
    await prefs.setBool(_kDecodeEnabled, decodeEnabled);
    await prefs.setBool(_kValidateChecksum, validateChecksum);
    await prefs.setString(_kTheme, appTheme.name);
    await prefs.setString(_kBasemap, basemapId);
    await prefs.setBool(_kShowTrails, showTrails);
    await prefs.setBool(_kShowVectors, showVectors);
    await prefs.setBool(_kClassicWebSdr, enableClassicWebSdrAudio);
    await prefs.setString(
      _kTargets,
      jsonEncode(targets.map((t) => t.toJson()).toList()),
    );
    for (final e in feedEnabled.entries) {
      await prefs.setBool(_kFeedPrefix + e.key, e.value);
    }
    await prefs.setString(
      _kCustomFeeds,
      jsonEncode(customFeeds.map((f) => f.toJson()).toList()),
    );
    await prefs.setString(_kSimulation, jsonEncode(simConfig.toJson()));
    await prefs.setString(_kImportFormat, nmeaImportFormat.name);
    await prefs.setString(_kImportTagSource, nmeaImportTagSource);
    if (localeCode == null) {
      await prefs.remove(_kLocale);
    } else {
      await prefs.setString(_kLocale, localeCode!);
    }
  }
}
