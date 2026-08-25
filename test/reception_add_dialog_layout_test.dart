import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderParagraph;
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/app_settings.dart';
import 'package:kik_ais/boat_animation.dart';
import 'package:kik_ais/boatmanager.dart';
import 'package:kik_ais/l10n/generated/app_localizations.dart';
import 'package:kik_ais/message_stats.dart';
import 'package:kik_ais/reception_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n_test_utils.dart';

/// Guards the "add source" dialog layout: the five source-type segments must
/// fit their labels on a single line for the widest Latin labels (ru/es use
/// longer words and are allowed to wrap gracefully).
void main() {
  for (final locale in const [Locale('en'), Locale('fr'), Locale('de'), Locale('pt')]) {
    testWidgets('add source dialog segments fit on one line ($locale)',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      SharedPreferences.setMockInitialValues({});
      final stats = MessageStats();
      final boatManager = BoatManager(stats: stats);
      final settings = AppSettings();
      final boat = BoatAnimationController();
      final running = ValueNotifier(false);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: boatManager),
            ChangeNotifierProvider.value(value: settings),
            ChangeNotifierProvider.value(value: stats),
          ],
          child: withLocalizations(
            ReceptionPage(boat, running: running),
            locale: locale,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      final loc = lookupAppLocalizations(locale);
      for (final label in [
        loc.receptionNetwork,
        loc.receptionFile,
        loc.receptionSerial,
        loc.receptionRtlSdr,
        loc.receptionWebSdr,
      ]) {
        final render = tester.renderObject<RenderParagraph>(find.text(label));
        final singleLine = render.getMaxIntrinsicHeight(10000);
        expect(render.size.height <= singleLine + 1, isTrue,
            reason: '$label wraps onto two lines '
                '(h=${render.size.height}, single-line=$singleLine)');
      }
      expect(tester.takeException(), isNull);

      boatManager.dispose();
      stats.dispose();
      boat.dispose();
      running.dispose();
    });
  }
}
