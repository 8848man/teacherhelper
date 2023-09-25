import 'package:flutter/services.dart';

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 남김
    final formattedText = StringBuffer();

    if (newText.isNotEmpty) {
      formattedText.write(newText.substring(0, 3));
      if (newText.length >= 4) {
        formattedText.write('-');
        formattedText.write(newText.substring(3, 7));
      }
      if (newText.length >= 8) {
        formattedText.write('-');
        formattedText.write(newText.substring(7, 11));
      } else {
        formattedText.write(newText.substring(7));
      }
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
