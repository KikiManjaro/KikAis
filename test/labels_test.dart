import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kik_ais/forwarder_service.dart';
import 'package:kik_ais/l10n/generated/app_localizations.dart';
import 'package:kik_ais/labels.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('RTL-SDR log messages render with their arguments in place', () {
    expect(
      logMessageText(
        l10n,
        const LogMessage(
          'rtlSdrOpening',
          {'device': 'Generic RTL2832U OEM'},
          '',
        ),
      ),
      'Opening RTL-SDR dongle Generic RTL2832U OEM...',
    );

    expect(
      logMessageText(
        l10n,
        const LogMessage(
          'rtlSdrConnected',
          {
            'device': 'Generic RTL2832U OEM',
            'freq': '162.000 MHz',
            'rate': '1.024 MHz',
            'gain': 'auto',
            'channels': 'A + B',
          },
          '',
        ),
      ),
      'RTL-SDR Generic RTL2832U OEM connected (162.000 MHz, 1.024 MHz '
      'sample rate, auto gain, channels A + B).',
    );

    expect(
      logMessageText(
        l10n,
        const LogMessage(
          'rtlSdrError',
          {'device': '#0', 'error': 'Device busy'},
          '',
        ),
      ),
      'RTL-SDR #0 error: Device busy',
    );

    expect(
      logMessageText(
        l10n,
        const LogMessage('rtlSdrStreamClosed', {'device': '#0'}, ''),
      ),
      'RTL-SDR #0 stream closed.',
    );

    expect(
      logMessageText(
        l10n,
        const LogMessage('rtlSdrDisconnected', {'device': '#0'}, ''),
      ),
      'RTL-SDR #0 disconnected.',
    );
  });

  test('multi-argument log messages keep the generated parameter order', () {
    // Guards against the gen-l10n alphabetical reordering scrambling the args.
    expect(
      logMessageText(
        l10n,
        const LogMessage(
          'feedConnected',
          {'name': 'My AIS'},
          '',
        ),
      ),
      'Feed My AIS connected.',
    );

    expect(
      logMessageText(
        l10n,
        const LogMessage(
          'feedConnectFailed',
          {'name': 'My AIS', 'error': 'refused'},
          '',
        ),
      ),
      'Failed to connect feed My AIS: refused. Retrying in 5s...',
    );

    expect(
      logMessageText(
        l10n,
        const LogMessage(
          'targetConnected',
          {
            'name': 'Boat',
            'protocol': ForwardProtocol.tcpClient,
            'host': '1.2.3.4',
            'port': '3000',
          },
          '',
        ),
      ),
      'Target Boat connected (TCP Client 1.2.3.4:3000).',
    );
  });
}

