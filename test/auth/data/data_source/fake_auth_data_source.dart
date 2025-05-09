import 'package:mocktail/mocktail.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

import '../../fixtures/auth_data_fixtures.dart';

class FakeAuthDataSource extends Fake implements AuthDataSource {
  @override
  Future<UserDto> findCurrentUser() async {
    if (authDataFixtures.isEmpty) {
      throw FirestoreError.notFoundError;
    }
    return authDataFixtures.first;
  }

  @override
  Future<String> findCurrentUserId() async {
    if (authDataFixtures.isEmpty) {
      throw FirestoreError.notFoundError;
    }
    return 'testUserId';
  }

  @override
  Future<void> login() async {
    authDataFixtures.add(authFixture);
  }
}
