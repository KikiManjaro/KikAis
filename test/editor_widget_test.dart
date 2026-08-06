import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/ais_editor_page.dart';

void main() {
  testWidgets('editor page builds without layout errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AisEditorPage(running: ValueNotifier<bool>(false)),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Send to target is disabled while the forwarder is stopped',
      (tester) async {
    final running = ValueNotifier<bool>(false);
    String? sent;
    await tester.pumpWidget(
      MaterialApp(
        home: AisEditorPage(
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
}
