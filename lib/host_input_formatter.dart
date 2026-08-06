import 'package:flutter/services.dart';

/// Allows hostnames (letters, digits, dots, hyphens) and bare IP addresses.
class HostInputFormatter extends TextInputFormatter {
  static final RegExp _hostRegex = RegExp(r'^[a-zA-Z0-9.\-]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_hostRegex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
