import 'package:flutter/material.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';

class SettingsViewModel with ChangeNotifier {
  final PermissionCheckUseCase _permissionCheckUseCase;

  SettingsViewModel({required PermissionCheckUseCase permissionCheckUseCase})
    : _permissionCheckUseCase = permissionCheckUseCase;

  Future<void> onAction(SettingsAction action) async {
    switch (action) {
      case CameraPermissionRequest():
        await _permissionCheckUseCase.execute(PermissionType.camera);
      case PhotoPermissionRequest():
        await _permissionCheckUseCase.execute(PermissionType.photos);
      case LocationPermissionRequest():
        await _permissionCheckUseCase.execute(PermissionType.location);
    }
  }
}
