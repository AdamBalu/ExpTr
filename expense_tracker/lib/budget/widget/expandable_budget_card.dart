import 'package:expense_tracker/common/widget/custom_text_field.dart';
import 'package:expense_tracker/plans/service/plan_service.dart';
import 'package:flutter/material.dart';

import '../../common/functions/reusable.dart';
import '../../common/service/ioc_container.dart';
import '../../plans/model/plan.dart';
import '../model/budget.dart';
import '../service/budget_service.dart';
import 'custom_pie_chart.dart';

class ExpandableBudgetCard extends StatefulWidget {
  final CustomPieChart chart;
  final Budget budget;
  final Plan plan;

  const ExpandableBudgetCard(
      {super.key,
      required this.chart,
      required this.budget,
      required this.plan});

  @override
  _ExpandableBudgetCardState createState() => _ExpandableBudgetCardState();
}

class _ExpandableBudgetCardState extends State<ExpandableBudgetCard> {
  bool _isExpanded = false;

  final _budgetService = get<BudgetService>();
  final _planService = get<PlanService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: _isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(capitalizeWord(widget.chart.category.name),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const Text(
                            "Budget",
                            textAlign: TextAlign.left,
                          )
                        ])
                  : Row(
                      children: [
                        Text(capitalizeWord(widget.chart.category.name)),
                      ],
                    ),
              trailing: Container(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Row(
                  children: [
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == '/delete') {
                          _budgetService.deleteBudget(
                              widget.budget.id, widget.plan);
                        }
                        if (value == '/charge_budget') {
                          _dialogBuilder(context, widget.budget);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return _buildPopupMenuItems();
                      },
                    ),
                    IconButton(
                      icon: _isExpanded
                          ? const Icon(Icons.expand_less)
                          : const Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            _isExpanded ? widget.chart : _buildCollapsedContent(widget.chart),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Budget budget) {
    final value = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Increase budget'),
          actions: [
            Center(
              child: FloatingActionButton(
                child: const Text("+"),
                onPressed: () async {
                  if (await _planService.addBudget(-double.parse(value.text))) {
                    await _budgetService
                        .updateBudgetValue(
                            budget.copyWith(
                                value: budget.value + double.parse(value.text),
                                usedValue: budget.usedValue +
                                    double.parse(value.text)),
                            updateTotalValue: true)
                        .then((_) => Navigator.of(context).pop());
                  }
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

  Widget _buildCollapsedContent(CustomPieChart chart) {
    final Color categoryColor = getCategoryColor(chart.category, context);
    return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                " ${(chart.totalBudgetMoney != 0 ? 100 - (chart.remainingBudgetMoney / chart.totalBudgetMoney * 100) : 0).toStringAsFixed(0)}% spent",
              ),
            ),
            LinearProgressIndicator(
              color: categoryColor,
              backgroundColor: categoryColor.withAlpha(65),
              minHeight: 25,
              value: chart.totalBudgetMoney != 0
                  ? 1 - (chart.remainingBudgetMoney / chart.totalBudgetMoney)
                  : 0,
              borderRadius: BorderRadius.circular(5),
            ),
          ],
        ));
  }

  List<PopupMenuItem<String>> _buildPopupMenuItems() {
    return const [
      PopupMenuItem(
          value: '/charge_budget',
          child: Row(
            children: [Icon(Icons.add), SizedBox(width: 10), Text("Increase")],
          )),
      PopupMenuItem(
          value: '/delete',
          child: Row(
            children: [Icon(Icons.delete), SizedBox(width: 10), Text("Delete")],
          )),
    ];
  }
}
