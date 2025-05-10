import 'package:photopin/location/domain/model/location_model.dart';

class PhotoModel {
  final String id;
  final String name;
  final int dateTimeMilli;
  final String journalId;
  final String imageUrl;
  final LocationModel location;
  final String comment;

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(dateTimeMilli);

  const PhotoModel({
    required this.id,
    required this.name,
    required this.dateTimeMilli,
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

  PhotoModel copyWith({
    String? id,
    String? name,
    int? dateTimeMilli,
    String? journalId,
    String? imageUrl,
    LocationModel? location,
    String? comment,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dateTimeMilli: dateTimeMilli ?? this.dateTimeMilli,
      journalId: journalId ?? this.journalId,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      comment: comment ?? this.comment,
    );
  }
}
