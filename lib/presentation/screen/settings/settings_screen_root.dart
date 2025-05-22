import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/enums/permission_allow_status.dart';
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
            final result = await widget.viewModel.onAction(action);

            if (!context.mounted) return;

            switch (action) {
              case CameraPermissionRequest():
                switch (result) {
                  case PermissionAllowStatus.allow:
                    AlertInfo.show(
                      context: context,
                      text: '카메라 권한이 허가되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.denied:
                    AlertInfo.show(
                      context: context,
                      text: '카메라 권한이 거부되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.limited:
                    AlertInfo.show(
                      context: context,
                      text: '카메라 권한이 제한적으로 허가되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.restricted:
                    AlertInfo.show(
                      context: context,
                      text: '카메라 권한이 제한되었습니다',
                      icon: Icons.check,
                    );
                }
              case PhotoPermissionRequest():
                switch (result) {
                  case PermissionAllowStatus.allow:
                    AlertInfo.show(
                      context: context,
                      text: '사진 권한이 허가되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.denied:
                    AlertInfo.show(
                      context: context,
                      text: '사진 권한이 거부되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.limited:
                    AlertInfo.show(
                      context: context,
                      text: '사진 권한이 제한적으로 허가되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.restricted:
                    AlertInfo.show(
                      context: context,
                      text: '사진 권한이 제한되었습니다',
                      icon: Icons.check,
                    );
                }
              case LocationPermissionRequest():
                switch (result) {
                  case PermissionAllowStatus.allow:
                    AlertInfo.show(
                      context: context,
                      text: '위치 권한이 허가되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.denied:
                    AlertInfo.show(
                      context: context,
                      text: '위치 권한이 거부되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.limited:
                    AlertInfo.show(
                      context: context,
                      text: '위치 권한이 제한적으로 허가되었습니다',
                      icon: Icons.check,
                    );
                  case PermissionAllowStatus.restricted:
                    AlertInfo.show(
                      context: context,
                      text: '위치 권한이 제한되었습니다',
                      icon: Icons.check,
                    );
                }
            }
          },
        );
      },
    );
  }
}
