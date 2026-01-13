import 'package:flutter/material.dart';

class PhoneTextFormField {
  Widget getCustomEditTextArea({
    String labelValue = "",
    String hintValue = "",
    double fontLabelSize = 15,
    String? Function(String?)? validator,
    IconData? icon,
    bool validation = false,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? validationErrorMsg,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        prefixStyle: const TextStyle(color: Colors.black45),
        fillColor: const Color.fromRGBO(255, 255, 255, 0.6),
        filled: true,
        isDense: true,
        labelStyle: TextStyle(color: Colors.grey[800], fontSize: fontLabelSize),
        focusColor: Colors.black,
        errorStyle: TextStyle(
          color: Colors.white,
          wordSpacing: 5.0,
          fontSize: fontLabelSize + 2,
        ),
        hintText: hintValue,
        labelText: labelValue,
      ),
      validator: validator,
    );
  }
}
