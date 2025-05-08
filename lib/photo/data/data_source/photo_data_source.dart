import 'package:photopin/photo/data/dto/photo_dto.dart';

abstract interface class PhotoDataSource {
  Future<List<PhotoDto>> findPhotosByJournalId(String journalId);
  Future<PhotoDto> findPhotoById(String id);
  Future<List<PhotoDto>> findPhotos();
  Future<void> savePhoto(PhotoDto dto);
  Future<void> deletePhoto(String photoId);
}
