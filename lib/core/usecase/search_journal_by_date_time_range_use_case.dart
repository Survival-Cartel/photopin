import 'package:flutter/material.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

class SearchJournalByDateTimeRangeUseCase {
  final JournalRepository _journalRepository;

  SearchJournalByDateTimeRangeUseCase({
    required JournalRepository journalRepository,
  }) : _journalRepository = journalRepository;

  Future<List<JournalModel>> execute(DateTimeRange range) async {
    List<JournalModel> journals = await _journalRepository
        .findJournalsByDateTimeRange(range);

    return journals;
  }
}
