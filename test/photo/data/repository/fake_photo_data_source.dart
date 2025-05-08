import 'package:mocktail/mocktail.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';

class FakePhotoDataSource extends Fake implements PhotoDataSource {
  final List<PhotoDto> photos;

  FakePhotoDataSource({required this.photos});

  @override
  Future<List<PhotoDto>> findPhotosByJournalId(String journalId) async {
    return photos.where((photo) => photo.journalId == journalId).toList();
  }

  @override
  Future<PhotoDto> findPhotoById(String id) async {
    return photos.firstWhere((photo) => photo.id == id);
  }

  @override
  Future<List<PhotoDto>> findPhotos() async {
    return photos;
  }

  @override
  Future<void> savePhoto(PhotoDto dto) async {
    photos.add(dto);
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    photos.removeWhere((photo) => photo.id == photoId);
  }
}
