import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class MapState {
  final bool isLoading;
  final JournalModel journal;
  final List<PhotoModel> photos;

  const MapState({
    this.isLoading = false,
    this.journal = const JournalModel(
      id: '',
      name: '',
      tripWith: [],
      startDateMilli: 0,
      endDateMilli: 0,
      comment: '',
    ),
    this.photos = const [],
  });

  MapState copyWith({
    bool? isLoading,
    JournalModel? journal,
    List<PhotoModel>? photos,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      journal: journal ?? this.journal,
      photos: photos ?? this.photos,
    );
  }
}
