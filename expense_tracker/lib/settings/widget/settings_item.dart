import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final Widget icon;
  final String description;
  final void Function() onTap;
  const SettingsItem(
      {Key? key,
      required this.icon,
      required this.description,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(children: [
                icon,
                const VerticalDivider(width: 20),
                Text(description),
              ]))),
    );
  }
}
