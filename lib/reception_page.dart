import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'ais/ais_decoder.dart'
    show NmeaFormat, NmeaTagBlock, buildTagBlock, msSinceUtcMidnight;
import 'app_settings.dart';
import 'boat_animation.dart';
import 'boatmanager.dart';
import 'feed_def.dart';
import 'file_feed_player.dart';
import 'forwarder_service.dart';
import 'host_input_formatter.dart';
import 'l10n_ext.dart';
import 'labels.dart';
import 'message_stats.dart';
import 'port_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sdr/ais_catcher_feed_player.dart';
import 'sdr/ais_catcher_process.dart';
import 'sdr/rtlsdr_device.dart';
import 'serial_feed_player.dart';
import 'simulator_service.dart';
import 'widgets.dart';

/// A feed is considered "receiving" while a frame arrived within this window.
const Duration feedStaleAfter = Duration(seconds: 10);

/// Key of the virtual "Simulation" feed shown alongside the network feeds.
const String kSimulationFeedKey = 'Simulation';

enum FeedDotColor { grey, red, orange, green }

/// Determines the feed status dot color.
///
/// - red: a connection problem occurred
/// - green: connected and receiving AIS frames recently
/// - orange: connecting, or connected but no (fresh) frames
/// - grey: not running
FeedDotColor feedDotColor(FeedStatus? status, DateTime now) {
  if (status == null) return FeedDotColor.grey;
  if (status.error != null) return FeedDotColor.red;
  if (!status.connected) {
    return status.connecting ? FeedDotColor.orange : FeedDotColor.grey;
  }
  final last = status.lastMessageAt;
  final fresh = last != null && now.difference(last) < feedStaleAfter;
  return fresh ? FeedDotColor.green : FeedDotColor.orange;
}

/// Extracts the AIS channel (A, B, or null) from a raw NMEA sentence.
///
/// The channel is the fourth comma-separated field after the `!` prefix
/// in `!AIVDM,1,1,,A,<payload>,0*<checksum>`.
String? _extractChannel(String sentence) {
  final bang = sentence.indexOf('!');
  if (bang < 0) return null;
  var idx = bang;
  for (var i = 0; i < 4; i++) {
    idx = sentence.indexOf(',', idx + 1);
    if (idx < 0) return null;
  }
  final end = sentence.indexOf(',', idx + 1);
  if (end < 0) return null;
  final ch = sentence.substring(idx + 1, end);
  return ch.isEmpty ? null : ch;
}

/// Reception page: AIS sources (feeds), the connection log and the global
/// start/stop. Sending is handled by the separate Send page.
class ReceptionPage extends StatefulWidget {
  final BoatAnimationController boat;
  final ValueNotifier<bool> running;

  const ReceptionPage(this.boat, {required this.running, super.key});

  @override
  State<ReceptionPage> createState() => ReceptionPageState();
}

class ReceptionPageState extends State<ReceptionPage> {
  static const int maxLogEntries = 2000;

  final ScrollController _scrollController = ScrollController();
  late ForwarderService forwarderService;
  late SimulatorService sim;

  /// Log lines waiting to be flushed to [logEntries] in a single rebuild.
  final List<LogEntry> _pendingLogs = [];
  static const Duration _logFlushDelay = Duration(milliseconds: 50);
  Timer? _logFlushTimer;

  final List<LogEntry> logEntries = [];
  final Map<String, bool> feedEnabled = {};
  final ValueNotifier<int> _statusTick = ValueNotifier(0);
  Timer? _statusTimer;
  List<FeedDef> _customFeeds = [];

  /// Built feed tiles, keyed by feed key (the simulation tile uses
  /// [kSimulationFeedKey]). A tile is only rebuilt when its checkbox state
  /// changes; the status dot refreshes itself via [_FeedStatusDot], so the
  /// card never rebuilds on status ticks or incoming frames.
  final Map<String, Widget> _tilesCache = {};
  final Map<String, bool> _tilesEnabledCache = {};

  /// Active file players, keyed by feed.key. Created lazily when a file feed
  /// is enabled, kept alive so re-enabling replays instantly.
  final Map<String, FileFeedPlayer> _filePlayers = {};

  /// Active serial players, keyed by feed.key. Created lazily when a serial
  /// feed is enabled, kept alive so re-enabling reconnects instantly.
  final Map<String, SerialFeedPlayer> _serialPlayers = {};

  /// Active RTL-SDR players, keyed by feed.key.
  final Map<String, AisCatcherFeedPlayer> _rtlSdrPlayers = {};

  bool isRunning = false;
  bool _validateChecksum = true;
  late NmeaFormat _importFormat;
  late String _importTagSource;
  final _importTagSourceC = TextEditingController();

  late BoatManager boatManager;
  late AppSettings settings;
  late MessageStats stats;

  @override
  void initState() {
    super.initState();
    boatManager = context.read<BoatManager>();
    settings = context.read<AppSettings>();
    stats = context.read<MessageStats>();
    _importFormat = settings.nmeaImportFormat;
    _importTagSource = settings.nmeaImportTagSource;
    _importTagSourceC.text = _importTagSource;

    forwarderService = ForwarderService(
      onLog: (message, starter, name) {
        final (_, sentence) = NmeaTagBlock.split(message);
        final isAis = sentence.startsWith('!');
        if (isAis) {
          stats.recordReceived(name, channel: _extractChannel(sentence));
        }
        // Batched: a single setState per flush instead of one per frame, so
        // high-volume feeds (e.g. a large simulated fleet) don't stall the UI.
        _pendingLogs.add(
          LogEntry(
            message: message,
            starter: starter,
            name: name,
            time: DateTime.now(),
          ),
        );
        _logFlushTimer ??= Timer(_logFlushDelay, _flushLogs);
        if (boatManager.decodeEnabled && isAis) {
          boatManager.processMessage(sentence, feed: name);
        }
      },
      onStatus: _queueLog,
    );
    forwarderService.setTargets(settings.targets);
    forwarderService.importFormat = settings.nmeaImportFormat;
    forwarderService.importTagSourceId = settings.nmeaImportTagSource;

    sim = SimulatorService(config: settings.simConfig);
    sim.onSentence = (nmea) =>
        forwarderService.ingest('Simulation', 'SIM', nmea);

    _customFeeds = List.of(settings.customFeeds);
    feedEnabled
      ..clear()
      ..addAll({for (final f in kFeedDefs) f.key: false})
      ..addAll({for (final f in _customFeeds) f.key: false})
      ..addAll(settings.feedEnabled);
    _validateChecksum = settings.validateChecksum;
    // BoatManager setters notify listeners; deferring them to the first
    // post-frame avoids calling notifyListeners() while the widget tree is
    // still building (which throws an assertion and disrupts the first frame).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (boatManager.validateChecksum != settings.validateChecksum) {
        boatManager.setValidateChecksum(settings.validateChecksum);
      }
      if (boatManager.decodeEnabled != settings.decodeEnabled) {
        boatManager.setDecodeEnabled(settings.decodeEnabled);
      }
      if (boatManager.sendToMap != settings.sendToMap) {
        boatManager.setSendToMap(settings.sendToMap);
      }
    });

    // The feed tiles are cached and their status dots listen to [_statusTick]
    // on their own, so the card only rebuilds on explicit state changes
    // (toggles, add/remove) instead of on every status update or every second.
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isRunning) _statusTick.value++;
    });
  }

  List<FeedDef> get _allFeeds => [...kFeedDefs, ..._customFeeds];

  /// The simulation service, exposed to the Simulation tab.
  SimulatorService get simService => sim;

  void _syncFeedSettings() {
    settings.customFeeds = List.of(_customFeeds);
    settings.feedEnabled
      ..clear()
      ..addAll(feedEnabled);
    settings.save();
  }

  /// Queues a structured status message for the next log flush (used by the
  /// forwarder and the RTL-SDR feed player).
  void _queueLog(LogMessage status) {
    _pendingLogs.add(
      LogEntry(
        message: status.fallback,
        status: status,
        time: DateTime.now(),
      ),
    );
    _logFlushTimer ??= Timer(_logFlushDelay, _flushLogs);
  }

  void _flushLogs() {
    _logFlushTimer = null;
    if (_pendingLogs.isEmpty) return;
    setState(() {
      logEntries.addAll(_pendingLogs);
      _pendingLogs.clear();
      if (logEntries.length > maxLogEntries) {
        logEntries.removeRange(0, logEntries.length - maxLogEntries);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void startForwarder() async {
    await forwarderService.start();
    setState(() => isRunning = true);
    widget.running.value = true;

    for (final feed in _allFeeds) {
      if (feedEnabled[feed.key] ?? false) {
        if (feed.type == FeedType.network) {
          await forwarderService.addFeed(
            feed.displayName,
            feed.key,
            feed.host,
            feed.port,
            header: feed.header,
          );
        } else if (feed.type == FeedType.file) {
          await _startFileFeed(feed);
        } else if (feed.type == FeedType.serial) {
          await _startSerialFeed(feed);
        } else {
          await _startRtlSdrFeed(feed);
        }
      }
    }

    if (feedEnabled[kSimulationFeedKey] ?? false) {
      sim.start();
    }
  }

  void stopForwarder() async {
    if (sim.isRunning) {
      sim.stop();
    }
    for (final feed in _allFeeds) {
      if (feed.type == FeedType.file) {
        _stopFileFeed(feed);
      } else if (feed.type == FeedType.serial) {
        _stopSerialFeed(feed);
      } else if (feed.type == FeedType.rtlsdr) {
        _stopRtlSdrFeed(feed);
      }
    }
    await forwarderService.stop();
    setState(() => isRunning = false);
    widget.running.value = false;
  }

  Future<void> toggleSimFeed(bool value) async {
    setState(() => feedEnabled[kSimulationFeedKey] = value);
    settings.feedEnabled[kSimulationFeedKey] = value;
    settings.saveFeedEnabled(kSimulationFeedKey, value);

    if (!isRunning) return;

    if (value) {
      sim.start();
    } else {
      sim.stop();
    }
  }

  /// Status of the virtual simulation feed, derived from the simulator so the
  /// tile reuses the same dot semantics as the network feeds.
  FeedStatus _simFeedStatus() {
    if (!sim.isRunning) return const FeedStatus();
    return FeedStatus(
      connected: true,
      messageCount: sim.emittedCount,
      lastMessageAt: sim.lastEmitAt,
    );
  }

  /// Returns the existing player for a file feed or creates and wires one.
  FileFeedPlayer _playerFor(FeedDef feed) {
    final existing = _filePlayers[feed.key];
    if (existing != null) return existing;

    final player = FileFeedPlayer(
      path: feed.path ?? '',
      intervalMs: feed.intervalMs,
      loop: feed.loop,
      useTimestamps: feed.useTimestamps,
      speed: feed.speed,
    );
    player.onSentence = (nmea) =>
        forwarderService.ingest(feed.displayName, feed.key, nmea);
    player.addListener(() {
      forwarderService.setFeedStatus(feed.displayName, player.status);
    });
    _filePlayers[feed.key] = player;
    return player;
  }

  /// Loads the file and starts replaying it through the pipeline. On load
  /// failure the feed is left stopped with an error status.
  Future<void> _startFileFeed(FeedDef feed) async {
    final player = _playerFor(feed);
    await player.load();
    forwarderService.setFeedStatus(feed.displayName, player.status);
    if (player.error == null && !player.isRunning) {
      player.start();
    }
  }

  void _stopFileFeed(FeedDef feed) {
    _filePlayers[feed.key]?.stop();
    forwarderService.removeFeedStatus(feed.displayName);
  }

  /// Returns the existing player for a serial feed or creates and wires one.
  SerialFeedPlayer _playerForSerial(FeedDef feed) {
    final existing = _serialPlayers[feed.key];
    if (existing != null) return existing;

    final player = SerialFeedPlayer(
      address: feed.serialPort ?? '',
      baudRate: feed.baudRate,
    );
    player.onSentence = (nmea) =>
        forwarderService.ingest(feed.displayName, feed.key, nmea);
    player.addListener(() {
      forwarderService.setFeedStatus(feed.displayName, player.status);
    });
    _serialPlayers[feed.key] = player;
    return player;
  }

  /// Opens the serial port and starts reading. On connect failure the feed is
  /// left stopped with an error status.
  Future<void> _startSerialFeed(FeedDef feed) async {
    final player = _playerForSerial(feed);
    await player.connect();
    forwarderService.setFeedStatus(feed.displayName, player.status);
  }

  Future<void> _stopSerialFeed(FeedDef feed) async {
    await _serialPlayers[feed.key]?.disconnect();
    forwarderService.removeFeedStatus(feed.displayName);
  }

  /// Returns the existing player for an RTL-SDR feed or creates and wires one.
  AisCatcherFeedPlayer _playerForRtlSdr(FeedDef feed) {
    final existing = _rtlSdrPlayers[feed.key];
    if (existing != null) return existing;

    final player = AisCatcherFeedPlayer(
      config: AisCatcherFeedConfig(
        deviceIndex: feed.deviceIndex,
        gainDb: feed.gainDb,
        autoGain: feed.gainDb == null,
        sampleRate: feed.sampleRate,
        useChannel1: feed.useChannel1,
        useChannel2: feed.useChannel2,
      ),
    );
    player.onSentence = (nmea) =>
        forwarderService.ingest(feed.displayName, feed.key, nmea);
    player.onStatus = _queueLog;
    player.addListener(() {
      forwarderService.setFeedStatus(feed.displayName, player.status);
    });
    _rtlSdrPlayers[feed.key] = player;
    return player;
  }

  /// Opens the dongle and starts streaming. On connect failure the feed is
  /// left stopped with an error status.
  Future<void> _startRtlSdrFeed(FeedDef feed) async {
    // Check if ais-catcher is available; if not, show the setup dialog.
    if (AisCatcherProcess.findExecutable() == null) {
      final setupOk = await _showAisCatcherSetupDialog();
      if (!setupOk) return;
    }
    final player = _playerForRtlSdr(feed);
    await player.connect();
    forwarderService.setFeedStatus(feed.displayName, player.status);
  }

  /// Shows a dialog asking the user to set up AIS-catcher. Returns true when
  /// a valid executable path is resolved (auto-download, custom path, or cached).
  Future<bool> _showAisCatcherSetupDialog() async {
    double? progress;
    String progressText = '';
    bool downloading = false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('AIS-catcher'),
          content: SizedBox(
            width: 460,
            child: downloading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(progressText),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 8),
                      Text(
                        progress != null
                            ? '${(progress! * 100).toStringAsFixed(0)}%'
                            : '',
                        style: Theme.of(ctx).textTheme.bodySmall,
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.aisCatcherNotFound),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () async {
                                setDialogState(() {
                                  downloading = true;
                                  progressText = context
                                      .l10n.aisCatcherDownloading;
                                });
                                try {
                                  await AisCatcherProcess.ensureAvailable(
                                    onProgress: (p, speed) {
                                      setDialogState(() {
                                        progress = p;
                                        progressText =
                                            '${context.l10n.aisCatcherDownloading} ($speed)';
                                      });
                                    },
                                  );
                                  if (ctx.mounted) Navigator.of(ctx).pop(true);
                                } catch (e) {
                                  if (ctx.mounted) {
                                    setDialogState(() {
                                      downloading = false;
                                    });
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(content: Text('$e')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.download),
                              label:
                                  Text(context.l10n.aisCatcherDownload),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final file = await openFile(
                                  acceptedTypeGroups: [
                                    XTypeGroup(
                                      label: 'ais-catcher',
                                      extensions: ['exe'],
                                    ),
                                  ],
                                );
                                if (file == null) return;
                                final ok = await AisCatcherProcess
                                    .setCustomPath(file.path);
                                if (!ok) {
                                  if (ctx.mounted) {
                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          ctx
                                              .l10n.aisCatcherInvalidPath,
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }
                                if (ctx.mounted) Navigator.of(ctx).pop(true);
                              },
                              icon: const Icon(Icons.folder_open),
                              label: Text(context.l10n.aisCatcherChoosePath),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(context.l10n.aisCatcherCancel),
            ),
            TextButton(
              onPressed: () => launchUrl(
                Uri.parse(
                  'https://github.com/jvde-github/AIS-catcher/releases',
                ),
              ),
              child: Text(context.l10n.aisCatcherManualDownload),
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }

  Future<void> _stopRtlSdrFeed(FeedDef feed) async {
    await _rtlSdrPlayers[feed.key]?.disconnect();
    forwarderService.removeFeedStatus(feed.displayName);
  }

  void toggleFeed(FeedDef feed, bool value) async {
    setState(() => feedEnabled[feed.key] = value);
    settings.feedEnabled[feed.key] = value;
    settings.saveFeedEnabled(feed.key, value);

    if (!isRunning) return;

    if (feed.type == FeedType.network) {
      if (value) {
        await forwarderService.addFeed(
          feed.displayName,
          feed.key,
          feed.host,
          feed.port,
          header: feed.header,
        );
      } else {
        await forwarderService.removeFeed(feed.displayName);
      }
    } else if (feed.type == FeedType.file) {
      if (value) {
        await _startFileFeed(feed);
      } else {
        _stopFileFeed(feed);
      }
    } else if (feed.type == FeedType.serial) {
      if (value) {
        await _startSerialFeed(feed);
      } else {
        await _stopSerialFeed(feed);
      }
    } else {
      if (value) {
        await _startRtlSdrFeed(feed);
      } else {
        await _stopRtlSdrFeed(feed);
      }
    }
  }

  Future<void> _showAddFeedDialog() async {
    final feed = await showDialog<FeedDef>(
      context: context,
      builder: (_) => const _AddFeedDialog(),
    );

    if (feed == null || !mounted) return;

    setState(() {
      _customFeeds.add(feed);
      feedEnabled[feed.key] = false;
    });
    _syncFeedSettings();

    if (isRunning) {
      if (feed.type == FeedType.network) {
        await forwarderService.addFeed(
          feed.displayName,
          feed.key,
          feed.host,
          feed.port,
          header: feed.header,
        );
      } else if (feed.type == FeedType.file) {
        await _startFileFeed(feed);
      } else if (feed.type == FeedType.serial) {
        await _startSerialFeed(feed);
      } else {
        await _startRtlSdrFeed(feed);
      }
    }
  }

  Future<void> _removeCustomFeed(FeedDef feed) async {
    if (feed.type == FeedType.file) {
      _stopFileFeed(feed);
    } else if (feed.type == FeedType.serial) {
      await _stopSerialFeed(feed);
    } else if (feed.type == FeedType.rtlsdr) {
      await _stopRtlSdrFeed(feed);
    } else if (isRunning) {
      await forwarderService.removeFeed(feed.displayName);
    }
    setState(() {
      _customFeeds.remove(feed);
      feedEnabled.remove(feed.key);
    });
    _tilesCache.remove(feed.key);
    _tilesEnabledCache.remove(feed.key);
    _filePlayers.remove(feed.key)?.dispose();
    _serialPlayers.remove(feed.key)?.dispose();
    _rtlSdrPlayers.remove(feed.key)?.dispose();
    _syncFeedSettings();
  }

  /// Sends a raw NMEA sentence to all enabled targets (used by the AIS
  /// message editor page) and logs it with the "KikAis" source.
  void sendRaw(String nmea) {
    forwarderService.sendRaw(nmea);
    setState(() {
      logEntries.add(
        LogEntry(
          message: nmea.trim(),
          starter: "KikAis",
          name: null,
          time: DateTime.now(),
        ),
      );
      if (logEntries.length > maxLogEntries) {
        logEntries.removeRange(0, logEntries.length - maxLogEntries);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget feedIcon(FeedDef feed) {
    if (feed.type == FeedType.serial) {
      return const Icon(Icons.settings_ethernet, size: 30);
    }
    if (feed.type == FeedType.rtlsdr) {
      return const Icon(Icons.settings_input_antenna, size: 30);
    }
    if (feed.type == FeedType.file) {
      return const Icon(Icons.description, size: 30);
    }
    if (feed.key == "Kikistream.io") {
      return const Icon(Icons.public, size: 30);
    }
    if (feed.key.length == 2) {
      return CountryFlag.fromCountryCode(
        feed.key,
        theme: const ImageTheme(width: 30, height: 18),
      );
    }
    return const Icon(Icons.directions_boat, size: 30);
  }

  /// Returns the cached simulation tile, rebuilding it only when the checkbox
  /// state changes.
  Widget _simTileCached() {
    final enabled = feedEnabled[kSimulationFeedKey] ?? false;
    final cached = _tilesCache[kSimulationFeedKey];
    if (cached != null && _tilesEnabledCache[kSimulationFeedKey] == enabled) {
      return cached;
    }
    final tile = _buildSimFeedTile();
    _tilesCache[kSimulationFeedKey] = tile;
    _tilesEnabledCache[kSimulationFeedKey] = enabled;
    return tile;
  }

  /// Returns the cached tile for [feed], rebuilding it only when its checkbox
  /// state changes.
  Widget _feedTileCached(FeedDef feed) {
    final enabled = feedEnabled[feed.key] ?? false;
    final cached = _tilesCache[feed.key];
    if (cached != null && _tilesEnabledCache[feed.key] == enabled) {
      return cached;
    }
    final tile = _buildFeedTile(feed);
    _tilesCache[feed.key] = tile;
    _tilesEnabledCache[feed.key] = enabled;
    return tile;
  }

  Widget _buildSimFeedTile() {
    return CheckboxListTile(
      dense: true,
      title: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.tabSimulation,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _FeedStatusDot(
            statusSource: sim,
            tick: _statusTick,
            statusOf: _simFeedStatus,
          ),
        ],
      ),
      value: feedEnabled[kSimulationFeedKey] ?? false,
      onChanged: (val) => toggleSimFeed(val ?? false),
      secondary: const Icon(Icons.science, size: 30),
    );
  }

  Widget _buildFeedTile(FeedDef feed) {
    return CheckboxListTile(
      dense: true,
      title: Row(
        children: [
          Expanded(
            child: Text(feed.displayName, overflow: TextOverflow.ellipsis),
          ),
          _FeedStatusDot(
            statusSource: forwarderService.feedStatuses,
            tick: _statusTick,
            statusOf: () =>
                forwarderService.feedStatuses.value[feed.displayName],
          ),
          if (!feed.builtIn)
            HoverTooltip(
              message: context.l10n.tooltipReceptionRemoveSource,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _removeCustomFeed(feed),
              ),
            ),
        ],
      ),
      value: feedEnabled[feed.key] ?? false,
      onChanged: (val) => toggleFeed(feed, val ?? false),
      secondary: feedIcon(feed),
    );
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _statusTick.dispose();
    _tilesCache.clear();
    _tilesEnabledCache.clear();
    _scrollController.dispose();
    _logFlushTimer?.cancel();
    _importTagSourceC.dispose();
    sim.dispose();
    for (final player in _filePlayers.values) {
      player.dispose();
    }
    for (final player in _serialPlayers.values) {
      player.dispose();
    }
    for (final player in _rtlSdrPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }

  Future<void> saveLogs() async {
    const String fileName = 'kikais_logs.txt';
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [
        XTypeGroup(label: context.l10n.textFiles, extensions: ['txt']),
      ],
    );
    if (result == null) {
      return;
    }

    final StringBuffer logBuffer = StringBuffer();
    for (var entry in logEntries) {
      if (entry.starter != null) {
        // Prefix each frame with a NMEA 4.0 tag block carrying the source
        // and the recorded time so it can be replayed chronologically.
        if (entry.message.startsWith('\\')) {
          logBuffer.writeln(entry.message);
        } else {
          final tag = buildTagBlock(
            sourceId: entry.starter!,
            timeMs: msSinceUtcMidnight(entry.time),
          );
          logBuffer.writeln('$tag${entry.message}');
        }
      }
    }
    final Uint8List data = Uint8List.fromList(logBuffer.toString().codeUnits);
    const String mimeType = 'text/plain';
    final XFile textFile = XFile.fromData(
      data,
      mimeType: mimeType,
      name: fileName,
    );
    await textFile.saveTo(result.path);
  }

  Widget _buildStarterWidget(LogEntry entry) {
    if (entry.starter == null) return const SizedBox.shrink();

    if (entry.starter == "KikAis") {
      return const Icon(Icons.send, size: 16, color: Colors.lightBlueAccent);
    }
    if (entry.starter == "Kikistream.io") {
      return const Icon(Icons.public, size: 16);
    }
    if (_serialFeedKeys.contains(entry.starter)) {
      return const Icon(Icons.settings_ethernet, size: 16);
    }
    if (_rtlSdrFeedKeys.contains(entry.starter)) {
      return const Icon(Icons.settings_input_antenna, size: 16);
    }
    if (_fileFeedKeys.contains(entry.starter)) {
      return const Icon(Icons.description, size: 16);
    }
    if (entry.starter!.length == 2) {
      try {
        return CountryFlag.fromCountryCode(
          entry.starter!,
          theme: const ImageTheme(width: 16, height: 10),
        );
      } catch (_) {
        return Text(entry.starter!);
      }
    }
    return const Icon(Icons.directions_boat, size: 16);
  }

  /// Keys of the file-type custom feeds, used to pick a log starter icon.
  Set<String> get _fileFeedKeys => {
    for (final f in _allFeeds)
      if (f.type == FeedType.file) f.key,
  };

  /// Keys of the serial-type custom feeds, used to pick a log starter icon.
  Set<String> get _serialFeedKeys => {
    for (final f in _allFeeds)
      if (f.type == FeedType.serial) f.key,
  };

  /// Keys of the RTL-SDR-type custom feeds, used to pick a log starter icon.
  Set<String> get _rtlSdrFeedKeys => {
    for (final f in _allFeeds)
      if (f.type == FeedType.rtlsdr) f.key,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SectionHeader(
                icon: Icons.rss_feed,
                title: context.l10n.receptionFeeds,
                trailing: HoverTooltip(
                  message: context.l10n.tooltipReceptionAddSource,
                  child: IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: _showAddFeedDialog,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final tiles = <Widget>[
                        _simTileCached(),
                        for (final feed in _allFeeds) _feedTileCached(feed),
                      ];
                      const itemHeight = 48.0;
                      final fits =
                          tiles.length * itemHeight <= constraints.maxHeight;
                      if (fits) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: tiles,
                        );
                      }
                      return ListView.builder(
                        itemCount: tiles.length,
                        itemBuilder: (context, i) => tiles[i],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            HoverTooltip(
              message: context.l10n.tooltipReceptionValidateChecksums,
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                dense: true,
                title: Text(
                  context.l10n.receptionValidateChecksums,
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: AnimatedBuilder(
                  animation: boatManager,
                  builder: (_, _) => Text(
                    context.l10n.receptionDroppedSentences(
                      boatManager.invalidChecksumCount,
                    ),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                value: _validateChecksum,
                onChanged: (v) {
                  setState(() {
                    _validateChecksum = v;
                  });
                  boatManager.setValidateChecksum(v);
                  settings.validateChecksum = v;
                  settings.save();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(
                    context.l10n.receptionImportFormat,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const Spacer(),
                  HoverTooltip(
                    message: context.l10n.tooltipReceptionImportFormat,
                    child: DropdownButton<NmeaFormat>(
                      value: _importFormat,
                      mouseCursor: WidgetStateMouseCursor.clickable,
                      isDense: true,
                      underline: const SizedBox.shrink(),
                      items: [
                        for (final f in NmeaFormat.values)
                          DropdownMenuItem(
                            value: f,
                            child: Text(
                              nmeaFormatLabelLocalized(f, context.l10n),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                      onChanged: (f) {
                        if (f == null) return;
                        setState(() => _importFormat = f);
                        forwarderService.importFormat = f;
                        settings.setImportFormat(f, _importTagSource);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_importFormat == NmeaFormat.tag)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                child: TextField(
                  controller: _importTagSourceC,
                  decoration: InputDecoration(
                    labelText: context.l10n.fieldTagSourceId,
                    isDense: true,
                  ),
                  onChanged: (v) {
                    final source = v.trim().isEmpty ? 'KIKAIS' : v.trim();
                    setState(() => _importTagSource = source);
                    forwarderService.importTagSourceId = source;
                    settings.setImportFormat(_importFormat, source);
                  },
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: HoverTooltip(
                    message: isRunning
                        ? context.l10n.tooltipReceptionStop
                        : context.l10n.tooltipReceptionStart,
                    child: ElevatedButton.icon(
                      key: ValueKey(isRunning),
                      icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                      label: Text(
                        isRunning
                            ? context.l10n.receptionStop
                            : context.l10n.receptionStart,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isRunning ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (isRunning) {
                          stopForwarder();
                          widget.boat.stop();
                        } else {
                          startForwarder();
                          widget.boat.start();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(context.l10n.receptionLogs),
                        const Spacer(),
                        HoverTooltip(
                          message: context.l10n.tooltipReceptionSaveLogs,
                          child: IconButton(
                            icon: const Icon(Icons.save_outlined),
                            iconSize: 18,
                            visualDensity: VisualDensity.compact,
                            onPressed: saveLogs,
                          ),
                        ),
                        HoverTooltip(
                          message: context.l10n.tooltipReceptionClearLogs,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            iconSize: 18,
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              setState(() {
                                logEntries.clear();
                                _scrollController.jumpTo(0);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(right: 14),
                          itemCount: logEntries.length,
                          itemBuilder: (context, index) {
                            final entry = logEntries[index];

                            final text = entry.status != null
                                ? logMessageText(context.l10n, entry.status!)
                                : (entry.name != null
                                      ? "[${entry.name}] ${entry.message}"
                                      : entry.message);

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildStarterWidget(entry),
                                const SizedBox(width: 5),
                                Expanded(child: Text(text)),
                                if (entry.message.startsWith('!'))
                                  CopyIconButton(
                                    text: entry.message,
                                    message: context.l10n.receptionFrameCopied,
                                    padding: EdgeInsets.zero,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The 10x10 status dot of a feed tile. It listens to both the feed's status
/// source and the one-second [tick], so staleness (green fading to orange) and
/// per-frame status updates only repaint this tiny widget instead of rebuilding
/// the whole (cached) tile.
class _FeedStatusDot extends StatelessWidget {
  const _FeedStatusDot({
    required this.statusSource,
    required this.tick,
    required this.statusOf,
  });

  /// Fires whenever the feed's status may have changed.
  final Listenable statusSource;

  /// Ticks once per second so a connected feed goes stale after 10 s.
  final Listenable tick;

  /// Reads the latest status for the feed this dot represents.
  final FeedStatus? Function() statusOf;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([statusSource, tick]),
      builder: (context, _) {
        final color = switch (feedDotColor(statusOf(), DateTime.now())) {
          FeedDotColor.grey => Colors.grey.shade600,
          FeedDotColor.red => Colors.red,
          FeedDotColor.orange => Colors.orange,
          FeedDotColor.green => Colors.green,
        };
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      },
    );
  }
}

class LogEntry {
  final String message;
  final LogMessage? status;
  final String? starter;
  final String? name;
  final DateTime time;

  LogEntry({
    required this.message,
    this.status,
    this.starter,
    this.name,
    required this.time,
  });
}

/// Dialog used to add a custom feed source. The source type (network or
/// file) selects which details are edited. The controllers live in this
/// State so they are disposed together with the dialog route (after its exit
/// animation completes).
class _AddFeedDialog extends StatefulWidget {
  const _AddFeedDialog();

  @override
  State<_AddFeedDialog> createState() => _AddFeedDialogState();
}

class _AddFeedDialogState extends State<_AddFeedDialog> {
  static const List<int> kBaudRates = [4800, 9600, 19200, 38400, 57600, 115200];

  FeedType _type = FeedType.network;
  final _name = TextEditingController();
  final _host = TextEditingController();
  final _port = TextEditingController(text: '3000');
  final _header = TextEditingController();
  final _path = TextEditingController();
  final _interval = TextEditingController(text: '1000');
  final _serialPort = TextEditingController();
  int _baudRate = 38400;
  List<String> _serialPorts = [];
  int _deviceIndex = 0;
  List<RtlSdrDeviceInfo> _rtlSdrDevices = [];
  int? _gainDb;
  bool _autoGain = true;
  final int _sampleRate = 1024000;
  bool _useChannel1 = true;
  bool _useChannel2 = true;
  bool _loop = true;
  bool _useTimestamps = false;
  int _speed = 1;

  @override
  void dispose() {
    _name.dispose();
    _host.dispose();
    _port.dispose();
    _header.dispose();
    _path.dispose();
    _interval.dispose();
    _serialPort.dispose();
    super.dispose();
  }

  /// Refreshes the list of serial ports detected on the system. When the
  /// native library is unavailable (e.g. under `flutter test`) this simply
  /// leaves the manual-entry field visible.
  void _refreshSerialPorts() {
    setState(() => _serialPorts = availableSerialPorts());
  }

  /// Refreshes the list of RTL-SDR dongles detected on the system. Empty when
  /// the drivers are not installed.
  void _refreshRtlSdrDevices() {
    setState(() {
      _rtlSdrDevices = listRtlSdrDevices();
      if (_deviceIndex >= _rtlSdrDevices.length && _rtlSdrDevices.isNotEmpty) {
        _deviceIndex = 0;
      }
    });
  }

  Future<void> _browse() async {
    const typeGroup = XTypeGroup(
      label: 'NMEA / text',
      extensions: ['txt', 'nmea', 'log'],
    );
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null && mounted) {
      setState(() => _path.text = file.path);
    }
  }

  FeedDef? _buildResult() {
    final name = _name.text.trim();
    if (name.isEmpty) return null;
    if (_type == FeedType.network) {
      final host = _host.text.trim();
      if (host.isEmpty) return null;
      final header = _header.text.trim();
      return FeedDef(
        key: name,
        displayName: name,
        type: FeedType.network,
        host: host,
        port: int.tryParse(_port.text) ?? 3000,
        header: header.isEmpty ? null : header,
      );
    }
    if (_type == FeedType.serial) {
      final serialPort = _serialPort.text.trim();
      if (serialPort.isEmpty) return null;
      return FeedDef(
        key: name,
        displayName: name,
        type: FeedType.serial,
        serialPort: serialPort,
        baudRate: _baudRate,
      );
    }
    if (_type == FeedType.rtlsdr) {
      if (_rtlSdrDevices.isEmpty) return null;
      return FeedDef(
        key: name,
        displayName: name,
        type: FeedType.rtlsdr,
        deviceIndex: _deviceIndex,
        gainDb: _autoGain ? null : _gainDb,
        sampleRate: _sampleRate,
        useChannel1: _useChannel1,
        useChannel2: _useChannel2,
      );
    }
    final path = _path.text.trim();
    if (path.isEmpty) return null;
    final interval = (int.tryParse(_interval.text) ?? 1000)
        .clamp(1, 60000)
        .toInt();
    return FeedDef(
      key: name,
      displayName: name,
      type: FeedType.file,
      path: path,
      intervalMs: interval,
      loop: _loop,
      useTimestamps: _useTimestamps,
      speed: _speed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.receptionAddSource),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<FeedType>(
                showSelectedIcon: false,
                style: const ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
                segments: [
                  ButtonSegment(
                    value: FeedType.network,
                    label: Text(context.l10n.receptionNetwork),
                  ),
                  ButtonSegment(
                    value: FeedType.file,
                    label: Text(context.l10n.receptionFile),
                  ),
                  ButtonSegment(
                    value: FeedType.serial,
                    label: Text(context.l10n.receptionSerial),
                  ),
                  ButtonSegment(
                    value: FeedType.rtlsdr,
                    label: Text(context.l10n.receptionRtlSdr),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (s) {
                  setState(() => _type = s.first);
                  if (s.first == FeedType.serial) {
                    _refreshSerialPorts();
                  }
                  if (s.first == FeedType.rtlsdr) {
                    _refreshRtlSdrDevices();
                  }
                },
              ),
              const SizedBox(height: 16),
              HoverTooltip(
                message: context.l10n.tooltipFeedName,
                child: TextField(
                  controller: _name,
                  decoration:
                      InputDecoration(labelText: context.l10n.fieldName),
                ),
              ),
              const SizedBox(height: 12),
              if (_type == FeedType.network) ...[
                HoverTooltip(
                  message: context.l10n.tooltipFeedHost,
                  child: TextField(
                    controller: _host,
                    decoration: InputDecoration(
                      labelText: context.l10n.fieldHost,
                    ),
                    inputFormatters: [HostInputFormatter()],
                  ),
                ),
                const SizedBox(height: 12),
                HoverTooltip(
                  message: context.l10n.tooltipFeedPort,
                  child: TextField(
                    controller: _port,
                    decoration: InputDecoration(
                      labelText: context.l10n.fieldPort,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PortInputFormatter(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                HoverTooltip(
                  message: context.l10n.tooltipFeedHeader,
                  child: TextField(
                    controller: _header,
                    decoration: InputDecoration(
                      labelText: context.l10n.receptionHeaderOptional,
                    ),
                  ),
                ),
              ] else if (_type == FeedType.file) ...[
                Row(
                  children: [
                    Expanded(
                      child: HoverTooltip(
                        message: context.l10n.tooltipFeedFile,
                        child: TextField(
                          controller: _path,
                          decoration: InputDecoration(
                            labelText: context.l10n.fieldFile,
                            hintText: context.l10n.receptionPathOrBrowse,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverTooltip(
                      message: context.l10n.tooltipBrowse,
                      child: IconButton(
                        icon: const Icon(Icons.folder_open),
                        onPressed: _browse,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                HoverTooltip(
                  message: context.l10n.tooltipFeedInterval,
                  child: TextField(
                    controller: _interval,
                    decoration: InputDecoration(
                      labelText: context.l10n.receptionIntervalMs,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    context.l10n.receptionReplayTimestamps,
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    context.l10n.receptionReplayTimestampsHint,
                    style: const TextStyle(fontSize: 11),
                  ),
                  value: _useTimestamps,
                  onChanged: (v) => setState(() => _useTimestamps = v),
                ),
                if (_useTimestamps)
                  Row(
                    children: [
                      Text(
                        context.l10n.receptionSpeed,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Spacer(),
                      HoverTooltip(
                        message: context.l10n.tooltipFeedSpeed,
                        child: DropdownButton<int>(
                          value: _speed,
                          mouseCursor: WidgetStateMouseCursor.clickable,
                          isDense: true,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('×1')),
                            DropdownMenuItem(value: 2, child: Text('×2')),
                            DropdownMenuItem(value: 5, child: Text('×5')),
                            DropdownMenuItem(value: 10, child: Text('×10')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _speed = v);
                          },
                        ),
                      ),
                    ],
                  ),
                HoverTooltip(
                  message: context.l10n.tooltipFeedLoop,
                  child: SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      context.l10n.receptionReplayLoop,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: _loop,
                    onChanged: (v) => setState(() => _loop = v),
                  ),
                ),
              ] else if (_type == FeedType.serial) ...[
                Row(
                  children: [
                    Expanded(
                      child: HoverTooltip(
                        message: context.l10n.tooltipFeedSerialPort,
                        child: TextField(
                          controller: _serialPort,
                          decoration: InputDecoration(
                            labelText: context.l10n.receptionSerialPort,
                            hintText: context.l10n.receptionSerialPortHint,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverTooltip(
                      message: context.l10n.tooltipReceptionSerialPorts,
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshSerialPorts,
                      ),
                    ),
                  ],
                ),
                if (_serialPorts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final p in _serialPorts)
                        ActionChip(
                          label: Text(p),
                          mouseCursor: WidgetStateMouseCursor.clickable,
                          onPressed: () {
                            setState(() => _serialPort.text = p);
                          },
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                HoverTooltip(
                  message: context.l10n.tooltipFeedBaudRate,
                  child: DropdownButtonFormField<int>(
                    initialValue: _baudRate,
                    mouseCursor: WidgetStateMouseCursor.clickable,
                    decoration: InputDecoration(
                      labelText: context.l10n.receptionBaudRate,
                    ),
                    items: [
                      for (final rate in kBaudRates)
                        DropdownMenuItem(value: rate, child: Text('$rate')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _baudRate = v);
                    },
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: HoverTooltip(
                        message: context.l10n.tooltipFeedRtlDevice,
                        child: DropdownButtonFormField<int>(
                          initialValue: _deviceIndex,
                          mouseCursor: WidgetStateMouseCursor.clickable,
                          decoration: InputDecoration(
                            labelText: context.l10n.receptionRtlSdrDevice,
                          ),
                          items: [
                            for (final d in _rtlSdrDevices)
                              DropdownMenuItem(
                                value: d.index,
                                child: Text(
                                  d.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _deviceIndex = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    HoverTooltip(
                      message: context.l10n.tooltipReceptionRtlSdrDevices,
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshRtlSdrDevices,
                      ),
                    ),
                  ],
                ),
                if (_rtlSdrDevices.isEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.receptionRtlSdrNoDevice,
                    style: const TextStyle(fontSize: 11, color: Colors.orange),
                  ),
                ],
                const SizedBox(height: 12),
                HoverTooltip(
                  message: context.l10n.tooltipFeedRtlAutoGain,
                  child: SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      context.l10n.receptionRtlSdrAutoGain,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: _autoGain,
                    onChanged: (v) => setState(() => _autoGain = v),
                  ),
                ),
                if (!_autoGain)
                  Row(
                    children: [
                      Text(
                        context.l10n.receptionRtlSdrGainDb,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Spacer(),
                      HoverTooltip(
                        message: context.l10n.tooltipFeedRtlGain,
                        child: DropdownButton<int>(
                          value: _gainDb ?? 30,
                          mouseCursor: WidgetStateMouseCursor.clickable,
                          isDense: true,
                          underline: const SizedBox.shrink(),
                          items: [
                            for (var g = 0; g <= 49; g += 3)
                              DropdownMenuItem(value: g, child: Text('$g dB')),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _gainDb = v);
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      context.l10n.receptionRtlSdrChannels,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const Spacer(),
                    HoverTooltip(
                      message: context.l10n.tooltipFeedRtlChannels,
                      child: DropdownButton<String>(
                        value: _useChannel1 && _useChannel2
                            ? 'both'
                            : (_useChannel1 ? 'A' : 'B'),
                        mouseCursor: WidgetStateMouseCursor.clickable,
                        isDense: true,
                        underline: const SizedBox.shrink(),
                        items: const [
                          DropdownMenuItem(
                              value: 'both', child: Text('A + B')),
                          DropdownMenuItem(
                              value: 'A', child: Text('A (161.975)')),
                          DropdownMenuItem(
                              value: 'B', child: Text('B (162.025)')),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _useChannel1 = v != 'B';
                            _useChannel2 = v != 'A';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.fieldCancel),
        ),
        FilledButton(
          onPressed: () {
            final result = _buildResult();
            if (result != null) {
              Navigator.pop(context, result);
            }
          },
          child: Text(context.l10n.fieldAdd),
        ),
      ],
    );
  }
}


