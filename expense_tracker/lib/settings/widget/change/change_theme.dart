import 'package:flutter/material.dart';

import '../settings_item.dart';
import '../../../app_root.dart';

class ChangeTheme extends StatelessWidget {
  const ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change theme"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              child: Column(children: [
                SettingsItem(
                  icon: const Icon(Icons.light_mode),
                  description: 'Light',
                  onTap: () =>
                      AppRoot.of(context)?.changeTheme(ThemeMode.light),
                ),
                SettingsItem(
                  icon: const Icon(Icons.dark_mode),
                  description: 'Dark',
                  onTap: () => AppRoot.of(context)?.changeTheme(ThemeMode.dark),
                ),
                SettingsItem(
                  icon: const Icon(Icons.settings_suggest),
                  description: 'System default',
                  onTap: () =>
                      AppRoot.of(context)?.changeTheme(ThemeMode.system),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
