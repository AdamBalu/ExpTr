import 'package:flutter/material.dart';

class SettingFormWrapper extends StatelessWidget {
  final Widget form;
  final VoidCallback onSubmit;

  const SettingFormWrapper(
      {Key? key, required this.form, required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
            child: Column(children: [
      SizedBox(width: 300, child: form),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      ElevatedButton(
          onPressed: onSubmit,
          child: const SizedBox(
              width: 240, height: 40, child: Center(child: Text("Submit"))))
    ])));
  }
}
