import 'package:photopin/journal/data/dto/journal_dto.dart';

final List<JournalDto> journalDtoFixtures = [
  JournalDto(
    id: '1',
    name: 'europe',
    startDateMilli: DateTime(2014, 7, 1).millisecondsSinceEpoch,
    endDateMilli: DateTime(2014, 7, 30).millisecondsSinceEpoch,
    tripWith: ['song', 'an', 'sin'],
    comment: 'paris',
  ),
  JournalDto(
    id: '2',
    name: 'russia',
    startDateMilli: DateTime(2017, 10, 1).millisecondsSinceEpoch,
    endDateMilli: DateTime(2017, 10, 11).millisecondsSinceEpoch,
    tripWith: ['sin', 'lee'],
    comment: 'Vladivostok',
  ),
  JournalDto(
    id: '3',
    name: 'Philippines',
    startDateMilli: DateTime(2019, 6, 15).millisecondsSinceEpoch,
    endDateMilli: DateTime(2019, 6, 21).millisecondsSinceEpoch,
    tripWith: ['jang', 'lee', 'choi'],
    comment: 'boracay',
  ),
  JournalDto(
    id: '4',
    name: 'vietnam',
    startDateMilli: DateTime(2023, 1, 11).millisecondsSinceEpoch,
    endDateMilli: DateTime(2023, 1, 16).millisecondsSinceEpoch,
    tripWith: ['park', 'lee'],
    comment: 'Da Nang',
  ),
];
