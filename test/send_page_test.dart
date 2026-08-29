import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/send_page.dart';
import 'package:kik_ais/target_config.dart';
import 'package:kik_ais/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_test_utils.dart';

void main() {
  Widget harness(AppSettings settings, ValueNotifier<bool> running) {
    return ChangeNotifierProvider.value(
      value: settings,
      child: withLocalizations(
        SendPage(serviceGetter: () => null, running: running),
      ),
    );
  }

  testWidgets('send page lists destinations when stopped', (tester) async {
    final settings = AppSettings()
      ..targets = [
        const TargetConfig(
          id: 't1',
          name: 'Vessel viewer',
          protocol: ForwardProtocol.udpServer,
          host: '10.0.0.1',
          port: 33333,
        ),
      ];
    final running = ValueNotifier<bool>(false);

    await tester.pumpWidget(harness(settings, running));
    await tester.pump();

    expect(find.text('Vessel viewer'), findsOneWidget);
    expect(find.textContaining('UDP Server · 10.0.0.1:33333'), findsOneWidget);
    expect(find.textContaining('destinations are locked'), findsNothing);

    final addButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.add),
    );
    expect(addButton.onPressed, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('send page is locked while the forwarder runs', (tester) async {
    final settings = AppSettings()
      ..targets = [
        const TargetConfig(
          id: 't1',
          name: 'Vessel viewer',
          protocol: ForwardProtocol.udpServer,
          host: '10.0.0.1',
          port: 33333,
        ),
      ];
    final running = ValueNotifier<bool>(true);

    await tester.pumpWidget(harness(settings, running));
    await tester.pump();

    expect(find.textContaining('destinations are locked'), findsOneWidget);
    final addButton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.add),
    );
    expect(addButton.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('toggling a destination switch updates it immediately', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final settings = AppSettings()
      ..targets = [
        const TargetConfig(
          id: 't1',
          name: 'Vessel viewer',
          protocol: ForwardProtocol.udpServer,
          host: '10.0.0.1',
          port: 33333,
        ),
      ];
    final running = ValueNotifier<bool>(false);

    await tester.pumpWidget(harness(settings, running));
    await tester.pump();

    final targetCard = find.ancestor(
      of: find.text('Vessel viewer'),
      matching: find.byType(TintedCard),
    );
    final targetSwitch = find.descendant(
      of: targetCard,
      matching: find.byType(Switch),
    );

    expect(settings.targets.single.enabled, isTrue);
    expect(tester.widget<Switch>(targetSwitch).value, isTrue);

    await tester.tap(targetSwitch);
    await tester.pump();

    expect(settings.targets.single.enabled, isFalse);
    expect(tester.widget<Switch>(targetSwitch).value, isFalse);
    expect(tester.takeException(), isNull);
  });
}
