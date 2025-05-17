import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/enums/permission_allow_status.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/core/usecase/save_token_use_case.dart';
import 'package:photopin/core/usecase/watch_journals_use_case.dart';
import 'package:photopin/fcm/data/data_source/firebase_messaging_data_source.dart';
import 'package:photopin/fcm/data/repository/token_repository.dart';
import 'package:photopin/journal/data/repository/journal_repository_impl.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

import '../../../journal/data/data_source/fake_journal_data_source.dart';
import '../../../user/fixtures/user_model_fixtures.dart';

// Mocktail을 사용한 mock 클래스 정의
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

class MockGetJournalListUseCase extends Mock implements GetJournalListUseCase {}

class MockWatchJournalsUseCase extends Mock implements WatchJournalsUseCase {}

class MockPermissionCheckUseCase extends Mock
    implements PermissionCheckUseCase {}

class StubTokenRepository implements TokenRepository {
  bool called = false;
  String? lastUserId, lastToken;

  @override
  Future<void> saveToken(String userId, String token) async {
    called = true;
    lastUserId = userId;
    lastToken = token;
  }

  @override
  Future<String?> fetchToken(String userId) async => null;
}

class MockFirebaseMessagingDataSource extends Mock
    implements FirebaseMessagingDataSource {}

void main() {
  late HomeViewModel viewModel;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockGetJournalListUseCase mockGetJournalListUseCase;
  late WatchJournalsUseCase mockWatchJournalsUseCase;
  late JournalPhotoCollection testCollection;
  late MockPermissionCheckUseCase mockPermissionCheckUseCase;
  late StubTokenRepository tokenRepository;
  late SaveTokenUseCase saveTokenUseCase;
  late MockFirebaseMessagingDataSource mockFirebaseMessagingDataSource;

  setUpAll(() {
    // 이 시점에는 모든 타입이 등록됩니다
    registerFallbackValue(FindUser());
    registerFallbackValue(PermissionType.notification);
  });

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockGetJournalListUseCase = MockGetJournalListUseCase();
    mockWatchJournalsUseCase = MockWatchJournalsUseCase();
    mockPermissionCheckUseCase = MockPermissionCheckUseCase();
    mockFirebaseMessagingDataSource = MockFirebaseMessagingDataSource();

    tokenRepository = StubTokenRepository();
    saveTokenUseCase = SaveTokenUseCase(tokenRepository);

    when(
      () => mockPermissionCheckUseCase.execute(any()),
    ).thenAnswer((_) async => PermissionAllowStatus.allow);

    when(
      () => mockFirebaseMessagingDataSource.fetchToken(),
    ).thenAnswer((_) async => 'mock_token');

    when(
      () => mockFirebaseMessagingDataSource.tokenRefreshStream(),
    ).thenAnswer((_) => const Stream.empty());

    viewModel = HomeViewModel(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      journalRepository: JournalRepositoryImpl(
        dataSource: FakeJournalDataSource(),
      ),
      getJournalListUseCase: mockGetJournalListUseCase,
      watchJournalsUserCase: mockWatchJournalsUseCase,
      permissionCheckUseCase: mockPermissionCheckUseCase,
      saveTokenUseCase: saveTokenUseCase,
      firebaseMessagingDataSource: mockFirebaseMessagingDataSource,
    );

    // 가정: JournalPhotoCollection 구조에 맞게 테스트 데이터 생성
    testCollection = const JournalPhotoCollection(journals: [], photoMap: {});
  });

  group('HomeViewModel 테스트', () {
    test('init 호출 시 사용자와 저널 정보를 함께 로드한다', () async {
      // given
      final testUser = userModelFixtures[0]; // A 사용자 사용

      when(
        () => mockGetCurrentUserUseCase.execute(),
      ).thenAnswer((_) async => testUser);
      when(() => mockWatchJournalsUseCase.execute()).thenAnswer((_) async* {
        yield testCollection;
      });

      // when
      await viewModel.init();

      // then
      expect(viewModel.state.isLoading, true);
      expect(viewModel.state.currentUser, testUser);
      expect(viewModel.state.journals, testCollection.journals);
      expect(viewModel.state.photoMap, testCollection.photoMap);
      verify(() => mockGetCurrentUserUseCase.execute()).called(1);
      verify(() => mockWatchJournalsUseCase.execute()).called(1);
    });

    test('FindUser 액션 실행 시 사용자 정보만 갱신한다', () async {
      // given
      final testUser = userModelFixtures[1]; // B 사용자 사용
      when(
        () => mockGetCurrentUserUseCase.execute(),
      ).thenAnswer((_) async => testUser);

      // when
      await viewModel.onAction(FindUser());

      // then
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.currentUser, testUser);
      expect(viewModel.state.currentUser.displayName, 'B');
      expect(viewModel.state.currentUser.email, 'example2@example.com');
      verify(() => mockGetCurrentUserUseCase.execute()).called(1);
      verifyNever(() => mockGetJournalListUseCase.execute());
    });

    test('FindJounals 액션 실행 시 저널 정보만 갱신한다', () async {
      // given
      when(
        () => mockGetJournalListUseCase.execute(),
      ).thenAnswer((_) async => testCollection);

      // when
      await viewModel.onAction(FindJounals());

      // then
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.journals, testCollection.journals);
      verify(() => mockGetJournalListUseCase.execute()).called(1);
      verifyNever(() => mockGetCurrentUserUseCase.execute());
    });

    test('로딩 상태가 액션 수행 중에 변경된다', () async {
      // given
      final testUser = userModelFixtures[0];
      final completer = Completer<UserModel>();

      // 상태 변경을 추적하기 위한 리스너
      List<bool> loadingStates = [];
      viewModel.addListener(() {
        loadingStates.add(viewModel.state.isLoading);
      });

      when(
        () => mockGetCurrentUserUseCase.execute(),
      ).thenAnswer((_) => completer.future);

      // when
      final future = viewModel.onAction(FindUser());

      // 첫번째 상태 확인
      expect(
        viewModel.state.isLoading,
        true,
        reason: '액션 실행 직후에는 로딩 상태가 true여야 합니다',
      );

      // completer 완료
      completer.complete(testUser);

      // 비동기 작업 완료 대기
      await future;

      // 액션 완료 후 상태 확인
      expect(
        viewModel.state.isLoading,
        false,
        reason: '액션 완료 후에는 로딩 상태가 false여야 합니다',
      );

      // 로딩 상태 변화 확인
      expect(loadingStates, contains(true), reason: '로딩 상태가 true로 변경되어야 합니다');
      expect(loadingStates.last, false, reason: '마지막 로딩 상태는 false여야 합니다');
    });

    test('미구현 액션 호출 시 UnimplementedError를 발생시킨다', () async {
      // when, then
      expect(
        () => viewModel.onAction(RecentActivityClick()),
        throwsA(isA<UnimplementedError>()),
      );
      expect(
        () => viewModel.onAction(SeeAllClick()),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('구현된 액션 호출 시 오류가 발생하지 않는다', () async {
      // when, then
      // 아직 구현되지 않았지만 에러를 던지지 않는 액션들
      expect(() => viewModel.onAction(CameraClick()), returnsNormally);
      expect(() => viewModel.onAction(NewJournalClick()), returnsNormally);
      expect(() => viewModel.onAction(ShareClick()), returnsNormally);
      expect(
        () => viewModel.onAction(const MyJournalClick('journal-id')),
        returnsNormally,
      );
    });

    test('notifyListeners가 상태 변경시 호출된다', () async {
      // 이 테스트를 위해 ChangeNotifier 기능 테스트
      // given
      bool notified = false;
      viewModel.addListener(() {
        notified = true;
      });

      when(
        () => mockGetCurrentUserUseCase.execute(),
      ).thenAnswer((_) async => userModelFixtures[0]);

      // when
      await viewModel.onAction(FindUser());

      // then
      expect(notified, true);
    });

    test('MyJournalClick 액션 실행 시 id 파라미터를 정확히 전달한다', () async {
      // given
      const journalId = 'test-journal-id';

      // when
      await viewModel.onAction(const MyJournalClick(journalId));

      // then
      // 현재 구현에서는 MyJournalClick이 아무 처리를 하지 않지만
      // 정상적으로 호출되는지 확인합니다
      expect(
        () => viewModel.onAction(const MyJournalClick(journalId)),
        returnsNormally,
      );
    });
  });
}
