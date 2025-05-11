import 'package:photopin/journal/domain/model/journal_model.dart';

class PhotosState {
  final bool isLoading;
  final List<JournalModel> journals;

  PhotosState({this.isLoading = false, List<JournalModel> journals = const []})
    : journals = List.unmodifiable(journals);

  PhotosState copyWith({bool? isLoading, List<JournalModel>? journals}) {
    return PhotosState(
      isLoading: isLoading ?? this.isLoading,
      journals: journals != null ? List.unmodifiable(journals) : this.journals,
    );
  }
}
