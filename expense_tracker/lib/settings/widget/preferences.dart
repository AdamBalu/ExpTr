import 'package:expense_tracker/settings/widget/settings_item.dart';
import 'package:flutter/material.dart';

import 'change/change_theme.dart';

class Preferences extends StatelessWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        SettingsItem(
          icon: const Icon(Icons.palette),
          description: 'Appearance',
          onTap: () => {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChangeTheme()))
          },
        ),
      ],
    ));
  }
}
