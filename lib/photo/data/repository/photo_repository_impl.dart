import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/mapper/photo_mapper.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoDataSource _photoDataSource;

  const PhotoRepositoryImpl({required PhotoDataSource photoDataSource})
    : _photoDataSource = photoDataSource;

  @override
  Future<void> deletePhoto(String photoId) async {
    await _photoDataSource.deletePhoto(photoId);
  }

  @override
  Future<List<PhotoModel>> findAll() async {
    return (await _photoDataSource.findPhotos())
        .map((dto) => dto.toModel())
        .toList();
  }

  @override
  Future<PhotoModel?> findOne(String id) async {
    return (await _photoDataSource.findPhotoById(id)).toModel();
  }

  @override
  Future<List<PhotoModel>> findPhotosByDateRange({
    required String journalId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    List<PhotoModel> photos = await findPhotosByJournalId(journalId);

    return photos
        .where(
          (photo) =>
              photo.dateTime.isAfter(startDate) &&
              photo.dateTime.isBefore(endDate) &&
              photo.journalId == journalId,
        )
        .toList();
  }

  @override
  Future<List<PhotoModel>> findPhotosByJournalId(String journalId) async {
    return (await _photoDataSource.findPhotosByJournalId(
      journalId,
    )).map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> savePhoto(PhotoModel model) async {
    await _photoDataSource.savePhoto(model.toDto());
  }

  @override
  Future<void> updatePhoto(PhotoModel photoModel) async {
    await _photoDataSource.updatePhoto(photoModel.toDto());
  }

  @override
  Stream<List<PhotoModel>> watchPhotos() {
    return _photoDataSource.watchPhotos().map(
      (dtoList) => dtoList.map((dto) => dto.toModel()).toList(),
    );
  }
}
