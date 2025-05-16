import 'package:flutter/material.dart';
import 'package:photopin/core/usecase/link_access_notification_use_case.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_state.dart';

class CompareDialogViewModel with ChangeNotifier {
  final JournalRepository _repository;
  final LinkAccessNotificationUseCase _accessNotificationUseCase;

  CompareDialogState _state = const CompareDialogState();

  CompareDialogViewModel({
    required JournalRepository repository,
    required LinkAccessNotificationUseCase linkAccessNotificationuseCase,
  }) : _repository = repository,
       _accessNotificationUseCase = linkAccessNotificationuseCase {
    init();
  }

  CompareDialogState get state => _state;

  Future<void> init() async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final List<JournalModel> journals = await _repository.findAll();

    _state = state.copyWith(journals: journals, isLoading: false);
    notifyListeners();
  }

  Future<void> notifyDeepLinkAccess({
    required String targetUserId,
    required String journalId,
  }) async {
    final success = await _accessNotificationUseCase.execute(
      userId: targetUserId,
      journalId: journalId,
    );
    if (!success) {
      debugPrint('딥링크 알림 전송 실패');
    }
  }
}
