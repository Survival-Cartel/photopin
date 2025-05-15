import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/domain/integration_model.dart';
import 'package:photopin/core/usecase/get_compare_model_use_case.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapViewModel with ChangeNotifier {
  final PhotoRepository _photoRepository;
  final GetCompareModelUseCase _getCompareModelUseCase;
  MapState _state = const MapState();

  MapViewModel({
    required PhotoRepository photoRepository,
    required GetCompareModelUseCase getCompareModelUseCase,
  }) : _photoRepository = photoRepository,
       _getCompareModelUseCase = getCompareModelUseCase;

  MapState get state => _state;

  Future<void> onAction(MapAction action) async {
    switch (action) {
      case OnDateRangeClick():
        _onDateRangeClick(
          journalId: action.journalId,
          startDate: action.startDate,
          endDate: action.endDate,
        );
      case OnPhotoClick():
        break;
      case OnShareClick():
        break;
    }
  }

  Future<void> _onDateRangeClick({
    required String journalId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final List<PhotoModel> photos = await _photoRepository
        .findPhotosByDateRange(
          journalId: journalId,
          startDate: startDate,
          endDate: endDate,
        );

    final IntegrationModel model = state.mapModel.copyWith(photos: photos);

    _state = state.copyWith(isLoading: false, mapModel: model);
    notifyListeners();
  }

  Future<void> init(String journalId, String userId) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final IntegrationModel model = await _getCompareModelUseCase.execute(
      userId: userId,
      journalId: journalId,
    );

    _state = state.copyWith(isLoading: false, mapModel: model);
    notifyListeners();
  }
}
