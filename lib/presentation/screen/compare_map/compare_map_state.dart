import 'package:photopin/core/domain/compare_model.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class CompareMapState {
  final CompareModel sharedData;
  final CompareModel myData;
  final bool isLoading;

  const CompareMapState({
    this.sharedData = const CompareModel(
      user: UserModel(id: '', email: '', displayName: '', profileImg: ''),
      photos: [],
      journal: JournalModel(
        comment: '',
        id: '',
        endDateMilli: 0,
        startDateMilli: 0,
        name: '',
        tripWith: [],
      ),
    ),
    this.myData = const CompareModel(
      user: UserModel(id: '', email: '', displayName: '', profileImg: ''),
      photos: [],
      journal: JournalModel(
        comment: '',
        id: '',
        endDateMilli: 0,
        startDateMilli: 0,
        name: '',
        tripWith: [],
      ),
    ),
    this.isLoading = false,
  });

  CompareMapState copyWith({
    CompareModel? sharedData,
    CompareModel? myData,
    bool? isLoading,
  }) {
    return CompareMapState(
      sharedData: sharedData ?? this.sharedData,
      myData: myData ?? this.myData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
