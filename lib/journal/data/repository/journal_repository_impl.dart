import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/mapper/journal_mapper.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalDataSource dataSource;

  const JournalRepositoryImpl({required this.dataSource});

  @override
  Future<void> deleteJournal(String journalId) async {
    await dataSource.deleteJournal(journalId);
  }

  @override
  Future<List<JournalModel>> findAll() async {
    return (await dataSource.findJournals()).map((e) => e.toModel()).toList();
  }

  @override
  Future<JournalModel> findJournalById(String id) async {
    return (await dataSource.findJournalById(id));
  }

  @override
  Future<JournalModel> findJournalByName(String name) {
    // TODO: implement findJournalByName
    throw UnimplementedError();
  }

  @override
  Future<List<JournalModel>> findJournals() {
    // TODO: implement findJournals
    throw UnimplementedError();
  }

  @override
  Future<JournalModel?> findOne(String id) {
    // TODO: implement findOne
    throw UnimplementedError();
  }

  @override
  Future<void> saveJournal(JournalModel model) {
    // TODO: implement saveJournal
    throw UnimplementedError();
  }
}
