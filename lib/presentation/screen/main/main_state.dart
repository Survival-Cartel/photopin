// lib/presentation/main/main_screen_state.dart
import 'package:photopin/user/domain/model/user_model.dart';

class MainState {
  final bool isLoading;
  final int selectedIndex;
  final UserModel userModel;

  const MainState({
    this.isLoading = false,
    this.selectedIndex = 0,
    this.userModel = const UserModel(
      displayName: '',
      email: '',
      id: '',
      profileImg: '',
    ),
  });

  MainState copyWith({
    bool? isLoading,
    int? selectedIndex,
    UserModel? userModel,
  }) {
    return MainState(
      isLoading: isLoading ?? this.isLoading,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      userModel: userModel ?? this.userModel,
    );
  }
}
