import 'package:photopin/photo/domain/model/photo_model.dart';

sealed class PhotosAction {
  factory PhotosAction.photoFilterClick(int index) = PhotoFilterClick;
  factory PhotosAction.photoCardClick() = PhotoCardClick;
  factory PhotosAction.applyClick(PhotoModel photoModel) = PhotoApplyClick;
  factory PhotosAction.shareClick() = PhotoShareClick;
}

class PhotoFilterClick implements PhotosAction {
  final int index;

  PhotoFilterClick(this.index);
}

class PhotoCardClick implements PhotosAction {}

class PhotoApplyClick implements PhotosAction {
  final PhotoModel photoModel;

  PhotoApplyClick(this.photoModel);
}

class PhotoShareClick implements PhotosAction {}
