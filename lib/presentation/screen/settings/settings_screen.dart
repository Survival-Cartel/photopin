import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';

class SettingsScreen extends StatelessWidget {
  final Function(SettingsAction action) onAction;

  const SettingsScreen({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // BaseButton(
          //   buttonName: '사진 권한 요청',
          //   onClick: onAction(PhotoPermissionRequest()),
          //   buttonType: ButtonType.small,
          // ),
          ElevatedButton(
            onPressed: () => onAction(PhotoPermissionRequest()),
            child: Text('사진 권한 요청'),
          ),
          ElevatedButton(
            onPressed: () => onAction(CameraPermissionRequest()),
            child: Text('카메라 권한 요청'),
          ),
          ElevatedButton(
            onPressed: () => onAction(LocationPermissionRequest()),
            child: Text('위치 권한 요청'),
          ),
        ],
      ),
    );
  }
}
