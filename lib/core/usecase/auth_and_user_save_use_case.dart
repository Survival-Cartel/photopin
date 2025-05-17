import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class AuthAndUserSaveUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthAndUserSaveUseCase({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository;

  Future<UserModel> execute() async {
    UserModel? user = await _authRepository.login();

    if (user == null) {
      throw FirestoreError.notFoundError;
    }

    await _userRepository.saveUser(user);

    return user;
  }
}
