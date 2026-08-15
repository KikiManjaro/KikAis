import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boatmanager.dart';
import 'feed_def.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n_ext.dart';
import 'message_stats.dart';
import 'themes.dart';
import 'widgets.dart';

/// Localized name of an AIS message type (ITU-R M.1371, types 1-27).
String messageTypeLabel(int type, AppLocalizations l10n) {
  final label = switch (type) {
    1 => l10n.msgType1,
    2 => l10n.msgType2,
    3 => l10n.msgType3,
    4 => l10n.msgType4,
    5 => l10n.msgType5,
    6 => l10n.msgType6,
    7 => l10n.msgType7,
    8 => l10n.msgType8,
    9 => l10n.msgType9,
    10 => l10n.msgType10,
    11 => l10n.msgType11,
    12 => l10n.msgType12,
    13 => l10n.msgType13,
    14 => l10n.msgType14,
    15 => l10n.msgType15,
    16 => l10n.msgType16,
    17 => l10n.msgType17,
    18 => l10n.msgType18,
    19 => l10n.msgType19,
    20 => l10n.msgType20,
    21 => l10n.msgType21,
    22 => l10n.msgType22,
    23 => l10n.msgType23,
    24 => l10n.msgType24,
    25 => l10n.msgType25,
    26 => l10n.msgType26,
    27 => l10n.msgType27,
    _ => null,
  };
  return label ?? l10n.statsTypeFallback(type);
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String? _feedFilter;

  List<String> _availableFeeds(MessageStats stats, AppSettings settings) {
    final feeds = <String>{
      ...stats.byFeed.keys,
      ...stats.byFeedDecoded.keys,
      for (final f in kFeedDefs) f.displayName,
      for (final f in settings.customFeeds) f.displayName,
    }.toList()..sort();
    return feeds;
  }

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<MessageStats>();
    final boatManager = context.watch<BoatManager>();
    final settings = context.read<AppSettings>();

    final feeds = _availableFeeds(stats, settings);
    if (_feedFilter != null && !feeds.contains(_feedFilter)) {
      _feedFilter = null;
    }
    final filter = _feedFilter;

    final received = filter == null
        ? stats.totalReceived
        : (stats.byFeed[filter] ?? 0);
    final decoded = filter == null
        ? stats.totalDecoded
        : (stats.byFeedDecoded[filter] ?? 0);
    final decodedRate = stats.decodedHistory.isEmpty
        ? 0.0
        : stats.decodedHistory.last;
    final fragmentsSeen = boatManager.fragmentsSeen;
    final multiPartCompleted = boatManager.multiPartCompleted;
    final pending = boatManager.pendingFragmentCount;
    final dropped = boatManager.droppedFragmentCount;
    final multiOverhead = math.max(
      0,
      fragmentsSeen - multiPartCompleted - pending - dropped,
    );
    final byType = filter == null
        ? stats.byType
        : (stats.byTypePerFeed[filter] ?? const <int, int>{});

    final maxType = byType.values.fold<int>(0, (m, v) => v > m ? v : m);
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.statsTitle),
        actions: [
          HoverTooltip(
            message: context.l10n.tooltipStatsDecode,
            child: IconButton(
              icon: Icon(
                boatManager.decodeEnabled ? Icons.track_changes : Icons.pause,
                color: boatManager.decodeEnabled
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: () {
                final next = !boatManager.decodeEnabled;
                boatManager.setDecodeEnabled(next);
                settings.decodeEnabled = next;
                settings.save();
              },
            ),
          ),
          HoverTooltip(
            message: context.l10n.tooltipStatsReset,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                stats.reset();
                boatManager.resetCounters();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String?>(
              initialValue: filter,
              mouseCursor: WidgetStateMouseCursor.clickable,
              decoration: InputDecoration(
                labelText: context.l10n.statsFeed,
                isDense: true,
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(context.l10n.statsAllFeeds),
                ),
                for (final f in feeds)
                  DropdownMenuItem<String?>(
                    value: f,
                    child: _FeedOption(
                      name: f,
                      hasData:
                          stats.byFeed.containsKey(f) ||
                          stats.byFeedDecoded.containsKey(f),
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => _feedFilter = v),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: GridView(
                key: ValueKey<String?>('kpi-$filter'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 280,
                  mainAxisExtent: 176,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                children: [
                  _KpiCard(
                    label: context.l10n.statsReceived,
                    value: received.toDouble(),
                    icon: Icons.south,
                    accent: appColors.info,
                    subtitle: filter == null
                        ? context.l10n.statsPerSecond(
                            stats.messagesPerSecond.toStringAsFixed(1),
                          )
                        : context.l10n.statsAllFeedsShort,
                    live: stats.messagesPerSecond > 0,
                    chart: _MiniLineChart(
                      data: stats.rateHistory,
                      color: appColors.info,
                      collectingLabel: context.l10n.statsCollecting,
                    ),
                  ),
                  _KpiCard(
                    label: context.l10n.statsDecoded,
                    value: decoded.toDouble(),
                    icon: Icons.check_circle_outline,
                    accent: appColors.success,
                    subtitle: filter == null
                        ? context.l10n.statsPerSecond(
                            decodedRate.toStringAsFixed(1),
                          )
                        : context.l10n.statsAllFeedsShort,
                    live: decodedRate > 0,
                    chart: _MiniLineChart(
                      data: stats.decodedHistory,
                      color: appColors.success,
                      collectingLabel: context.l10n.statsCollecting,
                    ),
                  ),
                  _KpiCard(
                    label: context.l10n.statsInvalidChecksums,
                    value: boatManager.invalidChecksumCount.toDouble(),
                    icon: Icons.error_outline,
                    accent: appColors.danger,
                    subtitle: filter == null
                        ? null
                        : context.l10n.statsAllFeedsShort,
                  ),
                  _KpiCard(
                    label: context.l10n.statsDroppedFragments,
                    value: boatManager.droppedFragmentCount.toDouble(),
                    icon: Icons.call_split,
                    accent: appColors.info,
                    subtitle: filter == null
                        ? null
                        : context.l10n.statsAllFeedsShort,
                  ),
                  _KpiCard(
                    label: context.l10n.statsParseErrors,
                    value: boatManager.parseErrorCount.toDouble(),
                    icon: Icons.bug_report_outlined,
                    accent: appColors.danger,
                    subtitle: filter == null
                        ? null
                        : context.l10n.statsAllFeedsShort,
                  ),
                  _KpiCard(
                    label: context.l10n.statsPendingFragments,
                    value: boatManager.pendingFragmentCount.toDouble(),
                    icon: Icons.hourglass_bottom,
                    accent: appColors.warning,
                    live: boatManager.pendingFragmentCount > 0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.statsReceivedVsDecoded,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _LegendDot(color: appColors.info),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.statsReceived,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        _LegendDot(color: appColors.success),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.statsDecoded,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          filter == null
                              ? context.l10n.statsPerSecondLabel
                              : context.l10n.statsAllFeedsShort,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _DualLineChart(
                      received: stats.rateHistory,
                      decoded: stats.decodedHistory,
                      collectingLabel: context.l10n.statsCollecting,
                    ),
                  ],
                ),
              ),
            ),
            if (filter == null) ...[
              const SizedBox(height: 16),
              Text(
                context.l10n.statsAccounting,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _ReconciliationCard(
                received: received,
                decoded: decoded,
                invalid: boatManager.invalidChecksumCount,
                parseErrors: boatManager.parseErrorCount,
                multiOverhead: multiOverhead,
                pending: pending,
                dropped: dropped,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              context.l10n.statsByMessageType,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (byType.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: Text(context.l10n.statsNoDecodedYet)),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final entry
                          in byType.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value)))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  'T${entry.key}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  messageTypeLabel(entry.key, context.l10n),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: maxType == 0
                                        ? 0
                                        : entry.value / maxType,
                                    minHeight: 10,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 56,
                                child: Text(
                                  '${entry.value}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              filter == null
                  ? context.l10n.statsByFeed
                  : context.l10n.statsFeedFilter(filter),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (filter != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(filter, overflow: TextOverflow.ellipsis),
                      ),
                      Text('${stats.byFeed[filter] ?? 0}'),
                    ],
                  ),
                ),
              )
            else if (stats.byFeed.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: Text(context.l10n.statsNoActivityYet)),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final entry
                          in stats.byFeed.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value)))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(entry.value.toString()),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedOption extends StatelessWidget {
  final String name;
  final bool hasData;

  const _FeedOption({required this.name, required this.hasData});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: hasData ? scheme.primary : Colors.transparent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: hasData
                ? const TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color accent;
  final String? subtitle;
  final bool live;
  final Widget? chart;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.subtitle,
    this.live = false,
    this.chart,
  });

  String _format(double v) => _group(v.round());

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return TintedCard(
      accent: accent,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AccentBadge(icon: icon, accent: accent),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: value),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => Text(
                        _format(v),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(width: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 10,
                              color: textColor.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                        if (live) ...[
                          const SizedBox(width: 6),
                          _PulseDot(color: accent, size: 7),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (chart != null) ...[
            const SizedBox(height: 10),
            Expanded(child: chart!),
          ],
        ],
      ),
    );
  }

  static String _group(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      buffer.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buffer.write('\u2009');
    }
    return buffer.toString();
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulseDot({required this.color, required this.size});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.35).animate(_controller),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

/// Overlaid lines comparing received and decoded rates over the last 60 s.
class _DualLineChart extends StatelessWidget {
  final List<double> received;
  final List<double> decoded;
  final String collectingLabel;

  const _DualLineChart({
    required this.received,
    required this.decoded,
    required this.collectingLabel,
  });

  @override
  Widget build(BuildContext context) {
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    return SizedBox(
      height: 130,
      child: CustomPaint(
        size: Size.infinite,
        painter: _DualLinePainter(
          received: received,
          decoded: decoded,
          receivedColor: appColors.info,
          decodedColor: appColors.success,
          collectingLabel: collectingLabel,
        ),
      ),
    );
  }
}

class _DualLinePainter extends CustomPainter {
  final List<double> received;
  final List<double> decoded;
  final Color receivedColor;
  final Color decodedColor;
  final String collectingLabel;

  _DualLinePainter({
    required this.received,
    required this.decoded,
    required this.receivedColor,
    required this.decodedColor,
    required this.collectingLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (received.length < 2 && decoded.length < 2) {
      final painter = TextPainter(
        text: TextSpan(
          text: collectingLabel,
          style: TextStyle(
            fontSize: 10,
            color: receivedColor.withValues(alpha: 0.6),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(
          (size.width - painter.width) / 2,
          (size.height - painter.height) / 2,
        ),
      );
      return;
    }

    double maxOf(List<double> data) => data.fold(0.0, (m, v) => v > m ? v : m);
    final maxV = math.max(maxOf(received), maxOf(decoded));
    final top = maxV == 0 ? 1.0 : maxV;
    final left = 2.0;
    final right = size.width - 2;
    final bottom = size.height - 2;
    final topY = 3.0;

    Offset point(List<double> data, int i) {
      final x = left + (right - left) * (i / (data.length - 1));
      final y = bottom - (bottom - topY) * (data[i] / top);
      return Offset(x, y);
    }

    void drawSeries(List<double> data, Color color) {
      if (data.length < 2) return;
      final path = Path();
      for (var i = 0; i < data.length; i++) {
        final p = point(data, i);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      final fill = Path.from(path)
        ..lineTo(right, bottom)
        ..lineTo(left, bottom)
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.25),
              color.withValues(alpha: 0.02),
            ],
          ).createShader(Offset.zero & size),
      );
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }

    drawSeries(received, receivedColor);
    drawSeries(decoded, decodedColor);
  }

  @override
  bool shouldRepaint(_DualLinePainter oldDelegate) =>
      oldDelegate.received.length != received.length ||
      oldDelegate.decoded.length != decoded.length ||
      (received.isNotEmpty &&
          oldDelegate.received.isNotEmpty &&
          oldDelegate.received.last != received.last) ||
      (decoded.isNotEmpty &&
          oldDelegate.decoded.isNotEmpty &&
          oldDelegate.decoded.last != decoded.last);
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Exact accounting of the received/decoded counters.
class _ReconciliationCard extends StatelessWidget {
  final int received;
  final int decoded;
  final int invalid;
  final int parseErrors;
  final int multiOverhead;
  final int pending;
  final int dropped;

  const _ReconciliationCard({
    required this.received,
    required this.decoded,
    required this.invalid,
    required this.parseErrors,
    required this.multiOverhead,
    required this.pending,
    required this.dropped,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final sum =
        decoded + invalid + parseErrors + multiOverhead + pending + dropped;
    final balanced = sum == received;

    Widget row(IconData icon, Color color, String label, int value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
            Text(
              _KpiCard._group(value),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.statsReceivedAmountEquals(
                _KpiCard._group(received),
                _KpiCard._group(sum),
              ),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            row(
              Icons.check_circle_outline,
              appColors.success,
              context.l10n.statsDecoded,
              decoded,
            ),
            row(
              Icons.error_outline,
              appColors.danger,
              context.l10n.statsInvalidChecksums,
              invalid,
            ),
            row(
              Icons.bug_report_outlined,
              appColors.danger,
              context.l10n.statsParseErrors,
              parseErrors,
            ),
            row(
              Icons.call_split,
              appColors.info,
              context.l10n.statsMultiPartParts,
              multiOverhead,
            ),
            row(
              Icons.hourglass_bottom,
              appColors.warning,
              context.l10n.statsPending,
              pending,
            ),
            row(
              Icons.delete_outline,
              appColors.warning,
              context.l10n.statsDropped,
              dropped,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  balanced ? Icons.check_circle : Icons.info_outline,
                  size: 14,
                  color: balanced ? appColors.success : appColors.warning,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    balanced
                        ? context.l10n.statsReconcile
                        : context.l10n.statsGapPaused,
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Sparkline for the rate history.
class _MiniLineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final String collectingLabel;

  const _MiniLineChart({
    required this.data,
    required this.color,
    required this.collectingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _MiniLinePainter(
        data: data,
        color: color,
        collectingLabel: collectingLabel,
      ),
    );
  }
}

class _MiniLinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final String collectingLabel;

  _MiniLinePainter({
    required this.data,
    required this.color,
    required this.collectingLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) {
      final painter = TextPainter(
        text: TextSpan(
          text: collectingLabel,
          style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.6)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(
          (size.width - painter.width) / 2,
          (size.height - painter.height) / 2,
        ),
      );
      return;
    }

    final maxV = data.fold(0.0, (m, v) => v > m ? v : m);
    final top = maxV == 0 ? 1.0 : maxV;
    final left = 2.0;
    final right = size.width - 2;
    final bottom = size.height - 2;
    final topY = 3.0;

    Offset point(int i) {
      final x = left + (right - left) * (i / (data.length - 1));
      final y = bottom - (bottom - topY) * (data[i] / top);
      return Offset(x, y);
    }

    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final p = point(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    final fill = Path.from(path)
      ..lineTo(right, bottom)
      ..lineTo(left, bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.02)],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = color,
    );

    final last = point(data.length - 1);
    canvas.drawCircle(last, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MiniLinePainter oldDelegate) =>
      oldDelegate.data.length != data.length ||
      (data.isNotEmpty && oldDelegate.data.last != data.last);
}
