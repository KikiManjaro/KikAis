import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

/// Identifier of the painted pointer, for widget tests.
const Key tourCursorKey = ValueKey('tour-cursor');

const double _titleBarStripHeight = 32;

/// Drives the fake cursor shown during the guided tour.
///
/// The cursor only *shows* what to do: it glides to the target and pulses as
/// if clicking. Real input is injected by the tour itself where it is safe
/// (tab navigation), never through the cursor.
class TourCursorController extends ChangeNotifier {
  Offset? _position;
  bool _visible = false;
  int _clicks = 0;
  int _frontRequests = 0;

  /// Current cursor position in global coordinates, or null before the first
  /// move.
  Offset? get position => _position;

  /// Whether the cursor should be shown.
  bool get visible => _visible;

  /// Number of pulses requested so far; the widget fires one ripple per bump.
  int get clicks => _clicks;

  /// Incremented when the cursor must be moved above the tour overlay.
  int get frontRequests => _frontRequests;

  void hide() {
    if (!_visible) return;
    _visible = false;
    notifyListeners();
  }

  /// Glides the cursor to [target] (global coordinates).
  void moveTo(Offset target) {
    if (_position == target && _visible) return;
    _position = target;
    _visible = true;
    notifyListeners();
  }

  /// Plays one click ripple at the current position.
  void click() {
    _clicks++;
    notifyListeners();
  }

  /// Asks the host to re-insert the overlay above the tour's own overlay.
  void bringToFront() {
    _frontRequests++;
    notifyListeners();
  }
}

/// Keeps the cursor overlay in sync with [controller].
///
/// The overlay entry is inserted on first use and re-inserted above the
/// showcase overlay when asked. The animation state lives here, not in the
/// entry, so re-inserting never resets a glide in progress.
class TourCursorHost extends StatefulWidget {
  final TourCursorController controller;
  final bool Function() canDragWindow;

  const TourCursorHost({
    super.key,
    required this.controller,
    this.canDragWindow = _allowDrag,
  });

  @override
  State<TourCursorHost> createState() => _TourCursorHostState();
}

bool _allowDrag() => true;

class _TourCursorHostState extends State<TourCursorHost>
    with TickerProviderStateMixin {
  static const Duration _moveDuration = Duration(milliseconds: 380);
  static const Duration _pulseDuration = Duration(milliseconds: 320);

  late final AnimationController _move = AnimationController(
    vsync: this,
    duration: _moveDuration,
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: _pulseDuration,
  );

  OverlayEntry? _entry;
  int _seenFront = 0;
  int _seenClicks = 0;
  Offset _from = Offset.zero;
  Offset _to = Offset.zero;

  @override
  void initState() {
    super.initState();
    _seenClicks = widget.controller.clicks;
    final start = widget.controller.position;
    if (start != null) {
      _from = start;
      _to = start;
    }
    widget.controller.addListener(_sync);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    _removeEntry();
    _move.dispose();
    _pulse.dispose();
    super.dispose();
  }

  void _sync() {
    if (!mounted) return;
    if (!widget.controller.visible) {
      _removeEntry();
      return;
    }
    final target = widget.controller.position;
    if (target != null && target != _to) {
      _from = _currentOffset;
      _to = target;
      _move.forward(from: 0);
    }
    if (widget.controller.clicks != _seenClicks) {
      _seenClicks = widget.controller.clicks;
      _pulse.forward(from: 0);
    }
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_entry == null) {
      _entry = OverlayEntry(builder: (_) => _buildOverlay());
      overlay.insert(_entry!);
      _seenFront = widget.controller.frontRequests;
      return;
    }
    if (widget.controller.frontRequests != _seenFront) {
      _seenFront = widget.controller.frontRequests;
      // Overlay entries are painted in insertion order: re-insert to sit above
      // the showcase overlay the tour inserts before each step.
      _entry!.remove();
      overlay.insert(_entry!);
    }
  }

  Offset get _currentOffset =>
      Offset.lerp(_from, _to, Curves.easeOutCubic.transform(_move.value))!;

  Widget _buildOverlay() {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: Listenable.merge([_move, _pulse]),
                builder: (context, _) => _CursorPaint(
                  position: _currentOffset,
                  pulse: _pulse.isAnimating ? _pulse.value : 1.0,
                ),
              ),
            ),
          ),
          if (widget.canDragWindow())
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _titleBarStripHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (_) => appWindow.startDragging(),
              ),
            ),
        ],
      ),
    );
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _CursorPaint extends StatelessWidget {
  final Offset position;
  final double pulse;

  const _CursorPaint({required this.position, required this.pulse});

  static const double _cursorSize = 22;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final pos = Offset(
      position.dx.clamp(0.0, screen.width - _cursorSize),
      position.dy.clamp(0.0, screen.height - _cursorSize),
    );
    final scheme = Theme.of(context).colorScheme;
    final t = pulse;
    return Stack(
      children: [
        if (t < 1)
          Positioned(
            left: pos.dx - 26 * t,
            top: pos.dy - 26 * t,
            child: Opacity(
              opacity: (1 - t).clamp(0.0, 1.0),
              child: Container(
                width: 52 * t,
                height: 52 * t,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.7),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: CustomPaint(
            key: tourCursorKey,
            size: const Size(14, 22),
            painter: _PointerPainter(
              fill: scheme.surface,
              stroke: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

/// Classic arrow pointer, tip at the top-left corner of its box.
class _PointerPainter extends CustomPainter {
  final Color fill;
  final Color stroke;

  _PointerPainter({required this.fill, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 19)
      ..lineTo(4.6, 14.2)
      ..lineTo(8.2, 21)
      ..lineTo(11.4, 19.4)
      ..lineTo(7.8, 12.6)
      ..lineTo(13.6, 12.6)
      ..close();
    canvas.drawShadow(path, Colors.black, 3, true);
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(_PointerPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}
