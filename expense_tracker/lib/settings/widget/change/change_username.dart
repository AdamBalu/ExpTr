import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:expense_tracker/settings/widget/setting_form_wrapper.dart';
import 'package:flutter/material.dart';

import '../../../common/widget/custom_text_field.dart';

class ChangeUsername extends StatelessWidget {
  ChangeUsername({super.key});

  final _userService = get<UserService>();

  @override
  Widget build(BuildContext context) {
    final newUsername = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Change username"),
        ),
        body: SettingFormWrapper(
          form: Column(
            children: [CustomTextField(label: "New username", hint: "", controller: newUsername)],
          ),
          onSubmit: () => {
            _userService.changeUsername(_userService.currentUserId, newUsername.text),
            Navigator.of(context).pop()
          },
        ));
  }
}
