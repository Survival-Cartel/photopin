import 'package:flutter/material.dart';
import 'package:photopin/core/domain/compare_model.dart';
import 'package:photopin/core/usecase/get_compare_model_use_case.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_state.dart';

class CompareMapViewModel with ChangeNotifier {
  final GetCompareModelUseCase _sharedUseCase;
  final GetCompareModelUseCase _myUseCase;
  CompareMapState _state = const CompareMapState();

  CompareMapViewModel({
    required GetCompareModelUseCase sharedUseCase,
    required GetCompareModelUseCase myUseCase,
  }) : _sharedUseCase = sharedUseCase,
       _myUseCase = myUseCase;

  CompareMapState get state => _state;

  Future<void> init({
    required String sharedUserId,
    required String sharedJournalId,
    required String myUserId,
    required String myJournalId,
  }) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final CompareModel sharedModel = await _sharedUseCase.execute(
      userId: sharedUserId,
      journalId: sharedJournalId,
    );
    final CompareModel myModel = await _myUseCase.execute(
      userId: myUserId,
      journalId: myJournalId,
    );

    _state = state.copyWith(
      sharedData: sharedModel,
      myData: myModel,
      isLoading: false,
    );
    notifyListeners();
  }
}
