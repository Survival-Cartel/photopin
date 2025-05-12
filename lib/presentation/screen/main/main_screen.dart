// lib/presentation/screen/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';
import 'package:photopin/presentation/component/top_bar.dart';
import 'package:photopin/presentation/screen/main/main_state.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';

class MainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<MainScreenViewModel>(param1: widget.navigationShell);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MainScreenState>(
      valueListenable: _viewModel.stateNotifier,
      builder: (context, state, _) {
        return Scaffold(
          appBar: TopBar(
            profileImg: _viewModel.profileImgToDisplay,
            onNotificationTap: () {},
          ),
          body: widget.navigationShell,
          bottomSheet: BottomBar(
            selectedIndex: state.selectedIndex,
            changeTab: _viewModel.changeTab,
          ),
        );
      },
    );
  }
}
