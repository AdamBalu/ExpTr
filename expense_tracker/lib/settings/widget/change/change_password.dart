import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:expense_tracker/settings/widget/setting_form_wrapper.dart';
import 'package:flutter/material.dart';

import '../../../common/widget/custom_text_field.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    final oldPassword = TextEditingController();
    final newPassword = TextEditingController();
    final newPasswordRepeated = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Change password"),
        ),
        body: SettingFormWrapper(
          form: Column(
            children: [
              CustomTextField(
                  label: "Old password",
                  hint: "********",
                  controller: oldPassword,
                  isPassword: true),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              CustomTextField(
                  label: "New password",
                  hint: "********",
                  controller: newPassword,
                  isPassword: true),
              CustomTextField(
                  label: "Repeat new password",
                  hint: "********",
                  controller: newPasswordRepeated,
                  isPassword: true)
            ],
          ),
          onSubmit: () {
            if (newPassword.text == newPasswordRepeated.text) {
              _userService.changePassword(oldPassword.text, newPassword.text);
            }
            Navigator.of(context).pop();
          },
        ));
  }
}
