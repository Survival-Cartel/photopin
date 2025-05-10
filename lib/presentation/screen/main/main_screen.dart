import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void changeTab(int index) {
    widget.navigationShell.goBranch(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomSheet: BottomBar(
          selectedIndex: _selectedIndex,
          changeTab: changeTab
      ),
    );
  }
}
