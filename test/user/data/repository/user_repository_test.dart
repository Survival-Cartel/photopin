import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/dto/user_dto.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/data/repository/user_repository_impl.dart';
import 'package:photopin/user/domain/model/user_model.dart';

import '../../fixtures/user_dto_fixtures.dart';
import '../data_source/mock_user_data_source.dart';

void main() {
  late UserRepository repository;
  final UserDataSource dataSource = MockUserDataSource();

  setUp(() {
    repository = UserRepositoryImpl(dataSource);
  });

  setUpAll(() {
    when(() => dataSource.findUsers()).thenAnswer((_) async {
      return userDtoFixtures;
    });
  });

  test('findAll을 호출하면 List<UserModel> 형태로 반환해야한다.', () async {
    List<UserModel> users = await repository.findAll();

    verify(() => dataSource.findUsers()).called(1);
    expect(users.length, userDtoFixtures.length);
  });

  test('findById를 호출하면 인자로 전달한 ID에 해당하는 UserModel을 반환해야한다.', () async {
    // GIVEN
    when(() => dataSource.findUserById(any<String>())).thenAnswer((
      invocation,
    ) async {
      final String id = invocation.positionalArguments.first as String;
      return userDtoFixtures.firstWhere((e) => e.id == id);
    });

    UserDto target = userDtoFixtures.first;

    // WHEN
    UserModel? user = await repository.findOne(target.id!);

    // THEN
    verify(() => dataSource.findUserById(target.id!)).called(1);
    expect(user, isNotNull);
    expect(user?.id, target.id);
    expect(user?.email, target.email);
  });

  test('findByFilter를 호출하면 인자로 전달한 조건에 해당하는 UserModel을 반환해야한다.', () async {
    // GIVEN
    UserDto target = userDtoFixtures.last;

    // WHEN
    UserModel? user = await repository.findByFilter(
      (e) => e.email == target.email,
    );

    // THEN
    verify(() => dataSource.findUsers()).called(1);
    expect(user, isNotNull);
    expect(user?.id, target.id);
    expect(user?.email, target.email);
  });
}
