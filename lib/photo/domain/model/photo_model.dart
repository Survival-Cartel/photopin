import 'package:photopin/location/domain/model/location_model.dart';

class PhotoModel {
  final String id;
  final String name;
  final DateTime dateTime;
  final String journalId;
  final String imageUrl;
  final LocationModel location;
  final String comment;

  const PhotoModel({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.journalId,
    required this.imageUrl,
    required this.location,
    required this.comment,
  });

  @override
  String toString() {
    return 'PhotoModel(id: $id, name: $name, dateTime: $dateTime, jounalId: $journalId, imageUrl: $imageUrl, location: $location, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhotoModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
