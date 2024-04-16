import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:expense_tracker/settings/widget/settings_item.dart';
import 'package:flutter/material.dart';

class SettingActions extends StatelessWidget {
  SettingActions({super.key});

  final _userService = get<UserService>();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SettingsItem(
            icon: const Icon(Icons.logout),
            description: 'Log out',
            onTap: () => {_userService.userLogout()},
          ),
        ],
      ),
    );
  }
}
