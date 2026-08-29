import '../../message_factory.dart';
import '../messages/base/ais_message.dart';
import 'fragment_assembler.dart';
import 'nmea_sentence.dart';

/// Snapshot of the decoder counters, sent back to the main isolate.
class DecoderReport {
  final int invalidChecksums;
  final int droppedFragments;
  final int parseErrors;
  final int pendingFragments;
  final int fragmentsSeen;
  final int multiPartCompleted;

  const DecoderReport({
    this.invalidChecksums = 0,
    this.droppedFragments = 0,
    this.parseErrors = 0,
    this.pendingFragments = 0,
    this.fragmentsSeen = 0,
    this.multiPartCompleted = 0,
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

  /// Multi-fragment messages received but still awaiting their remaining parts.
  int get pendingFragments => _assembler.pending;

  /// Multi-part sentences (fragmentCount > 1) seen so far.
  int get fragmentsSeen => _assembler.fragmentsSeen;

  /// Multi-part messages fully reassembled so far.
  int get multiPartCompleted => _assembler.multiPartCompleted;

  List<String> _lastRawSentences = const [];

  /// The raw NMEA sentences that produced the most recent successful decode
  /// (every fragment of a multi-part message, in order). Empty when the last
  /// call only buffered fragments or failed.
  List<String> get lastRawSentences => _lastRawSentences;

  AISMessage? decode(String rawLine) {
    final sentence = NmeaSentence.tryParse(rawLine);
    if (sentence == null) {
      parseErrors++;
      _lastRawSentences = const [];
      return null;
    }
    if (validateChecksum && !sentence.isChecksumValid) {
      invalidChecksums++;
      _lastRawSentences = const [];
      return null;
    }
    final assembled = _assembler.add(sentence);
    if (assembled == null) {
      _lastRawSentences = const [];
      return null;
    }
    try {
      final message = MessageFactory.create(
        assembled.payload,
        false,
        false,
        true,
      );
      decodedCount++;
      _lastRawSentences = assembled.rawSentences;
      return message;
    } catch (_) {
      parseErrors++;
      _lastRawSentences = const [];
      return null;
    }
  }

  DecoderReport report() => DecoderReport(
    invalidChecksums: invalidChecksums,
    droppedFragments: droppedFragments,
    parseErrors: parseErrors,
    pendingFragments: pendingFragments,
    fragmentsSeen: fragmentsSeen,
    multiPartCompleted: multiPartCompleted,
  );

  /// Resets all counters and clears the fragment buffer.
  void reset() {
    invalidChecksums = 0;
    parseErrors = 0;
    decodedCount = 0;
    _lastRawSentences = const [];
    _assembler.reset();
  }
}
