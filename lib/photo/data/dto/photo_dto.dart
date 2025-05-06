import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PhotoDto {
  final String? id;
  final String? name;
  final DateTime? dateTime;
  final String? journalId;
  final String? imageUrl;
  @JsonKey(fromJson: LatLng.fromJson, toJson: jsonEncode)
  final LatLng? location;
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
