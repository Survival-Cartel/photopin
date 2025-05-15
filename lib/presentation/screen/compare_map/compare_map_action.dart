import 'package:flutter/foundation.dart';

sealed class CompareMapAction {
  const factory CompareMapAction.onPhotoClick({
    required String photoId,
    required bool isCompare,
  }) = OnPhotoClick;
}

@immutable
class OnPhotoClick implements CompareMapAction {
  final String photoId;
  final bool isCompare;

  const OnPhotoClick({required this.photoId, required this.isCompare});
}
