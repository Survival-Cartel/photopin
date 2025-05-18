import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/data/repository/photo_repository_impl.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

import '../../fixtures/photo_dto_fixtures.dart';
import '../../fixtures/photo_model_fixtures.dart';
import 'fake_photo_data_source.dart';
import 'fake_storage_data_source.dart';

void main() {
  late PhotoRepository repository;
  late FakePhotoDataSource dataSource;
  late FakeStorageDataSource storageDataSource;
  const String journalId = 'journal1';
  final DateTime endDate = DateTime(2025, 05, 10);
  final DateTime startDate = DateTime(2025, 05, 08);

  setUpAll(() {
    dataSource = FakePhotoDataSource(photos: photoDtoFixtures);
    storageDataSource = FakeStorageDataSource();
    repository = PhotoRepositoryImpl(
      photoDataSource: dataSource,
      storageDataSource: storageDataSource,
    );
  });

  setUp(() {
    // 각 테스트 전에 상태 초기화
    dataSource.reset();
    storageDataSource.reset();
  });

  test('findAll을 호출하면 List<PhotoModel> 형태로 반환해야한다.', () async {
    final List<PhotoModel> photos = await repository.findAll();

    expect(photos.first, isA<PhotoModel>());
    expect(photos.length, photoDtoFixtures.length);
  });

  test('findOne을 호출하면 id에 맞는 PhotoModel 형태로 반환해야한다.', () async {
    PhotoModel photo = (await repository.findOne('1'))!;

    expect(photo, isA<PhotoModel>());
    expect(photo.id, '1');
  });

  test(
    'findPhotosByJournalId를 호출하면 journalId에 맞는 PhotoModel 형태로 반환해야한다.',
    () async {
      final List<PhotoModel> photos = await repository.findPhotosByJournalId(
        journalId,
      );

      expect(photos.first, isA<PhotoModel>());
      expect(photos.first.journalId, journalId);
    },
  );

  test(
    'findPhotosByDateRange 호출하면 startDate 와 endDate에 맞는 List<PhotoModel> 형태로 반환해야한다.',
    () async {
      final List<PhotoModel> photos = await repository.findPhotosByDateRange(
        startDate: startDate,
        endDate: endDate,
        journalId: 'journal1',
      );
      expect(photos.first, isA<PhotoModel>());
      expect(photos.length, 2);
      expect(photos.first.dateTime.isBefore(endDate), isTrue);
      expect(photos.last.dateTime.isAfter(startDate), isTrue);
    },
  );

  test('savePhoto 호출하면 List<PhotoModel>에 값이 제대로 저장되어야한다.', () async {
    await repository.savePhoto(photoModelFixture);
    final List<PhotoModel> photos = await repository.findAll();

    expect(photos.first, isA<PhotoModel>());
    expect(photos.length, photoDtoFixtures.length + 1); // 수정: 하나 추가되었으므로 +1
    expect(photos.any((photo) => photo.id == photoModelFixture.id), isTrue);
  });

  test('deletePhoto 호출하면 해당 photo가 삭제되고 storage에서도 파일이 삭제되어야한다.', () async {
    // Given: 삭제할 photo가 존재함
    final photoToDelete = await repository.findOne('1');
    expect(photoToDelete, isNotNull);

    // When: deletePhoto 호출
    await repository.deletePhoto('1');

    // Then: photo가 삭제됨
    final List<PhotoModel> photos = await repository.findAll();
    expect(photos.any((photo) => photo.id == '1'), isFalse);
    expect(photos.length, photoDtoFixtures.length - 1); // 수정: 하나 삭제되었으므로 -1

    // And: storage에서도 파일 삭제가 호출됨
    expect(storageDataSource.deletedFiles.length, 1);
    expect(storageDataSource.deletedFiles.first, photoToDelete!.imageUrl);
  });
}
