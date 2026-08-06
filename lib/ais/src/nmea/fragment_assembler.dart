import 'nmea_sentence.dart';

/// Reassembles multi-fragment AIS sentences (e.g. type 5 static data sent
/// as two sentences) into a single 6-bit payload string.
class FragmentAssembler {
  final Duration timeout;
  final Map<String, _PartialMessage> _partials = {};
  int dropped = 0;

  FragmentAssembler({this.timeout = const Duration(seconds: 5)});

  /// Returns the assembled payload string when the sentence completes a
  /// message, or null when more fragments are still expected.
  String? add(NmeaSentence sentence) {
    final now = DateTime.now();
    final before = _partials.length;
    _partials.removeWhere((_, p) => now.difference(p.lastUpdate) > timeout);
    dropped += before - _partials.length;

    if (sentence.fragmentCount <= 1) {
      return sentence.payload;
    }

    final key = '${sentence.sequentialId}|${sentence.channel}';
    final partial = _partials.putIfAbsent(
      key,
      () => _PartialMessage(sentence.fragmentCount),
    );
    partial.add(sentence.fragmentNumber, sentence.payload);
    partial.lastUpdate = now;

    if (partial.isComplete) {
      _partials.remove(key);
      return partial.payload;
    }
    return null;
  }

  void clear() {
    _partials.clear();
  }
}

class _PartialMessage {
  final int total;
  final Map<int, String> parts = {};
  DateTime lastUpdate = DateTime.now();

  _PartialMessage(this.total);

  void add(int index, String payload) => parts[index] = payload;

  bool get isComplete => parts.length >= total;

  String get payload {
    final indexes = parts.keys.toList()..sort();
    return indexes.map((i) => parts[i]).join();
  }
}
