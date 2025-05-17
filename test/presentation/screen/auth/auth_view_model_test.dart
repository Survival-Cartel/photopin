import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/auth/data/repository/auth_repository_impl.dart';
import 'package:photopin/core/usecase/auth_and_user_save_use_case.dart';
import 'package:photopin/presentation/screen/auth/auth_action.dart';
import 'package:photopin/presentation/screen/auth/auth_state.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/user/data/mapper/user_mapper.dart';
import 'package:photopin/user/domain/model/user_model.dart';

import '../../../auth/data/data_source/fake_auth_data_source.dart';
import '../../../auth/fixtures/auth_data_fixtures.dart';

class MockAuthAndUserSaveUseCase extends Mock
    implements AuthAndUserSaveUseCase {}

void main() {
  late AuthDataSource dataSource;
  late AuthRepository repository;
  late AuthViewModel viewModel;
  late AuthAndUserSaveUseCase authAndUserSaveUseCase;

  setUpAll(() {
    dataSource = FakeAuthDataSource();
    repository = AuthRepositoryImpl(dataSource: dataSource);
    authAndUserSaveUseCase = MockAuthAndUserSaveUseCase();
    viewModel = AuthViewModel(
      authRepository: repository,
      authAndUserSaveUseCase: authAndUserSaveUseCase,
    );
  });

  test('뷰모델의 초기 상태(state)는 isLoading이 false이고 email이 비어 있어야 한다.', () {
    expect(viewModel.state, isA<AuthState>());
    expect(viewModel.state.isLoading, false);
    expect(
      viewModel.state.currentUser,
      const UserModel(displayName: '', email: '', id: '', profileImg: ''),
    );
  });

  group('action() : ', () {
    test('action(AuthAction.login()) 은 login() 액션을 트리거 해야한다.', () async {
      when(() => authAndUserSaveUseCase.execute()).thenAnswer((_) async {
        return authFixture.toModel();
      });
      await viewModel.action(AuthAction.login());

      expect(viewModel.state.currentUser.email, authFixture.toModel().email);
    });
    test('action(AuthAction.logout()) 은 logout() 액션을 트리거 해야한다.', () async {
      await viewModel.action(AuthAction.logout());

      expect(viewModel.state.currentUser.email, '');
    });
  });
}
