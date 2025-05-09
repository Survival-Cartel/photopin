import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/dto/journal_dto.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/data/repository/journal_repository_impl.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

import '../../fixtures/journal_dto_fixtures.dart';
import '../data_source/fake_journal_data_source.dart';

void main() {
  late JournalRepository repository;
  JournalDataSource dataSource = FakeJournalDataSource();

  setUp(() {
    dataSource = FakeJournalDataSource();
    repository = JournalRepositoryImpl(dataSource: dataSource);
  });
  test('saveJournal를 호출하면 journalDto가 저장되어야 한다', () async {
    // GIVEN
    final JournalDto dto = journalDtoFixtures[0];

    // WHEN
    await repository.saveJournal(dto);

    // THEN
    final JournalModel? journalModel = await repository.findOne(dto.id!);
    expect(journalModel, isNotNull);
    expect(journalModel?.id, dto.id);
  });

  test('findAll을 호출하면 List<JournalModel> 형태로 반환해야 한다.', () async {
    // GIVEN
    for (final dto in journalDtoFixtures) {
      await repository.saveJournal(dto);
    }

    // WHEN
    final List<JournalModel> journals = await repository.findAll();

    // THEN
    expect(journals.first, isA<JournalModel>());
    expect(journals.length, journalDtoFixtures.length);
  });
  test('findOne를 호출하면 Id에 맞는 JournalModel을 반환해야 한다.', () async {
    //GIVEN
    final JournalDto dto = journalDtoFixtures[0];
    await repository.saveJournal(dto);

    //WHEN
    final JournalModel? journalModel = await repository.findOne(dto.id!);

    //THEN
    expect(journalModel, isA<JournalModel>());
    expect(journalModel?.id, dto.id);
  });
  test('deleteJournal을 호출하면 List<JournalModel>에서 정한 Id가 지워져야 한다', () async {
    // GIVEN
    for (final dto in journalDtoFixtures) {
      await repository.saveJournal(dto);
    }

    // WHEN
    await repository.deleteJournal(journalDtoFixtures[3].id!);

    //THEN
    final List<JournalModel> journals = await repository.findAll();
    expect(journals.first, isA<JournalModel>());
    expect(journals.any((journal) => journal.id == '4'), isFalse);
  });
}
