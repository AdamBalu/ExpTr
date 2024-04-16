import 'package:expense_tracker/budget/widget/new_budget.dart';
import 'package:expense_tracker/plans/widget/new_plan.dart';
import 'package:expense_tracker/purchases/widget/new_purchase.dart';
import 'package:expense_tracker/savings/widget/new_saving.dart';
import 'package:expense_tracker/settings/widget/settings_item.dart';
import 'package:flutter/material.dart';

class ContextActionsMenu extends StatelessWidget {
  final void Function() hideContextActionsMenu;
  final bool isMenuShown;
  const ContextActionsMenu(
      {super.key,
      required this.isMenuShown,
      required this.hideContextActionsMenu});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: kBottomNavigationBarHeight,
      left: 0,
      right: 0,
      child: Visibility(
        visible: isMenuShown,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SettingsItem(
                        icon: const Icon(Icons.add_chart_rounded,
                            color: Colors.purple),
                        description: "New long-term plan",
                        onTap: () =>
                            _handleCreateButtonTap(const NewPlan(), context)),
                    SettingsItem(
                        icon: const Icon(Icons.add_shopping_cart,
                            color: Colors.green),
                        description: "New purchase",
                        onTap: () => _handleCreateButtonTap(
                            const NewPurchase(), context)),
                    SettingsItem(
                        icon: _getColoredImage(
                            Image.asset('assets/img/moneybag_add_icon.png',
                                width: 24, height: 24),
                            Colors.brown),
                        description: "New budget",
                        onTap: () =>
                            _handleCreateButtonTap(const NewBudget(), context)),
                    SettingsItem(
                        icon: _getColoredImage(
                            Image.asset('assets/img/money_shield_icon.png',
                                width: 24, height: 24),
                            Colors.blue),
                        description: "New saving",
                        onTap: () =>
                            _handleCreateButtonTap(const NewSaving(), context))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCreateButtonTap(Widget targetScreen, BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => targetScreen));
    hideContextActionsMenu();
  }

  Widget _getColoredImage(Image img, Color color) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: img,
    );
  }
}
