import 'package:photopin/journal/data/dto/journal_dto.dart';

final List<JournalDto> journalDtoFixtures = [
  JournalDto(
    id: '1',
    name: 'europe',
    startDate: DateTime(2014, 7, 1),
    endDate: DateTime(2014, 7, 30),
    tripWith: ['song', 'an', 'sin'],
    comment: 'paris',
  ),
  JournalDto(
    id: '2',
    name: 'russia',
    startDate: DateTime(2017, 10, 1),
    endDate: DateTime(2017, 10, 11),
    tripWith: ['sin', 'lee'],
    comment: 'Vladivostok',
  ),
  JournalDto(
    id: '3',
    name: 'Philippines',
    startDate: DateTime(2019, 6, 15),
    endDate: DateTime(2019, 6, 21),
    tripWith: ['jang', 'lee', 'choi'],
    comment: 'boracay',
  ),
  JournalDto(
    id: '4',
    name: 'vietnam',
    startDate: DateTime(2023, 1, 11),
    endDate: DateTime(2023, 1, 16),
    tripWith: ['park', 'lee'],
    comment: 'Da Nang',
  ),
];
