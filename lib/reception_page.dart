import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boat_animation.dart';
import 'boatmanager.dart';
import 'feed_def.dart';
import 'file_feed_player.dart';
import 'forwarder_service.dart';
import 'host_input_formatter.dart';
import 'message_stats.dart';
import 'port_input_formatter.dart';
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
  late final Listenable _feedListenable;
  List<FeedDef> _customFeeds = [];

  /// Active file players, keyed by feed.key. Created lazily when a file feed
  /// is enabled, kept alive so re-enabling replays instantly.
  final Map<String, FileFeedPlayer> _filePlayers = {};

  /// Active serial players, keyed by feed.key. Created lazily when a serial
  /// feed is enabled, kept alive so re-enabling reconnects instantly.
  final Map<String, SerialFeedPlayer> _serialPlayers = {};

  bool isRunning = false;
  bool _validateChecksum = true;

  late BoatManager boatManager;
  late AppSettings settings;
  late MessageStats stats;

  @override
  void initState() {
    super.initState();
    boatManager = context.read<BoatManager>();
    settings = context.read<AppSettings>();
    stats = context.read<MessageStats>();

    forwarderService = ForwarderService(
      onLog: (message, starter, name) {
        if (message.startsWith("!")) {
          stats.recordReceived(name);
        }
        // Batched: a single setState per flush instead of one per frame, so
        // high-volume feeds (e.g. a large simulated fleet) don't stall the UI.
        _pendingLogs.add(
          LogEntry(message: message, starter: starter, name: name),
        );
        _logFlushTimer ??= Timer(_logFlushDelay, _flushLogs);
        if (boatManager.decodeEnabled && message.startsWith("!")) {
          boatManager.processMessage(message, feed: name);
        }
      },
    );
    forwarderService.setTargets(settings.targets);

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

    _feedListenable = Listenable.merge([
      forwarderService.feedStatuses,
      sim,
      _statusTick,
    ]);
    // Refresh the feed tiles only while the forwarder is running; the dots
    // never change over time otherwise. Idle rebuilds churn the semantics tree
    // (ListView + Tooltips), which on Windows triggers AXTree bridge failures.
    _statusTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (isRunning) _statusTick.value++;
      },
    );
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
        } else {
          await _startSerialFeed(feed);
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
      }
    }
    await forwarderService.stop();
    setState(() => isRunning = false);
    widget.running.value = false;
  }

  Future<void> toggleSimFeed(bool value) async {
    setState(() => feedEnabled[kSimulationFeedKey] = value);
    settings.feedEnabled[kSimulationFeedKey] = value;
    settings.save();

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

  void toggleFeed(FeedDef feed, bool value) async {
    setState(() => feedEnabled[feed.key] = value);
    settings.feedEnabled[feed.key] = value;
    settings.save();

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
    } else {
      if (value) {
        await _startSerialFeed(feed);
      } else {
        await _stopSerialFeed(feed);
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
      } else {
        await _startSerialFeed(feed);
      }
    }
  }

  Future<void> _removeCustomFeed(FeedDef feed) async {
    if (feed.type == FeedType.file) {
      _stopFileFeed(feed);
    } else if (feed.type == FeedType.serial) {
      await _stopSerialFeed(feed);
    } else if (isRunning) {
      await forwarderService.removeFeed(feed.displayName);
    }
    setState(() {
      _customFeeds.remove(feed);
      feedEnabled.remove(feed.key);
    });
    _filePlayers.remove(feed.key)?.dispose();
    _serialPlayers.remove(feed.key)?.dispose();
    _syncFeedSettings();
  }

  /// Sends a raw NMEA sentence to all enabled targets (used by the AIS
  /// message editor page) and logs it with the "KikAis" source.
  void sendRaw(String nmea) {
    forwarderService.sendRaw(nmea);
    setState(() {
      logEntries.add(
        LogEntry(message: nmea.trim(), starter: "KikAis", name: null),
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
    if (feed.type == FeedType.file) {
      return const Icon(Icons.description, size: 30);
    }
    if (feed.key == "Kikistream.io") {
      return const Icon(Icons.public, size: 30);
    }
    if (feed.key.length == 2) {
      return CountryFlag.fromCountryCode(feed.key, width: 30, height: 18);
    }
    return const Icon(Icons.directions_boat, size: 30);
  }

  Widget _feedStatusDot(FeedStatus? status) {
    final color = switch (feedDotColor(status, DateTime.now())) {
      FeedDotColor.grey => Colors.grey.shade600,
      FeedDotColor.red => Colors.red,
      FeedDotColor.orange => Colors.orange,
      FeedDotColor.green => Colors.green,
    };
    return Tooltip(
      message: _statusTooltip(status),
      child: Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  String _statusTooltip(FeedStatus? status) {
    if (status == null) return 'Disconnected';
    if (status.error != null) {
      return '${status.messageCount} messages · ${status.error}';
    }
    if (!status.connected) {
      return status.connecting ? 'Connecting…' : 'Disconnected';
    }
    final last = status.lastMessageAt;
    if (last == null) {
      return 'Connected · no AIS frames yet';
    }
    final seconds = DateTime.now().difference(last).inSeconds;
    return '${status.messageCount} messages · last frame ${seconds}s ago';
  }

  Widget _buildSimFeedTile(FeedStatus status) {
    final tile = CheckboxListTile(
      dense: true,
      title: Row(
        children: [
          const Expanded(
            child: Text('Simulation', overflow: TextOverflow.ellipsis),
          ),
          _feedStatusDot(status),
        ],
      ),
      value: feedEnabled[kSimulationFeedKey] ?? false,
      onChanged: (val) => toggleSimFeed(val ?? false),
      secondary: const Icon(Icons.science, size: 30),
    );
    return Tooltip(
      message: 'Emit a simulated AIS fleet around a location. '
          'Configure it on the Simulation tab.',
      child: tile,
    );
  }

  Widget _buildFeedTile(FeedDef feed, FeedStatus? status) {
    final tile = CheckboxListTile(
      dense: true,
      title: Row(
        children: [
          Expanded(
            child: Text(
              feed.displayName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _feedStatusDot(status),
          if (!feed.builtIn)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _removeCustomFeed(feed),
              tooltip: 'Remove feed',
            ),
        ],
      ),
      value: feedEnabled[feed.key] ?? false,
      onChanged: (val) => toggleFeed(feed, val ?? false),
      secondary: feedIcon(feed),
    );
    if (feed.tooltip != null) {
      return Tooltip(message: feed.tooltip!, child: tile);
    }
    if (feed.type == FeedType.serial) {
      final port = feed.serialPort ?? '';
      return Tooltip(
        message: 'Reads NMEA frames from serial port $port at '
            '${feed.baudRate} baud.',
        child: tile,
      );
    }
    if (feed.type == FeedType.file) {
      final fileName = (feed.path ?? '').split(RegExp(r'[/\\]')).last;
      return Tooltip(
        message: 'Replays "$fileName", one frame every '
            '${feed.intervalMs} ms${feed.loop ? ' (loops)' : ''}.',
        child: tile,
      );
    }
    return tile;
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _statusTick.dispose();
    _scrollController.dispose();
    _logFlushTimer?.cancel();
    sim.dispose();
    for (final player in _filePlayers.values) {
      player.dispose();
    }
    for (final player in _serialPlayers.values) {
      player.dispose();
    }
    super.dispose();
  }

  Future<void> saveLogs() async {
    const String fileName = 'kikais_logs.txt';
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: [
        XTypeGroup(label: 'Text Files', extensions: ['txt']),
      ],
    );
    if (result == null) {
      return;
    }

    final StringBuffer logBuffer = StringBuffer();
    for (var entry in logEntries) {
      if (entry.starter != null) {
        logBuffer.writeln(entry.message);
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
    if (_fileFeedKeys.contains(entry.starter)) {
      return const Icon(Icons.description, size: 16);
    }
    if (entry.starter!.length == 2) {
      try {
        return CountryFlag.fromCountryCode(
          entry.starter!,
          width: 16,
          height: 10,
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
                title: "Feeds",
                trailing: IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  onPressed: _showAddFeedDialog,
                  tooltip: 'Add feed',
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
                    child: AnimatedBuilder(
                    animation: _feedListenable,
                    builder: (context, _) {
                      final statuses = forwarderService.feedStatuses.value;
                      final tiles = [
                        _buildSimFeedTile(_simFeedStatus()),
                        for (final feed in _allFeeds)
                          _buildFeedTile(
                            feed,
                            statuses[feed.displayName],
                          ),
                      ];
                      return LayoutBuilder(
                        builder: (context, constraints) {
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
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Tooltip(
              message: 'When enabled, sentences with an invalid NMEA '
                  'checksum are dropped before decoding. Disable it to accept '
                  'feeds that send malformed or unchecked sentences.',
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                dense: true,
                title: const Text(
                  "Validate NMEA checksums",
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: AnimatedBuilder(
                  animation: boatManager,
                  builder: (_, __) => Text(
                    "${boatManager.invalidChecksumCount} "
                    "sentences dropped",
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Tooltip(
                    message: isRunning
                        ? 'Stop the forwarder'
                        : 'Start the forwarder',
                    child: ElevatedButton.icon(
                      key: ValueKey(isRunning),
                      icon: Icon(
                        isRunning ? Icons.stop : Icons.play_arrow,
                      ),
                      label: Text(isRunning ? "Stop" : "Start"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isRunning ? Colors.red : Colors.green,
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
                        const Text("Logs"),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.save_outlined),
                          iconSize: 18,
                          visualDensity: VisualDensity.compact,
                          onPressed: saveLogs,
                          tooltip: "Save logs to a file",
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          iconSize: 18,
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            setState(() {
                              logEntries.clear();
                              _scrollController.jumpTo(0);
                            });
                          },
                          tooltip: "Clear logs",
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

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildStarterWidget(entry),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    entry.name != null
                                        ? "[${entry.name}] ${entry.message}"
                                        : entry.message,
                                  ),
                                ),
                                if (entry.message.startsWith('!'))
                                  CopyIconButton(
                                    text: entry.message,
                                    message: 'Frame copied',
                                    padding: EdgeInsets.zero,
                                    tooltip: 'Copy this frame',
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

class LogEntry {
  final String message;
  final String? starter;
  final String? name;

  LogEntry({required this.message, this.starter, this.name});
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
  static const List<int> kBaudRates = [
    4800, 9600, 19200, 38400, 57600, 115200,
  ];

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
  bool _loop = true;

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
    final path = _path.text.trim();
    if (path.isEmpty) return null;
    final interval =
        (int.tryParse(_interval.text) ?? 1000).clamp(1, 60000).toInt();
    return FeedDef(
      key: name,
      displayName: name,
      type: FeedType.file,
      path: path,
      intervalMs: interval,
      loop: _loop,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add source'),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<FeedType>(
                segments: const [
                  ButtonSegment(
                    value: FeedType.network,
                    label: Text('Network'),
                    icon: Icon(Icons.dns_outlined),
                  ),
                  ButtonSegment(
                    value: FeedType.file,
                    label: Text('File'),
                    icon: Icon(Icons.description_outlined),
                  ),
                  ButtonSegment(
                    value: FeedType.serial,
                    label: Text('Serial'),
                    icon: Icon(Icons.settings_ethernet_outlined),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (s) {
                  setState(() => _type = s.first);
                  if (s.first == FeedType.serial) {
                    _refreshSerialPorts();
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              if (_type == FeedType.network) ...[
                TextField(
                  controller: _host,
                  decoration: const InputDecoration(labelText: 'Host'),
                  inputFormatters: [HostInputFormatter()],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _port,
                  decoration: const InputDecoration(labelText: 'Port'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PortInputFormatter(),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _header,
                  decoration: const InputDecoration(
                    labelText: 'Header (optional)',
                  ),
                ),
              ] else if (_type == FeedType.file) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _path,
                        decoration: const InputDecoration(
                          labelText: 'File',
                          hintText: 'Path or Browse…',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.folder_open),
                      tooltip: 'Browse',
                      onPressed: _browse,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _interval,
                  decoration: const InputDecoration(
                    labelText: 'Interval between frames (ms)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Loop (replay from the start)',
                    style: TextStyle(fontSize: 13),
                  ),
                  value: _loop,
                  onChanged: (v) => setState(() => _loop = v),
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _serialPort,
                        decoration: const InputDecoration(
                          labelText: 'Serial port',
                          hintText: 'e.g. COM3 or /dev/ttyUSB0',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh ports',
                      onPressed: _refreshSerialPorts,
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
                          onPressed: () {
                            setState(() => _serialPort.text = p);
                          },
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: _baudRate,
                  decoration: const InputDecoration(labelText: 'Baud rate'),
                  items: [
                    for (final rate in kBaudRates)
                      DropdownMenuItem(value: rate, child: Text('$rate')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _baudRate = v);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final result = _buildResult();
            if (result != null) {
              Navigator.pop(context, result);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
