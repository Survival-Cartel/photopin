import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
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

  JournalViewModel({
    required GetJournalListUseCase getJournalListUseCase,
    required WatchJournalsUseCase watchJournalsUserCase,
    required UpdateJournalUseCase updateJournalUseCase,
  }) : _getJournalListUseCase = getJournalListUseCase,
       _watchJournalsUserCase = watchJournalsUserCase,
       _updateJournalUseCase = updateJournalUseCase;

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
        await _search(query);
      case OnTapJournalCard():
        // 추후에 go_router로 화면 이동이 필요하기 때문에 구현하지 않음
        throw UnimplementedError();
      case OnTapEdit(:final JournalModel journal):
        await _update(journal);
    }
  }

  Future<void> _search(String query) async {
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
      collection.journals.sort((a, b) => a.startDate.compareTo(b.startDate));

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
}
