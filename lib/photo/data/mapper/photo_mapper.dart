import 'package:photopin/location/domain/model/location_model.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

extension PhotoMapper on PhotoDto {
  PhotoModel toModel() {
    return PhotoModel(
      id: id ?? 'N/A',
      name: name ?? 'N/A',
      dateTime: dateTime ?? DateTime(1999, 1, 1),
      journalId: journalId ?? 'N/A',
      imageUrl: imageUrl ?? 'N/A',
      location: LocationModel(
        latitude: latitude ?? 0,
        longitude: longitude ?? 0,
      ),
      comment: comment ?? 'N/A',
    );
  }
}

extension ModelMapper on PhotoModel {
  PhotoDto toDto() {
    return PhotoDto(
      id: id,
      comment: comment,
      dateTime: dateTime,
      imageUrl: imageUrl,
      journalId: journalId,
      latitude: location.latitude,
      longitude: location.longitude,
      name: name,
    );
  }
}
