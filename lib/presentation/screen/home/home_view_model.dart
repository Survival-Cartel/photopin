import 'package:flutter/widgets.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeViewModel with ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetJournalListUseCase getJournalListUseCase;
  HomeState _state = HomeState();

  HomeViewModel({
    required this.getCurrentUserUseCase,
    required this.getJournalListUseCase,
  });

  HomeState get state => _state;

  Future<void> _findUser() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final UserModel user = await getCurrentUserUseCase.execute();

    _state = _state.copyWith(isLoading: false, currentUser: user);
    notifyListeners();
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

    final UserModel user = await getCurrentUserUseCase.execute();
    final JournalPhotoCollection collection =
        await getJournalListUseCase.execute();

    _state = _state.copyWith(
      currentUser: user,
      journals: collection.journals,
      photoMap: collection.photoMap,
      isLoading: false,
    );
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
      case MyJournalClick():
        break;
      case FindJounals():
        _findJournals();
      case FindUser():
        _findUser();
    }
  }
}
