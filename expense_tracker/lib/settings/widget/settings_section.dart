import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final Widget settings;
  const SettingsSection({Key? key, required this.settings, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.tertiary)),
        settings,
        const Padding(padding: EdgeInsets.all(10)),
      ],
    );
  }
}
