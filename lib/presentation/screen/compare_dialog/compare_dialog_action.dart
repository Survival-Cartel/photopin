import 'package:flutter/foundation.dart';

sealed class CompareDialogAction {
  const factory CompareDialogAction.onApply(String journalId) = OnApply;
}

@immutable
class OnApply implements CompareDialogAction {
  final String journalId;

  const OnApply(this.journalId);
}
