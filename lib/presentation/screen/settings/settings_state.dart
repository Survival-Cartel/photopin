import 'package:photopin/user/domain/model/user_model.dart';

class SettingsState {
  final bool isLoading;
  final UserModel currentUser;

  const SettingsState({
    this.isLoading = false,
    this.currentUser = const UserModel(
      displayName: '',
      email: '',
      id: '',
      profileImg: '',
    ),
  });

  SettingsState copyWith({UserModel? currentUser, bool? isLoading}) {
    return SettingsState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
