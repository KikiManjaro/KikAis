import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ais_editor_page.dart';
import 'app_settings.dart';
import 'boat_animation.dart';
import 'decoder_page.dart';
import 'forwarder_ui.dart';
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
  final GlobalKey<ForwarderUIState> _forwarderKey =
      GlobalKey<ForwarderUIState>();
  late final BoatAnimation boat;
  late final ForwarderUI forwarderPage;
  late final WorldMapPage mapPage;
  late final AisEditorPage editorPage;
  late final DecoderPage decoderPage;
  late final StatsPage statsPage;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    boat = BoatAnimation(controller: boatController);
    forwarderPage = ForwarderUI(
      boatController,
      key: _forwarderKey,
      running: forwarderRunning,
    );
    mapPage = WorldMapPage(key: const PageStorageKey('world_map'));
    editorPage = AisEditorPage(
      running: forwarderRunning,
      onSendToTarget: (sentence) async {
        _forwarderKey.currentState?.sendRaw(sentence);
      },
    );
    decoderPage = const DecoderPage(key: PageStorageKey('decoder'));
    statsPage = const StatsPage();
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
                          _currentIndex = (_currentIndex + 1).clamp(0, 4);
                        });
                      } else if (pointerSignal.scrollDelta.dx < 0) {
                        setState(() {
                          _currentIndex = (_currentIndex - 1).clamp(0, 4);
                        });
                      }
                    }
                  },
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      forwarderPage,
                      mapPage,
                      editorPage,
                      decoderPage,
                      statsPage,
                    ],
                  ),
                ),
                bottomNavigationBar: SizedBox(
                  height: 20,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Row(
                          children: List.generate(5, (index) {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _currentIndex = index),
                                child: Container(color: Colors.transparent),
                              ),
                            );
                          }),
                        ),
                      ),
                      IgnorePointer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentIndex == index ? 30 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentIndex == index
                                    ? Colors.lightBlueAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
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
