import 'package:expense_tracker/settings/widget/preferences.dart';
import 'package:expense_tracker/settings/widget/settings_section.dart';
import 'package:flutter/material.dart';
import 'account_settings.dart';
import 'setting_actions.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SettingsSection(
                title: "Account", settings: AccountSettings()),
            const SettingsSection(
                title: "Preferences", settings: Preferences()),
            SettingsSection(title: "Actions", settings: SettingActions())
          ],
        ),
      ),
    );
  }
}
