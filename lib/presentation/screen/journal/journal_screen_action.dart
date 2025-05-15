import 'package:flutter/material.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

sealed class JournalScreenAction {
  const factory JournalScreenAction.searchJournal({required String query}) =
      SearchJournal;

  const factory JournalScreenAction.onTapEdit({required JournalModel journal}) =
      OnTapEdit;

  const factory JournalScreenAction.onTapJournalCard({
    required String journalId,
  }) = OnTapJournalCard;
}

@immutable
class SearchJournal implements JournalScreenAction {
  final String query;

  const SearchJournal({required this.query});
}

@immutable
class OnTapEdit implements JournalScreenAction {
  final JournalModel journal;

  const OnTapEdit({required this.journal});
}

@immutable
class OnTapJournalCard implements JournalScreenAction {
  final String journalId;

  const OnTapJournalCard({required this.journalId});
}
