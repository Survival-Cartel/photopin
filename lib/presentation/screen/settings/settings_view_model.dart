import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/core/enums/permission_allow_status.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';

class SettingsViewModel with ChangeNotifier {
  final PermissionCheckUseCase _permissionCheckUseCase;
  final AuthRepository _authRepository;

  SettingsViewModel({
    required PermissionCheckUseCase permissionCheckUseCase,
    required AuthRepository authRepository,
  }) : _permissionCheckUseCase = permissionCheckUseCase,
       _authRepository = authRepository;

  Future<void> logout() async {
    await _authRepository.logout();
  }

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
