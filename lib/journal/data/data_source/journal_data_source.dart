import 'package:flutter/material.dart';
import 'package:photopin/journal/data/dto/journal_dto.dart';

abstract interface class JournalDataSource {
  Future<JournalDto> findJournalById(String id);
  Future<JournalDto> findJournalByName(String name);
  Future<void> saveJournal(JournalDto dto);
  Future<void> deleteJournal(String journalId);
  Future<List<JournalDto>> findJournals();
  Future<List<JournalDto>> findJournalsByDateTimeRange(DateTimeRange range);
  Stream<List<JournalDto>> watchJournals();
  Future<void> update(JournalDto journal);
}
