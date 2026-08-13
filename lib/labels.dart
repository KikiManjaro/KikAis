import 'package:kik_ais/ais/ais_decoder.dart' show NmeaFormat;
import 'package:kik_ais/forwarder_service.dart'
    show ForwardProtocol, LogMessage;

import 'l10n/generated/app_localizations.dart';

/// Localized label of a forward protocol (UDP/TCP client/server).
String protocolLabelLocalized(ForwardProtocol p, AppLocalizations l10n) =>
    switch (p) {
      ForwardProtocol.udpServer => l10n.protocolUdpServer,
      ForwardProtocol.udpClient => l10n.protocolUdpClient,
      ForwardProtocol.tcpClient => l10n.protocolTcpClient,
      ForwardProtocol.tcpServer => l10n.protocolTcpServer,
    };

/// Localized label of an NMEA import/export format.
String nmeaFormatLabelLocalized(NmeaFormat f, AppLocalizations l10n) =>
    switch (f) {
      NmeaFormat.passthrough => l10n.formatPassthrough,
      NmeaFormat.strip => l10n.formatStrip,
      NmeaFormat.tag => l10n.formatTag,
    };

String _s(Object? v) => v is String ? v : '$v';

/// Localizes a structured [LogMessage] emitted by the forwarder. Unknown keys
/// fall back to the message's English text.
String logMessageText(AppLocalizations l10n, LogMessage m) => switch (m.key) {
      'targetConnected' => l10n.logTargetConnected(
          _s(m.args['name']),
          protocolLabelLocalized(m.args['protocol']! as ForwardProtocol, l10n),
          _s(m.args['host']),
          _s(m.args['port']),
        ),
      'targetConnectFailed' => l10n.logTargetConnectFailed(
          _s(m.args['name']), _s(m.args['error'])),
      'stopping' => l10n.logStopping,
      'stopped' => l10n.logStopped,
      'feedAdded' => l10n.logFeedAdded(
          _s(m.args['name']), _s(m.args['host']), _s(m.args['port'])),
      'feedRemoved' => l10n.logFeedRemoved(_s(m.args['name'])),
      'feedConnected' => l10n.logFeedConnected(_s(m.args['name'])),
      'feedDisconnected' =>
        l10n.logFeedDisconnected(_s(m.args['name'])),
      'feedConnectFailed' => l10n.logFeedConnectFailed(
          _s(m.args['name']), _s(m.args['error'])),
      'tcpListening' => l10n.logTcpListening(
          _s(m.args['name']), _s(m.args['port'])),
      'tcpClientConnected' => l10n.logTcpClientConnected(
          _s(m.args['name']), _s(m.args['address']), _s(m.args['port'])),
      'tcpClientDisconnected' =>
        l10n.logTcpClientDisconnected(_s(m.args['name'])),
      'tcpClientError' => l10n.logTcpClientError(
          _s(m.args['name']), _s(m.args['error'])),
      'sendError' => l10n.logSendError(_s(m.args['name']), _s(m.args['error'])),
      _ => m.fallback,
    };
