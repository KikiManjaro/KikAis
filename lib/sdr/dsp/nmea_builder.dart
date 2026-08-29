import '../../ais/src/encoder/ais_payload_encoder.dart'
    show computeNmeaChecksum;

/// Builds an `!AIVDM` NMEA sentence from raw AIS message bits (payload, CRC
/// already stripped), armoring them into the 6-bit alphabet used by NMEA.
String bitsToAivdm(List<int> bits, {String channel = 'A'}) {
  final fill = (6 - bits.length % 6) % 6;
  final padded = [...bits, ...List<int>.filled(fill, 0)];
  final sb = StringBuffer();
  for (var i = 0; i < padded.length; i += 6) {
    var v = 0;
    for (var j = 0; j < 6; j++) {
      v = (v << 1) | padded[i + j];
    }
    // AIS 6-bit armoring: 0-39 map to '0'..'W', 40-63 map to '`'..'w'.
    sb.writeCharCode(v + 48 + (v > 39 ? 8 : 0));
  }
  final payload = sb.toString();

  const int maxChars = 82;
  final parts = <String>[];
  for (var i = 0; i < payload.length; i += maxChars) {
    parts.add(
      payload.substring(
        i,
        i + maxChars > payload.length ? payload.length : i + maxChars,
      ),
    );
  }

  final total = parts.length;
  final sentences = <String>[];
  for (var i = 0; i < total; i++) {
    final seq = total > 1 ? (i % 9) : 0;
    // Only the last fragment carries the pad bits.
    final fragFill = i == total - 1 ? fill : 0;
    final body = 'AIVDM,$total,${i + 1},$seq,$channel,${parts[i]},$fragFill';
    sentences.add('!$body*${computeNmeaChecksum(body)}');
  }
  return sentences.join('\n');
}
