import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final void Function() onButtonPressed;
  const CreateButton({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: IconButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color?>(
                  Theme.of(context).colorScheme.primaryContainer)),
          onPressed: () => onButtonPressed(),
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.done, color: Theme.of(context).colorScheme.onPrimaryContainer),
              const SizedBox(width: 10),
              const Text("Create", style: TextStyle(color: Colors.white))
            ],
          )),
    );
  }
}
