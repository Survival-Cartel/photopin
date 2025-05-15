import 'package:photopin/core/domain/integration_model.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class CompareMapState {
  final IntegrationModel sharedData;
  final IntegrationModel myData;
  final bool isLoading;

  const CompareMapState({
    this.sharedData = const IntegrationModel(
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
    this.myData = const IntegrationModel(
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
    IntegrationModel? sharedData,
    IntegrationModel? myData,
    bool? isLoading,
  }) {
    return CompareMapState(
      sharedData: sharedData ?? this.sharedData,
      myData: myData ?? this.myData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
