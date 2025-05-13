import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/base_button.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';

class SettingsScreen extends StatelessWidget {
  final Function(SettingsAction action) onAction;

  const SettingsScreen({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Text('권한 재신청', style: AppFonts.mediumTextBold),
                const SizedBox(height: 12),
                BaseButton(
                  buttonName: '사진 권한 요청',
                  onClick: () => onAction(PhotoPermissionRequest()),
                  buttonType: ButtonType.small,
                ),
                const SizedBox(height: 12),
                BaseButton(
                  buttonName: '카메라 권한 요청',
                  onClick: () => onAction(CameraPermissionRequest()),
                  buttonType: ButtonType.small,
                ),
                const SizedBox(height: 12),
                BaseButton(
                  buttonName: '위치 권한 요청',
                  onClick: () => onAction(LocationPermissionRequest()),
                  buttonType: ButtonType.small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
