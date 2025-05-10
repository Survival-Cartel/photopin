import 'package:photopin/location/domain/model/location_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

final PhotoModel photoModelFixture = PhotoModel(
  id: '5',
  comment: 'test5',
  dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
  imageUrl: '',
  journalId: 'journal2',
  location: const LocationModel(latitude: 0, longitude: 0),
  name: 'test Photo5',
);
