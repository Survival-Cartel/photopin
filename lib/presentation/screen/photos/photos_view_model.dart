import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/domain/photo_journal_list_model.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_journal_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_list_with_journal_id_use_case.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/screen/photos/photos_action.dart';
import 'package:photopin/presentation/screen/photos/photos_state.dart';

class PhotosViewModel with ChangeNotifier {
  final GetPhotoListUseCase _getPhotoListUseCase;
  final GetJournalListUseCase _getJournalListUseCase;
  final GetPhotoListWithJournalIdUseCase _getPhotoListWithJournalIdUseCase;
  final PhotoRepository _photoRepository;
  final GetPhotoJournalListUseCase _getPhotoJournalListUseCase;

  StreamSubscription<PhotoJournalListModel>? _listStream;
  PhotosState _state = PhotosState();

  PhotosViewModel({
    required GetPhotoListUseCase getPhotoListUseCase,
    required GetJournalListUseCase getJournalListUseCase,
    required GetPhotoListWithJournalIdUseCase getPhotoListWithJournalIdUseCase,
    required PhotoRepository photoRepository,
    required GetPhotoJournalListUseCase getPhotoJournalListUseCase,
  }) : _getPhotoListUseCase = getPhotoListUseCase,
       _getJournalListUseCase = getJournalListUseCase,
       _getPhotoListWithJournalIdUseCase = getPhotoListWithJournalIdUseCase,
       _photoRepository = photoRepository,
       _getPhotoJournalListUseCase = getPhotoJournalListUseCase;

  PhotosState get state => _state;

  @override
  void dispose() {
    _listStream?.cancel();
    super.dispose();
  }

  Future<void> _photoApplyClick(PhotoModel photoModel) async {
    await _photoRepository.updatePhoto(photoModel);
  }

  Future<void> _photoFilterClick(int index) async {
    _state = _state.copyWith(isLoading: true, selectedFilterIndex: index);
    notifyListeners();

    final JournalPhotoCollection collection =
        await _getJournalListUseCase.execute();

    // 필터링된 사진 목록
    List<PhotoModel> filteredPhotos;

    // 인덱스가 0이면 전체 사진을 보여주고, 그 외에는 선택된 저널에 해당하는 사진만 필터링
    if (index == 0) {
      // 인덱스가 0이면 모든 사진을 보여줌
      List<PhotoModel> allPhotos = await _getPhotoListUseCase.execute();
      filteredPhotos = allPhotos;
    } else if (index < collection.journals.length + 1) {
      // 선택된 저널의 ID 가져오기 (index - 1을 사용하는 이유는 0번 인덱스가 '전체' 필터이기 때문)
      final String selectedJournalId = collection.journals[index - 1].id;

      // 선택된 저널 ID와 일치하는 사진들만 필터링
      filteredPhotos = await _getPhotoListWithJournalIdUseCase.execute(
        selectedJournalId,
      );
    } else {
      // 인덱스가 범위를 벗어나면 빈 목록 반환
      filteredPhotos = [];
    }

    _state = _state.copyWith(
      photos: filteredPhotos,
      journals: collection.journals,
      isLoading: false,
    );
    notifyListeners();
  }

  Future<void> _photoDeleteClick(String photoId) async {
    await _photoRepository.deletePhoto(photoId);
  }

  Future<void> init() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    _listStream = _getPhotoJournalListUseCase.execute().listen((collection) {
      _state = _state.copyWith(
        photos: collection.photos,
        journals: collection.journals,
        isLoading: false,
      );
      notifyListeners();
    });
  }

  Future<void> onAction(PhotosAction action) async {
    switch (action) {
      case PhotoFilterClick():
        _photoFilterClick(action.index);
      case PhotoCardClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case PhotoApplyClick():
        _photoApplyClick(action.photoModel);
      case PhotoDeleteClick():
        _photoDeleteClick(action.photoId);
    }
  }
}
