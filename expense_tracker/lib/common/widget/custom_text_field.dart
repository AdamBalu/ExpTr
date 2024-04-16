import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool isNumber;
  final bool isInputValid;
  final String invalidInputLabel;
  final TextEditingController controller;
  final int? lengthLimit;

  const CustomTextField(
      {super.key,
      required this.label,
      required this.hint,
      required this.controller,
      this.isPassword = false,
      this.isNumber = false,
      this.isInputValid = true,
      this.lengthLimit,
      this.invalidInputLabel = "This field can't be empty!"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: TextFormField(
        maxLength: lengthLimit,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hint,
            label: Text(label),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Theme.of(context).highlightColor),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Theme.of(context).primaryColorLight)),
            errorText: isInputValid ? null : invalidInputLabel),
      ),
    );
  }
}
