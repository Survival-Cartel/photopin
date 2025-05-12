import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/presentation/screen/main/main_screen.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';

class MainScreenRoot extends StatelessWidget {
  final MainScreenViewModel viewModel;
  final StatefulNavigationShell navigationShell;

  const MainScreenRoot({
    super.key,
    required this.viewModel,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return MainScreen(
          navigationShell: navigationShell,
          state: viewModel.state,
        );
      },
    );
  }
}
