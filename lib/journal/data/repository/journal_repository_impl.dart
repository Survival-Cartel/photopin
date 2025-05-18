import 'package:flutter/material.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/mapper/journal_mapper.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

import '../dto/journal_dto.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalDataSource _dataSource;

  const JournalRepositoryImpl({required JournalDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<JournalModel>> findAll() async {
    return (await _dataSource.findJournals()).map((e) => e.toModel()).toList();
  }

  @override
  Future<JournalModel?> findOne(String id) async {
    return (await _dataSource.findJournalById(id)).toModel();
  }

  @override
  Future<void> saveJournal(JournalDto dto) async {
    try {
      await _dataSource.saveJournal(dto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteJournal(String journalId) async {
    try {
      await _dataSource.deleteJournal(journalId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<JournalModel>> watchJournals() {
    return _dataSource.watchJournals().map(
      (dtoList) => dtoList.map((dto) => dto.toModel()).toList(),
    );
  }

  @override
  Future<void> update(JournalModel journal) async {
    try {
      await _dataSource.update(journal.toDto());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JournalModel>> findJournalsByDateTimeRange(
    DateTimeRange range,
  ) async {
    List<JournalDto> dtos = await _dataSource.findJournalsByDateTimeRange(
      range,
    );

    return dtos.map((journal) => journal.toModel()).toList();
  }
}
