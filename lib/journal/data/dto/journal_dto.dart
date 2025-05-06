import 'package:json_annotation/json_annotation.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';

part 'journal_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class JournalDto {
  final String? id;
  final String? name;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tripWith;
  final List<PhotoDto> photos;
  final String? comment;

  const JournalDto(
    this.id,
    this.name,
    this.tripWith,
    this.startDate,
    this.endDate,
    this.photos,
    this.comment,
  );

  factory JournalDto.fromJson(Map<String, dynamic> json) =>
      _$JournalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JournalDtoToJson(this);
}
