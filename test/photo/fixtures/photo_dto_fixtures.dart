import 'package:photopin/location/domain/model/location_model.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

final PhotoModel photoModelFixture = PhotoModel(
  id: '5',
  comment: 'test5',
  dateTime: DateTime.now(),
  imageUrl: '',
  journalId: 'journal2',
  location: const LocationModel(latitude: 0, longitude: 0),
  name: 'test Photo5',
);

final List<PhotoDto> photoDtoFixtures = [
  PhotoDto(
    id: '1',
    comment: 'test1',
    dateTime: DateTime.now(),
    imageUrl: '',
    journalId: 'journal1',
    latitude: 12.343,
    longitude: 43.12,
    name: 'test Photo1',
  ),
  PhotoDto(
    id: '2',
    comment: 'test2',
    dateTime: DateTime(2025, 05, 09),
    imageUrl: '',
    journalId: 'journal1',
    latitude: 0.1212,
    longitude: 0.435,
    name: 'test Photo2',
  ),
  PhotoDto(
    id: '3',
    comment: 'test3',
    dateTime: DateTime(2025, 05, 11),
    imageUrl: '',
    journalId: 'journal1',
    latitude: 10.23,
    longitude: 0.555,
    name: 'test Photo3',
  ),
  PhotoDto(
    id: '4',
    comment: 'test4',
    dateTime: DateTime(2025, 05, 15),
    imageUrl: '',
    journalId: 'journal2',
    latitude: 0.1,
    longitude: 0.23,
    name: 'test Photo4',
  ),
];
