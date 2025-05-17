import 'package:firebase_auth/firebase_auth.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

abstract interface class AuthDataSource {
  Future<UserCredential> login();
  Future<UserDto> findCurrentUser();
  Future<String> findCurrentUserId();
  Future<void> logout();
}
