import 'package:photopin/user/domain/model/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel?> login();
  Future<void> logout();
  Future<UserModel> findCurrentUser();
  Future<String> findCurrentUserId();
}
