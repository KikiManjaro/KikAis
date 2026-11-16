import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:showcaseview/showcaseview.dart';

import '../l10n/generated/app_localizations.dart';
import '../l10n_ext.dart';
import 'tour_cursor.dart';

/// Bump this to replay the tour once for every user, e.g. after a UI rework.
///
/// It is deliberately independent of the application version: shipping an
/// update must never replay the tour for someone who already saw it.
const int kOnboardingVersion = 1;

/// A modal the tour opens to show it, then closes without applying anything.
enum OnboardingDialog { none, addSource, mapFilters, sendDestination }

/// One step of the guided tour.
///
/// The order is the narrative: the app, its tabs, then each page in depth.
/// [tabIndex] is the page that must be visible for the step to make sense; it
/// matches the `IndexedStack` order in `swipper.dart`. [dialog] is opened
/// before the step is measured and closed when leaving it.
enum OnboardingStep {
  intro(0),
  tabs(0),
  workflow(0),
  simulationFeed(0),
  startButton(0),
  addSourceButton(0),
  addSourceDialog(0, dialog: OnboardingDialog.addSource),
  receptionOptions(0),
  logArea(0),
  logToolbar(0),
  mapSearch(2),
  mapFilters(2),
  mapFiltersDialog(2, dialog: OnboardingDialog.mapFilters),
  mapTrails(2),
  mapSendToMap(2),
  sendAdd(1),
  sendDialog(1, dialog: OnboardingDialog.sendDestination),
  editorCompose(3),
  editorInject(3),
  toolsRail(4),
  statsActions(5),
  simulationActions(6),
  docsSearch(7),
  replayTour(7);

  const OnboardingStep(this.tabIndex, {this.dialog = OnboardingDialog.none});

  final int tabIndex;
  final OnboardingDialog dialog;

  /// Position of the step in the tour, 1-based, for the tooltip title.
  int get position => index + 1;

  String title(AppLocalizations l10n) => switch (this) {
    OnboardingStep.intro => l10n.onboardingIntroTitle,
    OnboardingStep.tabs => l10n.onboardingTabsTitle,
    OnboardingStep.workflow => l10n.onboardingWorkflowTitle,
    OnboardingStep.simulationFeed => l10n.onboardingSimulationTitle,
    OnboardingStep.startButton => l10n.onboardingStartTitle,
    OnboardingStep.addSourceButton => l10n.onboardingAddSourceTitle,
    OnboardingStep.addSourceDialog => l10n.tooltipReceptionAddSource,
    OnboardingStep.receptionOptions => l10n.tooltipReceptionImportFormat,
    OnboardingStep.logArea => l10n.receptionLogs,
    OnboardingStep.logToolbar => l10n.onboardingLogToolsTitle,
    OnboardingStep.mapSearch => l10n.tooltipMapSearch,
    OnboardingStep.mapFilters => l10n.onboardingMapFilterTitle,
    OnboardingStep.mapFiltersDialog => l10n.tooltipMapFilters,
    OnboardingStep.mapTrails => l10n.tooltipMapTrails,
    OnboardingStep.mapSendToMap => l10n.tooltipMapSendToMap,
    OnboardingStep.sendAdd => l10n.onboardingSendTitle,
    OnboardingStep.sendDialog => l10n.sendAddDestination,
    OnboardingStep.editorCompose => l10n.onboardingEditorTitle,
    OnboardingStep.editorInject => l10n.onboardingTestFrameTitle,
    OnboardingStep.toolsRail => l10n.onboardingToolsTitle,
    OnboardingStep.statsActions => l10n.tabStats,
    OnboardingStep.simulationActions => l10n.tabSimulation,
    OnboardingStep.docsSearch => l10n.onboardingDocsTitle,
    OnboardingStep.replayTour => l10n.onboardingReplayTitle,
  };

  String body(AppLocalizations l10n) => switch (this) {
    OnboardingStep.intro => l10n.onboardingIntroBody,
    OnboardingStep.tabs => l10n.onboardingTabsBody,
    OnboardingStep.workflow => l10n.onboardingWorkflowBody,
    OnboardingStep.simulationFeed => l10n.onboardingSimulationBody,
    OnboardingStep.startButton => l10n.onboardingStartBody,
    OnboardingStep.addSourceButton => l10n.onboardingAddSourceBody,
    OnboardingStep.addSourceDialog => l10n.onboardingAddSourceDialogBody,
    OnboardingStep.receptionOptions => l10n.onboardingReceptionOptionsBody,
    OnboardingStep.logArea => l10n.onboardingLogAreaBody,
    OnboardingStep.logToolbar => l10n.onboardingLogToolbarBody,
    OnboardingStep.mapSearch => l10n.onboardingMapSearchBody,
    OnboardingStep.mapFilters => l10n.onboardingMapFiltersBody,
    OnboardingStep.mapFiltersDialog => l10n.onboardingMapFiltersDialogBody,
    OnboardingStep.mapTrails => l10n.onboardingMapTrailsBody,
    OnboardingStep.mapSendToMap => l10n.onboardingMapSendToMapBody,
    OnboardingStep.sendAdd => l10n.onboardingSendAddBody,
    OnboardingStep.sendDialog => l10n.onboardingSendDialogBody,
    OnboardingStep.editorCompose => l10n.onboardingEditorBody,
    OnboardingStep.editorInject => l10n.onboardingEditorInjectBody,
    OnboardingStep.toolsRail => l10n.onboardingToolsBody,
    OnboardingStep.statsActions => l10n.onboardingStatsBody,
    OnboardingStep.simulationActions => l10n.onboardingSimulationActionsBody,
    OnboardingStep.docsSearch => l10n.onboardingDocsSearchBody,
    OnboardingStep.replayTour => l10n.onboardingReplayBody,
  };
}

/// Stable [GlobalKey] per step.
///
/// The keys live here instead of in each page so the tour definition stays in
/// one place. A key must be used by exactly one `Showcase` in the tree: the
/// cached feed tiles therefore keep their own key instance for their lifetime.
class OnboardingTargets {
  static final Map<OnboardingStep, GlobalKey> _keys = {
    for (final step in OnboardingStep.values)
      step: GlobalKey(debugLabel: 'onboarding-${step.name}'),
  };

  /// Keys attached to the real widgets, used to measure the target rect for the
  /// fake cursor. `showcaseview` 5.x no longer attaches its own key to the
  /// element, so we keep a second, plain key for geometry.
  static final Map<OnboardingStep, GlobalKey> _measureKeys = {
    for (final step in OnboardingStep.values)
      step: GlobalKey(debugLabel: 'onboarding-measure-${step.name}'),
  };

  static GlobalKey keyOf(OnboardingStep step) => _keys[step]!;

  static GlobalKey measureKeyOf(OnboardingStep step) => _measureKeys[step]!;

  /// Global rect of the step target, or null when it is not rendered.
  static Rect? rectOf(OnboardingStep step) {
    final object = _measureKeys[step]?.currentContext?.findRenderObject();
    if (object is! RenderBox || !object.hasSize) return null;
    return object.localToGlobal(Offset.zero) & object.size;
  }
}

/// Whether the showcase overlay has been registered by the application shell.
///
/// Pages must stay renderable without it (widget tests mount them on their
/// own), so [onboardingStep] simply returns its child until the tour is armed.
bool _showcaseRegistered = false;

/// Registers the tour overlay. Called once by the application shell.
void registerOnboardingShowcase({
  required VoidCallback onComplete,
  required VoidCallback onDismiss,
  required List<TooltipActionButton> actions,
  TooltipActionConfig? actionConfig,
}) {
  ShowcaseView.register(
    onComplete: (index, key) => onComplete(),
    onDismiss: (key) => onDismiss(),
    globalTooltipActions: actions,
    globalTooltipActionConfig:
        actionConfig ??
        const TooltipActionConfig(
          position: TooltipActionPosition.inside,
          alignment: MainAxisAlignment.spaceBetween,
        ),
  );
  _showcaseRegistered = true;
}

/// Releases the overlay; targets fall back to plain widgets afterwards.
void unregisterOnboardingShowcase() {
  _showcaseRegistered = false;
  ShowcaseView.get().unregister();
}

/// Wraps [child] so it can be highlighted by the tour, with the localized
/// title and description of [step].
///
/// When the tour is not armed (a page mounted on its own, e.g. in a widget
/// test) the child is returned untouched: the package throws if a [Showcase]
/// is built before [ShowcaseView.register].
Widget onboardingStep(BuildContext context, OnboardingStep step, Widget child) {
  if (!_showcaseRegistered) return child;
  final scheme = Theme.of(context).colorScheme;
  return Showcase(
    key: OnboardingTargets.keyOf(step),
    // A step counter keeps the tour readable at a glance.
    title:
        '${step.position}/${OnboardingStep.values.length} · '
        '${step.title(context.l10n)}',
    description: step.body(context.l10n),
    tooltipBackgroundColor: scheme.surface,
    textColor: scheme.onSurface,
    targetBorderRadius: const BorderRadius.all(Radius.circular(10)),
    // No vertical slide between steps: the tooltip lands directly in place.
    // (The package's default is a 2 s move, which makes reading uncomfortable.)
    disableMovingAnimation: true,
    // A stray click outside the highlighted area must not end the tour; the
    // "skip" action is the explicit way out.
    onBarrierClick: () {},
    child: KeyedSubtree(
      key: OnboardingTargets.measureKeyOf(step),
      child: child,
    ),
  );
}

/// Drives the tour: switches to the right tab, opens the step's dialog, then
/// shows one step at a time.
///
/// Chaining single steps (instead of handing every key to the package at once)
/// is what makes cross-tab navigation and dialogs possible: the target has to
/// be on screen before it is measured.
class OnboardingController extends ChangeNotifier {
  OnboardingController({
    required this.onTabRequested,
    required this.onFinished,
    this.openDialog,
    this.closeDialog,
    this.stepDelay = const Duration(milliseconds: 320),
    this.awaitFrame = true,
    Future<void> Function(OnboardingStep step)? present,
  }) : _present = present;

  /// Asks the host to make [tabIndex] visible. Awaited so the host can play the
  /// real navigation (tap on the tab bar) before the next step is measured.
  final Future<void> Function(int tabIndex) onTabRequested;

  /// Called once when the tour ends. [completed] is false when it was skipped.
  final void Function(bool completed) onFinished;

  /// Opens one of the app's real dialogs for a step, without applying it.
  final Future<void> Function(OnboardingDialog dialog)? openDialog;

  /// Closes the dialog the tour opened.
  final Future<void> Function()? closeDialog;

  /// Grace delay added after the tab has switched, before measuring the target.
  /// Long enough for the tab-bar indicator animation to be seen.
  final Duration stepDelay;

  /// Whether to wait for a frame (and [stepDelay]) before presenting a step.
  /// Disabled by unit tests, which drive the controller without a render tree.
  final bool awaitFrame;

  /// How the step is shown; overridden in tests to avoid the showcase overlay.
  final Future<void> Function(OnboardingStep step)? _present;

  /// Fake cursor that points at each step and pulses on the simulated clicks.
  final TourCursorController cursor = TourCursorController();

  int _index = -1;
  bool _disposed = false;
  bool _ending = false;
  bool _completed = false;
  bool _suppressDismiss = false;
  OnboardingDialog _openDialog = OnboardingDialog.none;

  bool get isRunning => _index >= 0 && _index < OnboardingStep.values.length;
  OnboardingStep? get current =>
      isRunning ? OnboardingStep.values[_index] : null;

  /// True while the controller hides a step on purpose. The host must ignore
  /// `onDismiss` during that window: it is a transition, not a skip.
  bool get isSwitching => _suppressDismiss;

  /// True when the current step highlights something in the title bar: the tour
  /// must not put a drag strip over it, or the tooltip buttons become
  /// unreachable.
  bool get isTitleBarStep =>
      current == OnboardingStep.intro || current == OnboardingStep.replayTour;

  /// Starts (or restarts) the tour from the first step.
  Future<void> start() async {
    _ending = false;
    _completed = false;
    _index = 0;
    notifyListeners();
    await _showCurrent();
  }

  /// Moves to the next step, finishing the tour after the last one.
  Future<void> advance() async {
    if (!isRunning) return;
    _index++;
    if (_index >= OnboardingStep.values.length) {
      _completed = true;
      await finish();
      return;
    }
    notifyListeners();
    await _showCurrent();
  }

  /// Ends the tour, whether it was completed or skipped.
  Future<void> finish() async {
    // `dismiss()` fires `onDismiss`, which calls back here: run the teardown
    // once only.
    if (_disposed || _ending) return;
    _ending = true;
    final completed = _completed;
    _index = -1;
    cursor.hide();
    await _closeDialogIfAny();
    notifyListeners();
    if (_present == null) ShowcaseView.get().dismiss();
    onFinished(completed);
  }

  Future<void> _closeDialogIfAny() async {
    if (_openDialog == OnboardingDialog.none) return;
    _openDialog = OnboardingDialog.none;
    await closeDialog?.call();
  }

  Future<void> _showCurrent() async {
    final step = current;
    if (step == null) return;

    // Hide the previous overlay first: it would swallow the tab tap and hide
    // the navigation animation the user is supposed to watch.
    if (_present == null && ShowcaseView.get().isShowcaseRunning) {
      _suppressDismiss = true;
      ShowcaseView.get().dismiss();
      _suppressDismiss = false;
    }
    await _closeDialogIfAny();
    await onTabRequested(step.tabIndex);
    if (step.dialog != OnboardingDialog.none) {
      _openDialog = step.dialog;
      await openDialog?.call(step.dialog);
    }
    if (awaitFrame) {
      // Let the tab (and the dialog) settle before measuring the target. A
      // frame is forced because a step staying on the same tab schedules none.
      SchedulerBinding.instance.scheduleFrame();
      await SchedulerBinding.instance.endOfFrame;
      await Future<void>.delayed(stepDelay);
    }
    if (_disposed || !isRunning) return;
    final present = _present;
    if (present != null) {
      await present(step);
      return;
    }
    final view = ShowcaseView.get();
    // A target inside a collapsed section is not rendered: skip that step
    // instead of showing a tooltip pointing at nothing.
    if (!view.isTargetRendered(OnboardingTargets.keyOf(step))) {
      await advance();
      return;
    }
    view.startShowCase([OnboardingTargets.keyOf(step)]);
    // The cursor must sit above the veil the package just inserted.
    cursor.bringToFront();
    final rect = OnboardingTargets.rectOf(step);
    if (rect != null) cursor.moveTo(rect.center);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
