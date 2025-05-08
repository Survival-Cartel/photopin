import 'package:mocktail/mocktail.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

class FakeUserDataSourceImpl extends Fake implements UserDataSource {
  final List<UserDto> _userStore = [];

  @override
  Future<void> saveUser(UserDto dto) async {
    _userStore.add(dto);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final UserDto user = _userStore.where((e) => e.id == userId).first;
    _userStore.remove(user);
  }

  @override
  Future<UserDto> findUserByEmail(String email) async {
    return _userStore.where((e) => e.email == email).first;
  }

  @override
  Future<UserDto> findUserById(String id) async {
    return _userStore.where((e) => e.id == id).first;
  }

  @override
  Future<List<UserDto>> findUsers() async {
    return _userStore;
  }
}
