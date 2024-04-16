import 'package:expense_tracker/common/widget/buttons/create_button.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:flutter/material.dart';
import '../../common/enums/saving_category.dart';
import '../../common/functions/reusable.dart';
import '../../common/service/ioc_container.dart';
import '../../common/widget/category_select_button.dart';
import '../../common/widget/custom_stream_builder.dart';
import '../../common/widget/custom_text_field.dart';
import '../../common/widget/category_select_card.dart';
import '../../plans/model/plan.dart';
import '../service/budget_service.dart';

class NewBudget extends StatefulWidget {
  const NewBudget({Key? key}) : super(key: key);

  @override
  _NewBudgetState createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewBudget> {
  final amount = TextEditingController();
  ItemCategory selectedCategory = ItemCategory.other;
  final _budgetService = get<BudgetService>();
  final _planService = get<PlanService>();

  bool _isAmountInputValid = true;
  String _invalidAmountInputLabel = "This field can't be empty!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New budget"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
                width: 300,
                child: Column(children: [
                  CustomTextField(
                      label: "Amount",
                      hint: "433.55",
                      controller: amount,
                      isNumber: true,
                      isInputValid: _isAmountInputValid,
                      invalidInputLabel: _invalidAmountInputLabel)
                ])),
            buildCategorySelectCard(
                (category) => buildCategorySelectButton(category, () {
                      setState(() {
                        selectedCategory = category;
                      });
                    }, selectedCategory == category, context)),
            CustomStreamBuilder(
                stream: _planService.selectedPlanStream,
                builder: (context, AsyncSnapshot<SelectedPlan> snapshot) {
                  var selectedPlan = snapshot.data!;
                  return CustomStreamBuilder(
                      stream: _planService
                          .observeSelectedPlan(selectedPlan.plan.id),
                      builder: (context, AsyncSnapshot<Plan> snapshot) {
                        return CreateButton(
                            onButtonPressed: () =>
                                _handleCreateBudgetButtonPress(snapshot));
                      });
                }),
          ]),
        ),
      ),
    );
  }

  void _handleCreateBudgetButtonPress(AsyncSnapshot<Plan> snapshot) {
    var planBudgetData = snapshot.data!;
    var amountDouble = double.tryParse(amount.text);
    if (amount.text.isNotEmpty && amountDouble != null) {
      _budgetService.createBudget(
          selectedCategory, double.parse(amount.text), planBudgetData);
      Navigator.of(context).pop();
    } else {
      setState(() {
        _invalidAmountInputLabel =
            (amountDouble == null && amount.text.isNotEmpty)
                ? "Only numbers and decimals!"
                : "This field can't be empty!";
        _isAmountInputValid = false;
      });
    }
  }
}
