import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';
import 'package:photopin/presentation/screen/settings/settings_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class SettingsViewModel with ChangeNotifier {
  final PermissionCheckUseCase _permissionCheckUseCase;
  final AuthRepository _authRepository;

  SettingsState _state = const SettingsState();

  SettingsState get state => _state;
  final _eventController = StreamController<Exception?>();

  Stream<Exception?> get errorStream => _eventController.stream;

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }

  SettingsViewModel({
    required PermissionCheckUseCase permissionCheckUseCase,
    required AuthRepository authRepository,
  }) : _permissionCheckUseCase = permissionCheckUseCase,
       _authRepository = authRepository;

  Future<void> _logout() async {
    try {
      _state = state.copyWith(isLoading: true);
      notifyListeners();

      await _authRepository.logout();
      _state = state.copyWith(
        currentUser: const UserModel(
          displayName: '',
          email: '',
          id: '',
          profileImg: '',
        ),
      );
    } on Exception catch (e) {
      _addError(e);
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
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

  void _addError(Exception e) {
    _eventController.add(e);
  }
}
