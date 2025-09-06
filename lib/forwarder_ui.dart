import 'package:KikAis/port_input_formatter.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:country_flags/country_flags.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'boat_animation.dart';
import 'forwarder_service.dart';
import 'ip_address_input_formatter.dart';

class ForwarderUI extends StatefulWidget {
  @override
  _ForwarderUIState createState() => _ForwarderUIState();
}

class _ForwarderUIState extends State<ForwarderUI> {
  final BoatAnimation boat = BoatAnimation();
  final ScrollController _scrollController = ScrollController();
  late ForwarderService forwarderService;

  final TextEditingController hostController = TextEditingController(
    text: "127.0.0.1",
  );
  final TextEditingController portController = TextEditingController(
    text: "33333",
  );

  List<LogEntry> logEntries = [];
  bool isRunning = false;
  bool usFeed = false;
  bool norwegianFeed = true;
  bool gpsd1 = true;
  bool gpsd2 = true;
  bool simulatedSinagot = false;
  bool kikistreamio = false;

  @override
  void initState() {
    super.initState();
    forwarderService = ForwarderService(
      onLog: (message, starter, name) {
        setState(() {
          setState(() {
            logEntries.add(
              LogEntry(message: message, starter: starter, name: name),
            );
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          });
        });
      },
    );
  }

  void startForwarder() async {
    // Set host/port dynamically before starting
    forwarderService.targetHost = hostController.text;
    forwarderService.targetPort = int.tryParse(portController.text) ?? 33333;

    await forwarderService.start();
    setState(() => isRunning = true);

    // Automatically add selected feeds on start
    if (usFeed) {
      await forwarderService.addFeed(
        "US East Coast",
        "US",
        "ssia-ais.erau.edu",
        4000,
      );
    }
    if (norwegianFeed) {
      await forwarderService.addFeed("Norwegian", "NO", "153.44.253.27", 5631);
    }
    if (gpsd1) {
      await forwarderService.addFeed(
        "Sinagot 2947 (GPSD1)",
        "GPSD1",
        "5.39.78.33",
        2947,
        header: "?WATCH={\"enable\":true,\"raw\":1}",
      );
    }
    if (gpsd2) {
      await forwarderService.addFeed(
        "Sinagot 2948 (GPSD2)",
        "GPSD2",
        "5.39.78.33",
        2948,
        header: "?WATCH={\"enable\":true,\"raw\":1}",
      );
    }
    if (simulatedSinagot) {
      await forwarderService.addFeed(
        "Sinagot 5121 (simulated)",
        "Sinagot 5121 (simulated)",
        "5.39.78.33",
        5121,
      );
    }
    if (kikistreamio) {
      await forwarderService.addFeed(
        "Kikistream.io",
        "Kikistream.io",
        "88.181.60.160",
        20000,
      );
    }
  }

  void stopForwarder() async {
    await forwarderService.stop();
    setState(() => isRunning = false);
  }

  void toggleFeed(String feedName, bool value) async {
    setState(() {
      if (feedName == "US") usFeed = value;
      if (feedName == "NO") norwegianFeed = value;
      if (feedName == "GPSD1") gpsd1 = value;
      if (feedName == "GPSD2") gpsd2 = value;
      if (feedName == "Sinagot 5121 (simulated)") simulatedSinagot = value;
      if (feedName == "Kikistream.io") kikistreamio = value;
    });

    if (!isRunning) return;

    if (feedName == "US") {
      if (value) {
        await forwarderService.addFeed(
          "US East Coast",
          "US",
          "ssia-ais.erau.edu",
          4000,
        );
      } else {
        await forwarderService.removeFeed("US East Coast");
      }
    }

    if (feedName == "NO") {
      if (value) {
        await forwarderService.addFeed(
          "Norwegian",
          "NO",
          "153.44.253.27",
          5631,
        );
      } else {
        await forwarderService.removeFeed("Norwegian");
      }
    }
    if (feedName == "GPSD1") {
      if (value) {
        await forwarderService.addFeed(
          "Sinagot 2947 (GPSD1)",
          "GPSD1",
          "5.39.78.33",
          2947,
          header: "?WATCH={\"enable\":true,\"raw\":1}",
        );
      } else {
        await forwarderService.removeFeed("Sinagot 2947 (GPSD1)");
      }
    }
    if (feedName == "GPSD2") {
      if (value) {
        await forwarderService.addFeed(
          "Sinagot 2948 (GPSD2)",
          "GPSD2",
          "5.39.78.33",
          2948,
          header: "?WATCH={\"enable\":true,\"raw\":1}",
        );
      } else {
        await forwarderService.removeFeed("Sinagot 2948 (GPSD2)");
      }
    }
    if (feedName == "Sinagot 5121 (simulated)") {
      if (value) {
        await forwarderService.addFeed(
          "Sinagot 5121 (simulated)",
          "Sinagot 5121 (simulated)",
          "5.39.78.33",
          5121,
        );
      } else {
        await forwarderService.removeFeed("Sinagot 5121 (simulated)");
      }
    }
    if (feedName == "Kikistream.io") {
      if (value) {
        await forwarderService.addFeed(
          "Kikistream.io",
          "Kikistream.io",
          "88.181.60.160",
          20000,
        );
      } else {
        await forwarderService.removeFeed("Kikistream.io");
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WindowBorder(
        width: 3,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ImageIcon(
                          AssetImage("resources/FireBoat2.png"),
                          size: 26,
                        ),
                      ),
                      Text(
                        "KikAis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Stack(children: [boat, MoveWindow()])),
                  const WindowButtons(),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // make children take full height
                        children: [
                          Expanded(
                            // Host / Port / Protocol Card
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
                                      child: Text("Configuration"),
                                    ),
                                    Expanded(
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: hostController,
                                                decoration: InputDecoration(
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
                                                decoration: InputDecoration(
                                                  labelText: "Target Port",
                                                  prefixIcon: Icon(
                                                    Icons.numbers,
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  // only digits
                                                  PortInputFormatter(),
                                                  // valid port range
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Icon(Icons.link),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "Protocol",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),
                                                  DropdownButton<
                                                    ForwardProtocol
                                                  >(
                                                    value: forwarderService
                                                        .protocol,
                                                    items: ForwardProtocol
                                                        .values
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
                            // Feeds selection Card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.directional(
                                    start: 10,
                                  ),
                                  child: Text("Feeds"),
                                ),
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Tooltip(
                                            message:
                                                "Kikistream.io is based on a public AIS feed (aisstream.io),\neach message is transformed to a standard NMEA0183 AIS sentence\n(messages could be wrong or malformed)",
                                            child: CheckboxListTile(
                                              title: Text("Kikistream.io"),
                                              value: kikistreamio,
                                              onChanged: (val) => toggleFeed(
                                                "Kikistream.io",
                                                val ?? false,
                                              ),
                                              secondary: Icon(
                                                Icons.public,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                          CheckboxListTile(
                                            title: Text("Norwegian Feed"),
                                            value: norwegianFeed,
                                            onChanged: (val) =>
                                                toggleFeed("NO", val ?? false),
                                            secondary:
                                                CountryFlag.fromCountryCode(
                                                  "NO",
                                                  width: 30,
                                                  height: 18,
                                                ),
                                          ),
                                          CheckboxListTile(
                                            title: Text("Sinagot 2947 (GPSD1)"),
                                            value: gpsd1,
                                            onChanged: (val) => toggleFeed(
                                              "GPSD1",
                                              val ?? false,
                                            ),
                                            secondary:
                                                CountryFlag.fromCountryCode(
                                                  "GPSD1",
                                                  width: 30,
                                                  height: 18,
                                                ),
                                          ),
                                          CheckboxListTile(
                                            title: Text("Sinagot 2948 (GPSD2)"),
                                            value: gpsd2,
                                            onChanged: (val) => toggleFeed(
                                              "GPSD2",
                                              val ?? false,
                                            ),
                                            secondary:
                                                CountryFlag.fromCountryCode(
                                                  "GPSD2",
                                                  width: 30,
                                                  height: 18,
                                                ),
                                          ),
                                          CheckboxListTile(
                                            title: Text(
                                              "Sinagot 5121 (simulated)",
                                            ),
                                            value: simulatedSinagot,
                                            onChanged: (val) => toggleFeed(
                                              "Sinagot 5121 (simulated)",
                                              val ?? false,
                                            ),
                                            secondary:
                                                CountryFlag.fromCountryCode(
                                                  "Sinagot 5121 (simulated)",
                                                  width: 30,
                                                  height: 18,
                                                ),
                                          ),
                                          CheckboxListTile(
                                            title: Text(
                                              "US East Coast Feed (simulated)",
                                            ),
                                            value: usFeed,
                                            onChanged: (val) =>
                                                toggleFeed("US", val ?? false),
                                            secondary:
                                                CountryFlag.fromCountryCode(
                                                  "US",
                                                  width: 30,
                                                  height: 18,
                                                ),
                                          ),
                                        ],
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
                    SizedBox(height: 10),
                    // Control buttons and status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
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
                                boat.stop();
                              } else {
                                startForwarder();
                                boat.start();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Log display
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.directional(start: 10),
                            child: Text("Logs"),
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
                                          Widget starterWidget;

                                          if (entry.starter != null) {
                                            try {
                                              if (entry.starter ==
                                                  "Kikistream.io") {
                                                starterWidget = Icon(
                                                  Icons.public,
                                                  size: 16,
                                                );
                                              } else if (entry
                                                      .starter!
                                                      .length ==
                                                  2) {
                                                starterWidget =
                                                    CountryFlag.fromCountryCode(
                                                      entry.starter!,
                                                      width: 16,
                                                      height: 10,
                                                    );
                                              } else {
                                                starterWidget = Icon(
                                                  Icons.directions_boat,
                                                  size: 16,
                                                );
                                              }
                                            } catch (e) {
                                              starterWidget = Text(
                                                entry.starter!,
                                              );
                                            }
                                          } else {
                                            starterWidget = SizedBox.shrink();
                                          }

                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              starterWidget,
                                              SizedBox(width: 5),
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
                                    icon: Icon(Icons.delete_outline),
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
                                    icon: Icon(Icons.save_outlined),
                                    iconSize: 20,
                                    onPressed: () {
                                      setState(() {
                                        saveLogs();
                                      });
                                    },
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

final buttonColors = WindowButtonColors(
  iconNormal: Colors.lightBlue,
  mouseOver: Colors.lightBlueAccent,
  mouseDown: Colors.blue,
  iconMouseOver: Colors.blueGrey,
  iconMouseDown: Colors.lightBlueAccent,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: const Color(0xFF805306),
  iconMouseOver: Colors.white,
);

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
