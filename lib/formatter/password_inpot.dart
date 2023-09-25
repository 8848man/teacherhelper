import 'package:flutter/services.dart';

class AlphanumericTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''); // 영어 대소문자와 숫자만 허용
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
