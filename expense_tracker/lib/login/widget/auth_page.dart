import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../app_root.dart';
import 'login_homescreen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityProvider(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          // if logged in
          if (snapshot.hasData) {
            return const AppRoot();
          } else {
            return const LoginHomeScreen();
          }
        },
      ),
    );
  }
}
