import 'package:flutter/material.dart';

import 'ais/ais_decoder.dart' show NmeaTagBlock;
import 'forwarder_service.dart' show LogMessage;
import 'labels.dart' show logMessageText;
import 'l10n_ext.dart';
import 'reception_page.dart' show LogEntry;

const _monoFallback = ['Consolas', 'Cascadia Mono', 'Courier New', 'monospace'];

const _spanCacheMax = 500;
final Map<String, List<InlineSpan>> _spanCache = {};

/// Inline colored log line that splits provider / NMEA 4.0 TAG block /
/// sentence framing / payload / checksum into distinct colors.
///
/// - provider `[FeedName]` : pill with subtle background + separator │
/// - TAG block `\s:...` : orange
/// - sentence framing `!AIVDM,1,1,,A,` `,0*` : onSurfaceVariant
/// - payload : teal
/// - checksum `*CS` : amber
class NmeaLogText extends StatelessWidget {
  final LogEntry entry;
  final bool showProvider;
  final bool showTimestamp;

  const NmeaLogText({
    super.key,
    required this.entry,
    this.showProvider = true,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (entry.status != null) {
      final text = logMessageText(context.l10n, entry.status!);
      final color = _statusColor(context, entry.status!);
      final prefix = showTimestamp ? '${_formatTime(entry.time)} │ ' : '';
      return Text.rich(
        TextSpan(
          children: [
            if (prefix.isNotEmpty)
              TextSpan(
                text: prefix,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontFamilyFallback: _monoFallback,
                  fontSize: 11,
                  letterSpacing: 0.2,
                  height: 1.3,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            TextSpan(text: text),
          ],
          style: TextStyle(
            fontFamily: 'monospace',
            fontFamilyFallback: _monoFallback,
            fontSize: 12,
            letterSpacing: 0.2,
            height: 1.3,
            color: color ?? scheme.onSurface,
          ),
        ),
      );
    }

    final spans = _buildSpans(context, scheme, isDark);
    return Text.rich(
      TextSpan(children: spans),
      style: TextStyle(
        fontFamily: 'monospace',
        fontFamilyFallback: _monoFallback,
        fontSize: 12,
        letterSpacing: 0.2,
        height: 1.3,
        color: scheme.onSurface,
      ),
    );
  }

  Color? _statusColor(BuildContext context, LogMessage m) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (m.key) {
      case 'feedConnectFailed':
      case 'targetConnectFailed':
      case 'sendError':
      case 'tcpClientError':
      case 'rtlSdrError':
        return isDark ? Colors.red.shade300 : Colors.red.shade700;
      case 'feedConnected':
      case 'targetConnected':
      case 'rtlSdrConnected':
      case 'tcpClientConnected':
        return isDark ? Colors.green.shade300 : Colors.green.shade700;
      case 'feedDisconnected':
      case 'tcpClientDisconnected':
      case 'rtlSdrDisconnected':
      case 'rtlSdrStreamClosed':
        return isDark ? Colors.orange.shade300 : Colors.orange.shade700;
      case 'tcpListening':
        return scheme.primary;
      default:
        return null;
    }
  }

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }

  List<InlineSpan> _buildSpans(
    BuildContext context,
    ColorScheme scheme,
    bool isDark,
  ) {
    final raw = entry.message.trim();
    final provider = entry.name;
    final cacheKey = '$raw|${provider ?? ''}|$showProvider|$showTimestamp|$isDark';
    final cached = _spanCache[cacheKey];
    if (cached != null) return cached;

    final providerColor = isDark ? Colors.lightBlue.shade300 : Colors.lightBlue.shade700;
    final providerBg = providerColor.withValues(alpha: 0.13);
    final bracketColor = scheme.onSurfaceVariant.withValues(alpha: 0.7);
    final separatorColor = scheme.onSurfaceVariant.withValues(alpha: 0.5);
    final timestampColor = scheme.onSurfaceVariant.withValues(alpha: 0.7);
    final tagColor = isDark ? Colors.orange.shade300 : Colors.orange.shade700;
    final tagDelimColor = isDark ? Colors.orange.shade200 : Colors.orange.shade800;
    final framingColor = scheme.onSurfaceVariant;
    final payloadColor = isDark ? Colors.teal.shade300 : Colors.teal.shade700;
    final checksumColor = isDark ? Colors.amber.shade300 : Colors.amber.shade800;

    final spans = <InlineSpan>[];

    if (showTimestamp) {
      spans.add(TextSpan(
        text: '${_formatTime(entry.time)} ',
        style: TextStyle(color: timestampColor, fontSize: 11),
      ));
      spans.add(TextSpan(text: '│ ', style: TextStyle(color: separatorColor)));
    }

    if (showProvider && provider != null && provider.isNotEmpty) {
      spans.add(TextSpan(
        text: '[',
        style: TextStyle(color: bracketColor, fontSize: 11),
      ));
      spans.add(TextSpan(
        text: provider,
        style: TextStyle(
          color: providerColor,
          backgroundColor: providerBg,
          fontWeight: FontWeight.w700,
        ),
      ));
      spans.add(TextSpan(text: ']', style: TextStyle(color: bracketColor, fontSize: 11)));
      spans.add(TextSpan(text: ' │ ', style: TextStyle(color: separatorColor)));
    }

    final (tagBlock, sentencePart) = NmeaTagBlock.split(raw);
    final isNmea = sentencePart.startsWith('!') || tagBlock != null;
    if (!isNmea) {
      spans.add(TextSpan(text: raw, style: TextStyle(color: scheme.onSurface)));
      _cachePut(cacheKey, spans);
      return spans;
    }

    if (tagBlock != null) {
      spans.addAll(_tagSpans(tagBlock, tagColor, tagDelimColor, framingColor, isDark));
    }

    final sentenceRaw = sentencePart.trim();
    if (sentenceRaw.isEmpty) {
      _cachePut(cacheKey, spans);
      return spans;
    }

    // For log display we don't need full NMEA validation; the lightweight
    // fallback split is enough and avoids per-row checksum computation.
    spans.addAll(_fallbackSentenceSpans(sentenceRaw, framingColor, payloadColor, checksumColor, isDark));

    _cachePut(cacheKey, spans);
    return spans;
  }

  List<InlineSpan> _tagSpans(
    NmeaTagBlock tag,
    Color tagColor,
    Color delimColor,
    Color framingColor,
    bool isDark,
  ) {
    final raw = tag.raw;
    final inner = raw.substring(1, raw.length - 1);
    final spans = <InlineSpan>[];
    spans.add(TextSpan(text: '\\', style: TextStyle(color: delimColor, fontWeight: FontWeight.w700)));
    final pairs = inner.split(',');
    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      final colon = pair.indexOf(':');
      if (colon > 0) {
        final k = pair.substring(0, colon + 1);
        final v = pair.substring(colon + 1);
        final isChecksum = k == 'c:';
        spans.add(TextSpan(
          text: k,
          style: TextStyle(color: isChecksum ? Colors.amber.shade400 : tagColor, fontWeight: FontWeight.w700),
        ));
        spans.add(TextSpan(text: v, style: TextStyle(color: tagColor)));
      } else {
        spans.add(TextSpan(text: pair, style: TextStyle(color: tagColor)));
      }
      if (i < pairs.length - 1) {
        spans.add(TextSpan(text: ',', style: TextStyle(color: framingColor)));
      }
    }
    spans.add(TextSpan(text: '\\', style: TextStyle(color: delimColor, fontWeight: FontWeight.w700)));
    return spans;
  }

void _cachePut(String key, List<InlineSpan> spans) {
  if (_spanCache.length >= _spanCacheMax) {
    _spanCache.remove(_spanCache.keys.first);
  }
  _spanCache[key] = spans;
}

  List<InlineSpan> _fallbackSentenceSpans(
    String sentenceRaw,
    Color framingColor,
    Color payloadColor,
    Color checksumColor,
    bool isDark,
  ) {
    final star = sentenceRaw.indexOf('*');
    final body = star >= 0 ? sentenceRaw.substring(0, star) : sentenceRaw;
    final checksum = star >= 0 ? sentenceRaw.substring(star) : '';
    final spans = <InlineSpan>[];
    final commas = <int>[];
    for (var i = 0; i < body.length; i++) {
      if (body[i] == ',') commas.add(i);
    }
    if (commas.length >= 6) {
      final payloadStart = commas[4] + 1;
      final payloadEnd = commas.last;
      spans.add(TextSpan(text: body.substring(0, payloadStart), style: TextStyle(color: framingColor)));
      spans.add(TextSpan(
        text: body.substring(payloadStart, payloadEnd),
        style: TextStyle(color: payloadColor, fontWeight: FontWeight.w600),
      ));
      spans.add(TextSpan(text: body.substring(payloadEnd), style: TextStyle(color: framingColor)));
    } else {
      spans.add(TextSpan(text: body, style: TextStyle(color: framingColor)));
    }
    if (checksum.isNotEmpty) {
      spans.add(TextSpan(text: '*', style: TextStyle(color: framingColor)));
      spans.add(TextSpan(text: checksum.substring(1), style: TextStyle(color: checksumColor, fontWeight: FontWeight.w700)));
    }
    return spans;
  }
}
