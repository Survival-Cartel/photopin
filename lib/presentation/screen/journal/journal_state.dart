import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class JournalState {
  final bool isLoading;
  final List<JournalModel> journals;
  final Map<String, List<PhotoModel>> photoMap;

  JournalState({
    this.isLoading = false,
    List<JournalModel> journals = const [],
    Map<String, List<PhotoModel>> photoMap = const {},
  }) : journals = List.unmodifiable(journals),
       photoMap = Map.unmodifiable(photoMap);

  JournalState copyWith({
    bool? isLoading,
    List<JournalModel>? journals,
    Map<String, List<PhotoModel>>? photoMap,
  }) {
    return JournalState(
      isLoading: isLoading ?? this.isLoading,
      journals: journals != null ? List.unmodifiable(journals) : this.journals,
      photoMap: photoMap != null ? Map.unmodifiable(photoMap) : this.photoMap,
    );
  }
}
