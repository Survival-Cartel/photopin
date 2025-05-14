import 'package:flutter/material.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_state.dart';

class CompareDialogViewModel with ChangeNotifier {
  final JournalRepository _repository;
  CompareDialogState _state = const CompareDialogState();

  CompareDialogViewModel({required JournalRepository repository})
    : _repository = repository;

  CompareDialogState get state => _state;

  Future<void> init() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final List<JournalModel> journals = await _repository.findAll();

    _state = state.copyWith(journals: journals, isLoading: false);
    notifyListeners();
  }
}
