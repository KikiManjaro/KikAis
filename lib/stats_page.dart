import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'boatmanager.dart';
import 'feed_def.dart';
import 'message_stats.dart';
import 'themes.dart';
import 'widgets.dart';

const Map<int, String> kMessageTypeLabels = {
  1: 'Position Class A',
  2: 'Position Class A (assigned)',
  3: 'Position Class A (response)',
  4: 'Base Station',
  5: 'Static & Voyage',
  6: 'Binary Addressed',
  7: 'Binary Acknowledge',
  8: 'Binary Broadcast',
  9: 'SAR Aircraft Position',
  10: 'UTC/Date Inquiry',
  11: 'UTC/Date Response',
  12: 'Addressed Safety',
  13: 'Safety Acknowledge',
  14: 'Safety Broadcast',
  15: 'Interrogation',
  16: 'Assignment Mode',
  17: 'DGNSS Broadcast',
  18: 'Class B Position',
  19: 'Class B Extended',
  20: 'Data Link Mgmt',
  21: 'Aid to Navigation',
  22: 'Channel Mgmt',
  23: 'Group Assignment',
  24: 'Static Data',
  25: 'Single Slot Binary',
  26: 'Multiple Slot Binary',
  27: 'Long Range Position',
};

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
    final rate = filter == null
        ? stats.messagesPerSecond
        : (stats.rateByFeed[filter] ?? 0);
    final byType = filter == null
        ? stats.byType
        : (stats.byTypePerFeed[filter] ?? const <int, int>{});

    final maxType = byType.values.fold<int>(0, (m, v) => v > m ? v : m);
    final appColors =
        Theme.of(context).extension<AppColors>() ?? AppColors.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
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
            tooltip: boatManager.decodeEnabled
                ? 'Decoding is on - pause decoding'
                : 'Decoding is off - resume decoding',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              stats.reset();
              boatManager.resetCounters();
            },
            tooltip: 'Reset counters',
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
              decoration: const InputDecoration(
                labelText: 'Feed',
                isDense: true,
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All feeds'),
                ),
                for (final f in feeds)
                  DropdownMenuItem<String?>(value: f, child: Text(f)),
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
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 104,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                children: [
                  _KpiCard(
                    label: 'Received',
                    value: received.toDouble(),
                    icon: Icons.south,
                    accent: appColors.info,
                    tooltip: 'NMEA sentences received from the feeds',
                  ),
                  _KpiCard(
                    label: 'Decoded',
                    value: decoded.toDouble(),
                    icon: Icons.check_circle_outline,
                    accent: appColors.success,
                    tooltip: 'Messages successfully decoded',
                  ),
                  _KpiCard(
                    label: 'Rate',
                    value: rate,
                    decimals: 1,
                    icon: Icons.speed,
                    accent: appColors.warning,
                    live: rate > 0,
                    tooltip: 'Received messages per second',
                  ),
                  _KpiCard(
                    label: 'Invalid checksums',
                    value: boatManager.invalidChecksumCount.toDouble(),
                    icon: Icons.error_outline,
                    accent: appColors.danger,
                    subtitle: filter == null ? null : '(all feeds)',
                    tooltip: 'Sentences dropped due to a bad checksum',
                  ),
                  _KpiCard(
                    label: 'Dropped fragments',
                    value: boatManager.droppedFragmentCount.toDouble(),
                    icon: Icons.call_split,
                    accent: appColors.info,
                    subtitle: filter == null ? null : '(all feeds)',
                    tooltip: 'Incomplete multi-part sentences that were dropped',
                  ),
                  _KpiCard(
                    label: 'Parse errors',
                    value: boatManager.parseErrorCount.toDouble(),
                    icon: Icons.bug_report_outlined,
                    accent: appColors.danger,
                    subtitle: filter == null ? null : '(all feeds)',
                    tooltip: 'Sentences that failed to decode',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'By message type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (byType.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No decoded messages yet')),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final entry in byType.entries.toList()
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
                                  kMessageTypeLabels[entry.key] ??
                                      'Type ${entry.key}',
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
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
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
              filter == null ? 'By feed' : 'Feed: $filter',
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
                        child: Text(
                          filter,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('${stats.byFeed[filter] ?? 0}'),
                    ],
                  ),
                ),
              )
            else if (stats.byFeed.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text('No feed activity yet')),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      for (final entry in stats.byFeed.entries.toList()
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

class _KpiCard extends StatelessWidget {
  final String label;
  final double value;
  final int decimals;
  final IconData icon;
  final Color accent;
  final String? subtitle;
  final bool live;
  final String tooltip;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    required this.tooltip,
    this.decimals = 0,
    this.subtitle,
    this.live = false,
  });

  String _format(double v) => decimals == 0
      ? _group(v.round())
      : v.toStringAsFixed(decimals);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: TintedCard(
        accent: accent,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AccentBadge(icon: icon, accent: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: 2),
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
                        const Spacer(),
                        _PulseDot(color: accent, size: 7),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
