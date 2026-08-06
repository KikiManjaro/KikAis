import 'package:flutter/material.dart';

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
