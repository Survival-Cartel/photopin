import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

import '../../fixtures/auth_data_fixtures.dart';
import 'fake_auth_data_source.dart';

void main() {
  late AuthDataSource dataSource;

  setUpAll(() {
    dataSource = FakeAuthDataSource();
  });

  test('login() 전 상태에서 findCurrentUser() 호출 시 notFoundError 가 발생되어야 한다.', () {
    expect(
      () async => await dataSource.findCurrentUser(),
      throwsA(isA<FirestoreError>()),
    );
  });
  test('login() 전 상태에서 findCurrentUserId() 호출 시 notFoundError 가 발생되어야 한다.', () {
    expect(
      () async => await dataSource.findCurrentUserId(),
      throwsA(isA<FirestoreError>()),
    );
  });
  test('login() 호출 시 유저 목록에 값이 추가 되어야한다.', () async {
    await dataSource.login();
    final UserDto dto = await dataSource.findCurrentUser();

    expect(dto, authFixture);
  });
  test('login() 후 활성화된 유저를 가져올 수 있어야한다.', () async {
    await dataSource.login();
    final UserDto dto = await dataSource.findCurrentUser();

    expect(dto, authFixture);
  });
  test('login() 후 활성화된 유저의 id 값을 가져올 수 있어야한다.', () async {
    await dataSource.login();
    final String dtoId = await dataSource.findCurrentUserId();

    expect(dtoId, authFixture.id);
  });
}
