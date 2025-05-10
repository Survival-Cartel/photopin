import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';

import '../../../user/fixtures/user_model_fixtures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  late HomeViewModel viewModel;
  late GetCurrentUserUseCase mockGetCurrentUserUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    viewModel = HomeViewModel(getCurrentUserUseCase: mockGetCurrentUserUseCase);

    when(() => mockGetCurrentUserUseCase.execute()).thenAnswer((_) async {
      return userModelFixtures[0];
    });
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('초기 상태는 isLoading=false이고 userName이 비어있어야 한다.', () {
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.currentUser.displayName, '');
    expect(viewModel.state, const HomeState());
  });

  group('onAction(FindUser)', () {
    test('유저 정보 로드 후 userName이 업데이트되고 notifyListeners가 2번 호출되어야 한다.', () async {
      int notifyCount = 0;
      List<HomeState> states = [];

      viewModel.addListener(() {
        notifyCount++;
        states.add(viewModel.state);
      });

      await viewModel.onAction(FindUser());

      expect(notifyCount, 2);
      expect(states.first.isLoading, true);
      expect(states.last.isLoading, false);
      expect(
        states.last.currentUser.displayName,
        userModelFixtures[0].displayName,
      );

      verify(() => mockGetCurrentUserUseCase.execute()).called(1);
    });
  });
}
