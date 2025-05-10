import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/dto/journal_dto.dart';
import 'fake_journal_data_source.dart';

void main() {
  late JournalDataSource dataSource;

  final JournalDto dto1 = JournalDto(
    id: '1',
    name: 'test Journal',
    comment: 'Good',
    startDateMilli: DateTime(2023, 1, 1).millisecondsSinceEpoch,
    endDateMilli: DateTime(2023, 1, 2).millisecondsSinceEpoch,
    tripWith: ['철수', '영희'],
  );

  final JournalDto dto2 = JournalDto(
    id: '1',
    name: 'china trip',
    comment: 'Bad',
    startDateMilli: DateTime(2023, 1, 1).millisecondsSinceEpoch,
    endDateMilli: DateTime(2023, 1, 2).millisecondsSinceEpoch,
    tripWith: ['철수', '영희'],
  );

  setUp(() {
    dataSource = FakeJournalDataSource();
  });

  test('saveJournal을 호출하면 dto가 저장되어야 한다.', () async {
    await dataSource.saveJournal(dto1);

    final JournalDto journal = await dataSource.findJournalById(dto1.id!);

    expect(journal.name, 'test Journal');
  });

  test('findJournalById를 호출하면 인자로 전달한 ID에 해당하는 dto를 반환해야한다.', () async {
    // given
    await dataSource.saveJournal(dto1);

    // when
    final JournalDto journal = await dataSource.findJournalById(dto1.id!);

    // then
    expect(journal.name, 'test Journal');
  });

  test('findJournalByName을 호출하면 인자로 전달한 name에 해당하는 dto를 반환해야한다.', () async {
    // given
    await dataSource.saveJournal(dto1);

    // when
    final JournalDto journal = await dataSource.findJournalByName(dto1.name!);

    // then
    expect(journal.name, 'test Journal');
  });

  test('deleteJournal을 호출하면 인자로 전달한 ID에 해당하는 dto를 삭제해야한다.', () async {
    // given
    await dataSource.saveJournal(dto1);

    // when
    await dataSource.deleteJournal(dto1.id!);

    // then
    expect(dataSource.findJournalById(dto1.id!), throwsException);
  });

  test('findJournal을 호출하면 List 형태로 JournalDto를 반환해야한다.', () async {
    // given
    await dataSource.saveJournal(dto1);
    await dataSource.saveJournal(dto2);

    // when
    List<JournalDto> journalDtos = await dataSource.findJournals();

    // then
    expect(journalDtos.length, 2);
  });
}
