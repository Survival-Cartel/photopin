import 'package:flutter/material.dart';

sealed class MapAction {
  const factory MapAction.onDateRangeClick({
    required String journalId,
    required DateTime startDate,
    required DateTime endDate,
  }) = OnDateRangeClick;
  const factory MapAction.onPhotoClick(String photoId) = OnPhotoClick;
  const factory MapAction.onCancelClick() = OnCancelClick;
  const factory MapAction.onApplyFilterClick() = OnApplyFilterClick;
  const factory MapAction.onEditClick() = OnEditClick;
  const factory MapAction.onShareClick() = OnShareClick;
}

@immutable
class OnDateRangeClick implements MapAction {
  final String journalId;
  final DateTime startDate;
  final DateTime endDate;

  const OnDateRangeClick({
    required this.journalId,
    required this.startDate,
    required this.endDate,
  });
}

@immutable
class OnPhotoClick implements MapAction {
  final String photoId;

  const OnPhotoClick(this.photoId);
}

@immutable
class OnCancelClick implements MapAction {
  const OnCancelClick();
}

@immutable
class OnApplyFilterClick implements MapAction {
  const OnApplyFilterClick();
}

@immutable
class OnEditClick implements MapAction {
  const OnEditClick();
}

@immutable
class OnShareClick implements MapAction {
  const OnShareClick();
}
