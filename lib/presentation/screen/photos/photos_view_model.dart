import 'package:flutter/material.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/presentation/screen/photos/photos_action.dart';
import 'package:photopin/presentation/screen/photos/photos_state.dart';

class PhotosViewModel with ChangeNotifier {
  final GetJournalListUseCase getJournalListUseCase;
  PhotosState _state = PhotosState();

  PhotosViewModel({required this.getJournalListUseCase});

  PhotosState get state => _state;

  Future<void> onAction(PhotosAction action) async {
    switch (action) {
      case PhotoFilterClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case PhotoCardClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case PhotoApplyClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case PhotoShareClick():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
