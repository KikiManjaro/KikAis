import 'package:kik_ais/boat_animation.dart';
import 'package:kik_ais/port_input_formatter.dart';
import 'package:country_flags/country_flags.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'boatmanager.dart';
import 'forwarder_service.dart';
import 'ip_address_input_formatter.dart';

class FeedDef {
  final String key;
  final String displayName;
  final String host;
  final int port;
  final String? header;
  final String? tooltip;

  const FeedDef({
    required this.key,
    required this.displayName,
    required this.host,
    required this.port,
    this.header,
    this.tooltip,
  });
}

const List<FeedDef> kFeedDefs = [
  FeedDef(
    key: "Kikistream.io",
    displayName: "Kikistream.io",
    host: "kikimanjaro.hd.free.fr",
    port: 20000,
    tooltip: "Kikistream.io is based on a public AIS feed (aisstream.io),\n"
        "each message is transformed to a standard NMEA0183 AIS sentence\n"
        "(messages could be wrong or malformed)",
  ),
  FeedDef(
    key: "NO",
    displayName: "Norwegian Feed",
    host: "153.44.253.27",
    port: 5631,
  ),
  FeedDef(
    key: "GPSD1",
    displayName: "Sinagot 2947 (GPSD1)",
    host: "5.39.78.33",
    port: 2947,
    header: '?WATCH={"enable":true,"raw":1}',
  ),
  FeedDef(
    key: "GPSD2",
    displayName: "Sinagot 2948 (GPSD2)",
    host: "5.39.78.33",
    port: 2948,
    header: '?WATCH={"enable":true,"raw":1}',
  ),
  FeedDef(
    key: "Sinagot 5121 (simulated)",
    displayName: "Sinagot 5121 (simulated)",
    host: "5.39.78.33",
    port: 5121,
  ),
  FeedDef(
    key: "US",
    displayName: "US East Coast Feed (simulated)",
    host: "ssia-ais.erau.edu",
    port: 4000,
  ),
];

class ForwarderUI extends StatefulWidget {
  final BoatAnimationController boat;

  const ForwarderUI(this.boat, {super.key});

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
  final Map<String, bool> feedEnabled = {
    for (final feed in kFeedDefs) feed.key: false,
  };
  bool isRunning = false;

  late BoatManager boatManager;

  @override
  void initState() {
    super.initState();
    boatManager = context.read<BoatManager>();

    forwarderService = ForwarderService(
      onLog: (message, starter, name) {
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
        if (boatManager.sendToMap && message.startsWith("!")) {
          boatManager.processMessage(message);
        }
      },
    );
  }

  void startForwarder() async {
    forwarderService.targetHost = hostController.text;
    forwarderService.targetPort = int.tryParse(portController.text) ?? 33333;

    await forwarderService.start();
    setState(() => isRunning = true);

    for (final feed in kFeedDefs) {
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
  }

  void toggleFeed(FeedDef feed, bool value) async {
    setState(() => feedEnabled[feed.key] = value);

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

  Widget feedIcon(String key) {
    if (key == "Kikistream.io") return const Icon(Icons.public, size: 30);
    if (key.length == 2) {
      return CountryFlag.fromCountryCode(key, width: 30, height: 18);
    }
    return const Icon(Icons.directions_boat, size: 30);
  }

  @override
  void dispose() {
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
                                  Padding(
                                    padding: EdgeInsetsGeometry.directional(
                                      start: 10,
                                    ),
                                    child: const Text("Configuration"),
                                  ),
                                  Expanded(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: hostController,
                                              decoration: const InputDecoration(
                                                labelText: "Target Host",
                                                prefixIcon: Icon(
                                                  Icons.computer,
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9.]'),
                                                ),
                                                IpAddressInputFormatter(),
                                              ],
                                            ),
                                            TextField(
                                              controller: portController,
                                              decoration: const InputDecoration(
                                                labelText: "Target Port",
                                                prefixIcon: Icon(Icons.numbers),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                PortInputFormatter(),
                                              ],
                                            ),
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
                                                    color: Colors.white,
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
                                                    setState(() {
                                                      forwarderService
                                                          .setProtocol(p!);
                                                    });
                                                  },
                                                ),
                                              ],
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.directional(
                                  start: 10,
                                ),
                                child: const Text("Feeds"),
                              ),
                              Expanded(
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: kFeedDefs.map((feed) {
                                        final tile = CheckboxListTile(
                                          title: Text(feed.displayName),
                                          value: feedEnabled[feed.key],
                                          onChanged: (val) => toggleFeed(
                                            feed,
                                            val ?? false,
                                          ),
                                          secondary: feedIcon(feed.key),
                                        );
                                        if (feed.tooltip != null) {
                                          return Tooltip(
                                            message: feed.tooltip!,
                                            child: tile,
                                          );
                                        }
                                        return tile;
                                      }).toList(),
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
                        child: ElevatedButton.icon(
                          key: ValueKey(isRunning),
                          icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
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
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.directional(start: 10),
                          child: const Text("Logs"),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      controller: _scrollController,
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
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 10,
                                child: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  iconSize: 20,
                                  onPressed: () {
                                    setState(() {
                                      logEntries.clear();
                                      _scrollController.jumpTo(0);
                                    });
                                  },
                                  tooltip: "Clear logs",
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 40,
                                child: IconButton(
                                  icon: const Icon(Icons.save_outlined),
                                  iconSize: 20,
                                  onPressed: saveLogs,
                                  tooltip: "save",
                                ),
                              ),
                            ],
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
