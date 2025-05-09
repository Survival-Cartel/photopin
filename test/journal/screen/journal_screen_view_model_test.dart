import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/journal/screen/journal_screen_action.dart';
import 'package:photopin/journal/screen/journal_screen_view_model.dart';
import 'package:photopin/journal/screen/journal_screen_state.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';

import '../fixtures/journal_model_fixtures.dart';

class MockGetJournalListUseCase extends Mock implements GetJournalListUseCase {}

void main() {
  late JournalScreenViewModel viewModel;
  late GetJournalListUseCase mockGetJournalListUseCase;

  setUp(() {
    mockGetJournalListUseCase = MockGetJournalListUseCase();
    viewModel = JournalScreenViewModel(
      getJournalListUseCase: mockGetJournalListUseCase,
    );

    when(() => mockGetJournalListUseCase.execute()).thenAnswer((_) async {
      return journalModelFixtures;
    });
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('뷰모델의 초기 상태(state)는 isLoading이 false이고 journals가 비어 있어야 한다.', () {
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.journals, isEmpty);
    expect(viewModel.state, const JournalScreenState());
  });

  group('init()', () {
    test('init() 메서드는 UseCase를 사용해 저널 목록을 로드하고 상태를 업데이트 해야한다.', () async {
      await viewModel.init();

      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.journals.length, journalModelFixtures.length);
      expect(viewModel.state.journals, equals(journalModelFixtures));

      verify(() => mockGetJournalListUseCase.execute()).called(1);
    });

    test('메서드 호출 시 로딩 상태를 2번 변경하고 리스너에게 알려야한다.', () async {
      int listenerCallCount = 0;
      List<JournalScreenState> states = [];

      viewModel.addListener(() {
        listenerCallCount++;
        states.add(viewModel.state);
      });

      await viewModel.init();
      expect(listenerCallCount, 2);
      expect(states.first.isLoading, true);
      expect(states.first.journals, isEmpty);
      expect(states.last.isLoading, false);
      expect(states.last.journals, equals(journalModelFixtures));

      verify(() => mockGetJournalListUseCase.execute()).called(1);
    });
  });

  group('onAction()', () {
    group('onAction(SearchJournal)', () {
      test('onAction(SearchJournal)은 search 메서드를 트리거 해야한다.', () async {
        int listenerCallCount = 0;
        List<JournalScreenState> states = [];

        viewModel.addListener(() {
          listenerCallCount++;
          states.add(viewModel.state);
        });

        await viewModel.onAction(
          JournalScreenAction.searchJournal(
            query: journalModelFixtures[0].name,
          ),
        );

        expect(listenerCallCount, 2);
        expect(states.first.isLoading, true);
        expect(states.first.journals, isEmpty);

        expect(states.last.isLoading, false);
        expect(states.last.journals.length, 1);
        expect(
          states.last.journals.first.name,
          contains(journalModelFixtures[0].name),
        );

        verify(() => mockGetJournalListUseCase.execute()).called(1);
      });

      test('인자로 전달한 이름으로 저널을 필터링하고 상태를 업데이트해야한다.', () async {
        await viewModel.onAction(
          JournalScreenAction.searchJournal(
            query: journalModelFixtures[0].name,
          ),
        );

        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.journals.length, 1);
        expect(
          viewModel.state.journals.first.name,
          contains(journalModelFixtures[0].name),
        );
        verify(() => mockGetJournalListUseCase.execute()).called(1);
      });

      test('인자로 전달한 이름으로 저널을 필터링하고 상태를 업데이트해야한다.', () async {
        await viewModel.onAction(
          JournalScreenAction.searchJournal(
            query: journalModelFixtures[0].name,
          ),
        );

        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.journals.length, 1);
        expect(
          viewModel.state.journals.first.name,
          contains(journalModelFixtures[0].name),
        );
        verify(() => mockGetJournalListUseCase.execute()).called(1);
      });

      test('존재하지 않는 저널 이름으로 검색 시 비어있는 저널로 상태를 업데이트해야한다.', () async {
        await viewModel.onAction(
          const JournalScreenAction.searchJournal(query: 'NonExist'),
        );

        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.journals.length, 0);
        expect(viewModel.state.journals.isEmpty, true);
        verify(() => mockGetJournalListUseCase.execute()).called(1);
      });

      test('비어있는 문자열(Empty String)으로 검색 시 전체 리스트를 반환해야한다.', () async {
        await viewModel.onAction(
          const JournalScreenAction.searchJournal(query: ''),
        );

        expect(viewModel.state.isLoading, false);
        expect(viewModel.state.journals.length, journalModelFixtures.length);
        verify(() => mockGetJournalListUseCase.execute()).called(1);
      });

      test('메서드 호출 시 로딩 상태를 2번 변경하고 리스너에게 알려야한다.', () async {
        int listenerCallCount = 0;
        List<JournalScreenState> states = [];

        viewModel.addListener(() {
          listenerCallCount++;
          states.add(viewModel.state);
        });

        await viewModel.onAction(
          JournalScreenAction.searchJournal(
            query: journalModelFixtures[0].name,
          ),
        );

        expect(listenerCallCount, 2);
        expect(states.first.isLoading, true);

        expect(states.last.isLoading, false);
        expect(states.last.journals.length, 1);
        expect(
          states.last.journals.first.name,
          contains(journalModelFixtures[0].name),
        );

        verify(() => mockGetJournalListUseCase.execute()).called(1);
      });
    });
  });
}
