import 'package:photopin/journal/domain/model/journal_model.dart';

class CompareDialogState {
  final bool isLoading;
  final List<JournalModel> journals;

  const CompareDialogState({this.isLoading = false, this.journals = const []});

  CompareDialogState copyWith({bool? isLoading, List<JournalModel>? journals}) {
    return CompareDialogState(
      isLoading: isLoading ?? this.isLoading,
      journals: journals ?? this.journals,
    );
  }
}
