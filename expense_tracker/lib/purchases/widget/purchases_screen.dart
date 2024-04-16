import 'package:expense_tracker/budget/widget/new_budget.dart';
import 'package:expense_tracker/common/widget/custom_stream_builder.dart';
import 'package:expense_tracker/purchases/service/purchase_service.dart';
import 'package:expense_tracker/purchases/widget/purchase_item.dart';
import 'package:flutter/material.dart';
import '../../common/service/ioc_container.dart';
import '../../common/widget/profile_button.dart';
import '../../plans/service/plan_service.dart';

class PurchasesScreen extends StatelessWidget {
  PurchasesScreen({super.key});

  final _planService = get<PlanService>();
  final _purchaseService = get<PurchaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: const ProfileButton()),
        body: CustomStreamBuilder(
            stream: _planService.selectedPlanStream,
            builder: (context, AsyncSnapshot<SelectedPlan> snapshot) {
              return CustomStreamBuilder(
                  stream: _planService.observeSelectedPlan(snapshot.data!.plan.id),
                  builder: (context, snapshot) {
                    var planData = snapshot.data!;
                    return CustomStreamBuilder(
                        stream: _purchaseService.observeGroupPurchases(snapshot.data!.purchases),
                        builder: (context, snapshot) {
                          final purchases = snapshot.data!;
                          purchases.sort((a, b) => b.date.compareTo(a.date) + 1);

                          if (purchases.isEmpty) {
                            if (planData.categoryBudgets.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("You haven't created any budgets yet",
                                        style: TextStyle(fontSize: 20)),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                        onPressed: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => const NewBudget())),
                                        child: const Text("Create budget")),
                                  ],
                                ),
                              );
                            }
                            return const Center(
                                child:
                                    Text("There are no purchases", style: TextStyle(fontSize: 20)));
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            itemBuilder: (context, index) => PurchaseItem(
                              plan: planData,
                              purchase: purchases[index],
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8), // Smaller gap
                            itemCount: purchases.length,
                          );
                        });
                  });
            }));
  }
}
