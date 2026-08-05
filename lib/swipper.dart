import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'boat_animation.dart';
import 'forwarder_ui.dart';
import 'world_map_page.dart';

class SwipperUi extends StatefulWidget {
  const SwipperUi({super.key});

  @override
  State<SwipperUi> createState() => _SwipperUiState();
}

class _SwipperUiState extends State<SwipperUi> {
  final BoatAnimationController boatController = BoatAnimationController();
  final PageController _pageController = PageController();
  late final BoatAnimation boat;
  late final ForwarderUI forwarderPage;
  late final WorldMapPage mapPage;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    boat = BoatAnimation(controller: boatController);
    forwarderPage = ForwarderUI(
      boatController,
      key: const PageStorageKey('forwarder_ui'),
    );
    mapPage = WorldMapPage(key: const PageStorageKey('world_map'));
  }

  @override
  void dispose() {
    boatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      const Text(
                        "KikAis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
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
              child: Scaffold(
                body: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      if (pointerSignal.scrollDelta.dx > 0) {
                        setState(() {
                          _currentIndex = (_currentIndex + 1).clamp(0, 1);
                        });
                      } else if (pointerSignal.scrollDelta.dx < 0) {
                        setState(() {
                          _currentIndex = (_currentIndex - 1).clamp(0, 1);
                        });
                      }
                    }
                  },
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [forwarderPage, mapPage],
                  ),
                ),
                bottomNavigationBar: SizedBox(
                  height: 20,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        left: 0,
                        right: MediaQuery.of(context).size.width / 2,
                        child: GestureDetector(
                          onTap: () => setState(() => _currentIndex = 0),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      Positioned.fill(
                        left: MediaQuery.of(context).size.width / 2,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(() => _currentIndex = 1),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      IgnorePointer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(2, (index) {
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
