sealed class PhotosAction {
  factory PhotosAction.photoFilterClick(String filter) = PhotoFilterClick;
  factory PhotosAction.photoCardClick() = PhotoCardClick;
  factory PhotosAction.applyClick() = PhotoApplyClick;
  factory PhotosAction.shareClick() = PhotoShareClick;
}

class PhotoFilterClick implements PhotosAction {
  final String filter;

  PhotoFilterClick(this.filter);
}

class PhotoCardClick implements PhotosAction {}

class PhotoApplyClick implements PhotosAction {}

class PhotoShareClick implements PhotosAction {}
