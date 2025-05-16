import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class PhotoJournalListModel {
  final List<JournalModel> journals;
  final List<PhotoModel> photos;

  const PhotoJournalListModel({required this.journals, required this.photos});
}
