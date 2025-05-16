import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/core/usecase/watch_journals_use_case.dart';
import 'package:photopin/journal/data/mapper/journal_mapper.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeViewModel with ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final JournalRepository _journalRepository;
  final GetJournalListUseCase getJournalListUseCase;
  final WatchJournalsUseCase _watchJournalsUserCase;
  final PermissionCheckUseCase _permissionCheckUseCase;

  StreamSubscription<JournalPhotoCollection>? _streamSubscription;
  HomeState _state = HomeState();

  HomeViewModel({
    required this.getCurrentUserUseCase,
    required JournalRepository journalRepository,
    required this.getJournalListUseCase,
    required WatchJournalsUseCase watchJournalsUserCase,
    required PermissionCheckUseCase permissionCheckUseCase,
  }) : _journalRepository = journalRepository,
       _watchJournalsUserCase = watchJournalsUserCase,
       _permissionCheckUseCase = permissionCheckUseCase;

  HomeState get state => _state;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _findUser() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final UserModel user = await getCurrentUserUseCase.execute();

    _state = _state.copyWith(isLoading: false, currentUser: user);
    notifyListeners();
  }

  Future<void> _newJournalSave({required JournalModel journal}) async {
    await _journalRepository.saveJournal(journal.toDto());
  }

  Future<void> _findJournals() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final JournalPhotoCollection collection =
        await getJournalListUseCase.execute();

    _state = _state.copyWith(isLoading: false, journals: collection.journals);
    notifyListeners();
  }

  // Future<void> _myJournalClick() async {
  //   _state = _state.copyWith(isLoading: true);
  //   notifyListeners();

  //   final JournalPhotoCollection collection =
  //       await getJournalListUseCase.execute();

  //   _state = _state.copyWith(isLoading: false, journals: collection.journals);
  //   notifyListeners();
  // }

  Future<void> init() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await _permissionCheckUseCase.execute(PermissionType.notification);

    final UserModel user = await getCurrentUserUseCase.execute();

    _state = _state.copyWith(currentUser: user);
    notifyListeners();

    _streamSubscription = _watchJournalsUserCase.execute().listen((collection) {
      _state = state.copyWith(
        journals: collection.journals,
        photoMap: collection.photoMap,
        isLoading: false,
      );
      notifyListeners();
    });
  }

  Future<void> onAction(HomeAction action) async {
    switch (action) {
      case CameraClick():
        break;
      case NewJournalClick():
        break;
      case ShareClick():
        break;
      case RecentActivityClick():
        throw UnimplementedError();
      case SeeAllClick():
        throw UnimplementedError();
      case MyJournalClick():
        break;
      case FindJounals():
        _findJournals();
      case FindUser():
        _findUser();
      case NewJournalSave():
        _newJournalSave(journal: action.journal);
    }
  }
}
