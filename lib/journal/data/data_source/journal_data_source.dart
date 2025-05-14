import 'package:photopin/journal/data/dto/journal_dto.dart';

abstract interface class JournalDataSource {
  Future<JournalDto> findJournalById(String id);
  Future<JournalDto> findJournalByName(String name);
  Future<void> saveJournal(JournalDto dto);
  Future<void> deleteJournal(String journalId);
  Future<List<JournalDto>> findJournals();
  Stream<List<JournalDto>> watchJournals();
}
