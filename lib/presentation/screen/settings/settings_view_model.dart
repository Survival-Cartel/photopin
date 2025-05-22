import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
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

  Future<void> _logout() async {
    await _authRepository.logout();
  }

  Future<void> onAction(SettingsAction action) async {
    switch (action) {
      case CameraPermissionRequest():
        await _permissionCheckUseCase.execute(PermissionType.camera);
      case PhotoPermissionRequest():
        await _permissionCheckUseCase.execute(PermissionType.photos);
      case LocationPermissionRequest():
        await _permissionCheckUseCase.execute(PermissionType.location);
      case Logout():
        await _logout();
    }
  }
}
