import 'package:expense_tracker/settings/widget/change/change_password.dart';
import 'package:expense_tracker/settings/widget/settings_item.dart';
import 'package:flutter/material.dart';
import 'change/change_email.dart';
import 'change/change_username.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SettingsItem(
            icon: const Icon(Icons.person),
            description: 'Change username',
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeUsername()))
            },
          ),
          SettingsItem(
            icon: const Icon(Icons.alternate_email),
            description: 'Change email',
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeEmail()))
            },
          ),
          SettingsItem(
            icon: const Icon(Icons.lock_reset),
            description: 'Change password',
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePassword()))
            },
          ),
        ],
      ),
    );
  }
}
