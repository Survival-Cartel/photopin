import 'package:flutter/material.dart';
import 'package:photopin/core/enums/permission_allow_status.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';

class SettingsViewModel with ChangeNotifier {
  final PermissionCheckUseCase _permissionCheckUseCase;

  SettingsViewModel({required PermissionCheckUseCase permissionCheckUseCase})
    : _permissionCheckUseCase = permissionCheckUseCase;

  Future<PermissionAllowStatus> onAction(SettingsAction action) async {
    switch (action) {
      case CameraPermissionRequest():
        return await _permissionCheckUseCase.execute(PermissionType.camera);
      case PhotoPermissionRequest():
        return await _permissionCheckUseCase.execute(PermissionType.photos);
      case LocationPermissionRequest():
        return await _permissionCheckUseCase.execute(PermissionType.location);
    }
  }
}
