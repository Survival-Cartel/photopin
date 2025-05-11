import 'package:flutter/widgets.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/journal/data/mapper/journal_mapper.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeViewModel with ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final JournalRepository _journalRepository;
  HomeState _state = const HomeState();

  HomeViewModel({
    required this.getCurrentUserUseCase,
    required JournalRepository journalRepository,
  }) : _journalRepository = journalRepository;

  HomeState get state => _state;

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

  Future<void> init() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final UserModel user = await getCurrentUserUseCase.execute();

    _state = _state.copyWith(currentUser: user, isLoading: false);
    notifyListeners();
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
      case ViewAllClick():
        throw UnimplementedError();
      case MyJounalClick():
        throw UnimplementedError();
      case FindJounals():
        throw UnimplementedError();
      case FindUser():
        _findUser();
      case NewJournalSave():
        _newJournalSave(journal: action.journal);
    }
  }
}
