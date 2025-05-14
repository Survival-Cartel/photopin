import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class PhotosState {
  final bool isLoading;
  final int selectedFilterIndex;
  final List<JournalModel> journals;
  final List<PhotoModel> photos;

  PhotosState({
    this.isLoading = false,
    this.selectedFilterIndex = 0,
    List<JournalModel> journals = const [],
    List<PhotoModel> photos = const [],
  }) : journals = List.unmodifiable(journals),
       photos = List.unmodifiable(photos);

  PhotosState copyWith({
    bool? isLoading,
    int? selectedFilterIndex,
    List<JournalModel>? journals,
    List<PhotoModel>? photos,
  }) {
    return PhotosState(
      isLoading: isLoading ?? this.isLoading,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      journals: journals != null ? List.unmodifiable(journals) : this.journals,
      photos: photos != null ? List.unmodifiable(photos) : this.photos,
    );
  }
}
