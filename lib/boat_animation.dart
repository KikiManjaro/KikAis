import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoatAnimation extends StatefulWidget {
  BoatAnimation({Key? key}) : super(key: key);

  final _BoatAnimationState _state = _BoatAnimationState();

  // Public methods
  void start() => _state.startAnimation();
  void stop() => _state.stopAnimation();

  @override
  _BoatAnimationState createState() => _state;
}

class _BoatAnimationState extends State<BoatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showBoat = false;
  double _lastParentWidth = 0;
  final double shipWidth = 22;
  final double speed = 30; // pixels per second

  void startAnimation() {
    setState(() => _showBoat = true);
    _controller.repeat(reverse: true);
  }

  void stopAnimation() {
    _controller.stop();
    setState(() => _showBoat = false);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  void _updateControllerDuration(double parentWidth) {
    if (parentWidth != _lastParentWidth) {
      _lastParentWidth = parentWidth;
      double distance = parentWidth - shipWidth;
      Duration duration = Duration(milliseconds: (distance / speed * 1000).round());
      _controller.stop();
      _controller.duration = duration;
      if (_showBoat) _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double parentWidth = constraints.maxWidth;
        double parentHeight = constraints.maxHeight;

        _updateControllerDuration(parentWidth);

        return Stack(
          children: [
            if (_showBoat)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double dx = _controller.value * (parentWidth - shipWidth);
                  bool goingRight = _controller.status == AnimationStatus.forward;
                  double scaleX = goingRight ? 1.0 : -1.0;
                  double tilt = math.sin(_controller.value * 2 * math.pi * 8) * 0.10;

                  return Positioned(
                    left: dx,
                    top: (parentHeight - shipWidth) / 2,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(scaleX, 1.0)
                        ..rotateZ(tilt),
                      child: child,
                    ),
                  );
                },
                child: ImageIcon(
                  AssetImage('resources/ship.png'),
                  size: shipWidth,
                ),
              ),
          ],
        );
      },
    );
  }
}
