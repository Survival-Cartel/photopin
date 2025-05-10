import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class JournalPhotoCollection {
  final List<JournalModel> journals;
  final Map<String, List<PhotoModel>> photoMap;

  const JournalPhotoCollection({
    required this.journals,
    required this.photoMap,
  });
}
