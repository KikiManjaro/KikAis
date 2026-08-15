import 'dart:async';

import 'package:auto_updater/auto_updater.dart';
import 'package:flutter/foundation.dart';

/// Exposes the auto-updater state to the UI: whether a newer version exists,
/// and lets the user trigger a manual check / launch the update.
///
/// On the installed app the plugin (WinSparkle) handles the download and the
/// restart-and-install. The portable self-extracting exe runs from a temporary
/// directory, so auto-update is disabled there ([updatesSupported] is false).
class UpdateNotifier extends ChangeNotifier with UpdaterListener {
  /// Hard ceiling for every startup call. Startup must never be blocked by the
  /// updater plugin (it talks to a remote appcast and runs on a native thread,
  /// which can hang or crash); [main] awaits [initialize] before showing UI.
  static const Duration _startupTimeout = Duration(seconds: 3);

  bool _updatesSupported = false;
  bool _feedSet = false;
  bool _checking = false;
  bool _updateAvailable = false;
  bool _updateDownloaded = false;
  String? _availableVersion;
  String? _lastError;

  bool get updatesSupported => _updatesSupported;
  bool get checking => _checking;
  bool get updateAvailable => _updateAvailable;
  bool get updateDownloaded => _updateDownloaded;
  String? get availableVersion => _availableVersion;
  String? get lastError => _lastError;

  /// Runs [future], but returns early after [_startupTimeout] so a hung plugin
  /// call can never stall the app (runApp is awaited right after this).
  Future<T?> _withTimeout<T>(Future<T> future) async {
    try {
      return await future.timeout(_startupTimeout);
    } catch (_) {
      // Timeout or plugin error: updates are best-effort, never fatal.
      return null;
    }
  }

  /// Sets the appcast feed URL, schedules the hourly background check and
  /// runs one immediately. Called once at startup.
  Future<void> initialize(String feedUrl, {required bool supported}) async {
    _updatesSupported = supported;
    if (!supported) return;
    await _withTimeout(autoUpdater.setFeedURL(feedUrl));
    _feedSet = true;
    await _withTimeout(autoUpdater.setScheduledCheckInterval(3600));
    await checkForUpdates(inBackground: true);
  }

  /// Checks for a newer version. In the foreground ([inBackground] false) the
  /// platform UI is shown and the update download/install starts if available.
  Future<void> checkForUpdates({bool inBackground = false}) async {
    if (!_updatesSupported || !_feedSet) return;
    _checking = true;
    _lastError = null;
    notifyListeners();
    try {
      await autoUpdater
          .checkForUpdates(inBackground: inBackground)
          .timeout(_startupTimeout);
    } catch (e) {
      _lastError = '$e';
    } finally {
      _checking = false;
      notifyListeners();
    }
  }

  @override
  void onUpdaterCheckingForUpdate(Appcast? appcast) {
    _checking = true;
    notifyListeners();
  }

  @override
  void onUpdaterUpdateAvailable(AppcastItem? item) {
    _updateAvailable = true;
    _availableVersion =
        item?.displayVersionString ?? item?.versionString ?? item?.title;
    _checking = false;
    notifyListeners();
  }

  @override
  void onUpdaterUpdateNotAvailable(UpdaterError? error) {
    _updateAvailable = false;
    _updateDownloaded = false;
    _checking = false;
    notifyListeners();
  }

  @override
  void onUpdaterUpdateDownloaded(AppcastItem? item) {
    _updateDownloaded = true;
    notifyListeners();
  }

  @override
  void onUpdaterError(UpdaterError? error) {
    _lastError = error?.message;
    _checking = false;
    notifyListeners();
  }

  @override
  void onUpdaterBeforeQuitForUpdate(AppcastItem? item) {
    // The app is about to quit to apply the update.
  }
}
