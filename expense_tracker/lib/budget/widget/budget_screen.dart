import 'package:expense_tracker/budget/model/budget.dart';
import 'package:expense_tracker/budget/service/budget_service.dart';
import 'package:expense_tracker/budget/widget/expandable_budget_card.dart';
import 'package:expense_tracker/common/enums/saving_category.dart';
import 'package:expense_tracker/common/functions/reusable.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/purchases/model/purchase.dart';
import 'package:expense_tracker/purchases/service/purchase_service.dart';
import 'package:flutter/material.dart';
import '../../common/widget/profile_button.dart';
import '../../plans/model/plan.dart';
import 'custom_pie_chart.dart';
import 'new_budget.dart';

class BudgetScreen extends StatelessWidget {
  BudgetScreen({super.key});

  final _planService = get<PlanService>();
  final _purchaseService = get<PurchaseService>();
  final _budgetService = get<BudgetService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: const ProfileButton()),
        body: Center(
          child: CustomStreamBuilder(
              stream: _planService.selectedPlanStream,
              builder: (context, AsyncSnapshot<SelectedPlan> snapshot) {
                return CustomStreamBuilder(
                    stream: _planService.observeSelectedPlan(snapshot.data!.plan.id),
                    builder: (context, AsyncSnapshot<Plan> snapshot) {
                      var planBudgetData = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomStreamBuilder(
                              stream: _budgetService
                                  .observeGroupBudgets(planBudgetData.categoryBudgets),
                              builder: (context, AsyncSnapshot<List<Budget>> snapshot) {
                                final budgets = snapshot.data!;

                                if (budgets.isEmpty) {
                                  return const Center(
                                      child: Text("This group has no budget categories set",
                                          style: TextStyle(fontSize: 20)));
                                }
                                return _buildBudgetCards(budgets, planBudgetData);
                              }),
                        ],
                      );
                    });
              }),
        ));
  }

  Widget _buildBudgetCards(List<Budget> budgets, Plan plan) {
    return Expanded(
      child: CustomStreamBuilder(
          stream: _purchaseService.observeGroupPurchases(plan.purchases),
          builder: (context, AsyncSnapshot<List<Purchase>> snapshot) {
            final List<Widget> columnCharts = [];
            final planPurchases = snapshot.data!;

            // iterate trough list categoryBudgets
            for (Budget budget in budgets) {
              // retrieve purchases that fall under the categoryBudget
              List<Purchase> budgetPurchases = planPurchases
                  .where((purchase) =>
                      purchase.category == budget.itemCategory &&
                      purchase.date.compareTo(plan.intervalStart!) == 1 &&
                      purchase.date.compareTo(
                              plan.intervalStart!.add(Duration(days: plan.intervalDuration))) ==
                          -1)
                  .toList();

              // fill out data
              columnCharts.add(_buildBudgetCard(
                  CustomPieChart(
                    remainingBudgetMoney: budget.usedValue,
                    totalBudgetMoney: budget.value,
                    category: budget.itemCategory,

                    // map individual purchases into Purchase widgets
                    purchasesInCategory: budgetPurchases
                        .map((purchase) => Purchase(purchase.name, purchase.description,
                            purchase.cost, purchase.category, purchase.id, purchase.date, ""))
                        .toList(),
                  ),
                  budget,
                  plan));
            }

            if (columnCharts.isNotEmpty) {
              return SingleChildScrollView(child: Column(children: columnCharts));
            } else {
              return const Text("Could not load data, idk why, sucks to be you");
            }
          }),
    );
  }

  Widget _buildBudgetCard(CustomPieChart chart, Budget budget, Plan plan) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpandableBudgetCard(chart: chart, budget: budget, plan: plan),
    );
  }
}
