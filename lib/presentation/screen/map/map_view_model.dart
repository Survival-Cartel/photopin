import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapViewModel with ChangeNotifier {
  final JournalRepository _journalRepository;
  final PhotoRepository _photoRepository;
  MapState _state = const MapState();

  MapViewModel(this._photoRepository, this._journalRepository);

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

    final List<PhotoModel> photos = await _photoRepository
        .findPhotosByJournalId(journalId);
    final JournalModel jounal = (await _journalRepository.findOne(journalId))!;
    _state = state.copyWith(isLoading: false, photos: photos, journal: jounal);
    notifyListeners();
  }
}
