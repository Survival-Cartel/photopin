import 'package:photopin/core/data/repository.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

abstract interface class PhotoRepository
    implements Repository<PhotoModel, String, PhotoDto> {
  Future<List<PhotoModel>> findPhotosByJournalId(String journalId);
  Future<List<PhotoModel>> findPhotosByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<void> savePhoto(PhotoModel model);
  Future<void> deletePhoto(String photoId);
}
