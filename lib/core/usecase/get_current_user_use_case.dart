import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<UserModel> execute() async => await _authRepository.findCurrentUser();
}
