import 'package:expense_tracker/purchases/widget/purchases_screen.dart';
import 'package:flutter/material.dart';

import 'bottom_navbar/bottom_navbar.dart';
import 'budget/widget/budget_screen.dart';
import 'context_actions_menu.dart';
import 'homepage/widget/home_screen.dart';
import 'savings/widget/savings_screen.dart';

import 'color_schemes.g.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);
  @override
  State<AppRoot> createState() => _AppRootState();

  static _AppRootState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppRootState>();
  }
}

class _AppRootState extends State<AppRoot> {
  bool _isContextMenuShown = false;
  int _selectedIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;

  static final List<Widget> _screens = <Widget>[
    HomeScreen(),
    PurchasesScreen(),
    const Placeholder(),
    BudgetScreen(),
    SavingsScreen()
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _toggleContextMenuVisibility();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _toggleContextMenuVisibility() {
    setState(() {
      _isContextMenuShown = !_isContextMenuShown;
    });
  }

  void _turnOffContextMenuVisibility() {
    setState(() {
      _isContextMenuShown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: _themeMode,
      home: GestureDetector(
        onTap: () => {_turnOffContextMenuVisibility()},
        child: Scaffold(
          body: Stack(children: [
            IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            ContextActionsMenu(
              isMenuShown: _isContextMenuShown,
              hideContextActionsMenu: () => _turnOffContextMenuVisibility(),
            )
          ]),
          bottomNavigationBar: BottomNavbar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
