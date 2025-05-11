import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeState {
  final bool isLoading;
  final UserModel currentUser;
  final List<JournalModel> journals;
  final Map<String, List<PhotoModel>> photoMap;

  HomeState({
    this.isLoading = false,
    this.currentUser = const UserModel(
      displayName: '',
      email: '',
      id: '',
      profileImg: '',
    ),
    this.journals = const [],
    Map<String, List<PhotoModel>> photoMap = const {},
  }) : photoMap = Map.unmodifiable(photoMap);

  HomeState copyWith({
    UserModel? currentUser,
    bool? isLoading,
    List<JournalModel>? journals,
    Map<String, List<PhotoModel>>? photoMap,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      journals: journals ?? this.journals,
      photoMap: photoMap != null ? Map.unmodifiable(photoMap) : this.photoMap,
    );
  }
}
