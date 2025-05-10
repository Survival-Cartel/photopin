import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';
import 'package:photopin/presentation/component/top_bar.dart';

import '../../../core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di();
  runApp(const PhotopinApp());
}

class PhotopinApp extends StatelessWidget {
  const PhotopinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // ← GoRouter will create the shell
      debugShowCheckedModeBanner: false,
      theme: ThemeData(/* … */),
    );
  }
}

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
      appBar: TopBar(
        onNotificationTap: () {},
        profileImg: 'https://i.pravatar.cc/150?img=3',
      ),
      body: widget.navigationShell,
      bottomSheet: BottomBar(
        selectedIndex: _selectedIndex,
        changeTab: changeTab,
      ),
    );
  }
}
