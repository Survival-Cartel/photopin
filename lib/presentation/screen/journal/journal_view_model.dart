import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/search_journal_by_date_time_range_use_case.dart';
import 'package:photopin/core/usecase/update_journal_use_case.dart';
import 'package:photopin/core/usecase/watch_journals_use_case.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_action.dart';
import 'package:photopin/presentation/screen/journal/journal_state.dart';

class JournalViewModel with ChangeNotifier {
  JournalState _state = JournalState();
  StreamSubscription<JournalPhotoCollection>? _journalSubscription;

  final GetJournalListUseCase _getJournalListUseCase;
  final WatchJournalsUseCase _watchJournalsUserCase;
  final UpdateJournalUseCase _updateJournalUseCase;
  final SearchJournalByDateTimeRangeUseCase
  _searchJournalByDateTimeRangeUseCase;

  JournalViewModel({
    required GetJournalListUseCase getJournalListUseCase,
    required WatchJournalsUseCase watchJournalsUserCase,
    required UpdateJournalUseCase updateJournalUseCase,
    required SearchJournalByDateTimeRangeUseCase
    searchJournalByDateTimeRangeUseCase,
  }) : _getJournalListUseCase = getJournalListUseCase,
       _watchJournalsUserCase = watchJournalsUserCase,
       _updateJournalUseCase = updateJournalUseCase,
       _searchJournalByDateTimeRangeUseCase =
           searchJournalByDateTimeRangeUseCase;

  JournalState get state => _state;
  bool get isLoading => _state.isLoading;

  @override
  void dispose() {
    _journalSubscription?.cancel();
    super.dispose();
  }

  Future<void> onAction(JournalScreenAction action) async {
    switch (action) {
      case SearchJournal(:final String query):
        await _searchTitle(query);
      case OnTapJournalCard():
        // 추후에 go_router로 화면 이동이 필요하기 때문에 구현하지 않음
        throw UnimplementedError();
      case OnTapEdit(:final JournalModel journal):
        await _update(journal);
      case SetSearchFilter(:final SearchFilterOption option):
        await _setSearchFilter(option);
      case OnSearchDateRange(:final DateTimeRange range):
        await _searchDateRange(range);
    }
  }

  Future<void> _searchTitle(String query) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final JournalPhotoCollection collection =
        await _getJournalListUseCase.execute();

    _state = _state.copyWith(
      journals:
          collection.journals
              .where(
                (journal) => journal.name.toLowerCase().contains(
                  query.trim().toLowerCase(),
                ),
              )
              .toList(),
      photoMap: collection.photoMap,
      isLoading: false,
    );

    notifyListeners();
  }

  Future<void> _searchDateRange(DateTimeRange range) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    List<JournalModel> journals = await _searchJournalByDateTimeRangeUseCase
        .execute(range);

    _state = _state.copyWith(
      searchDateTimeRange: range,
      journals: journals,
      isLoading: false,
    );
    notifyListeners();
  }

  Future<void> init() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    // final JournalPhotoCollection collection =
    //     await _getJournalListUseCase.execute();

    // _state = _state.copyWith(
    //   journals: collection.journals,
    //   photoMap: collection.photoMap,
    //   isLoading: false,
    // );
    //
    _journalSubscription = _watchJournalsUserCase.execute().listen((
      collection,
    ) {
      _state = _state.copyWith(
        journals: collection.journals,
        photoMap: collection.photoMap,
        isLoading: false,
      );
      notifyListeners();
    });
  }

  Future<void> _update(JournalModel journal) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await _updateJournalUseCase.execute(journal);

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> _setSearchFilter(SearchFilterOption option) async {
    _state = _state.copyWith(searchFilterOption: option);
    notifyListeners();
  }
}
