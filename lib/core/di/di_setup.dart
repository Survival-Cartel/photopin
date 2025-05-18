import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/auth/data/data_source/auth_data_source_impl.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/auth/data/repository/auth_repository_impl.dart';
import 'package:photopin/camera/data/repository/image_save_plus_local_device_repository.dart';
import 'package:photopin/camera/data/repository/local_device_repository.dart';
import 'package:photopin/camera/helper/camera_helper.dart';
import 'package:photopin/camera/helper/image_picker_camera_helper.dart';
import 'package:photopin/camera/presentation/camera_view_model.dart';
import 'package:photopin/camera/usecase/launch_camera_check_permission_use_case.dart';
import 'package:photopin/camera/usecase/launch_camera_use_case.dart';
import 'package:photopin/camera/usecase/save_picture_in_device_use_case.dart';
import 'package:photopin/camera/usecase/save_picture_in_firebase_use_case.dart';
import 'package:photopin/core/firebase/firestore_setup.dart';
import 'package:photopin/core/usecase/auth_and_user_save_use_case.dart';
import 'package:photopin/core/service/geolocator_location_service.dart';
import 'package:photopin/core/service/location_service.dart';
import 'package:photopin/core/service/push_service.dart';
import 'package:photopin/core/usecase/delete_journal_use_case.dart';
import 'package:photopin/core/usecase/get_compare_model_use_case.dart';
import 'package:photopin/core/usecase/get_current_location_use_case.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_journal_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_list_use_case.dart';
import 'package:photopin/core/usecase/get_photo_list_with_journal_id_use_case.dart';
import 'package:photopin/core/usecase/get_place_name_use_case.dart';
import 'package:photopin/core/usecase/link_access_notification_use_case.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';
import 'package:photopin/core/usecase/save_photo_use_case.dart';
import 'package:photopin/core/usecase/search_journal_by_date_time_range_use_case.dart';
import 'package:photopin/core/usecase/save_token_use_case.dart';
import 'package:photopin/core/usecase/update_journal_use_case.dart';
import 'package:photopin/core/usecase/upload_file_in_storage_use_case.dart';
import 'package:photopin/core/usecase/watch_photo_collection_use_case.dart';
import 'package:photopin/core/usecase/watch_journals_use_case.dart';
import 'package:photopin/fcm/data/data_source/firebase_messaging_data_source.dart';
import 'package:photopin/fcm/data/data_source/firebase_messaging_data_source_impl.dart';
import 'package:photopin/fcm/data/repository/token_repository.dart';
import 'package:photopin/fcm/data/repository/token_repository_impl.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/data_source/journal_data_source_impl.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/data/repository/journal_repository_impl.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/data_source/photo_data_source_impl.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/data/repository/photo_repository_impl.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_view_model.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_view_model.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/presentation/screen/journal/journal_view_model.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';
import 'package:photopin/presentation/screen/photos/photos_view_model.dart';
import 'package:photopin/presentation/screen/settings/settings_view_model.dart';
import 'package:photopin/storage/data/data_source/firebase_storage_data_source.dart';
import 'package:photopin/storage/data/data_source/storage_data_source.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/data_source/user_data_source_impl.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/data/repository/user_repository_impl.dart';

final getIt = GetIt.instance;

void di() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseMessaging.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirestoreSetup>(() => FirestoreSetup());
  getIt.registerSingleton<UserDataSource>(
    UserDataSourceImpl(userStore: getIt.get<FirestoreSetup>().userFirestore()),
  );

  getIt.registerSingleton<UserRepository>(UserRepositoryImpl(getIt()));

  getIt.registerFactory<MainScreenViewModel>(
    () => MainScreenViewModel(getCurrentUserUseCase: getIt()),
  );
  getIt.registerLazySingleton<TokenRepository>(
    () => TokenRepositoryImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerSingleton<FirebaseMessagingDataSource>(
    FirebaseMessagingDataSourceImpl(getIt<FirebaseMessaging>()),
  );

  // userId 마다 firestore에서 받아오는 photo collection 이 달라져야함으로 싱글톤이 의미가 없음.
  getIt.registerFactoryParam<PhotoDataSource, String, void>(
    (userId, _) => PhotoDataSourceImpl(
      photoStore: getIt<FirestoreSetup>().photoFirestore(userId),
    ),
  );

  getIt.registerFactoryParam<SavePhotoUseCase, String, void>(
    (userId, _) => SavePhotoUseCase(getIt<PhotoRepository>(param1: userId)),
  );

  getIt.registerFactoryParam<PhotoRepository, String, void>(
    (userId, _) => PhotoRepositoryImpl(
      photoDataSource: getIt<PhotoDataSource>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<StorageDataSource, String, void>(
    (userId, _) => FirebaseStorageDataSource(
      storage: getIt<FirebaseStorage>(),
      path: userId,
    ),
  );

  getIt.registerFactoryParam<GetPhotoListUseCase, String, void>(
    (userId, _) => GetPhotoListUseCase(
      photoRepository: getIt<PhotoRepository>(param1: userId),
    ),
  );

  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(auth: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt()),
  );

  getIt.registerFactoryParam<HomeViewModel, String, void>(
    (userId, _) => HomeViewModel(
      watchPhotoCollectionUseCase: getIt<WatchPhotoCollectionUseCase>(
        param1: userId,
      ),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      journalRepository: getIt<JournalRepository>(param1: userId),
      getJournalListUseCase: getIt<GetJournalListUseCase>(param1: userId),
      permissionCheckUseCase: getIt<PermissionCheckUseCase>(),
      saveTokenUseCase: getIt<SaveTokenUseCase>(),
      firebaseMessagingDataSource: getIt<FirebaseMessagingDataSource>(),
    ),
  );

  getIt.registerFactoryParam<GetJournalListUseCase, String, void>(
    (userId, _) => GetJournalListUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
      photoRepository: getIt<PhotoRepository>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<SearchJournalByDateTimeRangeUseCase, String, void>(
    (userId, _) => SearchJournalByDateTimeRangeUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<GetPhotoListWithJournalIdUseCase, String, void>(
    (userId, _) => GetPhotoListWithJournalIdUseCase(
      photoRepository: getIt<PhotoRepository>(param1: userId),
    ),
  );

  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(getIt()),
  );

  getIt.registerSingleton<LocationService>(GeolocatorLocationService());

  getIt.registerSingleton<GetCurrentLocationUseCase>(
    GetCurrentLocationUseCase(geoService: getIt<LocationService>()),
  );

  getIt.registerSingleton<PermissionCheckUseCase>(PermissionCheckUseCase());

  getIt.registerSingleton<LaunchCameraCheckPermissionUseCase>(
    LaunchCameraCheckPermissionUseCase(
      permissionCheckUseCase: getIt<PermissionCheckUseCase>(),
    ),
  );

  getIt.registerFactoryParam<WatchJournalsUseCase, String, void>(
    (userId, _) => WatchJournalsUseCase(
      photoRepository: getIt<PhotoRepository>(param1: userId),
      journalRepository: getIt<JournalRepository>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<UpdateJournalUseCase, String, void>(
    (userId, _) => UpdateJournalUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<DeleteJournalUseCase, String, void>(
    (userId, _) => DeleteJournalUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<WatchPhotoCollectionUseCase, String, void>(
    (userId, _) => WatchPhotoCollectionUseCase(
      getPhotoJournalListUseCase: getIt<GetPhotoJournalListUseCase>(
        param1: userId,
      ),
    ),
  );

  getIt.registerFactoryParam<JournalViewModel, String, void>(
    (userId, _) => JournalViewModel(
      watchPhotoCollectionUseCase: getIt<WatchPhotoCollectionUseCase>(
        param1: userId,
      ),
      deleteJournalUseCase: getIt<DeleteJournalUseCase>(param1: userId),
      searchJournalByDateTimeRangeUseCase:
          getIt<SearchJournalByDateTimeRangeUseCase>(param1: userId),
      updateJournalUseCase: getIt<UpdateJournalUseCase>(param1: userId),
    ),
  );

  getIt.registerSingleton<CameraHelper>(ImagePickerCameraHelper());

  getIt.registerSingleton<LaunchCameraUseCase>(
    LaunchCameraUseCase(cameraHelper: getIt<CameraHelper>()),
  );

  getIt.registerFactoryParam<UploadFileInStorageUseCase, String, void>(
    (userId, _) =>
        UploadFileInStorageUseCase(getIt<StorageDataSource>(param1: userId)),
  );

  getIt.registerFactoryParam<SavePictureInFirebaseUseCase, String, void>(
    (userId, _) => SavePictureInFirebaseUseCase(
      getCurrentLocationUseCase: getIt<GetCurrentLocationUseCase>(),
      savePhotoUseCase: getIt<SavePhotoUseCase>(param1: userId),
      uploadFileInStorageUseCase: getIt<UploadFileInStorageUseCase>(
        param1: userId,
      ),
      getPlaceNameUseCase: getIt<GetPlaceNameUseCase>(),
    ),
  );

  getIt.registerSingleton<LocalDeviceRepository>(
    ImageSavePlusLocalDeviceRepository(),
  );

  getIt.registerSingleton<SavePictureInDeviceUseCase>(
    SavePictureInDeviceUseCase(
      localDeviceRepository: getIt<LocalDeviceRepository>(),
    ),
  );

  getIt.registerFactoryParam<CameraViewModel, String, void>(
    (userId, _) => CameraViewModel(
      savePictureInDeviceUseCase: getIt<SavePictureInDeviceUseCase>(),
      launchCameraUseCase: getIt<LaunchCameraUseCase>(),
      launchCameraCheckPermissionUseCase:
          getIt<LaunchCameraCheckPermissionUseCase>(),
      savePictureInFirebaseUseCase: getIt<SavePictureInFirebaseUseCase>(
        param1: userId,
      ),
    ),
  );

  getIt.registerSingleton<GetPlaceNameUseCase>(
    GetPlaceNameUseCase(http.Client()),
  );

  getIt.registerSingleton<AuthAndUserSaveUseCase>(
    AuthAndUserSaveUseCase(
      authRepository: getIt<AuthRepository>(),
      userRepository: getIt<UserRepository>(),
    ),
  );

  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      authRepository: getIt<AuthRepository>(),
      authAndUserSaveUseCase: getIt<AuthAndUserSaveUseCase>(),
    ),
  );

  getIt.registerFactoryParam<JournalDataSource, String, void>(
    (userId, _) => JournalDataSourceImpl(
      journalStore: getIt<FirestoreSetup>().journalFirestore(userId),
    ),
  );

  getIt.registerFactoryParam<JournalRepository, String, void>(
    (userId, _) => JournalRepositoryImpl(
      dataSource: getIt<JournalDataSource>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<MapViewModel, String, void>(
    (userId, _) => MapViewModel(
      photoRepository: getIt<PhotoRepository>(param1: userId),
      getCompareModelUseCase: getIt<GetCompareModelUseCase>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<PhotosViewModel, String, void>(
    (userId, _) => PhotosViewModel(
      getPhotoListUseCase: getIt<GetPhotoListUseCase>(param1: userId),
      getJournalListUseCase: getIt<GetJournalListUseCase>(param1: userId),
      getPhotoListWithJournalIdUseCase: getIt<GetPhotoListWithJournalIdUseCase>(
        param1: userId,
      ),
      photoRepository: getIt<PhotoRepository>(param1: userId),
      getPhotoJournalListUseCase: getIt<GetPhotoJournalListUseCase>(
        param1: userId,
      ),
    ),
  );

  getIt.registerFactoryParam<GetPhotoJournalListUseCase, String, void>(
    (userId, _) => GetPhotoJournalListUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
      photoRepository: getIt<PhotoRepository>(param1: userId),
    ),
  );

  getIt.registerSingleton<SettingsViewModel>(
    SettingsViewModel(permissionCheckUseCase: getIt<PermissionCheckUseCase>()),
  );

  getIt.registerFactoryParam<GetCompareModelUseCase, String, void>(
    (userId, _) => GetCompareModelUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
      photoRepository: getIt<PhotoRepository>(param1: userId),
      userRepository: getIt<UserRepository>(),
    ),
  );

  getIt.registerFactoryParam<CompareMapViewModel, String, String>(
    (compareUserId, myUserId) => CompareMapViewModel(
      sharedUseCase: getIt<GetCompareModelUseCase>(param1: compareUserId),
      myUseCase: getIt<GetCompareModelUseCase>(param1: myUserId),
    ),
  );

  getIt.registerLazySingleton<PushService>(() => PushService());

  getIt.registerSingleton<LinkAccessNotificationUseCase>(
    LinkAccessNotificationUseCase(
      tokenRepository: getIt<TokenRepository>(),
      pushService: getIt<PushService>(),
    ),
  );

  getIt.registerFactoryParam<CompareDialogViewModel, String, void>(
    (userId, _) => CompareDialogViewModel(
      repository: getIt<JournalRepository>(param1: userId),
      linkAccessNotificationuseCase: getIt<LinkAccessNotificationUseCase>(),
    ),
  );

  getIt.registerSingleton<SaveTokenUseCase>(SaveTokenUseCase(getIt()));
}
