import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

class UpdateJournalUseCase {
  final JournalRepository _journalRepository;

  const UpdateJournalUseCase({required JournalRepository journalRepository})
    : _journalRepository = journalRepository;

  Future<void> execute(JournalModel journal) async {
    await _journalRepository.update(journal);
  }
}
