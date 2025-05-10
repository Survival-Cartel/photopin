import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapViewModel with ChangeNotifier {
  final PhotoRepository _repository;
  MapState _state = const MapState();

  MapViewModel(this._repository);

  MapState get state => _state;

  Future<void> onAction(MapAction action) async {
    switch (action) {
      case OnDateRangeClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OnPhotoClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OnCancelClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OnApplyFilterClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OnEditClick():
        // TODO: Handle this case.
        throw UnimplementedError();
      case OnShareClick():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Future<void> init(String journalId) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final List<PhotoModel> photos = await _repository.findPhotosByJournalId(
      journalId,
    );
    _state = state.copyWith(isLoading: false, photos: photos);
    notifyListeners();
  }
}
