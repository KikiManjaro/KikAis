import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoatAnimation extends StatefulWidget {
  @override
  _BoatAnimationState createState() => _BoatAnimationState();
}

class _BoatAnimationState extends State<BoatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _lastParentWidth = 0;
  final double shipWidth = 30;
  final double speed = 30; // pixels per second

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(
      reverse: true,
      period: const Duration(seconds: 6), // explicitly set period
    );

  }

  void _updateControllerDuration(double parentWidth) {
    if (parentWidth != _lastParentWidth) {
      _lastParentWidth = parentWidth;
      double distance = parentWidth - shipWidth;
      Duration duration = Duration(milliseconds: (distance / speed * 1000).round());
      _controller.stop();
      _controller.duration = duration;
      _controller.repeat(reverse: true);
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

        // Update animation speed based on parent width
        _updateControllerDuration(parentWidth);

        return Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double dx = _controller.value * (parentWidth - shipWidth);

                bool goingRight = _controller.status == AnimationStatus.forward;
                double scaleX = goingRight ? 1.0 : -1.0;

                double tiltSpeed = 4;
                double tilt =
                    math.sin(_controller.value * 2 * math.pi * tiltSpeed) * 0.10;

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
