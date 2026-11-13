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
    expect(find.textContaining('UDP · listen (server)'), findsOneWidget);
    expect(find.text('Listen port 33333'), findsOneWidget);
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

  testWidgets('new destination defaults to sending to 127.0.0.1:33333', (
    tester,
  ) async {
    final settings = AppSettings();
    final running = ValueNotifier<bool>(false);
    await tester.pumpWidget(harness(settings, running));
    await tester.pump();

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('UDP · send (client)'), findsOneWidget);
    expect(find.textContaining('sends the frames'), findsOneWidget);
    expect(find.widgetWithText(TextField, '127.0.0.1'), findsOneWidget);
    expect(find.widgetWithText(TextField, '33333'), findsOneWidget);
  });

  testWidgets('listen mode hides the host field and explains the role', (
    tester,
  ) async {
    final settings = AppSettings();
    final running = ValueNotifier<bool>(false);
    await tester.pumpWidget(harness(settings, running));
    await tester.pump();

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Remote host'), findsOneWidget);

    // Switch the protocol to the UDP listening role.
    await tester.tap(find.text('UDP · send (client)').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('UDP · listen (server)').last);
    await tester.pumpAndSettle();

    expect(find.text('Remote host'), findsNothing);
    expect(find.text('Listen port'), findsOneWidget);
    expect(find.textContaining('listens on this port'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a listen port already in use is refused', (tester) async {
    final settings = AppSettings()
      ..targets = [
        const TargetConfig(
          id: 't1',
          name: 'Existing listener',
          protocol: ForwardProtocol.tcpServer,
          host: '0.0.0.0',
          port: 33333,
        ),
      ];
    final running = ValueNotifier<bool>(false);
    await tester.pumpWidget(harness(settings, running));
    await tester.pump();

    await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UDP · send (client)').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('TCP · listen (server)').last);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('already used by another destination'),
      findsOneWidget,
    );
    final add = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Add'),
    );
    expect(add.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });
}
