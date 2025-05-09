import 'package:photopin/journal/domain/model/journal_model.dart';

class JournalScreenState {
  final bool isLoading;
  final List<JournalModel> journals;

  const JournalScreenState({this.isLoading = false, this.journals = const []});

  JournalScreenState copyWith({bool? isLoading, List<JournalModel>? journals}) {
    return JournalScreenState(
      isLoading: isLoading ?? this.isLoading,
      journals: journals ?? this.journals,
    );
  }
}
