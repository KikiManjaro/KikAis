import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ais_editor_page.dart';
import 'app_settings.dart';
import 'boat_animation.dart';
import 'decoder_page.dart';
import 'reception_page.dart';
import 'send_page.dart';
import 'simulation_page.dart';
import 'stats_page.dart';
import 'themes.dart';
import 'world_map_page.dart';

class SwipperUi extends StatefulWidget {
  final String version;

  const SwipperUi({super.key, required this.version});

  @override
  State<SwipperUi> createState() => _SwipperUiState();
}

class _SwipperUiState extends State<SwipperUi> {
  final BoatAnimationController boatController = BoatAnimationController();
  final ValueNotifier<bool> forwarderRunning = ValueNotifier(false);
  final PageController _pageController = PageController();
  final GlobalKey<ReceptionPageState> _receptionKey =
      GlobalKey<ReceptionPageState>();
  late final BoatAnimation boat;
  late final ReceptionPage receptionPage;
  late final SendPage sendPage;
  late final WorldMapPage mapPage;
  late final AisEditorPage editorPage;
  late final DecoderPage decoderPage;
  late final StatsPage statsPage;
  late final SimulationPage simulationPage;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    boat = BoatAnimation(controller: boatController);
    receptionPage = ReceptionPage(
      boatController,
      key: _receptionKey,
      running: forwarderRunning,
    );
    sendPage = SendPage(
      serviceGetter: () => _receptionKey.currentState?.forwarderService,
      running: forwarderRunning,
    );
    mapPage = WorldMapPage(key: const PageStorageKey('world_map'));
    editorPage = AisEditorPage(
      running: forwarderRunning,
      onSendToTarget: (sentence) async {
        _receptionKey.currentState?.sendRaw(sentence);
      },
    );
    decoderPage = const DecoderPage(key: PageStorageKey('decoder'));
    statsPage = const StatsPage();
    simulationPage = SimulationPage(
      simGetter: () => _receptionKey.currentState?.simService,
      onGoToReception: () => setState(() => _currentIndex = 0),
    );
  }

  @override
  void dispose() {
    boatController.dispose();
    forwarderRunning.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<AppSettings>().appTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return WindowBorder(
      width: 3,
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
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
                          color: onSurface,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'v${widget.version}',
                        style: TextStyle(
                          fontSize: 11,
                          color: onSurface.withValues(alpha: 0.6),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Stack(children: [boat, MoveWindow()])),
                  Material(
                    type: MaterialType.transparency,
                    child: PopupMenuButton<AppTheme>(
                      tooltip: 'Change theme',
                      onSelected: (t) =>
                          context.read<AppSettings>().setTheme(t),
                      itemBuilder: (context) => [
                        for (final t in AppTheme.values)
                          PopupMenuItem<AppTheme>(
                            value: t,
                            child: Row(
                              children: [
                                Icon(
                                  t == currentTheme ? Icons.check : t.icon,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(t.label),
                              ],
                            ),
                          ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Icon(
                          Icons.brightness_6,
                          size: 18,
                          color: onSurface,
                        ),
                      ),
                    ),
                  ),
                  const WindowButtons(),
                ],
              ),
            ),
            Expanded(
              child: Scaffold(
                body: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      if (pointerSignal.scrollDelta.dx > 0) {
                        setState(() {
                          _currentIndex = (_currentIndex + 1).clamp(0, 6);
                        });
                      } else if (pointerSignal.scrollDelta.dx < 0) {
                        setState(() {
                          _currentIndex = (_currentIndex - 1).clamp(0, 6);
                        });
                      }
                    }
                  },
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      // Hidden pages keep their state but their animations are
                      // muted (TickerMode) so they don't churn the frame loop.
                      TickerMode(
                        enabled: _currentIndex == 0,
                        child: receptionPage,
                      ),
                      TickerMode(enabled: _currentIndex == 1, child: sendPage),
                      TickerMode(enabled: _currentIndex == 2, child: mapPage),
                      TickerMode(enabled: _currentIndex == 3, child: editorPage),
                      TickerMode(
                        enabled: _currentIndex == 4,
                        child: decoderPage,
                      ),
                      TickerMode(enabled: _currentIndex == 5, child: statsPage),
                      TickerMode(
                        enabled: _currentIndex == 6,
                        child: simulationPage,
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _currentIndex = index),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.radio_outlined),
                      selectedIcon: Icon(Icons.radio),
                      label: 'Reception',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.outbox_outlined),
                      selectedIcon: Icon(Icons.outbox),
                      label: 'Send',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.map_outlined),
                      selectedIcon: Icon(Icons.map),
                      label: 'Map',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.edit_note_outlined),
                      selectedIcon: Icon(Icons.edit_note),
                      label: 'Editor',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.manage_search_outlined),
                      selectedIcon: Icon(Icons.manage_search),
                      label: 'Decoder',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bar_chart_outlined),
                      selectedIcon: Icon(Icons.bar_chart),
                      label: 'Stats',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.bubble_chart_outlined),
                      selectedIcon: Icon(Icons.bubble_chart),
                      label: 'Simulation',
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
  const WindowButtons({super.key});

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
