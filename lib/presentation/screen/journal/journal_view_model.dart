import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/enums/action_type.dart';
import 'package:photopin/core/enums/error_type.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/core/mixins/event_notifier.dart';
import 'package:photopin/core/stream_event/stream_event.dart';
import 'package:photopin/core/usecase/delete_journal_use_case.dart';
import 'package:photopin/core/usecase/search_journal_by_date_time_range_use_case.dart';
import 'package:photopin/core/usecase/update_journal_use_case.dart';
import 'package:photopin/core/usecase/watch_photo_collection_use_case.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_action.dart';
import 'package:photopin/presentation/screen/journal/journal_state.dart';

class JournalViewModel extends EventNotifier {
  JournalState _state = JournalState();
  StreamSubscription<JournalPhotoCollection>? _journalSubscription;

  final WatchPhotoCollectionUseCase _watchPhotoCollectionUseCase;
  final UpdateJournalUseCase _updateJournalUseCase;
  final DeleteJournalUseCase _deleteJournalUseCase;
  final SearchJournalByDateTimeRangeUseCase
  _searchJournalByDateTimeRangeUseCase;

  JournalViewModel({
    required super.streamController,
    required UpdateJournalUseCase updateJournalUseCase,
    required WatchPhotoCollectionUseCase watchPhotoCollectionUseCase,
    required SearchJournalByDateTimeRangeUseCase
    searchJournalByDateTimeRangeUseCase,
    required DeleteJournalUseCase deleteJournalUseCase,
  }) : _updateJournalUseCase = updateJournalUseCase,
       _watchPhotoCollectionUseCase = watchPhotoCollectionUseCase,
       _searchJournalByDateTimeRangeUseCase =
           searchJournalByDateTimeRangeUseCase,
       _deleteJournalUseCase = deleteJournalUseCase;

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
      case DeleteJournal(:final String journalId):
        await _deleteJournal(journalId);
    }
  }

  Future<void> _searchTitle(String query) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    _journalSubscription = _watchPhotoCollectionUseCase.execute().listen(
      (collection) {
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
      },
      onDone: () {
        _journalSubscription!.cancel();
      },
    );
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

    _journalSubscription = _watchPhotoCollectionUseCase.execute().listen(
      (JournalPhotoCollection collection) {
        _state = _state.copyWith(
          journals: collection.journals,
          photoMap: collection.photoMap,
          isLoading: false,
        );

        notifyListeners();
      },
      onDone: () {
        _journalSubscription!.cancel();
      },
    );
  }

  Future<void> _update(JournalModel journal) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await _updateJournalUseCase.execute(journal);
      addEvent(const StreamEvent.success(ActionType.journalUpdate));
    } catch (e) {
      addEvent(const StreamEvent.error(ErrorType.journalUpdate));
    }

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> _setSearchFilter(SearchFilterOption option) async {
    _state = _state.copyWith(searchFilterOption: option);
    notifyListeners();
  }

  Future<void> _deleteJournal(String journalId) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      await _deleteJournalUseCase.execute(journalId);
      addEvent(const StreamEvent.success(ActionType.journalDelete));
    } catch (e) {
      addEvent(const StreamEvent.error(ErrorType.journalDelete));
    }

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}
