import 'ais/src/utils/convert_char_to_bin.dart';
import 'asm_formats.dart';

/// The full ASM catalog (see `asm_formats.dart`).
export 'asm_formats.dart';

/// How an ASM sub-field is encoded into the data bit stream.
enum AsmFieldKind {
  /// Plain unsigned integer.
  unsigned,

  /// Two's-complement signed integer.
  signed,

  /// Fixed-width 6-bit ASCII text (AIS data alphabet).
  text6,

  /// Variable-width free 6-bit ASCII text — the editor offers a plain text
  /// field and the message is encoded with exactly the characters typed.
  freeText,

  /// Uninterpreted binary bytes (hex / comma-separated list in the editor).
  data,
}

/// A single named field of an Application Specific Message data layout.
class AsmField {
  final String key;
  final String name;
  final int bits;
  final AsmFieldKind kind;
  final String? unit;

  const AsmField(
    this.key,
    this.name,
    this.bits, {
    this.kind = AsmFieldKind.unsigned,
    this.unit,
  });
}

/// Lifecycle state of an ASM in the catalog.
enum AsmState {
  inForce,
  deprecated,
  replaced,
  discontinued,
  draft,
  proposal,
  testing,
}

/// An Application Specific Message (ASM): the structured binary payload
/// identified by a Designated Area Code (DAC) and Function Identifier (FID),
/// used by AIS message types 6, 8, 25 and 26.
///
/// The field bit layouts follow the definitions published by IMO / IALA and
/// summarised in the gpsd AIVDM documentation. Values are raw: numeric fields
/// are packed as-is (the caller applies the unit scale, e.g. 1/10 of a knot).
class AsmFormat {
  final int dac;
  final int fid;

  /// Human-readable name of the application.
  final String name;

  /// Field layout, in transmission order. Empty when the bit layout is not
  /// documented — such entries are edited as raw Data bytes.
  final List<AsmField> fields;

  /// The message types this ASM is valid for (subset of 6, 8, 25, 26).
  final List<int> types;

  /// Standard / reference that defines the message (e.g. "IMO Circ. 289").
  final String? source;

  /// Version number of the message within its DAC/FID.
  final int? version;

  /// Sub-version (e.g. the Seaway sub-messages).
  final int? sub;

  /// Maximum number of TDMA slots used.
  final int? slotsMax;

  /// Registrant organisation.
  final String? registrant;

  final AsmState state;

  /// "Permitted as from" date (DD/MM/YYYY).
  final String? permittedAsFrom;

  /// "Not to be used after" date (DD/MM/YYYY).
  final String? notToBeUsedAfter;

  /// Free-text deprecation note, shown as "deprecated since …".
  final String? deprecatedSince;

  const AsmFormat({
    required this.dac,
    required this.fid,
    required this.name,
    this.fields = const [],
    required this.types,
    this.source,
    this.version,
    this.sub,
    this.slotsMax,
    this.registrant,
    this.state = AsmState.inForce,
    this.permittedAsFrom,
    this.notToBeUsedAfter,
    this.deprecatedSince,
  });

  /// Whether the message is no longer recommended for new use.
  bool get isDeprecated =>
      state == AsmState.deprecated ||
      state == AsmState.replaced ||
      state == AsmState.discontinued;

  /// Whether a bit-level field layout is known.
  bool get hasLayout => fields.isNotEmpty;

  bool validFor(int messageType) => types.contains(messageType);
}

String _pad3(int v) => v.toString().padLeft(3, '0');
String _pad2(int v) => v.toString().padLeft(2, '0');

/// Stable unique identifier for [asm], used by the editor preset picker.
/// Disambiguates duplicate DAC/FID entries (different version/sub/source,
/// registrant or message type).
String asmKey(AsmFormat asm) {
  final parts = [_pad3(asm.dac), _pad2(asm.fid)];
  if (asm.sub != null) parts.add('s${asm.sub}');
  if (asm.version != null) parts.add('v${asm.version}');
  final authority = asm.source ?? asm.registrant;
  if (authority != null) parts.add(authority.replaceAll(' ', '-'));
  parts.add('t${asm.types.join('')}');
  return parts.join('/');
}

/// Short display key, e.g. "001/11 [v2]".
String asmShortKey(AsmFormat asm) {
  var key = '${_pad3(asm.dac)}/${_pad2(asm.fid)}';
  if (asm.sub != null) key += '/${asm.sub}';
  if (asm.version != null) key += ' v${asm.version}';
  return key;
}

/// Looks up the ASM for [dac] and [fid], or null when unknown. Returns the
/// first match when several entries share the pair.
AsmFormat? asmFor(int dac, int fid) {
  for (final asm in kAsmFormats) {
    if (asm.dac == dac && asm.fid == fid) return asm;
  }
  return null;
}

/// Looks up the ASM for [dac] and [fid] that is valid for message [type].
///
/// Returns null when unknown, when the ASM does not support [type], or when
/// several entries share the DAC/FID (ambiguous — the user must pick from the
/// catalog instead).
AsmFormat? asmForMessage(int type, int dac, int fid) {
  AsmFormat? found;
  for (final asm in kAsmFormats) {
    if (asm.dac != dac || asm.fid != fid || !asm.validFor(type)) continue;
    if (found != null) return null; // ambiguous
    found = asm;
  }
  return found;
}

/// Looks up the ASM by its stable [asmKey], or null.
AsmFormat? asmByKey(String key) {
  for (final asm in kAsmFormats) {
    if (asmKey(asm) == key) return asm;
  }
  return null;
}

String _bits(int value, int width) =>
    value.toRadixString(2).padLeft(width, '0');

String _text6(String text, int width) {
  final sb = StringBuffer();
  for (final c in text.toUpperCase().split('')) {
    final v = aisDataChars.indexOf(c);
    sb.write(_bits(v < 0 ? 32 : v, 6));
  }
  return sb.toString().padRight(width, '0').substring(0, width);
}

/// Packs [values] (keyed `asm.<fieldKey>`) into the data bytes of an ASM.
/// Numeric fields are read as integers (signed fields use two's complement),
/// text fields take a [String] and `data` fields take a [List<int>] of bytes.
/// Missing or invalid values pack as zero. Returns an empty list for ASMs
/// without a documented layout.
List<int> packAsmData(AsmFormat format, Map<String, dynamic> values) {
  final binary = StringBuffer();
  for (final field in format.fields) {
    final raw = values['asm.${field.key}'];
    switch (field.kind) {
      case AsmFieldKind.unsigned:
        final v = raw is num ? raw.toInt() : 0;
        binary.write(_bits(v.clamp(0, (1 << field.bits) - 1), field.bits));
      case AsmFieldKind.signed:
        final v = raw is num ? raw.toInt() : 0;
        final min = -(1 << (field.bits - 1));
        final max = (1 << (field.bits - 1)) - 1;
        binary.write(
          _bits(v.clamp(min, max) & ((1 << field.bits) - 1), field.bits),
        );
      case AsmFieldKind.text6:
        final text = raw is String ? raw : '';
        binary.write(_text6(text, field.bits));
      case AsmFieldKind.freeText:
        // Variable width: encode every typed character as 6-bit ASCII.
        final text = raw is String ? raw : '';
        for (final c in text.toUpperCase().split('')) {
          final v = aisDataChars.indexOf(c);
          binary.write(_bits(v < 0 ? 32 : v, 6));
        }
      case AsmFieldKind.data:
        // Variable width: pack exactly the bytes given (used for "remaining
        // data" and variable-length ASM payloads).
        final bytes = raw is List ? raw.whereType<int>() : <int>[];
        for (final byte in bytes) {
          binary.write(_bits(byte, 8));
        }
    }
  }
  final bitString = binary.toString();
  final padded = bitString.padRight(((bitString.length + 7) ~/ 8) * 8, '0');
  final out = <int>[];
  for (var i = 0; i < padded.length; i += 8) {
    out.add(int.parse(padded.substring(i, i + 8), radix: 2));
  }
  return out;
}
