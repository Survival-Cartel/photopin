import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class IntegrationModel {
  final UserModel user;
  final JournalModel journal;
  final List<PhotoModel> photos;

  const IntegrationModel({
    required this.user,
    required this.journal,
    required this.photos,
  });
}
