import 'dart:math' as math;

import 'package:flutter/material.dart';

class BoatAnimationController extends ChangeNotifier {
  bool _active = false;
  bool get active => _active;

  void start() {
    _active = true;
    notifyListeners();
  }

  void stop() {
    _active = false;
    notifyListeners();
  }
}

class BoatAnimation extends StatefulWidget {
  final BoatAnimationController controller;

  const BoatAnimation({super.key, required this.controller});

  @override
  State<BoatAnimation> createState() => _BoatAnimationState();
}

class _BoatAnimationState extends State<BoatAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _lastParentWidth = 0;
  final double shipWidth = 22;
  final double speed = 30;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    widget.controller.addListener(_onControllerChanged);
    _onControllerChanged();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {
      if (widget.controller.active) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    });
  }

  void _updateControllerDuration(double parentWidth) {
    if (parentWidth != _lastParentWidth) {
      _lastParentWidth = parentWidth;
      double distance = parentWidth - shipWidth;
      Duration duration = Duration(
        milliseconds: (distance / speed * 1000).round(),
      );
      _controller.stop();
      _controller.duration = duration;
      if (widget.controller.active) _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
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
            if (widget.controller.active)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double dx = _controller.value * (parentWidth - shipWidth);
                  bool goingRight =
                      _controller.status == AnimationStatus.forward;
                  double scaleX = goingRight ? 1.0 : -1.0;
                  double tilt = math.sin(
                        _controller.value * 2 * math.pi * 8,
                      ) *
                      0.10;

                  return Positioned(
                    left: dx,
                    top: (parentHeight - shipWidth) / 2,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scaleByDouble(scaleX, 1.0, 1.0, 1.0)
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
