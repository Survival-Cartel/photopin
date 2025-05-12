// lib/presentation/screen/main/main_screen_view_model.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/presentation/screen/main/main_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class MainScreenViewModel {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StatefulNavigationShell navigationShell;

  ValueNotifier<MainScreenState> stateNotifier = ValueNotifier<MainScreenState>(
    const MainScreenState(),
  );

  MainScreenViewModel({
    required this.navigationShell,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _getCurrentUserUseCase = getCurrentUserUseCase {
    _loadProfileImage();
  }

  MainScreenState get state => stateNotifier.value;

  Future<void> _loadProfileImage() async {
    try {
      final UserModel user = await _getCurrentUserUseCase.execute();

      final profileImg = user.profileImg;
      if (profileImg.isNotEmpty) {
        stateNotifier.value = stateNotifier.value.copyWith(
          profileImageUrl: profileImg,
        );
      }
    } catch (e) {
      debugPrint('프로필 이미지 로드 중 오류 발생: $e');
    }
  }

  void changeTab(int index) {
    navigationShell.goBranch(index);
    stateNotifier.value = stateNotifier.value.copyWith(selectedIndex: index);
  }

  String? get profileImgToDisplay {
    final profileImageUrl = state.profileImageUrl;
    return (profileImageUrl == null || profileImageUrl.isEmpty)
        ? null
        : profileImageUrl;
  }

  void dispose() {
    stateNotifier.dispose();
  }
}
