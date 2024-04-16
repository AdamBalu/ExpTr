import 'package:flutter/material.dart';

import '../../settings/widget/settings.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle,
          size: 30.0, color: Theme.of(context).colorScheme.tertiary),
      onPressed: () => {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Settings()))
      },
    );
  }
}
