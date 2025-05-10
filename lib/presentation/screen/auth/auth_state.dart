import 'package:photopin/user/domain/model/user_model.dart';

class AuthState {
  final bool isLoading;
  final UserModel currentUser;

  const AuthState({
    this.isLoading = false,
    this.currentUser = const UserModel(
      displayName: '',
      email: '',
      id: '',
      profileImg: '',
    ),
  });

  AuthState copyWith({UserModel? currentUser, bool? isLoading}) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
