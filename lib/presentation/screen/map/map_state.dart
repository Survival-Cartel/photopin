import 'package:photopin/core/domain/integration_model.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class MapState {
  final bool isLoading;
  final IntegrationModel mapModel;

  const MapState({
    this.isLoading = false,
    this.mapModel = const IntegrationModel(
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
  });

  MapState copyWith({bool? isLoading, IntegrationModel? mapModel}) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      mapModel: mapModel ?? this.mapModel,
    );
  }
}
