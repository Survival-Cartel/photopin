import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

import 'fake_user_data_source.dart';

void main() {
  late FakeUserDataSourceImpl dataSource;

  final UserDto dto1 = const UserDto(
    id: '1',
    email: 'test@test.com',
    displayName: 'example1',
    profileImg: '',
  );

  final UserDto dto2 = const UserDto(
    id: '2',
    email: 'test2@test.com',
    displayName: 'example2',
    profileImg: '',
  );

  setUp(() {
    dataSource = FakeUserDataSourceImpl();
  });

  test('saveUser 메서드 호출 시 UserDTO가 올바르게 저장되어야한다.', () async {
    await dataSource.saveUser(dto1);

    final UserDto user = await dataSource.findUserById('1');
    expect(user.email, 'test@test.com');
  });

  test('deleteUser 메서드 호출 시 해당하는 UserDTO가 삭제되어야한다.', () async {
    // GIVEN
    await dataSource.saveUser(dto1);

    // WHEN
    await dataSource.deleteUser('1');

    // THEN
    expect(
      () async => await dataSource.findUserById('1'),
      throwsA(isA<StateError>()),
    );
  });

  test('findUserById 메서드 호출 시 인자로 전달한 ID에 해당하는 UserDTO가 반환되야한다.', () async {
    // GIVEN
    await dataSource.saveUser(dto1);

    // WHEN
    final UserDto userDto = await dataSource.findUserById('1');

    // THEN
    expect(userDto.email, 'test@test.com');
  });

  test(
    'findUserByEmail 메서드 호출 시 인자로 전달한 email에 해당하는 UserDTO가 반환되야한다.',
    () async {
      // GIVEN
      await dataSource.saveUser(dto1);

      // WHEN
      final UserDto userDto = await dataSource.findUserByEmail('test@test.com');

      // THEN
      expect(userDto.id, '1');
    },
  );

  test('findUsers 메서드 호출 시 저장된 모든 DTO가 반환되어야한다.', () async {
    // GIVEN
    await dataSource.saveUser(dto1);
    await dataSource.saveUser(dto2);

    // WHEN
    final List<UserDto> dtos = await dataSource.findUsers();

    // THEN
    expect(dtos.length, 2);
  });
}
