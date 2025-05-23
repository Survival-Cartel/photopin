import 'package:photopin/user/data/dto/user_dto.dart';

abstract interface class AuthDataSource {
  Future<UserDto?> login();
  Future<UserDto> findCurrentUser();
  Future<String> findCurrentUserId();
  Future<void> logout();
}
