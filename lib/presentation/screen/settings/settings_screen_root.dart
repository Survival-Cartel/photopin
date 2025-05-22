import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';
import 'package:photopin/presentation/screen/settings/settings_screen.dart';
import 'package:photopin/presentation/screen/settings/settings_view_model.dart';

class SettingsScreenRoot extends StatefulWidget {
  final SettingsViewModel viewModel;

  const SettingsScreenRoot({super.key, required this.viewModel});

  @override
  State<SettingsScreenRoot> createState() => _SettingsScreenRootState();
}

class _SettingsScreenRootState extends State<SettingsScreenRoot> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (BuildContext context, child) {
        return SettingsScreen(
          onAction: (SettingsAction action) async {
            switch (action) {
              case CameraPermissionRequest():
                widget.viewModel.onAction(action);
              case PhotoPermissionRequest():
                widget.viewModel.onAction(action);
              case LocationPermissionRequest():
                widget.viewModel.onAction(action);
              case Logout():
                await widget.viewModel.onAction(action);
                context.go(Routes.login);
            }
          },
        );
      },
    );
  }
}
