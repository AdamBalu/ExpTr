import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../common/service/ioc_container.dart';
import '../../common/widget/buttons/create_button.dart';
import '../../common/widget/custom_text_field.dart';
import '../../user/service/user_service.dart';
import '../service/plan_service.dart';

class NewPlan extends StatefulWidget {
  const NewPlan({super.key});

  @override
  State<NewPlan> createState() => _NewPlanState();
}

class _NewPlanState extends State<NewPlan> {
  int _dayPeriod = 30;

  final planNameController = TextEditingController();
  final planPeriodController = TextEditingController();
  final _userService = get<UserService>();
  final _planService = get<PlanService>();
  bool _isPlanNameInputValid = true;
  bool _isPlanCustomIntervalValid = true;
  String _invalidPlanIntervalLabel = "This field can't be empty!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New plan"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: CustomTextField(
                    label: "Name",
                    hint: "My new saving plan",
                    controller: planNameController,
                    isInputValid: _isPlanNameInputValid,
                    lengthLimit: 15),
              ),
              Column(
                children: [
                  const SizedBox(height: 25),
                  const Text("Interval (in days)"),
                  NumberPicker(
                      minValue: 1,
                      maxValue: 31,
                      value: _dayPeriod,
                      onChanged: (val) => setState(() {
                            _dayPeriod = val;
                          })),
                ],
              ),
              SizedBox(
                width: 300,
                child: CustomTextField(
                    label: "Custom interval (optional)",
                    hint: "365",
                    controller: planPeriodController,
                    isNumber: true,
                    isInputValid: _isPlanCustomIntervalValid,
                    invalidInputLabel: _invalidPlanIntervalLabel),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CreateButton(
                  onButtonPressed: () => _handleCreatePlanButtonClick(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreatePlanButtonClick() {
    var textFieldPeriod = planPeriodController.text;
    int? parsedInterval = int.tryParse(textFieldPeriod);

    if (textFieldPeriod.isEmpty) {
      parsedInterval = _dayPeriod;
    }

    setState(() {
      _invalidPlanIntervalLabel = parsedInterval == null ? "The value is not a number!" : "";
      _isPlanCustomIntervalValid = parsedInterval != null;
      _isPlanNameInputValid = planNameController.text.isNotEmpty;
    });

    if (_isPlanNameInputValid && _isPlanCustomIntervalValid) {
      _planService.createPlan(
          _userService.currentUserId, planNameController.text, false, parsedInterval!, false);
      Navigator.of(context).pop();
    }
  }
}
