import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoDto {
  final String? id;
  final String? name;
  final int? dateTimeMilli;
  final String? journalId;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? comment;

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(dateTimeMilli ?? 0);

  const PhotoDto({
    this.id,
    this.name,
    this.dateTimeMilli,
    this.journalId,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.comment,
  });

  factory PhotoDto.fromJson(Map<String, dynamic> json) => PhotoDto(
    id: json['id'],
    name: json['name'],
    dateTimeMilli: (json['dateTime'] as Timestamp).millisecondsSinceEpoch,
    journalId: json['journalId'],
    imageUrl: json['imageUrl'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateTime': Timestamp.fromMillisecondsSinceEpoch(dateTimeMilli ?? 0),
    'journalId': journalId,
    'imageUrl': imageUrl,
    'latitude': latitude,
    'longitude': longitude,
    'comment': comment,
  };
}
