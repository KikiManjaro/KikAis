import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feed_def.dart';
import 'forwarder_service.dart';
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

  bool mapClusterEnabled = true;
  bool sendToMap = false;
  bool decodeEnabled = true;
  bool validateChecksum = true;
  AppTheme appTheme = AppTheme.dark;

  /// Empty string means "auto" (follow the current theme).
  String basemapId = '';
  bool showTrails = true;
  bool showVectors = true;

  List<TargetConfig> targets = [];
  final Map<String, bool> feedEnabled = {};
  List<FeedDef> customFeeds = [];

  void setTheme(AppTheme theme) {
    if (appTheme == theme) return;
    appTheme = theme;
    notifyListeners();
    save();
  }

  void setBasemap(String id) {
    if (basemapId == id) return;
    basemapId = id;
    notifyListeners();
    save();
  }

  void setShowTrails(bool value) {
    if (showTrails == value) return;
    showTrails = value;
    notifyListeners();
    save();
  }

  void setShowVectors(bool value) {
    if (showVectors == value) return;
    showVectors = value;
    notifyListeners();
    save();
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
          enabled: true,
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

    notifyListeners();
  }

  ForwardProtocol _legacyProtocol(String? name) {
    if (name == null) return ForwardProtocol.udpServer;
    return ForwardProtocol.values.firstWhere(
      (p) => p.name == name,
      orElse: () => ForwardProtocol.udpServer,
    );
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
  }
}
