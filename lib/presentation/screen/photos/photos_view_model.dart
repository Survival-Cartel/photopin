import 'package:flutter/material.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_list_use_case.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/screen/photos/photos_action.dart';
import 'package:photopin/presentation/screen/photos/photos_state.dart';

class PhotosViewModel with ChangeNotifier {
  final GetPhotoListUseCase _getPhotoListUseCase;
  final GetJournalListUseCase _getJournalListUseCase;
  final PhotoRepository _photoRepository;
  PhotosState _state = PhotosState();

  PhotosViewModel({
    required GetPhotoListUseCase getPhotoListUseCase,
    required GetJournalListUseCase getJournalListUseCase,
    required PhotoRepository photoRepository,
  }) : _getPhotoListUseCase = getPhotoListUseCase,
       _getJournalListUseCase = getJournalListUseCase,
       _photoRepository = photoRepository;

  PhotosState get state => _state;

  Future<void> _photoApplyClick(PhotoModel photoModel) async {
    await _photoRepository.updatePhoto(photoModel);
  }

  Future<void> init() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    List<PhotoModel> photos = await _getPhotoListUseCase.execute();
    final JournalPhotoCollection collection =
        await _getJournalListUseCase.execute();

    _state = _state.copyWith(
      photos: photos,
      journals: collection.journals,
      isLoading: false,
    );
    notifyListeners();
  }

  Future<void> onAction(PhotosAction action) async {
    switch (action) {
      case PhotoFilterClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case PhotoCardClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case PhotoApplyClick():
        _photoApplyClick(action.photoModel);
      case PhotoShareClick():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
