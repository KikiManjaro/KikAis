import 'package:auto_updater/auto_updater.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/update_notifier.dart';

void main() {
  test('update notifier reflects update availability events', () {
    final notifier = UpdateNotifier();

    expect(notifier.updatesSupported, isFalse);
    expect(notifier.updateAvailable, isFalse);

    notifier.onUpdaterCheckingForUpdate(null);
    expect(notifier.checking, isTrue);

    final item = AppcastItem(displayVersionString: '2.2.0');
    notifier.onUpdaterUpdateAvailable(item);
    expect(notifier.updateAvailable, isTrue);
    expect(notifier.availableVersion, '2.2.0');
    expect(notifier.checking, isFalse);

    notifier.onUpdaterUpdateNotAvailable(null);
    expect(notifier.updateAvailable, isFalse);

    notifier.onUpdaterError(UpdaterError('boom'));
    expect(notifier.lastError, 'boom');
  });

  test('update notifier is a no-op when updates are unsupported', () async {
    final notifier = UpdateNotifier();
    await notifier.initialize(
      'https://example.com/appcast.xml',
      supported: false,
    );
    expect(notifier.updatesSupported, isFalse);
    // No exception thrown and no state change.
    await notifier.checkForUpdates();
    expect(notifier.checking, isFalse);
  });
}
