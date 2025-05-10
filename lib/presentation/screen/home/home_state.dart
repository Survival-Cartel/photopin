import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeState {
  final bool isLoading;
  final UserModel currentUser;
  final List<JournalModel> journals;

  const HomeState({
    this.isLoading = false,
    this.currentUser = const UserModel(
      displayName: '',
      email: '',
      id: '',
      profileImg: '',
    ),
    this.journals = const [],
  });

  HomeState copyWith({
    UserModel? currentUser,
    bool? isLoading,
    List<JournalModel>? journals,
  }) {
    return HomeState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      journals: journals ?? this.journals,
    );
  }
}
