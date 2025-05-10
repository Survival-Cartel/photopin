import 'package:flutter/material.dart';

sealed class MapAction {
  const factory MapAction.onDateRangeClick() = OnDateRangeClick;
  const factory MapAction.onPhotoClick(int index) = OnPhotoClick;
  const factory MapAction.onCancelClick() = OnCancelClick;
  const factory MapAction.onApplyFilterClick() = OnApplyFilterClick;
  const factory MapAction.onEditClick() = OnEditClick;
  const factory MapAction.onShareClick() = OnShareClick;
}

@immutable
class OnDateRangeClick implements MapAction {
  const OnDateRangeClick();
}

@immutable
class OnPhotoClick implements MapAction {
  final int index;

  const OnPhotoClick(this.index);
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
