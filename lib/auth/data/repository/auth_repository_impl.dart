import 'package:firebase_auth/firebase_auth.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/user/data/mapper/user_mapper.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  const AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserModel> findCurrentUser() async {
    return (await dataSource.findCurrentUser()).toModel();
  }

  @override
  Future<String> findCurrentUserId() async {
    return await dataSource.findCurrentUserId();
  }

  @override
  Future<UserCredential> login() async {
    return await dataSource.login();
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }
}
