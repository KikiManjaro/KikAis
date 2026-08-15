import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais_editor_page.dart';

import 'l10n_test_utils.dart';

void main() {
  testWidgets('editor page builds without layout errors', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Send to target is disabled while the forwarder is stopped',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final running = ValueNotifier<bool>(false);
    String? sent;
    await tester.pumpWidget(
      withLocalizations(
        AisEditorPage(
          running: running,
          onSendToTarget: (s) async => sent = s,
        ),
      ),
    );

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Send to target'),
    );
    expect(button.onPressed, isNull);

    running.value = true;
    await tester.pumpAndSettle();
    final enabled = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Send to target'),
    );
    expect(enabled.onPressed, isNotNull);

    await tester.tap(find.widgetWithText(FilledButton, 'Send to target'));
    await tester.pumpAndSettle();
    expect(sent, isNotNull);
    expect(sent, contains('!AIVDM'));
  });

  testWidgets('manual DAC/FID entry (Custom) hides the ASM fields',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );

    // Switch to message type 8 (Binary Broadcast).
    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('8 · Binary Broadcast').last);
    await tester.pumpAndSettle();

    // No ASM yet (DAC/FID default to 0).
    expect(find.textContaining('Application Specific Message'), findsNothing);

    // Even typing DAC=1/FID=11 manually stays in "Custom" mode: no ASM card,
    // no sub-fields, only the raw Data bytes field.
    await tester.enterText(find.byType(TextField).at(1), '1');
    await tester.enterText(find.byType(TextField).at(2), '11');
    await tester.pumpAndSettle();

    expect(find.textContaining('Application Specific Message'), findsNothing);
    expect(find.text('Average Wind Speed'), findsNothing);
    expect(find.text('Data bytes (hex or 1,2,3)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editor picks an ASM preset via the search picker',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('8 · Binary Broadcast').last);
    await tester.pumpAndSettle();

    // Open the ASM picker and search for the meteo message.
    await tester.tap(find.text('Custom — enter DAC/FID manually').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'Metreorological and hydrological',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.textContaining('Metreorological and hydrological data').last,
    );
    await tester.pumpAndSettle();

    // The preset hides the manual DAC/FID fields and shows the sub-fields
    // (the single "DAC" text is the ASM's own DAC sub-field).
    expect(find.text('DAC'), findsOneWidget);
    expect(
      find.textContaining('Application Specific Message — Metreorological'),
      findsOneWidget,
    );
    expect(find.text('Average Wind Speed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editor toggles between Data bytes and ASM fields',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('8 · Binary Broadcast').last);
    await tester.pumpAndSettle();

    // Pick the meteo preset -> source defaults to ASM fields.
    await tester.tap(find.text('Custom — enter DAC/FID manually').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'Metreorological and hydrological',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.textContaining('Metreorological and hydrological data').last,
    );
    await tester.pumpAndSettle();
    expect(find.text('Average Wind Speed'), findsOneWidget);
    expect(find.text('Data bytes (hex or 1,2,3)'), findsNothing);

    // Switch to raw data bytes: the raw field appears, sub-fields disappear.
    await tester.tap(find.text('Data bytes'));
    await tester.pumpAndSettle();
    expect(find.text('Average Wind Speed'), findsNothing);
    expect(find.text('Data bytes (hex or 1,2,3)'), findsOneWidget);

    // And back to ASM fields.
    await tester.tap(find.text('ASM fields'));
    await tester.pumpAndSettle();
    expect(find.text('Average Wind Speed'), findsOneWidget);
    expect(find.text('Data bytes (hex or 1,2,3)'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('editor returns to manual DAC/FID via Custom',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('8 · Binary Broadcast').last);
    await tester.pumpAndSettle();

    // Lock a preset, then switch back to manual.
    await tester.tap(find.text('Custom — enter DAC/FID manually').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'Metreorological and hydrological',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.textContaining('Metreorological and hydrological data').last,
    );
    await tester.pumpAndSettle();
    // Locked preset: only the ASM's own DAC/FID sub-fields are visible.
    expect(find.text('DAC'), findsOneWidget);

    // Reopen and pick "Custom" to reveal the manual DAC/FID fields again.
    await tester.tap(
      find.textContaining('Metreorological and hydrological data').first,
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.text('Custom — enter DAC/FID manually').last,
    );
    await tester.pumpAndSettle();

    // Manual DAC/FID fields only — the ASM sub-fields are hidden in Custom
    // mode.
    expect(find.text('DAC'), findsOneWidget);
    expect(find.text('FID'), findsOneWidget);
    expect(find.textContaining('Application Specific Message'), findsNothing);
    // The ASM preset field is never empty: its label must stay floating
    // instead of overlapping the "Custom" placeholder text.
    final decorator = tester.widget<InputDecorator>(
      find.ancestor(
        of: find.text('Custom — enter DAC/FID manually'),
        matching: find.byType(InputDecorator),
      ),
    );
    expect(decorator.isEmpty, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ASM preset list is filtered by message type',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );

    Future<void> selectType(int type, String label) async {
      await tester.tap(find.byType(DropdownButtonFormField<int>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining(label).last);
      await tester.pumpAndSettle();
    }

    Future<void> search(String query) async {
      await tester.tap(find.text('Custom — enter DAC/FID manually').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, query);
      await tester.pumpAndSettle();
    }

    // Type 8: the broadcast meteo (001/11) is offered…
    await selectType(8, '8 · Binary Broadcast');
    await search('Metreorological and hydrological');
    expect(
      find.textContaining('Metreorological and hydrological data'),
      findsWidgets,
    );
    // …but the type-6 "Number of persons on board" is not.
    await tester.enterText(find.byType(TextField).last, 'persons');
    await tester.pumpAndSettle();
    expect(find.textContaining('Number of persons on board'), findsNothing);
    await tester.tap(find.text('Custom — enter DAC/FID manually').last);
    await tester.pumpAndSettle();

    // Type 6: meteo (type-8 only) disappears, persons (type 6) stays.
    await selectType(6, '6 · Binary Addressed');
    await search('Metreorological and hydrological');
    expect(find.textContaining('Metreorological and hydrological data'),
        findsNothing);
    await tester.enterText(find.byType(TextField).last, 'persons');
    await tester.pumpAndSettle();
    expect(find.textContaining('Number of persons on board'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('text-only ASM preset shows a free-text field',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      withLocalizations(AisEditorPage(running: ValueNotifier<bool>(false))),
    );

    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('8 · Binary Broadcast').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Custom — enter DAC/FID manually').first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).last,
      'Text using 6-bit ASCII',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Text using 6-bit ASCII').last);
    await tester.pumpAndSettle();

    // The ASM card exposes a plain free-text field plus the data-source
    // toggle.
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Data bytes'), findsOneWidget);
    expect(find.text('ASM fields'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
