import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/data/repository/photo_repository_impl.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

import '../../fixtures/photo_dto_fixtures.dart';
import '../../fixtures/photo_model_fixtures.dart';
import 'fake_photo_data_source.dart';

void main() {
  late PhotoRepository repository;
  const String journalId = 'journal1';
  final PhotoDataSource dataSource = FakePhotoDataSource(
    photos: photoDtoFixtures,
  );
  final DateTime endDate = DateTime(2025, 05, 10);
  final DateTime startDate = DateTime(2025, 05, 08);

  setUpAll(() {
    repository = PhotoRepositoryImpl(dataSource: dataSource);
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
        journalId: '',
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
    expect(photos.length, photoDtoFixtures.length);
    expect(photos.any((photo) => photo.id == '5'), isTrue);
  });
  test('deletePhoto 호출하면 List<PhotoModel> 형태로 반환해야한다.', () async {
    await repository.deletePhoto('5');
    final List<PhotoModel> photos = await repository.findAll();

    expect(photos.first, isA<PhotoModel>());
    expect(photos.length, photoDtoFixtures.length);
    expect(photos.any((photo) => photo.id == '5'), isFalse);
  });
}
