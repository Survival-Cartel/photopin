import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/auth/data/repository/auth_repository_impl.dart';
import 'package:photopin/presentation/screen/auth/auth_action.dart';
import 'package:photopin/presentation/screen/auth/auth_state.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/user/data/mapper/user_mapper.dart';

import '../../../auth/data/data_source/fake_auth_data_source.dart';
import '../../../auth/fixtures/auth_data_fixtures.dart';

void main() {
  late AuthDataSource dataSource;
  late AuthRepository repository;
  late AuthViewModel viewModel;

  setUpAll(() {
    dataSource = FakeAuthDataSource();
    repository = AuthRepositoryImpl(dataSource: dataSource);
    viewModel = AuthViewModel(repository);
  });

  test('뷰모델의 초기 상태(state)는 isLoading이 false이고 email이 비어 있어야 한다.', () {
    expect(viewModel.state, isA<AuthState>());
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.email, '');
  });
  group('action() : ', () {
    test('action(AuthAction.login()) 은 login() 액션을 트리거 해야한다.', () async {
      await viewModel.action(AuthAction.login());

      expect(viewModel.state.email, authFixture.toModel().email);
    });
    test('action(AuthAction.logout()) 은 logout() 액션을 트리거 해야한다.', () async {
      await viewModel.action(AuthAction.logout());

      expect(viewModel.state.email, '');
    });
  });
}
