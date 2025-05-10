import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';

import 'mock_photo_data_source_impl.dart';

void main() async {
  late final PhotoDataSource photoDataSource;
  final String photoId = '1';
  final String journalId = 'journal1';
  final PhotoDto dto = PhotoDto(
    id: '5',
    comment: 'test5',
    dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
    imageUrl: '',
    journalId: 'journal2',
    latitude: 12.343,
    longitude: 43.12,
    name: 'test Photo5',
  );
  final List<PhotoDto> photos = [
    PhotoDto(
      id: '1',
      comment: 'test1',
      dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
      imageUrl: '',
      journalId: journalId,
      latitude: 12.343,
      longitude: 43.12,
      name: 'test Photo1',
    ),
    PhotoDto(
      id: '2',
      comment: 'test2',
      dateTimeMilli: DateTime(2025).millisecondsSinceEpoch,
      imageUrl: '',
      journalId: journalId,
      latitude: 0.1212,
      longitude: 0.435,
      name: 'test Photo2',
    ),
    PhotoDto(
      id: '3',
      comment: 'test3',
      dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
      imageUrl: '',
      journalId: journalId,
      latitude: 10.23,
      longitude: 0.555,
      name: 'test Photo3',
    ),
    PhotoDto(
      id: '4',
      comment: 'test4',
      dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
      imageUrl: '',
      journalId: 'journal2',
      latitude: 0.1,
      longitude: 0.23,
      name: 'test Photo4',
    ),
  ];

  setUpAll(() {
    photoDataSource = MockPhotoDataSourceImpl();
    when(() => photoDataSource.savePhoto(dto)).thenAnswer((_) async {
      photos.add(dto);
    });
    when(() => photoDataSource.findPhotos()).thenAnswer((_) async => photos);
    when(
      () => photoDataSource.findPhotoById(photoId),
    ).thenAnswer((_) async => photos.firstWhere((dto) => dto.id == photoId));
    when(() => photoDataSource.findPhotosByJournalId(journalId)).thenAnswer(
      (_) async => photos.where((dto) => dto.journalId == journalId).toList(),
    );
    when(() => photoDataSource.deletePhoto(photoId)).thenAnswer((_) async {
      photos.removeWhere((dto) => dto.id == photoId);
    });
  });

  test('저장된 리스트를 제대로 가져와야한다.', () async {
    final List<PhotoDto> dtos = await photoDataSource.findPhotos();

    expect(dtos, photos);
  });

  test('저장된 리스트에서 journalId를 이용해 데이터를 제대로 가져와야한다.', () async {
    final List<PhotoDto> dtos = await photoDataSource.findPhotosByJournalId(
      journalId,
    );

    expect(dtos, photos.where((dto) => dto.journalId == journalId).toList());
  });

  test('저장된 리스트에서 id를 이용해 데이터를 제대로 가져와야한다.', () async {
    final PhotoDto dto = await photoDataSource.findPhotoById(photoId);

    expect(dto, photos.firstWhere((dto) => dto.id == photoId));
  });

  test('photo data이(가) 제대로 들어가야한다.', () async {
    await photoDataSource.savePhoto(dto);

    expect(await photoDataSource.findPhotos(), photos);
  });

  test('photo data이(가) 제대로 삭제되어야한다.', () async {
    await photoDataSource.deletePhoto(photoId);

    expect(photos.any((dto) => dto.id == photoId), false);
  });
}
