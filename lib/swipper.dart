import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ais_editor_page.dart';
import 'app_settings.dart';
import 'boat_animation.dart';
import 'decoder_page.dart';
import 'documentation_page.dart';
import 'l10n_ext.dart';
import 'reception_page.dart';
import 'send_page.dart';
import 'simulation_page.dart';
import 'stats_page.dart';
import 'themes.dart';
import 'update_notifier.dart';
import 'widgets.dart';
import 'world_map_page.dart';

class SwipperUi extends StatefulWidget {
  final String version;

  const SwipperUi({super.key, required this.version});

  @override
  State<SwipperUi> createState() => _SwipperUiState();
}

class _SwipperUiState extends State<SwipperUi> {
  final BoatAnimationController boatController = BoatAnimationController();
  final ValueNotifier<bool> forwarderRunning = ValueNotifier(false);
  final PageController _pageController = PageController();
  final GlobalKey<ReceptionPageState> _receptionKey =
      GlobalKey<ReceptionPageState>();
  final GlobalKey<DecoderPageState> _decoderKey = GlobalKey<DecoderPageState>();
  late final BoatAnimation boat;
  late final ReceptionPage receptionPage;
  late final SendPage sendPage;
  late final WorldMapPage mapPage;
  late final AisEditorPage editorPage;
  late final DecoderPage decoderPage;
  late final StatsPage statsPage;
  late final SimulationPage simulationPage;
  late final DocumentationPage documentationPage;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    boat = BoatAnimation(controller: boatController);
    receptionPage = ReceptionPage(
      boatController,
      key: _receptionKey,
      running: forwarderRunning,
    );
    sendPage = SendPage(
      serviceGetter: () => _receptionKey.currentState?.forwarderService,
      running: forwarderRunning,
    );
    mapPage = WorldMapPage(key: const PageStorageKey('world_map'));
    editorPage = AisEditorPage(
      running: forwarderRunning,
      onSendToTarget: (sentence) async {
        _receptionKey.currentState?.sendRaw(sentence);
      },
    );
    decoderPage = DecoderPage(key: _decoderKey);
    statsPage = const StatsPage();
    simulationPage = SimulationPage(
      simGetter: () => _receptionKey.currentState?.simService,
      onGoToReception: () => setState(() => _currentIndex = 0),
    );
    documentationPage = DocumentationPage(
      onOpenTab: (i) => setState(() => _currentIndex = i),
      onOpenInDecoder: (sentence) {
        setState(() => _currentIndex = 4);
        _decoderKey.currentState?.loadSentences(sentence);
      },
    );
  }

  @override
  void dispose() {
    boatController.dispose();
    forwarderRunning.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context
        .select<AppSettings, ({AppTheme theme, String? locale})>(
          (s) => (theme: s.appTheme, locale: s.localeCode),
        );
    final update = context.watch<UpdateNotifier>();
    final currentTheme = settings.theme;
    final localeCode = settings.locale;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return WindowBorder(
      width: 3,
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: ImageIcon(
                          AssetImage("resources/FireBoat2.png"),
                          size: 26,
                        ),
                      ),
                      Text(
                        "KikAis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (update.updateAvailable)
                        _UpdateBadge(
                          version: update.availableVersion,
                          onPressed: () => update.checkForUpdates(),
                        ),
                      Text(
                        'v${widget.version}',
                        style: TextStyle(
                          fontSize: 11,
                          color: onSurface.withValues(alpha: 0.6),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Stack(children: [boat, MoveWindow()])),
                  if (update.updatesSupported)
                    Material(
                      type: MaterialType.transparency,
                      child: update.checking
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : HoverTooltip(
                              message: context.l10n.tooltipUpdate,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.system_update_alt,
                                  size: 18,
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                onPressed: () async {
                                  await update.checkForUpdates();
                                  if (!context.mounted) return;
                                  if (!update.updateAvailable) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          update.lastError == null
                                              ? context.l10n.updateUpToDate
                                              : context.l10n.updateCheckFailed,
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                    ),
                  Material(
                    type: MaterialType.transparency,
                    child: PopupMenuButton<String?>(
                      tooltip: '',
                      onSelected: (code) =>
                          context.read<AppSettings>().setLocale(code),
                      itemBuilder: (context) => [
                        PopupMenuItem<String?>(
                          value: null,
                          child: Row(
                            children: [
                              const Icon(Icons.settings_suggest, size: 18),
                              const SizedBox(width: 8),
                              Text(context.l10n.languageSystem),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        for (final code in kSupportedLocaleCodes)
                          PopupMenuItem<String?>(
                            value: code,
                            child: Row(
                              children: [
                                Icon(
                                  code == localeCode
                                      ? Icons.check
                                      : Icons.language,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(_languageName(context, code)),
                              ],
                            ),
                          ),
                      ],
                      child: HoverTooltip(
                        message: context.l10n.tooltipLanguage,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Icon(
                            Icons.language,
                            size: 18,
                            color: onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    type: MaterialType.transparency,
                    child: PopupMenuButton<AppTheme>(
                      tooltip: '',
                      onSelected: (t) =>
                          context.read<AppSettings>().setTheme(t),
                      itemBuilder: (context) => [
                        for (final t in AppTheme.values)
                          PopupMenuItem<AppTheme>(
                            value: t,
                            child: Row(
                              children: [
                                Icon(
                                  t == currentTheme ? Icons.check : t.icon,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(_themeName(context, t)),
                              ],
                            ),
                          ),
                      ],
                      child: HoverTooltip(
                        message: context.l10n.tooltipTheme,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Icon(
                            Icons.brightness_6,
                            size: 18,
                            color: onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const WindowButtons(),
                ],
              ),
            ),
            Expanded(
              child: Scaffold(
                body: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      if (pointerSignal.scrollDelta.dx > 0) {
                        setState(() {
                          _currentIndex = (_currentIndex + 1).clamp(0, 7);
                        });
                      } else if (pointerSignal.scrollDelta.dx < 0) {
                        setState(() {
                          _currentIndex = (_currentIndex - 1).clamp(0, 7);
                        });
                      }
                    }
                  },
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      receptionPage,
                      sendPage,
                      mapPage,
                      editorPage,
                      decoderPage,
                      statsPage,
                      simulationPage,
                      documentationPage,
                    ],
                  ),
                ),
                bottomNavigationBar: NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _currentIndex = index),
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.radio_outlined),
                      selectedIcon: const Icon(Icons.radio),
                      label: context.l10n.tabReception,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.outbox_outlined),
                      selectedIcon: const Icon(Icons.outbox),
                      label: context.l10n.tabSend,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.map_outlined),
                      selectedIcon: const Icon(Icons.map),
                      label: context.l10n.tabMap,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.edit_note_outlined),
                      selectedIcon: const Icon(Icons.edit_note),
                      label: context.l10n.tabEditor,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.manage_search_outlined),
                      selectedIcon: const Icon(Icons.manage_search),
                      label: context.l10n.tabTools,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.bar_chart_outlined),
                      selectedIcon: const Icon(Icons.bar_chart),
                      label: context.l10n.tabStats,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.bubble_chart_outlined),
                      selectedIcon: const Icon(Icons.bubble_chart),
                      label: context.l10n.tabSimulation,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.menu_book_outlined),
                      selectedIcon: const Icon(Icons.menu_book),
                      label: context.l10n.tabDocs,
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

final buttonColors = WindowButtonColors(
  iconNormal: Colors.lightBlue,
  mouseOver: Colors.lightBlueAccent,
  mouseDown: Colors.blue,
  iconMouseOver: Colors.blueGrey,
  iconMouseDown: Colors.lightBlueAccent,
);

/// A small green pill shown next to the version number when a newer version is
/// available. Clicking it launches the update (foreground check, which on
/// Windows shows the updater UI and installs when confirmed).
class _UpdateBadge extends StatelessWidget {
  final String? version;
  final VoidCallback onPressed;

  const _UpdateBadge({required this.version, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final label = version == null || version!.isEmpty
        ? context.l10n.updateNewVersion('')
        : context.l10n.updateNewVersion(version!);
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          mouseCursor: WidgetStateMouseCursor.clickable,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF4CAF50)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.system_update_alt,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Localized display name for a language code.
String _languageName(BuildContext context, String code) {
  final l10n = context.l10n;
  return switch (code) {
    'en' => l10n.languageEn,
    'fr' => l10n.languageFr,
    'es' => l10n.languageEs,
    'de' => l10n.languageDe,
    'pt' => l10n.languagePt,
    'it' => l10n.languageIt,
    'nl' => l10n.languageNl,
    'zh' => l10n.languageZh,
    'ja' => l10n.languageJa,
    'ru' => l10n.languageRu,
    _ => code,
  };
}

/// Localized display name for a theme.
String _themeName(BuildContext context, AppTheme theme) {
  final l10n = context.l10n;
  return switch (theme) {
    AppTheme.dark => l10n.themeDark,
    AppTheme.light => l10n.themeLight,
    AppTheme.highContrast => l10n.themeHighContrast,
  };
}

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: const Color(0xFF805306),
  iconMouseOver: Colors.white,
);

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
