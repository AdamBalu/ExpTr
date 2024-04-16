import 'package:expense_tracker/common/enums/saving_category.dart';
import 'package:expense_tracker/common/functions/reusable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../purchases/model/purchase.dart';

class CustomPieChart extends StatefulWidget {
  final double remainingBudgetMoney;
  final double totalBudgetMoney;
  final ItemCategory category;
  final List<Purchase> purchasesInCategory;

  const CustomPieChart(
      {super.key,
      required this.remainingBudgetMoney,
      required this.totalBudgetMoney,
      required this.category,
      required this.purchasesInCategory});

  @override
  _CustomPieChartState createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
              startDegreeOffset: -90,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: generatePieChartSections()),
        ),
      ),
    );
  }

  List<PieChartSectionData> generatePieChartSections() {
    final int numOfSections = widget.purchasesInCategory.length;
    var sections = <PieChartSectionData>[];

    _addRemainingBudgetSection(sections);

    for (int i = 0; i < numOfSections; i++) {
      final purchase = widget.purchasesInCategory[i];
      final isTouched = i + 1 == touchedIndex;
      final fontSize = isTouched ? 17.0 : 11.0;
      final radius = isTouched ? 110.0 : 100.0;
      final colors =
          isTouched ? const Color(0xFF000000) : const Color(0x8E000000);

      final String purchaseLabel =
          _getPurchasePieChartLabel(isTouched, purchase);

      sections.add(
        PieChartSectionData(
          color: getCategoryColor(widget.category, context).withAlpha(
              _calculatePurchaseSectionAlpha(
                  i, widget.purchasesInCategory.length)),
          value: purchase.cost,
          title: purchaseLabel,
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: colors,
          ),
        ),
      );
    }

    return sections;
  }

  int _calculatePurchaseSectionAlpha(int index, int length) {
    // Calculate the normalized value within the range of the purchases
    late double normalizedValue;
    if (length - 1 <= 0) {
      normalizedValue = 0;
    } else {
      normalizedValue = index / (length - 1);
    }

    // Map the normalized value inversely to the desired range (50 to 200)
    int minAlpha = 30;
    int maxAlpha = 225;
    int mappedAlpha =
        ((1 - normalizedValue) * (maxAlpha - minAlpha)).round() + minAlpha;

    return mappedAlpha;
  }

  void _addRemainingBudgetSection(List<PieChartSectionData> sections) {
    final String remainingBudgetMoneyText = touchedIndex == 0
        ? "Remaining budget"
        : "${widget.remainingBudgetMoney} €";

    sections.add(PieChartSectionData(
      color: _generatePieChartRemainingBudgetColor(
          widget.remainingBudgetMoney, widget.totalBudgetMoney),
      value: widget.remainingBudgetMoney,
      title: remainingBudgetMoneyText,
      radius: touchedIndex == 0 ? 110.0 : 100.0,
      titleStyle: TextStyle(
        fontSize: touchedIndex == 0 ? 20.0 : 16.0,
        fontWeight: FontWeight.bold,
        color: touchedIndex == 0
            ? const Color(0xFF000000)
            : const Color(0xFF000D57),
      ),
    ));
  }

  String _getPurchasePieChartLabel(bool isTouched, Purchase purchase) {
    return isTouched ? purchase.name : "${purchase.cost} €";
  }

  Color _generatePieChartRemainingBudgetColor(double value, double maxValue) {
    late double normalizedValue;
    if (maxValue > 0) {
      normalizedValue = value / maxValue;
    } else {
      normalizedValue = 0;
    }

    double hue = (normalizedValue * 360).clamp(0, 120);
    double red = 0.0;
    double green = 0.0;

    if (hue <= 100) {
      red = 1;
      green = hue / 60;
    } else {
      red = (180 - hue) / 360;
      green = 1;
    }

    double alpha = (normalizedValue * 125).round().toDouble();
    return Color.fromARGB(
      alpha.clamp(125, 255).toInt(),
      (red * 255).round(),
      (green * 255).round(),
      0,
    );
  }
}
