import 'package:mocktail/mocktail.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/dto/journal_dto.dart';

class FakeJournalDataSource extends Fake implements JournalDataSource {
  final List<JournalDto> _journals = [];

  @override
  Future<void> saveJournal(JournalDto dto) async {
    _journals.add(dto);
  }

  @override
  Future<JournalDto> findJournalById(String id) async {
    return _journals.firstWhere(
      (journal) => journal.id == id,
      orElse: () => throw Exception('Journal not found'),
    );
  }

  @override
  Future<JournalDto> findJournalByName(String name) async {
    return _journals.firstWhere(
      (journal) => journal.name == name,
      orElse: () => throw Exception('Journal not found'),
    );
  }

  @override
  Future<void> deleteJournal(String journalId) async {
    _journals.removeWhere((journal) => journal.id == journalId);
  }

  @override
  Future<List<JournalDto>> findJournals() async {
    return _journals;
  }
}
