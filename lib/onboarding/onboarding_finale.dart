import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../l10n_ext.dart';

void showOnboardingFinale(BuildContext context) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _FinaleView(
      onClosed: () {
        if (entry.mounted) entry.remove();
      },
    ),
  );
  overlay.insert(entry);
}

class _Confetto {
  final double x;
  final double delay;
  final double speed;
  final double drift;
  final double size;
  final double spin;
  final Color color;

  const _Confetto({
    required this.x,
    required this.delay,
    required this.speed,
    required this.drift,
    required this.size,
    required this.spin,
    required this.color,
  });
}

class _FinaleView extends StatefulWidget {
  final VoidCallback onClosed;

  const _FinaleView({required this.onClosed});

  @override
  State<_FinaleView> createState() => _FinaleViewState();
}

class _FinaleViewState extends State<_FinaleView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  )..forward();
  late final List<_Confetto> _confetti = _buildConfetti();
  Timer? _autoClose;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    _autoClose = Timer(const Duration(seconds: 6), _close);
  }

  @override
  void dispose() {
    _autoClose?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    if (_closed) return;
    _closed = true;
    widget.onClosed();
  }

  List<_Confetto> _buildConfetti() {
    final random = math.Random(7);
    final colors = <Color>[
      const Color(0xFF4FC3F7),
      const Color(0xFF81C784),
      const Color(0xFFFFB74D),
      const Color(0xFFE57373),
      const Color(0xFFBA68C8),
      const Color(0xFFFFF176),
    ];
    return List.generate(70, (i) {
      return _Confetto(
        x: random.nextDouble(),
        delay: random.nextDouble() * 0.45,
        speed: 0.55 + random.nextDouble() * 0.9,
        drift: (random.nextDouble() - 0.5) * 0.35,
        size: 4 + random.nextDouble() * 6,
        spin: (random.nextDouble() - 0.5) * 12,
        color: colors[i % colors.length],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _close,
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => CustomPaint(
                    painter: _ConfettiPainter(
                      progress: _controller.value,
                      confetti: _confetti,
                      accent: scheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final t = (_controller.value / 0.25).clamp(0.0, 1.0);
                  final scale = Curves.easeOutBack.transform(t);
                  return Opacity(
                    opacity: t,
                    child: Transform.scale(
                      scale: 0.85 + 0.15 * scale,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.fromLTRB(28, 26, 28, 18),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.primary.withValues(alpha: 0.5),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 30,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.celebration, size: 40, color: scheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        l10n.onboardingFinaleTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.onboardingFinaleBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _close,
                        child: Text(l10n.onboardingFinaleClose),
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

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final List<_Confetto> confetti;
  final Color accent;

  const _ConfettiPainter({
    required this.progress,
    required this.confetti,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final c in confetti) {
      final t = progress - c.delay;
      if (t <= 0) continue;
      final life = (t / (1 - c.delay)).clamp(0.0, 1.0);
      final x = (c.x + c.drift * life) * size.width;
      final y = (-0.05 + c.speed * life * 1.15) * size.height;
      if (y > size.height + 20) continue;
      paint.color = c.color.withValues(alpha: (1 - life).clamp(0.0, 1.0));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(c.spin * life);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: c.size,
            height: c.size * 0.55,
          ),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }

    for (final delay in const [0.02, 0.3]) {
      final t = progress - delay;
      if (t <= 0) continue;
      final life = (t / (1 - delay)).clamp(0.0, 1.0);
      final center = Offset(size.width / 2, size.height * 0.42);
      paint.color = accent.withValues(alpha: (1 - life) * 0.8);
      for (var i = 0; i < 14; i++) {
        final angle = (i / 14) * math.pi * 2;
        final radius = 20 + 220 * Curves.easeOut.transform(life);
        canvas.drawCircle(
          center + Offset(math.cos(angle), math.sin(angle)) * radius,
          3 * (1 - life) + 1,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.accent != accent;
}
