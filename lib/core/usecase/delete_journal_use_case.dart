import 'package:photopin/journal/data/repository/journal_repository.dart';

class DeleteJournalUseCase {
  final JournalRepository _journalRepository;

  const DeleteJournalUseCase({required JournalRepository journalRepository})
    : _journalRepository = journalRepository;

  Future<void> execute(String journalId) async {
    await _journalRepository.deleteJournal(journalId);
  }
}
