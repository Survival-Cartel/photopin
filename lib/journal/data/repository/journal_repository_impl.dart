import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/mapper/journal_mapper.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

import '../dto/journal_dto.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalDataSource dataSource;

  const JournalRepositoryImpl({required this.dataSource});

  @override
  Future<List<JournalModel>> findAll() async {
    return (await dataSource.findJournals()).map((e) => e.toModel()).toList();
  }

  @override
  Future<JournalModel?> findOne(String id) async {
    return (await dataSource.findJournalById(id)).toModel();
  }

  @override
  Future<void> saveJournal(JournalDto dto) async {
    await dataSource.saveJournal(dto);
  }

  @override
  Future<void> deleteJournal(String journalId) async {
    await dataSource.deleteJournal(journalId);
  }
}
