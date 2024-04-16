import 'package:expense_tracker/budget/service/budget_service.dart';
import 'package:expense_tracker/common/functions/reusable.dart';
import 'package:expense_tracker/common/service/ioc_container.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:expense_tracker/purchases/service/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../plans/model/plan.dart';
import '../model/purchase.dart';

class PurchaseItem extends StatelessWidget {
  final Plan plan;
  final Purchase purchase;
  PurchaseItem({super.key, required this.purchase, required this.plan});

  final _purchaseService = get<PurchaseService>();
  final _budgetService = get<BudgetService>();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildColoredItemName(context, textColor),
                PopupMenuButton<String>(
                  iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  onSelected: (value) async {
                    if (value == '/delete') {
                      if (plan.intervalStart != null &&
                          purchase.date.compareTo(plan.intervalStart!) == 1 &&
                          purchase.date.compareTo(plan.intervalStart!.add(
                                  Duration(days: plan.intervalDuration))) ==
                              -1) {
                        var budgets = await _budgetService
                            .getBudgetsFromList(plan.categoryBudgets);
                        var selectedBudget = budgets
                            .where((budget) =>
                                budget.itemCategory == purchase.category)
                            .first;
                        await _budgetService.updateBudgetValue(
                            selectedBudget.copyWith(
                                usedValue:
                                    selectedBudget.usedValue + purchase.cost));

                        await _purchaseService.deletePurchase(purchase.id);
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return _buildPopupMenuItems();
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 35.0),
              child: Text(
                purchase.description,
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPurchaseDate(textColor),
                Row(
                  children: [
                    _buildItemCost(context, textColor),
                    _buildBillButton(context)
                  ],
                )
              ],
            )
          ],
        ),
      ),
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

  Widget _buildColoredItemName(BuildContext context, Color textColor) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Center(
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getCategoryColor(purchase.category, context),
              ),
            ),
          ),
        ),
        Text(
          purchase.name,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
        ),
      ],
    );
  }

  Widget _buildPurchaseDate(Color textColor) {
    return Row(
      children: [
        Icon(Icons.calendar_month, color: textColor),
        const VerticalDivider(width: 5),
        Text(
          formatDate(purchase.date),
          style: TextStyle(fontSize: 13, color: textColor),
        )
      ],
    );
  }

  Widget _buildItemCost(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        "${purchase.cost}€",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18.0, color: textColor),
      ),
    );
  }

  Widget _buildBillButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton.outlined(
        hoverColor: const Color(0xffececec),
        icon: ColorFiltered(
          colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSecondaryContainer,
              BlendMode.srcIn),
          child: Image.asset('assets/img/bill.png', width: 24, height: 24),
        ),
        onPressed: () => {
          if (purchase.imageUrl != "")
            _showImageDialog(context, purchase.imageUrl)
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Set your desired border radius here
            ),
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Image.network(imageUrl),
        );
      },
    );
  }
}
