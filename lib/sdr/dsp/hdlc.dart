/// HDLC-style framing of the AIS VHF data link: NRZI decoding, flag
/// detection, bit destuffing and the CRC-16/CCITT frame check, producing the
/// raw AIS message bits (payload without the CRC) from a demodulated symbol
/// stream.
class AisFrameDecoder {
  /// CRC-16/CCITT-FALSE (polynomial 0x1021, init 0xFFFF, MSB-first). AIS
  /// transmits the ones complement of this value, so a valid frame has a
  /// residual of 0xF0B8 when the CRC is recomputed over data+CRC.
  static int crc16Ccitt(List<int> bits) {
    var crc = 0xFFFF;
    for (final b in bits) {
      crc ^= (b & 1) << 15;
      crc &= 0xFFFF;
      crc = (crc & 0x8000) != 0 ? ((crc << 1) ^ 0x1021) : (crc << 1);
      crc &= 0xFFFF;
    }
    return crc;
  }

  /// Decodes the first valid AIS frame found in [symbols] (±1, starting at
  /// the first preamble symbol) and returns its message bits (payload, CRC
  /// removed) together with the number of symbols consumed up to and including
  /// the closing flag — or null if no frame with a valid CRC was found.
  static (List<int>?, int) decode(List<int> symbols) {
    // NRZI decode: 0 -> transition, 1 -> no transition.
    final bits = List<int>.filled(symbols.length - 1, 0);
    for (var n = 1; n < symbols.length; n++) {
      bits[n - 1] = symbols[n] == symbols[n - 1] ? 1 : 0;
    }

    // Locate all 0x7E flags.
    final flags = <int>[];
    var acc = 0;
    for (var n = 0; n < bits.length; n++) {
      acc = ((acc << 1) | bits[n]) & 0xFF;
      if (n >= 7 && acc == 0x7E) flags.add(n - 7);
    }

    for (var i = 0; i + 1 < flags.length; i++) {
      final start = flags[i] + 8;
      final end = flags[i + 1];
      if (end - start < 16) continue;

      // Bit destuffing: drop the 0 inserted after five consecutive 1s.
      final unstuffed = <int>[];
      var ones = 0;
      for (var n = start; n < end; n++) {
        if (bits[n] == 1) {
          ones++;
          unstuffed.add(1);
        } else {
          if (ones == 5) {
            ones = 0;
            continue;
          }
          unstuffed.add(0);
          ones = 0;
        }
      }
      if (unstuffed.length < 16) continue;

      final payload = unstuffed.sublist(0, unstuffed.length - 16);
      final received = unstuffed.sublist(unstuffed.length - 16);
      var rcv = 0;
      for (final b in received) {
        rcv = ((rcv << 1) | b) & 0xFFFF;
      }
      if ((crc16Ccitt(payload) ^ 0xFFFF) == rcv) {
        return (payload, flags[i + 1] + 8);
      }
    }
    return (null, symbols.length);
  }
}
