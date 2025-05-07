import 'package:photopin/location/data/dto/location_dto.dart';

class PhotoDto {
  final String? id;
  final String? name;
  final DateTime? dateTime;
  final String? journalId;
  final String? imageUrl;
  final LocationDto? location;
  final String? comment;

  const PhotoDto({
    this.id,
    this.name,
    this.dateTime,
    this.journalId,
    this.imageUrl,
    this.location,
    this.comment,
  });

  factory PhotoDto.fromJson(Map<String, dynamic> json) => PhotoDto(
    id: json['id'],
    name: json['name'],
    dateTime: json['dateTime'],
    journalId: json['journalId'],
    imageUrl: json['imageUrl'],
    location: LocationDto.fromJson(json['location']),
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateTime': dateTime,
    'journalId': journalId,
    'imageUrl': imageUrl,
    'location': location?.toJson(),
    'comment': comment,
  };
}
