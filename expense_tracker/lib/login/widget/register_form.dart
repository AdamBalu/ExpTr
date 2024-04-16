import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:flutter/material.dart';
import '../../common/widget/buttons/login_button.dart';
import '../../common/widget/custom_text_field.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});

  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New user registration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SizedBox(
              width: 300,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _username,
                    hint: "",
                    label: "username",
                  ),
                  CustomTextField(
                    controller: _email,
                    hint: "your@email.com",
                    label: "email",
                  ),
                  CustomTextField(
                    controller: _password,
                    hint: "********",
                    label: "password",
                    isPassword: true,
                  ),
                  CustomTextField(
                    controller: _confirmPassword,
                    hint: "********",
                    label: "confirm password",
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: LoginButton(
                        onPressed: () {
                          _userService.userRegister(
                            _email.text,
                            _password.text,
                            _confirmPassword.text,
                            _username.text,
                          );
                          Navigator.of(context).pop();
                        },
                        text: "Sign up",
                        backgroundColor: Theme.of(context).highlightColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
