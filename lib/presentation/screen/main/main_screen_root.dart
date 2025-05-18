import 'dart:async';

import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/stream_event/stream_event.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/screen/main/main_screen.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';

class MainScreenRoot extends StatefulWidget {
  final MainScreenViewModel viewModel;
  final StatefulNavigationShell navigationShell;
  final StreamController<StreamEvent> streamController;

  const MainScreenRoot({
    required this.viewModel,
    required this.navigationShell,
    required this.streamController,
  });

  @override
  State<MainScreenRoot> createState() => _MainScreenRootState();
}

class _MainScreenRootState extends State<MainScreenRoot> {
  StreamSubscription<StreamEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.streamController.stream.listen((e) {
      if (mounted) {
        switch (e) {
          case Success():
            AlertInfo.show(
              context: context,
              text: e.success.message,
              icon: Icons.check,
            );
          case Error():
            AlertInfo.show(
              context: context,
              text: e.error.message,
              icon: Icons.warning_amber,
              iconColor: AppColors.warning,
            );
        }
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return MainScreen(
          navigationShell: widget.navigationShell,
          state: widget.viewModel.state,
        );
      },
    );
  }
}
