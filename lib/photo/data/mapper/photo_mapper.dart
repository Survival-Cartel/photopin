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
      location: location ?? LatLng(0, 0),
      comment: comment ?? 'N/A',
    );
  }
}
