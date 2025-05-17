import 'package:firebase_auth/firebase_auth.dart';
import 'package:photopin/user/domain/model/user_model.dart';

abstract interface class AuthRepository {
  Future<UserCredential> login();
  Future<void> logout();
  Future<UserModel> findCurrentUser();
  Future<String> findCurrentUserId();
}
