import 'package:photopin/photo/domain/model/photo_model.dart';

class JournalModel {
  final String id;
  final String name;
  final List<String> tripWith;
  final DateTime startDate;
  final DateTime endDate;
  final List<PhotoModel> photos;
  final String comment;

  const JournalModel({
    required this.id,
    required this.name,
    required this.tripWith,
    required this.startDate,
    required this.endDate,
    required this.photos,
    required this.comment,
  });

  @override
  String toString() {
    return 'JournalModel(id: $id, name: $name, tripWith: $tripWith, startDate: $startDate, endDate: $endDate, photos: $photos, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
