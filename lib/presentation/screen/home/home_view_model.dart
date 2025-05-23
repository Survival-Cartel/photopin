import 'dart:async';

import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/enums/action_type.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/mixins/event_notifier.dart';
import 'package:photopin/core/stream_event/stream_event.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/core/usecase/save_token_use_case.dart';
import 'package:photopin/core/usecase/watch_photo_collection_use_case.dart';
import 'package:photopin/fcm/data/data_source/firebase_messaging_data_source.dart';
import 'package:photopin/journal/data/mapper/journal_mapper.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_state.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class HomeViewModel extends EventNotifier {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final JournalRepository _journalRepository;
  final GetJournalListUseCase getJournalListUseCase;
  final WatchPhotoCollectionUseCase _watchPhotoCollectionUseCase;

  final PermissionCheckUseCase _permissionCheckUseCase;
  final SaveTokenUseCase _saveTokenUseCase;
  final FirebaseMessagingDataSource _firebaseMessagingDataSource;

  StreamSubscription<JournalPhotoCollection>? _streamSubscription;
  HomeState _state = HomeState();

  HomeViewModel({
    required super.streamController,
    required WatchPhotoCollectionUseCase watchPhotoCollectionUseCase,
    required this.getCurrentUserUseCase,
    required JournalRepository journalRepository,
    required this.getJournalListUseCase,
    required PermissionCheckUseCase permissionCheckUseCase,
    required SaveTokenUseCase saveTokenUseCase,
    required FirebaseMessagingDataSource firebaseMessagingDataSource,
  }) : _journalRepository = journalRepository,
       _permissionCheckUseCase = permissionCheckUseCase,
       _firebaseMessagingDataSource = firebaseMessagingDataSource,
       _watchPhotoCollectionUseCase = watchPhotoCollectionUseCase,
       _saveTokenUseCase = saveTokenUseCase;

  HomeState get state => _state;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _findUser() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final UserModel user = await getCurrentUserUseCase.execute();

    _state = _state.copyWith(isLoading: false, currentUser: user);
    notifyListeners();
  }

  Future<void> _newJournalSave({required JournalModel journal}) async {
    await _journalRepository.saveJournal(journal.toDto());
    addEvent(const StreamEvent.success(ActionType.journalCreate));
  }

  Future<void> _findJournals() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final JournalPhotoCollection collection =
        await getJournalListUseCase.execute();

    _state = _state.copyWith(isLoading: false, journals: collection.journals);
    notifyListeners();
  }

  // Future<void> _myJournalClick() async {
  //   _state = _state.copyWith(isLoading: true);
  //   notifyListeners();

  //   final JournalPhotoCollection collection =
  //       await getJournalListUseCase.execute();

  //   _state = _state.copyWith(isLoading: false, journals: collection.journals);
  //   notifyListeners();
  // }

  Future<void> init() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    await _permissionCheckUseCase.execute(PermissionType.notification);

    final UserModel user = await getCurrentUserUseCase.execute();

    _state = _state.copyWith(currentUser: user);
    notifyListeners();

    final token = await _firebaseMessagingDataSource.fetchToken();
    if (token != null) {
      await _saveTokenUseCase.execute(user.id, token);
    }
    _firebaseMessagingDataSource.tokenRefreshStream().listen((newToken) {
      _saveTokenUseCase.execute(user.id, newToken);
    });

    _streamSubscription = _watchPhotoCollectionUseCase.execute().listen((
      collection,
    ) {
      _state = state.copyWith(
        journals: collection.journals,
        photoMap: collection.photoMap,
        isLoading: false,
      );
      notifyListeners();
    });
  }

  Future<void> onAction(HomeAction action) async {
    switch (action) {
      case CameraClick():
        break;
      case NewJournalClick():
        break;
      case ShareClick():
        break;
      case RecentActivityClick():
        throw UnimplementedError();
      case SeeAllClick():
        throw UnimplementedError();
      case MyJournalClick():
        break;
      case FindJounals():
        _findJournals();
      case FindUser():
        _findUser();
      case NewJournalSave():
        _newJournalSave(journal: action.journal);
    }
  }
}
