import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:expense_tracker/color_schemes.g.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNavbar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.fixedCircle,
      height: 60,
      items: [
        TabItem(
            icon: _getColoredNavbarIcon(
                0, Image.asset('assets/img/piggy_icon.png', width: 24, height: 24), context),
            title: "Overview"),
        TabItem(
            icon: Icon(Icons.add_shopping_cart, color: _getColor(1, context)), title: "Purchases"),
        TabItem(
            icon: Icon(
          Icons.add,
          size: 30,
          color: Theme.of(context).colorScheme.primaryContainer,
        )),
        TabItem(
            icon: _getColoredNavbarIcon(
                3, Image.asset('assets/img/moneybag_icon.png', width: 24, height: 24), context),
            title: "Budgets"),
        TabItem(
            icon: _getColoredNavbarIcon(
                4, Image.asset('assets/img/money_shield_icon.png', width: 24, height: 24), context),
            title: "Savings")
      ],
      onTap: onItemTapped,
      color: Theme.of(context).colorScheme.primary,
      activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  ColorFiltered _getColoredNavbarIcon(int index, Widget? img, BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(_getColor(index, context), BlendMode.srcIn),
      child: img,
    );
  }

  Color _getColor(int index, BuildContext context) => (selectedIndex == index)
      ? Theme.of(context).colorScheme.onPrimaryContainer
      : Theme.of(context).colorScheme.primary;
}
