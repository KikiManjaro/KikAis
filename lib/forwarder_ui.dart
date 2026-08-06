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
import 'forwarder_service.dart';
import 'host_input_formatter.dart';
import 'ip_address_input_formatter.dart';
import 'message_stats.dart';
import 'port_input_formatter.dart';
import 'widgets.dart';

/// A feed is considered "receiving" while a frame arrived within this window.
const Duration feedStaleAfter = Duration(seconds: 10);

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

class ForwarderUI extends StatefulWidget {
  final BoatAnimationController boat;
  final ValueNotifier<bool> running;

  const ForwarderUI(this.boat, {required this.running, super.key});

  @override
  State<ForwarderUI> createState() => ForwarderUIState();
}

class ForwarderUIState extends State<ForwarderUI> {
  static const int maxLogEntries = 2000;

  final ScrollController _scrollController = ScrollController();
  late ForwarderService forwarderService;

  final TextEditingController hostController = TextEditingController(
    text: "127.0.0.1",
  );
  final TextEditingController portController = TextEditingController(
    text: "33333",
  );

  final List<LogEntry> logEntries = [];
  final Map<String, bool> feedEnabled = {};
  final ValueNotifier<int> _statusTick = ValueNotifier(0);
  Timer? _statusTimer;
  late final Listenable _feedListenable;
  List<FeedDef> _customFeeds = [];
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
        setState(() {
          logEntries.add(
            LogEntry(message: message, starter: starter, name: name),
          );
          if (logEntries.length > maxLogEntries) {
            logEntries.removeRange(0, logEntries.length - maxLogEntries);
          }
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });
        if (boatManager.decodeEnabled && message.startsWith("!")) {
          boatManager.processMessage(message, feed: name);
        }
      },
    );

    forwarderService.targetHost = settings.targetHost;
    hostController.text = settings.targetHost;
    portController.text = settings.targetPort.toString();
    forwarderService.setProtocol(settings.protocol);
    _customFeeds = List.of(settings.customFeeds);
    feedEnabled
      ..clear()
      ..addAll({for (final f in kFeedDefs) f.key: false})
      ..addAll({for (final f in _customFeeds) f.key: false})
      ..addAll(settings.feedEnabled);
    _validateChecksum = settings.validateChecksum;
    if (boatManager.validateChecksum != settings.validateChecksum) {
      boatManager.setValidateChecksum(settings.validateChecksum);
    }
    if (boatManager.decodeEnabled != settings.decodeEnabled) {
      boatManager.setDecodeEnabled(settings.decodeEnabled);
    }
    if (boatManager.sendToMap != settings.sendToMap) {
      boatManager.setSendToMap(settings.sendToMap);
    }

    _feedListenable = Listenable.merge([
      forwarderService.feedStatuses,
      _statusTick,
    ]);
    _statusTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _statusTick.value++,
    );
  }

  List<FeedDef> get _allFeeds => [...kFeedDefs, ..._customFeeds];

  void _syncFeedSettings() {
    settings.customFeeds = List.of(_customFeeds);
    settings.feedEnabled
      ..clear()
      ..addAll(feedEnabled);
    settings.save();
  }

  void startForwarder() async {
    forwarderService.targetHost = hostController.text;
    forwarderService.targetPort = int.tryParse(portController.text) ?? 33333;
    settings.targetHost = forwarderService.targetHost;
    settings.targetPort = forwarderService.targetPort;
    settings.protocol = forwarderService.protocol;
    settings.save();

    await forwarderService.start();
    setState(() => isRunning = true);
    widget.running.value = true;

    for (final feed in _allFeeds) {
      if (feedEnabled[feed.key] ?? false) {
        await forwarderService.addFeed(
          feed.displayName,
          feed.key,
          feed.host,
          feed.port,
          header: feed.header,
        );
      }
    }
  }

  void stopForwarder() async {
    await forwarderService.stop();
    setState(() => isRunning = false);
    widget.running.value = false;
  }

  void toggleFeed(FeedDef feed, bool value) async {
    setState(() => feedEnabled[feed.key] = value);
    settings.feedEnabled[feed.key] = value;
    settings.save();

    if (!isRunning) return;

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
  }

  Future<void> _showAddFeedDialog() async {
    final nameController = TextEditingController();
    final hostController = TextEditingController();
    final portController = TextEditingController(text: '3000');
    final headerController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add feed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: hostController,
              decoration: const InputDecoration(labelText: 'Host'),
              inputFormatters: [HostInputFormatter()],
            ),
            TextField(
              controller: portController,
              decoration: const InputDecoration(labelText: 'Port'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                PortInputFormatter(),
              ],
            ),
            TextField(
              controller: headerController,
              decoration: const InputDecoration(labelText: 'Header (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    nameController.dispose();
    hostController.dispose();
    portController.dispose();
    headerController.dispose();

    if (confirmed != true || !mounted) return;

    final name = nameController.text.trim();
    final host = hostController.text.trim();
    if (name.isEmpty || host.isEmpty) return;
    final header = headerController.text.trim();

    final feed = FeedDef(
      key: name,
      displayName: name,
      host: host,
      port: int.tryParse(portController.text) ?? 3000,
      header: header.isEmpty ? null : header,
    );

    setState(() {
      _customFeeds.add(feed);
      feedEnabled[feed.key] = false;
    });
    _syncFeedSettings();

    if (isRunning) {
      await forwarderService.addFeed(
        feed.displayName,
        feed.key,
        feed.host,
        feed.port,
        header: feed.header,
      );
    }
  }

  Future<void> _removeCustomFeed(FeedDef feed) async {
    if (isRunning) {
      await forwarderService.removeFeed(feed.displayName);
    }
    setState(() {
      _customFeeds.remove(feed);
      feedEnabled.remove(feed.key);
    });
    _syncFeedSettings();
  }

  /// Sends a raw NMEA sentence to the configured target (used by the AIS
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

  Widget feedIcon(String key) {
    if (key == "Kikistream.io") return const Icon(Icons.public, size: 30);
    if (key.length == 2) {
      return CountryFlag.fromCountryCode(key, width: 30, height: 18);
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
      secondary: feedIcon(feed.key),
    );
    if (feed.tooltip != null) {
      return Tooltip(message: feed.tooltip!, child: tile);
    }
    return tile;
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _statusTick.dispose();
    hostController.dispose();
    portController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: isRunning,
                            child: Opacity(
                              opacity: isRunning ? 0.6 : 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: SectionHeader(
                                      icon: Icons.tune,
                                      title: "Configuration",
                                    ),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: hostController,
                                              decoration:
                                                  const InputDecoration(
                                                labelText: "Target Host",
                                                prefixIcon: Icon(
                                                  Icons.computer,
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r'[0-9.]'),
                                                ),
                                                IpAddressInputFormatter(),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: portController,
                                              decoration:
                                                  const InputDecoration(
                                                labelText: "Target Port",
                                                prefixIcon:
                                                    Icon(Icons.numbers),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                PortInputFormatter(),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(width: 8),
                                                const Icon(Icons.link),
                                                const SizedBox(width: 12),
                                                Text(
                                                  "Protocol",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                DropdownButton<
                                                  ForwardProtocol
                                                >(
                                                  value:
                                                      forwarderService.protocol,
                                                  items: ForwardProtocol.values
                                                      .map((p) {
                                                        String label;
                                                        switch (p) {
                                                          case ForwardProtocol
                                                              .tcpClient:
                                                            label =
                                                                "TCP Client";
                                                            break;
                                                          case ForwardProtocol
                                                              .tcpServer:
                                                            label =
                                                                "TCP Server";
                                                            break;
                                                          case ForwardProtocol
                                                              .udpClient:
                                                            label =
                                                                "UDP Client";
                                                            break;
                                                          case ForwardProtocol
                                                              .udpServer:
                                                            label =
                                                                "UDP Server";
                                                            break;
                                                        }

                                                        return DropdownMenuItem(
                                                          value: p,
                                                          child: Text(label),
                                                        );
                                                      })
                                                      .toList(),
                                                  onChanged: (p) {
                                                    if (p == null) return;
                                                    setState(() {
                                                      forwarderService
                                                          .setProtocol(p);
                                                    });
                                                    settings.protocol = p;
                                                    settings.save();
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            SwitchListTile(
                                              contentPadding: EdgeInsets.zero,
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
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                              value: _validateChecksum,
                                              onChanged: (v) {
                                                setState(() {
                                                  _validateChecksum = v;
                                                });
                                                boatManager
                                                    .setValidateChecksum(v);
                                                settings.validateChecksum = v;
                                                settings.save();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
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
                                          final statuses =
                                              forwarderService
                                                  .feedStatuses.value;
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (final feed in _allFeeds)
                                                _buildFeedTile(
                                                  feed,
                                                  statuses[feed.displayName],
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
                              backgroundColor: isRunning
                                  ? Colors.red
                                  : Colors.green,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      IconButton(
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 14,
                                        ),
                                        iconSize: 14,
                                        visualDensity:
                                            VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 24,
                                          minHeight: 24,
                                        ),
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: entry.message,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Frame copied',
                                                ),
                                                duration: Duration(
                                                  seconds: 1,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                        },
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
          ),
        ],
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
