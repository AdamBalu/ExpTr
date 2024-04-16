import 'package:expense_tracker/login/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../common/widget/buttons/login_button.dart';
import 'login_form.dart';

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({super.key});

  @override
  State<LoginHomeScreen> createState() => _LoginHomeScreenState();
}

class _LoginHomeScreenState extends State<LoginHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isKeyboardVisible) _buildLogo(),
              const LoginForm(),
              LoginButton(
                onPressed: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => RegisterForm()))
                },
                text: "Sign Up",
                backgroundColor: Theme.of(context).highlightColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Image.asset(
        "assets/img/logo.png",
        width: 250,
      ),
    );
  }
}
