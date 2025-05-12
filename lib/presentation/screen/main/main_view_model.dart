import 'package:flutter/material.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/presentation/screen/main/main_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class MainScreenViewModel with ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  MainState _state = const MainState();

  MainScreenViewModel({required this.getCurrentUserUseCase});

  MainState get state => _state;

  Future<void> loadProfile() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final UserModel user = await getCurrentUserUseCase.execute();
      _state = state.copyWith(isLoading: false, userModel: user);
      notifyListeners();
    } catch (e) {
      // 에러 처리
      _state = state.copyWith(isLoading: false);
      notifyListeners();
      // 추가적인 에러 처리 로직이 필요할 수 있음
    }
  }

  Future<void> init() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();
    try {
      final UserModel user = await getCurrentUserUseCase.execute();
      _state = state.copyWith(
        userModel: user,
        selectedIndex: 0,
        isLoading: false,
      );
      notifyListeners();
    } catch (e) {
      // 에러 처리
      _state = state.copyWith(isLoading: false);
      notifyListeners();
      // 추가적인 에러 처리 로직이 필요할 수 있음
    }
  }
}
