import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/dto/user_dto.dart';
import 'package:photopin/user/data/mapper/user_mapper.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;

  const UserRepositoryImpl(this._dataSource);

  @override
  Future<List<UserModel>> findAll() async {
    List<UserDto> userDtos = await _dataSource.findUsers();
    return userDtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<UserModel?> findByFilter(
    bool Function(UserModel predicate) predicate,
  ) async {
    // TODO: 추후 조건으로 검색할 수 있게 DataSource 레벨에서부터 변경이 필요함
    List<UserModel> users = await findAll();
    return users.firstWhere(predicate);
  }

  @override
  Future<UserModel?> findOne(String id) async {
    UserDto dto = await _dataSource.findUserById(id);
    return dto.toModel();
  }
}
