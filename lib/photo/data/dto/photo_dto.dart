import 'package:json_annotation/json_annotation.dart';
import 'package:photopin/location/data/dto/location_dto.dart';

part 'photo_dto.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory PhotoDto.fromJson(Map<String, dynamic> json) =>
      _$PhotoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoDtoToJson(this);
}
