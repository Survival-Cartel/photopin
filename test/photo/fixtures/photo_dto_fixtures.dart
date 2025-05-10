import 'package:photopin/photo/data/dto/photo_dto.dart';

final List<PhotoDto> photoDtoFixtures = [
  PhotoDto(
    id: '1',
    comment: 'test1',
    dateTimeMilli: DateTime(2025, 05, 08, 13).millisecondsSinceEpoch,
    imageUrl: '',
    journalId: 'journal1',
    latitude: 12.343,
    longitude: 43.12,
    name: 'test Photo1',
  ),
  PhotoDto(
    id: '2',
    comment: 'test2',
    dateTimeMilli: DateTime(2025, 05, 09).millisecondsSinceEpoch,
    imageUrl: '',
    journalId: 'journal1',
    latitude: 0.1212,
    longitude: 0.435,
    name: 'test Photo2',
  ),
  PhotoDto(
    id: '3',
    comment: 'test3',
    dateTimeMilli: DateTime(2025, 05, 11).millisecondsSinceEpoch,
    imageUrl: '',
    journalId: 'journal1',
    latitude: 10.23,
    longitude: 0.555,
    name: 'test Photo3',
  ),
  PhotoDto(
    id: '4',
    comment: 'test4',
    dateTimeMilli: DateTime(2025, 05, 15).millisecondsSinceEpoch,
    imageUrl: '',
    journalId: 'journal2',
    latitude: 0.1,
    longitude: 0.23,
    name: 'test Photo4',
  ),
];
