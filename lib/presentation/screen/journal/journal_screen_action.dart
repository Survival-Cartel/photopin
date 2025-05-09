import 'package:flutter/material.dart';

sealed class JournalScreenAction {
  const factory JournalScreenAction.searchJournal({required String query}) =
      SearchJournal;

  const factory JournalScreenAction.onTapJournalCard({
    required String journalId,
  }) = OnTapJournalCard;
}

@immutable
class SearchJournal implements JournalScreenAction {
  final String query;

  const SearchJournal({required this.query});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is SearchJournal &&
          query == other.query);

  @override
  int get hashCode => Object.hash(runtimeType, query);

  @override
  String toString() => 'SearchJournal(query: "$query")';
}

@immutable
class OnTapJournalCard implements JournalScreenAction {
  final String journalId;

  const OnTapJournalCard({required this.journalId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is OnTapJournalCard &&
          journalId == other.journalId);

  @override
  int get hashCode => Object.hash(runtimeType, journalId);

  @override
  String toString() => 'OnTapJournalCard(journalId: "$journalId")';
}
