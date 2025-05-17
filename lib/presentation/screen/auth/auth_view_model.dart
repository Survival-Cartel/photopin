import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/presentation/screen/auth/auth_action.dart';
import 'package:photopin/presentation/screen/auth/auth_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthState _state = const AuthState();
  final _eventController = StreamController<Exception?>();

  Stream<Exception?> get errorStream => _eventController.stream;

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }

  AuthState get state => _state;

  AuthViewModel(this._authRepository);

  Future<void> action(AuthAction action) async {
    switch (action) {
      case Login():
        await _login();
      case OnClick():
        break;
      case Logout():
        await _logout();
    }
  }

  Future<void> _login() async {
    try {
      _state = state.copyWith(isLoading: true);
      notifyListeners();

      await _authRepository.login();
      final UserModel user = await _authRepository.findCurrentUser();
      _state = state.copyWith(currentUser: user);
    } on Exception catch (e) {
      _addError(e);
    } finally {
      _state = state.copyWith(isLoading: false);
      notifyListeners();
    }
  }

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

  void _addError(Exception e) {
    _eventController.add(e);
  }
}
