import 'package:photopin/journal/domain/model/journal_model.dart';

class HomeState {
  final bool isLoading;
  final String userName;
  final List<JournalModel> journals;

  const HomeState({
    this.isLoading = false,
    this.userName = '',
    this.journals = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? userName,
    List<JournalModel>? journals,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      journals: journals ?? this.journals,
    );
  }
}
