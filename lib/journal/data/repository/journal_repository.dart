import 'package:photopin/core/data/repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

import '../dto/journal_dto.dart';

abstract interface class JournalRepository
    implements Repository<JournalModel, String, JournalDto> {
  Future<void> deleteJournal(String journalId);
  Future<void> saveJournal(JournalDto dto);
  Stream<List<JournalModel>> watchJournals();
  Future<void> update(JournalModel journal);
}
