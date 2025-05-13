import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class PhotosState {
  final bool isLoading;
  final List<JournalModel> journals;
  final List<PhotoModel> photos;

  PhotosState({
    this.isLoading = false,
    List<JournalModel> journals = const [],
    List<PhotoModel> photos = const [],
  }) : journals = List.unmodifiable(journals),
       photos = List.unmodifiable(photos);

  PhotosState copyWith({
    bool? isLoading,
    List<JournalModel>? journals,
    List<PhotoModel>? photos,
  }) {
    return PhotosState(
      isLoading: isLoading ?? this.isLoading,
      journals: journals != null ? List.unmodifiable(journals) : this.journals,
      photos: photos != null ? List.unmodifiable(photos) : this.photos,
    );
  }
}
