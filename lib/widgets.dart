import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A tiny toast anchored next to a button ("Copied!"). Rendered in the app
/// overlay so it floats above the current page.
class MiniToast extends StatefulWidget {
  final String message;
  final Offset anchorBottomCenter;

  const MiniToast({
    super.key,
    required this.message,
    required this.anchorBottomCenter,
  });

  @override
  State<MiniToast> createState() => _MiniToastState();
}

class _MiniToastState extends State<MiniToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      left: widget.anchorBottomCenter.dx,
      top: widget.anchorBottomCenter.dy + 6,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.inverseSurface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 6),
              ],
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onInverseSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A compact copy button that copies [text] and shows a [MiniToast] right
/// next to it.
class CopyIconButton extends StatelessWidget {
  final String text;
  final String? tooltip;
  final String message;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const CopyIconButton({
    super.key,
    required this.text,
    this.tooltip = 'Copy',
    this.message = 'Copied',
    this.iconSize = 16,
    this.padding,
  });

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final pos = box.localToGlobal(Offset.zero);
    final anchor = Offset(
      pos.dx + box.size.width / 2,
      pos.dy + box.size.height,
    );
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => MiniToast(message: message, anchorBottomCenter: anchor),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.copy, size: iconSize),
      visualDensity: VisualDensity.compact,
      padding: padding,
      onPressed: () => _copy(context),
      tooltip: tooltip,
    );
  }
}

/// A fixed-height section header with an icon, a title and an optional
/// trailing action. Using the same height everywhere keeps side-by-side
/// sections perfectly aligned.
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// A rounded container tinted with [accent] at low opacity with a matching
/// border — the "KPI card" look, reusable everywhere.
class TintedCard extends StatelessWidget {
  final Color accent;
  final Widget child;
  final EdgeInsetsGeometry padding;

  const TintedCard({
    super.key,
    required this.accent,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      padding: padding,
      child: child,
    );
  }
}

/// A rounded square badge with an icon, tinted with [accent].
class AccentBadge extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final double size;

  const AccentBadge({
    super.key,
    required this.icon,
    required this.accent,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: accent, size: size * 0.55),
    );
  }
}
