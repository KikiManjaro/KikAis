import '../../message_factory.dart';
import '../messages/base/ais_message.dart';
import 'fragment_assembler.dart';
import 'nmea_sentence.dart';

/// Snapshot of the decoder error counters, sent back to the main isolate.
class DecoderReport {
  final int invalidChecksums;
  final int droppedFragments;
  final int parseErrors;

  const DecoderReport({
    this.invalidChecksums = 0,
    this.droppedFragments = 0,
    this.parseErrors = 0,
  });
}

/// Decodes raw NMEA 0183 AIS sentences into AISMessage objects.
///
/// Handles checksum validation (optional), multi-fragment reassembly and
/// final message parsing. Keeps state between calls so a message split over
/// several sentences can be reassembled.
class AisNmeaDecoder {
  final FragmentAssembler _assembler = FragmentAssembler();
  bool validateChecksum;
  int invalidChecksums = 0;
  int parseErrors = 0;
  int decodedCount = 0;

  AisNmeaDecoder({this.validateChecksum = true});

  int get droppedFragments => _assembler.dropped;

  AISMessage? decode(String rawLine) {
    final sentence = NmeaSentence.tryParse(rawLine);
    if (sentence == null) {
      parseErrors++;
      return null;
    }
    if (validateChecksum && !sentence.isChecksumValid) {
      invalidChecksums++;
      return null;
    }
    final payload = _assembler.add(sentence);
    if (payload == null) {
      return null;
    }
    try {
      final message = MessageFactory.create(payload, false, false, true);
      decodedCount++;
      return message;
    } catch (_) {
      parseErrors++;
      return null;
    }
  }

  DecoderReport report() => DecoderReport(
        invalidChecksums: invalidChecksums,
        droppedFragments: droppedFragments,
        parseErrors: parseErrors,
      );
}
