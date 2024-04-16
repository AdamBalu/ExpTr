import 'package:expense_tracker/user/service/user_service.dart';
import 'package:expense_tracker/common/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../common/service/ioc_container.dart';
import '../../common/widget/buttons/login_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    final userService = get<UserService>();

    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: StreamBuilder<String>(
                stream: userService.errMessageStream,
                builder: (_, snapshot) {
                  if (snapshot.data != null && snapshot.data != "") {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(color: Colors.red),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
          ),
          CustomTextField(
            controller: email,
            hint: "your@email.com",
            label: "email",
          ),
          CustomTextField(
            controller: password,
            hint: "********",
            label: "password",
            isPassword: true,
          ),
          Container(
            padding: const EdgeInsets.only(top: 3.0, bottom: 25.0),
            alignment: Alignment.topRight,
          ),
          LoginButton(
            onPressed: () => {userService.userLogin(email.text, password.text)},
            text: "Log In",
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
        ],
      ),
    );
  }
}
