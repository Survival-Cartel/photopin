import 'package:flutter/widgets.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeViewModel with ChangeNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  HomeState _homeState = const HomeState();

  HomeViewModel({required this.getCurrentUserUseCase});

  HomeState get homeState => _homeState;

  Future<void> _findUser() async {
    _homeState = homeState.copyWith(isLoading: true);
    notifyListeners();
    final UserModel user = await getCurrentUserUseCase.execute();
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
    }
  }
}
