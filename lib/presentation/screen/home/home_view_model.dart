import 'package:flutter/widgets.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeViewModel with ChangeNotifier {
  final AuthRepository _authRepository;
  HomeState _homeState = const HomeState();

  HomeViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  HomeState get homeState => _homeState;

  Future<void> _findUser() async {
    _homeState = homeState.copyWith(isLoading: true);
    notifyListeners();
    final UserModel user = await _authRepository.findCurrentUser();
    _homeState = homeState.copyWith(
      isLoading: false,
      userName: user.displayName,
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
        // TODO: Handle this case.
        throw UnimplementedError();
      case SeeAllClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case ViewAllClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case MyJounalClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case FindJounals():
        // TODO: Handle this case.
        throw UnimplementedError();
      case FindUser():
        _findUser();
    }
  }
}
