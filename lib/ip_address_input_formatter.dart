import 'package:flutter/services.dart';

class IpAddressInputFormatter extends TextInputFormatter {
  final RegExp _ipRegex = RegExp(r'^(\d{0,3})(\.(\d{0,3})){0,3}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_ipRegex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
