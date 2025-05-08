import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

import '../../fixtures/user_dto_fixtures.dart';
import 'fake_user_data_source.dart';

void main() {
  late UserDataSource dataSource;

  setUp(() {
    dataSource = FakeUserDataSourceImpl();
  });

  test('saveUser 메서드 호출 시 UserDTO가 올바르게 저장되어야한다.', () async {
    await dataSource.saveUser(userDtoFixtures.first);

    final UserDto user = await dataSource.findUserById('1');
    expect(user.email, userDtoFixtures.first.email);
  });

  test('deleteUser 메서드 호출 시 해당하는 UserDTO가 삭제되어야한다.', () async {
    // GIVEN
    await dataSource.saveUser(userDtoFixtures.first);

    // WHEN
    await dataSource.deleteUser(userDtoFixtures.first.id!);

    // THEN
    expect(
      () async => await dataSource.findUserById(userDtoFixtures.first.id!),
      throwsA(isA<StateError>()),
    );
  });

  test('findUserById 메서드 호출 시 인자로 전달한 ID에 해당하는 UserDTO가 반환되야한다.', () async {
    // GIVEN
    await dataSource.saveUser(userDtoFixtures.first);

    // WHEN
    final UserDto userDto = await dataSource.findUserById(
      userDtoFixtures.first.id!,
    );

    // THEN
    expect(userDto.email, userDtoFixtures.first.email);
  });

  test(
    'findUserByEmail 메서드 호출 시 인자로 전달한 email에 해당하는 UserDTO가 반환되야한다.',
    () async {
      // GIVEN
      await dataSource.saveUser(userDtoFixtures.first);

      // WHEN
      final UserDto userDto = await dataSource.findUserByEmail(
        userDtoFixtures.first.email!,
      );

      // THEN
      expect(userDto.id, userDtoFixtures.first.id);
    },
  );

  test('findUsers 메서드 호출 시 저장된 모든 DTO가 반환되어야한다.', () async {
    // GIVEN

    for (final dto in userDtoFixtures) {
      await dataSource.saveUser(dto);
    }

    // WHEN
    final List<UserDto> dtos = await dataSource.findUsers();

    // THEN
    expect(dtos.length, 2);
  });
}
