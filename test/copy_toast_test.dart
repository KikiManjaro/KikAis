import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/widgets.dart';

import 'l10n_test_utils.dart';

void main() {
  testWidgets('copy button shows a mini toast next to it', (tester) async {
    await tester.pumpWidget(
      withLocalizations(
        const Scaffold(
          body: Center(
            child: CopyIconButton(text: 'hello', message: 'Copied!'),
          ),
        ),
      ),
    );

    expect(find.text('Copied!'), findsNothing);

    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump();

    expect(find.text('Copied!'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // The toast disappears after its lifetime.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();
    expect(find.text('Copied!'), findsNothing);
  });
}
