import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'feed_def.dart';
import 'l10n_ext.dart';

/// First-run wizard: language → feed selection → ready.
///
/// Shown when [AppSettings.onboardingSeen] is false and no feed has ever
/// been enabled. Covers ROADMAP P3.2.
class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});

  /// Shows the dialog if onboarding is needed. Returns true when completed.
  static Future<bool> showIfNeeded(BuildContext context) async {
    final settings = context.read<AppSettings>();
    if (settings.onboardingSeen) return false;
    final hasEnabled = settings.feedEnabled.values.any((v) => v);
    if (hasEnabled) {
      await settings.setOnboardingSeen(true);
      return false;
    }
    if (!context.mounted) return false;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const OnboardingDialog(),
    );
    return result ?? false;
  }

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  int _step = 0;
  String? _pendingLocale;
  late Map<String, bool> _pendingFeeds;

  @override
  void initState() {
    super.initState();
    final s = context.read<AppSettings>();
    _pendingLocale = s.localeCode;
    _pendingFeeds = {
      for (final f in kFeedDefs) f.key: f.key == 'Kikistream.io',
      'Simulation': false,
    };
    for (final k in _pendingFeeds.keys.toList()) {
      if (s.feedEnabled.containsKey(k)) {
        _pendingFeeds[k] = s.feedEnabled[k]!;
      }
    }
  }

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _finish() async {
    final settings = context.read<AppSettings>();
    if (_pendingLocale != settings.localeCode) {
      settings.setLocale(_pendingLocale);
    }
    for (final e in _pendingFeeds.entries) {
      settings.feedEnabled[e.key] = e.value;
      await settings.saveFeedEnabled(e.key, e.value);
    }
    await settings.setOnboardingSeen(true);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _skip() async {
    final settings = context.read<AppSettings>();
    await settings.setOnboardingSeen(true);
    if (mounted) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List.generate(3, (i) {
                final active = i <= _step;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(
                      left: i == 0 ? 0 : 6,
                      right: i == 2 ? 0 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: active ? scheme.primary : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: _buildStep(context),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(onPressed: _skip, child: Text(context.l10n.fieldCancel)),
                const Spacer(),
                if (_step > 0)
                  OutlinedButton(onPressed: _back, child: const Text('Back')),
                if (_step > 0) const SizedBox(width: 8),
                FilledButton(
                  onPressed: _next,
                  child: Text(_step == 2 ? context.l10n.receptionStart : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildLanguageStep(context);
      case 1:
        return _buildFeedStep(context);
      case 2:
        return _buildReadyStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLanguageStep(BuildContext context) {
    const locales = <String?, String>{
      null: 'Auto (system)',
      'en': 'English',
      'fr': 'Français',
      'es': 'Español',
      'de': 'Deutsch',
      'pt': 'Português',
      'it': 'Italiano',
      'nl': 'Nederlands',
      'zh': '中文',
      'ja': '日本語',
      'ru': 'Русский',
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.waving_hand, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Welcome to KikAis',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Receive, decode and forward AIS frames in real time.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        Text('Choose your language', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          initialValue: _pendingLocale,
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
          items: locales.entries
              .map((e) => DropdownMenuItem<String?>(
                    value: e.key,
                    child: Text(e.value),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _pendingLocale = v),
        ),
        const SizedBox(height: 12),
        Text(
          'You can change it anytime in the title bar.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildFeedStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose your feeds',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          'Enable the sources you want to receive. You can add custom feeds later on the Reception tab.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        ...kFeedDefs.map((feed) => CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(feed.displayName),
              subtitle: feed.tooltip != null
                  ? Text(feed.tooltip!, style: Theme.of(context).textTheme.bodySmall)
                  : null,
              value: _pendingFeeds[feed.key] ?? false,
              onChanged: (v) => setState(() => _pendingFeeds[feed.key] = v ?? false),
            )),
        CheckboxListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: const Text('Simulation'),
          subtitle: Text('Generate a local fleet for testing — no network needed.',
              style: Theme.of(context).textTheme.bodySmall),
          value: _pendingFeeds['Simulation'] ?? false,
          onChanged: (v) => setState(() => _pendingFeeds['Simulation'] = v ?? false),
        ),
      ],
    );
  }

  Widget _buildReadyStep(BuildContext context) {
    final enabled = _pendingFeeds.entries.where((e) => e.value).map((e) => e.key).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade600),
            const SizedBox(width: 8),
            Text("You're all set!",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 8),
        if (enabled.isEmpty)
          Text('No feed selected — you can enable one later on the Reception tab.',
              style: Theme.of(context).textTheme.bodyMedium)
        else
          Text('Enabled: ${enabled.join(", ")}', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Text(
          'Hit Start on the Reception tab to begin receiving. Destinations are on the Send tab.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
