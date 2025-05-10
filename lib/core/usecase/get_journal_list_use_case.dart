import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

class GetJournalListUseCase {
  final JournalRepository _journalRepository;

  const GetJournalListUseCase(this._journalRepository);

  Future<List<JournalModel>> execute() async {
    List<JournalModel> journals = await _journalRepository.findAll();
    return journals;
  }
}
