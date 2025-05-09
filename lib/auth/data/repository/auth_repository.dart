import 'package:photopin/user/domain/model/user_model.dart';

abstract interface class AuthRepository {
  Future<void> login();
  Future<UserModel> findCurrentUser();
  Future<String> findCurrentUserId();
}
