// lib/presentation/screen/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';
import 'package:photopin/presentation/component/top_bar.dart';
import 'package:photopin/presentation/screen/main/main_state.dart';

class MainScreen extends StatefulWidget {
  final MainState state;
  final StatefulNavigationShell navigationShell;

  const MainScreen({
    super.key,
    required this.state,
    required this.navigationShell,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void changeTab(int index) {
    // index 2는 카메라 버튼
    // 카메라 버튼 누를 시에 ShellBranch를 벗어나서 카메라 런처 스크린 실행해야함, 아니면 State가 유지되지 않음
    if (index == 2) {
      context.push(Routes.camera);
      return;
    }

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
        profileImg: widget.state.userModel.profileImg,
      ),
      body: widget.navigationShell,
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        changeTab: changeTab,
      ),
    );
  }
}
