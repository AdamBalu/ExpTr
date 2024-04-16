import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/savings/service/savings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../common/enums/saving_category.dart';
import '../../common/service/ioc_container.dart';
import '../../common/widget/buttons/create_button.dart';
import '../../common/widget/custom_text_field.dart';

class NewSaving extends StatefulWidget {
  const NewSaving({super.key});

  @override
  _NewBudgetState createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewSaving> {
  Color _pickerColor = const Color(0x00ffffff);
  Color _currentColor = const Color(0x00ffffff);

  final _savingNameController = TextEditingController();
  final _savingAmountController = TextEditingController();
  ItemCategory selectedCategory = ItemCategory.other;

  final _savingsService = get<SavingsService>();
  final _planService = get<PlanService>();

  bool _isAmountInputValid = true;
  bool _isNameInputValid = true;
  String _invalidAmountInputLabel = "This field can't be empty!";
  final String _invalidNameInputLabel = "This field can't be empty!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New saving"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
                width: 300,
                child: Column(children: [
                  CustomTextField(
                      label: "Name",
                      hint: "August summer holiday",
                      controller: _savingNameController,
                      isInputValid: _isNameInputValid,
                      invalidInputLabel: _invalidNameInputLabel,
                      lengthLimit: 20),
                  CustomTextField(
                      label: "Amount",
                      hint: "433.55",
                      controller: _savingAmountController,
                      isNumber: true,
                      isInputValid: _isAmountInputValid,
                      invalidInputLabel: _invalidAmountInputLabel),
                  const SizedBox(height: 30),
                  OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(_currentColor),
                      ),
                      onPressed: () => _onPickColorButtonPressed(),
                      child: Text(
                        "Pick a color!",
                        style: TextStyle(
                            color: _getFontColorForBackground(_currentColor)),
                      )),
                  const SizedBox(height: 30)
                ])),
            CreateButton(onButtonPressed: () => _onCreateSavingButtonPressed())
          ]),
        ),
      ),
    );
  }

  void _onPickColorButtonPressed() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Pick a color"),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _pickerColor,
                onColorChanged: _changeSavingColor,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => _currentColor = _pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _onCreateSavingButtonPressed() {
    var amountDouble = double.tryParse(_savingAmountController.text);
    if (_allInputsValid(amountDouble)) {
      _savingsService.createSaving(_savingNameController.text,
          double.parse(_savingAmountController.text), _currentColor.value);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isNameInputValid = _savingNameController.text.isNotEmpty;
        _isAmountInputValid =
            amountDouble != null && _savingAmountController.text.isNotEmpty;
        _invalidAmountInputLabel =
            (amountDouble == null && _savingAmountController.text.isNotEmpty)
                ? "Only numbers and decimals!"
                : "This field can't be empty!";
      });
    }
  }

  bool _allInputsValid(double? amountDouble) =>
      _savingAmountController.text.isNotEmpty &&
      _savingNameController.text.isNotEmpty &&
      amountDouble != null;

  void _changeSavingColor(Color color) {
    setState(() => _pickerColor = color);
  }

  Color _getFontColorForBackground(Color background) {
    final luminance = background.computeLuminance();
    final alpha = background.alpha;
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    const alphaThreshold = 0.179;
    const lowAlphaThreshold = 80;

    if (alpha < alphaThreshold + 70 && isDarkMode) {
      return Colors.white;
    } else if (luminance > alphaThreshold || alpha < lowAlphaThreshold) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }
}
