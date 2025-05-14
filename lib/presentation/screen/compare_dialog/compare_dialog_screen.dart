import 'package:flutter/material.dart';
import 'package:photopin/presentation/component/select_journal_modal.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_action.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_state.dart';

class CompareDialogScreen extends StatelessWidget {
  final CompareDialogState state;
  final void Function(CompareDialogAction action) onAction;
  const CompareDialogScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return !state.isLoading
        ? SelectJournalModal(
          journals: state.journals,
          onApply: (value) {
            onAction(CompareDialogAction.onApply(value));
          },
        )
        : const CircularProgressIndicator();
  }
}
