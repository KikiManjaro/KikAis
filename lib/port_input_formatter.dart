import 'package:flutter/services.dart';

class PortInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    final intValue = int.tryParse(text);
    if (intValue != null && intValue >= 0 && intValue <= 65535) {
      return newValue;
    }
    return oldValue;
  }
}
