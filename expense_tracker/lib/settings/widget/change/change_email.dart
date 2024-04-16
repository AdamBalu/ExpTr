import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:expense_tracker/settings/widget/setting_form_wrapper.dart';
import 'package:flutter/material.dart';
import '../../../common/widget/custom_text_field.dart';

class ChangeEmail extends StatelessWidget {
  ChangeEmail({super.key});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    final newEmail = TextEditingController();
    final oldEmail = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Change email"),
        ),
        body: SettingFormWrapper(
          form: Column(
            children: [
              CustomTextField(label: "Old email", hint: "your_old@email.com", controller: oldEmail),
              CustomTextField(label: "New email", hint: "your_new@email.com", controller: newEmail),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              CustomTextField(
                  label: "Your password", hint: "********", controller: password, isPassword: true),
            ],
          ),
          onSubmit: () => {
            _userService.updateEmail(oldEmail.text, newEmail.text, password.text),
            Navigator.of(context).pop()
          },
        ));
  }
}
