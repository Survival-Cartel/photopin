import 'package:flutter/material.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

sealed class JournalScreenAction {
  const factory JournalScreenAction.searchJournal({required String query}) =
      SearchJournal;

  const factory JournalScreenAction.onTapEdit({required JournalModel journal}) =
      OnTapEdit;

  const factory JournalScreenAction.onTapJournalCard({
    required String journalId,
  }) = OnTapJournalCard;

  const factory JournalScreenAction.setSearchFilter({
    required SearchFilterOption option,
  }) = SetSearchFilter;

  const factory JournalScreenAction.onSearchDateRange({
    required DateTimeRange range,
  }) = OnSearchDateRange;
}

@immutable
class SearchJournal implements JournalScreenAction {
  final String query;

  const SearchJournal({required this.query});
}

@immutable
class SetSearchFilter implements JournalScreenAction {
  final SearchFilterOption option;

  const SetSearchFilter({required this.option});
}

@immutable
class OnTapEdit implements JournalScreenAction {
  final JournalModel journal;

  const OnTapEdit({required this.journal});
}

@immutable
class OnSearchDateRange implements JournalScreenAction {
  final DateTimeRange range;

  const OnSearchDateRange({required this.range});
}

@immutable
class OnTapJournalCard implements JournalScreenAction {
  final String journalId;

  const OnTapJournalCard({required this.journalId});
}
