import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/onboarding/onboarding_finale.dart';
import 'package:kik_ais/onboarding/onboarding_tour.dart';
import 'package:kik_ais/onboarding/tour_cursor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'l10n_test_utils.dart';

void main() {
  group('OnboardingController', () {
    late List<int> requestedTabs;
    late List<OnboardingStep> presented;
    late int finished;
    late bool? completedNaturally;
    late OnboardingController controller;

    setUp(() {
      requestedTabs = [];
      presented = [];
      finished = 0;
      controller = OnboardingController(
        onTabRequested: (index) async => requestedTabs.add(index),
        onFinished: (completed) {
          finished++;
          completedNaturally = completed;
        },
        stepDelay: Duration.zero,
        awaitFrame: false,
        present: (step) async => presented.add(step),
      );
    });

    tearDown(() => controller.dispose());

    test('walks every step and switches to the matching tab', () async {
      await controller.start();
      expect(controller.current, OnboardingStep.values.first);
      expect(requestedTabs.last, OnboardingStep.values.first.tabIndex);

      for (var i = 1; i < OnboardingStep.values.length; i++) {
        await controller.advance();
        expect(controller.current, OnboardingStep.values[i]);
        expect(requestedTabs.last, OnboardingStep.values[i].tabIndex);
      }

      expect(presented, OnboardingStep.values);
      expect(requestedTabs, OnboardingStep.values.map((s) => s.tabIndex));
      expect(finished, 0);

      // The last advance ends the tour.
      await controller.advance();
      expect(finished, 1);
      expect(completedNaturally, isTrue);
      expect(controller.isRunning, isFalse);
    });

    test('skip ends the tour exactly once', () async {
      await controller.start();
      await controller.advance();
      await controller.finish();
      expect(finished, 1);
      expect(completedNaturally, isFalse);
      expect(controller.isRunning, isFalse);

      // Dismissing twice (barrier then explicit skip) must not save twice.
      await controller.finish();
      expect(finished, 1);
    });

    test('restart after finishing runs again', () async {
      await controller.start();
      await controller.finish();
      expect(finished, 1);

      await controller.start();
      expect(controller.isRunning, isTrue);
      expect(controller.current, OnboardingStep.values.first);
    });

    test('advance outside a run does nothing', () async {
      await controller.advance();
      expect(controller.isRunning, isFalse);
      expect(presented, isEmpty);
    });
  });

  group('OnboardingTargets', () {
    test('every step has a distinct key', () {
      final keys = {
        for (final step in OnboardingStep.values) OnboardingTargets.keyOf(step),
      };
      expect(keys.length, OnboardingStep.values.length);
      expect(
        keys.contains(OnboardingTargets.keyOf(OnboardingStep.tabs)),
        isTrue,
      );
    });
  });

  group('AppSettings', () {
    test('the tour is unseen by default and the flag is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = AppSettings();
      await settings.load();
      expect(settings.onboardingVersion, 0);
      expect(settings.onboardingVersion, lessThan(kOnboardingVersion));

      await settings.saveOnboardingVersion(kOnboardingVersion);
      final reloaded = AppSettings();
      await reloaded.load();
      expect(reloaded.onboardingVersion, kOnboardingVersion);
    });
  });

  group('TourCursorController', () {
    test('moveTo shows the cursor and records the position', () {
      final cursor = TourCursorController();
      expect(cursor.visible, isFalse);
      cursor.moveTo(const Offset(12, 34));
      expect(cursor.visible, isTrue);
      expect(cursor.position, const Offset(12, 34));
      cursor.hide();
      expect(cursor.visible, isFalse);
    });

    test('click and bringToFront are observable', () {
      final cursor = TourCursorController();
      cursor.moveTo(Offset.zero);
      final clicks = cursor.clicks;
      cursor.click();
      expect(cursor.clicks, clicks + 1);
      final front = cursor.frontRequests;
      cursor.bringToFront();
      expect(cursor.frontRequests, front + 1);
    });
  });

  testWidgets('the cursor overlay renders, pulses and hides', (tester) async {
    final cursor = TourCursorController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TourCursorHost(controller: cursor)),
      ),
    );
    expect(find.byKey(tourCursorKey), findsNothing);

    cursor.moveTo(const Offset(120, 200));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(tourCursorKey), findsOneWidget);

    cursor.click();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);

    cursor.hide();
    await tester.pump();
    expect(find.byKey(tourCursorKey), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a synthetic tap selects the keyed destination', (tester) async {
    // This is how the tour navigates: it dispatches a real pointer down/up on
    // the keyed destination so the tab-bar animation plays.
    final keys = List.generate(3, (_) => GlobalKey());
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: selected,
            onDestinationSelected: (i) => selected = i,
            destinations: [
              NavigationDestination(
                key: keys[0],
                icon: const Icon(Icons.circle_outlined),
                label: 'A',
              ),
              NavigationDestination(
                key: keys[1],
                icon: const Icon(Icons.square_outlined),
                label: 'B',
              ),
              NavigationDestination(
                key: keys[2],
                icon: const Icon(Icons.star_outline),
                label: 'C',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    final box = keys[2].currentContext!.findRenderObject()! as RenderBox;
    final center = box.localToGlobal(box.size.center(Offset.zero));
    GestureBinding.instance.handlePointerEvent(
      PointerDownEvent(pointer: 1, position: center),
    );
    GestureBinding.instance.handlePointerEvent(
      PointerUpEvent(pointer: 1, position: center),
    );
    await tester.pump();

    expect(selected, 2);
  });

  testWidgets('the finale plays and closes', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      withLocalizations(
        Builder(
          builder: (ctx) {
            context = ctx;
            return const Scaffold(body: Text('home'));
          },
        ),
      ),
    );
    showOnboardingFinale(context);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Enjoy KikAis!'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Enjoy KikAis!'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('showcaseview shows and dismisses a registered step', (
    tester,
  ) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('harness'))),
    );
    ShowcaseView.register();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Showcase(
            key: key,
            title: 'Title',
            description: 'Description',
            child: const Text('target'),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    ShowcaseView.get().startShowCase([key]);
    // The showcase overlay animates continuously, so settle by hand.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);

    ShowcaseView.get().dismiss();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });
}
