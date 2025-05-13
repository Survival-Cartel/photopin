import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/mapper/photo_mapper.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoDataSource dataSource;

  const PhotoRepositoryImpl({required this.dataSource});

  @override
  Future<void> deletePhoto(String photoId) async {
    await dataSource.deletePhoto(photoId);
  }

  @override
  Future<List<PhotoModel>> findAll() async {
    return (await dataSource.findPhotos()).map((dto) => dto.toModel()).toList();
  }

  @override
  Future<PhotoModel?> findOne(String id) async {
    return (await dataSource.findPhotoById(id)).toModel();
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
    return (await dataSource.findPhotosByJournalId(
      journalId,
    )).map((dto) => dto.toModel()).toList();
  }

  @override
  Future<void> savePhoto(PhotoModel model) async {
    await dataSource.savePhoto(model.toDto());
  }

  @override
  Future<void> updatePhoto(PhotoModel photoModel) async {
    await dataSource.updatePhoto(photoModel.toDto());
  }
}
