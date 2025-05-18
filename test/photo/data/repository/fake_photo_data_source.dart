import 'package:mocktail/mocktail.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';

class FakePhotoDataSource extends Fake implements PhotoDataSource {
  List<PhotoDto> photos;
  final List<PhotoDto> _originalPhotos;

  FakePhotoDataSource({required List<PhotoDto> photos})
    : photos = List.from(photos),
      _originalPhotos = List.from(photos);

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
    return List.from(photos); // 복사본 반환하여 외부에서 수정 방지
  }

  @override
  Future<void> savePhoto(PhotoDto dto) async {
    photos.add(dto);
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    photos.removeWhere((photo) => photo.id == photoId);
  }

  @override
  Future<void> updatePhoto(PhotoDto photoDto) async {
    final index = photos.indexWhere((photo) => photo.id == photoDto.id);
    if (index != -1) {
      photos[index] = photoDto;
    }
  }

  @override
  Stream<List<PhotoDto>> watchPhotos() {
    // 테스트용으로 현재 상태를 한 번만 반환하는 스트림
    return Stream.value(List.from(photos));
  }

  // 테스트 전에 원래 상태로 되돌리는 메서드
  void reset() {
    photos = List.from(_originalPhotos);
  }
}
