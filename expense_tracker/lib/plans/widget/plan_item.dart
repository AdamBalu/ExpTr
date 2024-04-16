import 'package:expense_tracker/budget/service/budget_service.dart';
import 'package:expense_tracker/common/service/common_service.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/purchases/service/purchase_service.dart';
import 'package:expense_tracker/savings/service/savings_service.dart';
import 'package:expense_tracker/user/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../common/widget/custom_text_field.dart';
import '../model/plan.dart';

class PlanItem extends StatelessWidget {
  final Plan plan;
  final Plan selectedPlan;
  final Plan personalPlan;
  PlanItem({super.key, required this.plan, required this.selectedPlan, required this.personalPlan});

  final _commonService = get<CommonService>();
  final _userService = get<UserService>();
  final _budgetService = get<BudgetService>();
  final _purchaseService = get<PurchaseService>();
  final _savingsService = get<SavingsService>();
  final _planService = get<PlanService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: (selectedPlan.id == plan.id)
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlanHeading(context),
              Text("Purchases: ${plan.purchases.length}"),
              Text("Savings: ${plan.savings.length}"),
              Text("Budgets: ${plan.categoryBudgets.length}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Unused budget: ${plan.budget}€",
                  ),
                  IconButton.outlined(
                      onPressed: () => {_dialogBuilder(context, plan)}, icon: const Icon(Icons.add))
                ],
              ),
              const Spacer(),
              _buildIntervalProgressIndicator(context),
              const Spacer(),
              _buildBudgetProgressIndicator(context),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanHeading(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 0,
          child: Text(
            plan.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        Expanded(
          child: PopupMenuButton<String>(
            iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
            onSelected: (value) {
              if (value == '/delete') {
                _planService.selectPersonalPlan(personalPlan, true);
                _deletePlan(plan);
              }
            },
            itemBuilder: (BuildContext context) {
              return _buildPopupMenuItems();
            },
          ),
        )
      ],
    );
  }

  Widget _buildBudgetProgressIndicator(BuildContext context) {
    return FutureBuilder(
      future: _budgetService.getTotalBudget(plan),
      builder: (context, AsyncSnapshot<double> snapshot) {
        final totalBudget = snapshot.data;
        return FutureBuilder(
          future: _budgetService.getTotalBudget(plan, isUsedBudget: true),
          builder: (context, AsyncSnapshot<double> snapshot) {
            final usedBudget = snapshot.data;

            if (usedBudget != null && totalBudget != null) {
              bool wholeUsedNumber = usedBudget == usedBudget.toInt();
              bool wholeTotalNumber = totalBudget == totalBudget.toInt();

              return LinearPercentIndicator(
                progressColor: Colors.yellow,
                lineHeight: 20.0,
                barRadius: const Radius.circular(4),
                center: Text(
                  "${wholeUsedNumber ? usedBudget.toInt() : usedBudget}€ / ${wholeTotalNumber ? totalBudget.toInt() : totalBudget}€ remaining",
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                percent: totalBudget == 0
                    ? 0
                    : ((usedBudget / totalBudget) > 1 ? 0 : (usedBudget / totalBudget)),
              );
            } else {
              return const Text("Could not load budgets");
            }
          },
        );
      },
    );
  }

  Widget _buildIntervalProgressIndicator(BuildContext context) {
    final int daysLeft = (-DateTime.now()
        .difference(plan.intervalStart!.add(Duration(days: plan.intervalDuration)))
        .inDays);

    return LinearPercentIndicator(
      progressColor: Colors.orangeAccent,
      lineHeight: 18.0,
      barRadius: const Radius.circular(4),
      center: Text(
        "$daysLeft days left",
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      percent:
          (1 - daysLeft / plan.intervalDuration) > 0 ? 0 : (1 - daysLeft / plan.intervalDuration),
    );
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

  Future<void> _deletePlan(Plan plan) async {
    if (_userService.currentUserId == plan.ownerId) {
      for (var purchaseId in plan.purchases) {
        _purchaseService.deletePurchase(purchaseId);
      }

      for (var savingId in plan.savings) {
        _savingsService.deleteSaving(savingId, plan);
      }

      for (var budgetId in plan.categoryBudgets) {
        _budgetService.deleteBudget(budgetId, plan);
      }

      _planService.deletePlan(plan.id);
    } else {
      _commonService.throwToastNotification("You are not the owner");
    }
  }

  Future<void> _dialogBuilder(BuildContext context, Plan plan) {
    final value = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Charge budget'),
          actions: [
            Center(
              child: FloatingActionButton(
                child: const Text("+"),
                onPressed: () async {
                  _planService
                      .addBudget(double.parse(value.text))
                      .then((_) => Navigator.of(context).pop());
                },
              ),
            )
          ],
          content: CustomTextField(
            label: "amount",
            hint: "10.2",
            controller: value,
            isNumber: true,
          ),
        );
      },
    );
  }
}
