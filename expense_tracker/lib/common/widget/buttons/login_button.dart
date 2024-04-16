import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;

  const LoginButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.backgroundColor = Colors.black12});

  final double _buttonPadding = 5.0;
  final double _textPadding = 12.0;
  final double _buttonRounding = 18.0;
  final double _buttonShadow = 0.0;
  final double _fontSize = 17.0;
  final double _buttonWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_buttonPadding),
      child: SizedBox(
        width: _buttonWidth,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_buttonRounding),
              ),
            ),
            elevation: MaterialStateProperty.all(_buttonShadow),
          ),
          child: Padding(
            padding: EdgeInsets.all(_textPadding),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontSize: _fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
