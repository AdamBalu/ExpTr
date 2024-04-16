import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/common/widget/custom_text_field.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/savings/model/saving.dart';
import 'package:expense_tracker/savings/service/savings_service.dart';
import 'package:flutter/material.dart';

import '../../common/widget/profile_button.dart';
import '../../plans/model/plan.dart';

class SavingsScreen extends StatelessWidget {
  SavingsScreen({Key? key}) : super(key: key);

  final _savingService = get<SavingsService>();
  final _planService = get<PlanService>();

  final _moneyAddController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const ProfileButton()),
      body: CustomStreamBuilder(
          stream: _planService.selectedPlanStream,
          builder: (context, AsyncSnapshot<SelectedPlan> snapshot) {
            final selectedPlan = snapshot.data!;

            return CustomStreamBuilder(
                stream: _planService.observeSelectedPlan(selectedPlan.plan.id),
                builder: (context, AsyncSnapshot<Plan> snapshot) {
                  final planData = snapshot.data!;
                  return CustomStreamBuilder(
                      stream: _savingService.observeGroupSavings(snapshot.data!.savings),
                      builder: (context, AsyncSnapshot<List<Saving>> snapshot) {
                        final savings = snapshot.data!;

                        if (savings.isEmpty) {
                          return const Center(
                              child: Text("This group has no savings",
                                  style: TextStyle(fontSize: 20)));
                        }
                        return Column(children: [
                          Column(
                            children: [
                              const Text("Money saved from budgets", textAlign: TextAlign.center),
                              Text("${planData.extraBudget} €",
                                  style:
                                      const TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                child: Text(
                                    "You can distribute this money into your created savings by clicking a respective button in the saving",
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              itemBuilder: (context, index) =>
                                  _buildSaving(savings[index], context, planData),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8), // Smaller gap
                              itemCount: savings.length,
                            ),
                          ),
                        ]);
                      });
                });
          }),
    );
  }

  Widget _buildSaving(Saving saving, BuildContext context, Plan plan) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  saving.name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      child: IconButton(
                          onPressed: () {
                            _handleAddMoneyButtonClick(context, saving, plan);
                          },
                          icon: const Icon(Icons.payments, color: Color(0xFF197E1E))),
                    ),
                    PopupMenuButton<String>(
                      iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
                      onSelected: (value) {
                        if (value == '/delete') {
                          _savingService.deleteSaving(saving.id, plan);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return _buildPopupMenuItems();
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Saved money: ${saving.currentValue} € / ${saving.requiredValue} €",
                style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
            ),
            LinearProgressIndicator(
                value: saving.currentValue / saving.requiredValue,
                minHeight: 20,
                color: Color(saving.color).withAlpha(170),
                backgroundColor: Color(saving.color).withAlpha(50),
                borderRadius: BorderRadius.circular(5))
          ],
        ),
      ),
    );
  }

  _handleAddMoneyButtonClick(BuildContext context, Saving saving, Plan plan) {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add money"),
              content: CustomTextField(
                  label: 'Money', hint: '34.75', controller: _moneyAddController, isNumber: true),
              actions: [
                TextButton(
                    onPressed: () {
                      try {
                        _savingService.addMoneyToSaving(
                            saving, double.parse(_moneyAddController.text), plan);
                      } catch (e) {
                        //TODO ERR
                      }

                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"))
              ],
            ));
  }

  List<PopupMenuItem<String>> _buildPopupMenuItems() {
    return const [
      PopupMenuItem(
          value: '/delete',
          child: Row(
            children: [Icon(Icons.delete), SizedBox(width: 10), Text("Delete")],
          )),
    ];
  }
}
