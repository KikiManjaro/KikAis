import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n_ext.dart';

/// A hover tooltip that does NOT use Flutter's built-in [Tooltip] widget.
///
/// The stock tooltip triggers a NULL_PTR_READ crash in the Windows engine
/// (`UpdateTooltipPosition`, see flutter/flutter#182444) whenever a hover
/// tooltip shows or dismisses. This implementation drives its own overlay
/// entry from a [MouseRegion], so it never touches that engine code path.
class HoverTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  /// Delay before the tooltip appears once the pointer is over the child.
  final Duration delay;

  const HoverTooltip({
    super.key,
    required this.message,
    required this.child,
    this.delay = const Duration(milliseconds: 500),
  });

  @override
  State<HoverTooltip> createState() => _HoverTooltipState();
}

class _HoverTooltipState extends State<HoverTooltip> {
  final GlobalKey _targetKey = GlobalKey();
  Timer? _timer;
  OverlayEntry? _entry;
  bool _shown = false;

  void _onEnter(PointerEnterEvent event) {
    _timer?.cancel();
    _timer = Timer(widget.delay, _show);
  }

  void _onExit(PointerExitEvent event) {
    _timer?.cancel();
    _hide();
  }

  void _show() {
    if (!mounted || _shown || _entry != null) return;
    final box = _targetKey.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context, rootOverlay: true);
    if (box == null || !box.attached) return;
    final anchor = box.localToGlobal(Offset.zero);
    _shown = true;
    _entry = OverlayEntry(
      builder: (context) => _HoverTooltipOverlay(
        message: widget.message,
        anchorTopLeft: anchor,
        anchorSize: box.size,
      ),
    );
    overlay.insert(_entry!);
  }

  void _hide() {
    _shown = false;
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.message,
      tooltip: widget.message,
      child: MouseRegion(
        key: _targetKey,
        onEnter: _onEnter,
        onExit: _onExit,
        child: widget.child,
      ),
    );
  }
}

/// The tooltip bubble shown by [HoverTooltip], positioned under its anchor and
/// clamped to the screen edges. Uses a plain [Positioned] in the app overlay.
class _HoverTooltipOverlay extends StatefulWidget {
  final String message;
  final Offset anchorTopLeft;
  final Size anchorSize;

  const _HoverTooltipOverlay({
    required this.message,
    required this.anchorTopLeft,
    required this.anchorSize,
  });

  @override
  State<_HoverTooltipOverlay> createState() => _HoverTooltipOverlayState();
}

class _HoverTooltipOverlayState extends State<_HoverTooltipOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  )..forward();

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final screen = MediaQuery.sizeOf(context);
    final maxWidth = math.min(360.0, screen.width - 24);
    final centerX = widget.anchorTopLeft.dx + widget.anchorSize.width / 2;
    // Clamp so the (centered) bubble stays fully on screen.
    final left = centerX.clamp(
      maxWidth / 2 + 12,
      screen.width - maxWidth / 2 - 12,
    );
    // Place below the anchor, or above it when near the bottom edge.
    final placeBelow = widget.anchorTopLeft.dy < screen.height * 0.6;
    final top = placeBelow
        ? widget.anchorTopLeft.dy + widget.anchorSize.height + 6
        : widget.anchorTopLeft.dy - 10;

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: FractionalTranslation(
          translation: const Offset(-0.5, 0),
          child: FadeTransition(
            opacity: _fade,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
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
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
              style: TextStyle(fontSize: 12, color: scheme.onInverseSurface),
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
  final String? message;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const CopyIconButton({
    super.key,
    required this.text,
    this.message,
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
      builder: (_) => MiniToast(
        message: message ?? context.l10n.copied,
        anchorBottomCenter: anchor,
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HoverTooltip(
      message: context.l10n.tooltipCopy,
      child: IconButton(
        icon: Icon(Icons.copy, size: iconSize),
        visualDensity: VisualDensity.compact,
        padding: padding,
        onPressed: () => _copy(context),
      ),
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
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          ?trailing,
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
