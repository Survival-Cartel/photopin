import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/stream_event/stream_event.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
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
      switch (e) {
        case Success():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.success.message,
                style: AppFonts.mediumTextBold.copyWith(color: AppColors.black),
              ),
              backgroundColor: AppColors.secondary100,
            ),
          );
        case Error():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.error.message,
                style: AppFonts.mediumTextBold.copyWith(color: AppColors.black),
              ),
              backgroundColor: AppColors.warningBackground,
            ),
          );
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
