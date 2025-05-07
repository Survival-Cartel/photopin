import 'package:photopin/photo/data/dto/photo_dto.dart';

class JournalDto {
  final String? id;
  final String? name;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? tripWith;
  final List<PhotoDto>? photos;
  final String? comment;

  const JournalDto({
    this.id,
    this.name,
    this.tripWith,
    this.startDate,
    this.endDate,
    this.photos,
    this.comment,
  });

  factory JournalDto.fromJson(Map<String, dynamic> json) => JournalDto(
    id: json['id'],
    name: json['name'],
    tripWith: json['tripWith'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    photos:
        (json['photos'] as List<dynamic>)
            .map((e) => PhotoDto.fromJson(e as Map<String, dynamic>))
            .toList(),
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tripWith': tripWith,
    'startDate': startDate,
    'endDate': endDate,
    'photos': photos?.map((e) => e.toJson()).toList(),
    'comment': comment,
  };
}
