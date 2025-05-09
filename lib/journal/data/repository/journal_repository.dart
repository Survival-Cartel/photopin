import 'package:photopin/core/data/repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

import '../dto/journal_dto.dart';

abstract interface class JournalRepository
    implements Repository<JournalModel, String, JournalDto> {
  Future<JournalModel> findJournalById(String id);

  Future<void> deleteJournal(String journalId);

  Future<void> saveJournal(JournalModel model);

  Future<List<JournalModel>> findJournals();
}
