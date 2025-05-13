import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/auth/data/data_source/auth_data_source_impl.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/auth/data/repository/auth_repository_impl.dart';
import 'package:photopin/core/firebase/firestore_setup.dart';
import 'package:photopin/core/usecase/get_current_user_use_case.dart';
import 'package:photopin/core/usecase/get_journal_list_use_case.dart';
import 'package:photopin/core/usecase/get_place_name_use_case.dart';
import 'package:photopin/core/usecase/launch_camera_use_case.dart';
import 'package:photopin/core/usecase/permission_checker_use_case.dart';
import 'package:photopin/core/usecase/save_photo_use_case.dart';
import 'package:photopin/core/usecase/upload_file_use_case.dart';
import 'package:photopin/core/usecase/watch_journals_use_case.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/data_source/journal_data_source_impl.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/data/repository/journal_repository_impl.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/data_source/photo_data_source_impl.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/data/repository/photo_repository_impl.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/presentation/screen/camera/camera_view_model.dart';
import 'package:photopin/presentation/screen/camera/handler/camera_handler.dart';
import 'package:photopin/presentation/screen/camera/handler/image_picker_camera_handler.dart';
import 'package:photopin/presentation/screen/camera/handler/permission_checker.dart';
import 'package:photopin/presentation/screen/camera/handler/permisson_handler_checker.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/presentation/screen/journal/journal_view_model.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';
import 'package:photopin/storage/data/data_source/firebase_storage_data_source.dart';
import 'package:photopin/storage/data/data_source/storage_data_source.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/data_source/user_data_source_impl.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/data/repository/user_repository_impl.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

void di() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  getIt.registerLazySingleton<FirestoreSetup>(() => FirestoreSetup());
  getIt.registerSingleton<UserDataSource>(
    UserDataSourceImpl(userStore: getIt.get<FirestoreSetup>().userFirestore()),
  );

  getIt.registerSingleton<UserRepository>(UserRepositoryImpl(getIt()));

  getIt.registerFactory<MainScreenViewModel>(
    () => MainScreenViewModel(getCurrentUserUseCase: getIt()),
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

  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(auth: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt()),
  );

  getIt.registerFactoryParam<HomeViewModel, String, void>(
    (userId, _) => HomeViewModel(
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      journalRepository: getIt<JournalRepository>(param1: userId),
      getJournalListUseCase: getIt<GetJournalListUseCase>(param1: userId),
      watchJournalsUserCase: getIt<WatchJournalsUseCase>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<GetJournalListUseCase, String, void>(
    (userId, _) => GetJournalListUseCase(
      journalRepository: getIt<JournalRepository>(param1: userId),
      photoRepository: getIt<PhotoRepository>(param1: userId),
    ),
  );

  getIt.registerSingleton<PermissionChecker>(PermissionHandlerChecker());

  getIt.registerSingleton<PermissionCheckerUseCase>(
    PermissionCheckerUseCase(permissionChecker: getIt<PermissionChecker>()),
  );

  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(getIt()),
  );

  getIt.registerFactoryParam<WatchJournalsUseCase, String, void>(
    (userId, _) => WatchJournalsUseCase(
      photoRepository: getIt<PhotoRepository>(param1: userId),
      journalRepository: getIt<JournalRepository>(param1: userId),
    ),
  );

  getIt.registerFactoryParam<JournalViewModel, String, void>(
    (userId, _) => JournalViewModel(
      getJournalListUseCase: getIt<GetJournalListUseCase>(param1: userId),
      watchJournalsUserCase: getIt<WatchJournalsUseCase>(param1: userId),
    ),
  );

  getIt.registerSingleton<CameraHandler>(ImagePickerCameraHandler());

  getIt.registerSingleton<LaunchCameraUseCase>(
    LaunchCameraUseCase(cameraHandler: getIt<CameraHandler>()),
  );

  getIt.registerFactoryParam<UploadFileUseCase, String, void>(
    (userId, _) => UploadFileUseCase(getIt<StorageDataSource>(param1: userId)),
  );

  getIt.registerFactoryParam<CameraViewModel, String, void>(
    (userId, _) => CameraViewModel(
      launchCameraUseCase: getIt<LaunchCameraUseCase>(),
      permisionCheckerUseCase: getIt<PermissionCheckerUseCase>(),
      uploadFileUseCase: getIt<UploadFileUseCase>(param1: userId),
      savePhotoUseCase: getIt<SavePhotoUseCase>(param1: userId),
      getPlaceNameUseCase: getIt<GetPlaceNameUseCase>(),
    ),
  );

  getIt.registerSingleton<GetPlaceNameUseCase>(
    GetPlaceNameUseCase(http.Client()),
  );

  getIt.registerFactory<AuthViewModel>(() => AuthViewModel(getIt()));

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
      getIt<PhotoRepository>(param1: userId),
      getIt<JournalRepository>(param1: userId),
    ),
  );
}
