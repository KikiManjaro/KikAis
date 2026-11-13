import 'nmea_sentence.dart';

/// The assembled payload of a message together with every raw NMEA sentence
/// that contributed to it (all fragments, in order).
class AssembledPayload {
  final String payload;
  final List<String> rawSentences;

  /// Number of padding bits declared by the `fill` field of the last fragment.
  /// Variable-length messages (type 26) need it to find their real end.
  final int fillBits;

  const AssembledPayload(this.payload, this.rawSentences, {this.fillBits = 0});
}

/// Reassembles multi-fragment AIS sentences (e.g. type 5 static data sent
/// as two sentences) into a single 6-bit payload string.
class FragmentAssembler {
  final Duration timeout;
  final Map<String, _PartialMessage> _partials = {};
  int dropped = 0;

  /// Multi-part sentences (fragmentCount > 1) seen so far.
  int fragmentsSeen = 0;

  /// Multi-part messages that were fully reassembled so far.
  int multiPartCompleted = 0;

  FragmentAssembler({this.timeout = const Duration(seconds: 5)});

  /// Number of multi-fragment messages currently awaiting their remaining
  /// parts (received but not yet decodable).
  int get pending => _partials.length;

  /// Returns the assembled payload when the sentence completes a message, or
  /// null when more fragments are still expected or the fragment is
  /// inconsistent and was dropped.
  AssembledPayload? add(NmeaSentence sentence) {
    final now = DateTime.now();
    final before = _partials.length;
    _partials.removeWhere((_, p) => now.difference(p.lastUpdate) > timeout);
    dropped += before - _partials.length;

    if (sentence.fragmentCount <= 1) {
      return AssembledPayload(sentence.payload, [
        sentence.raw,
      ], fillBits: sentence.fillBits);
    }

    fragmentsSeen++;
    if (sentence.fragmentNumber < 1 ||
        sentence.fragmentNumber > sentence.fragmentCount) {
      dropped++;
      return null;
    }

    final key = '${sentence.sequentialId}|${sentence.channel}';
    final partial = _partials[key];
    if (partial == null) {
      final created = _PartialMessage(sentence.fragmentCount);
      created.add(
        sentence.fragmentNumber,
        sentence.payload,
        sentence.raw,
        sentence.fillBits,
      );
      created.lastUpdate = now;
      if (created.isComplete) {
        _partials.remove(key);
        multiPartCompleted++;
        return AssembledPayload(
          created.payload,
          created.rawSentences,
          fillBits: created.fillBits,
        );
      }
      _partials[key] = created;
      return null;
    }

    // A different message reused the same key: never merge fragments from
    // distinct messages into a corrupted payload.
    if (partial.total != sentence.fragmentCount) {
      dropped++;
      return null;
    }
    final existing = partial.parts[sentence.fragmentNumber];
    if (existing != null) {
      if (existing != sentence.payload) {
        dropped++;
        return null;
      }
      // Identical retransmission: keep waiting, just refresh the timeout.
      partial.lastUpdate = now;
      return null;
    }

    partial.add(
      sentence.fragmentNumber,
      sentence.payload,
      sentence.raw,
      sentence.fillBits,
    );
    partial.lastUpdate = now;

    if (partial.isComplete) {
      _partials.remove(key);
      multiPartCompleted++;
      return AssembledPayload(
        partial.payload,
        partial.rawSentences,
        fillBits: partial.fillBits,
      );
    }
    return null;
  }

  void clear() {
    _partials.clear();
  }

  void reset() {
    _partials.clear();
    dropped = 0;
    fragmentsSeen = 0;
    multiPartCompleted = 0;
  }
}

class _PartialMessage {
  final int total;
  final Map<int, String> parts = {};
  final Map<int, String> raws = {};
  final Map<int, int> fills = {};
  DateTime lastUpdate = DateTime.now();

  _PartialMessage(this.total);

  void add(int index, String payload, String raw, int fill) {
    parts[index] = payload;
    raws[index] = raw;
    fills[index] = fill;
  }

  bool get isComplete => parts.length == total;

  /// Padding declared by the last fragment; the only one that carries data
  /// past the previous fragment's 6-bit boundary.
  int get fillBits => fills[total] ?? 0;

  String get payload {
    final indexes = parts.keys.toList()..sort();
    return indexes.map((i) => parts[i]).join();
  }

  List<String> get rawSentences {
    final indexes = parts.keys.toList()..sort();
    return indexes.map((i) => raws[i]!).toList();
  }
}
