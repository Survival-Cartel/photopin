import 'package:photopin/user/data/dto/user_dto.dart';

abstract interface class UserDataSource {
  Future<UserDto> findUserByEmail(String email);
  Future<UserDto> findUserById(String id);
  Future<List<UserDto>> findUsers();
  Future<void> saveUser(UserDto dto);
  Future<void> deleteUser(String id);
}
