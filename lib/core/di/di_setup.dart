import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:photopin/auth/data/data_source/auth_data_source.dart';
import 'package:photopin/auth/data/data_source/auth_data_source_impl.dart';
import 'package:photopin/auth/data/repository/auth_repository.dart';
import 'package:photopin/auth/data/repository/auth_repository_impl.dart';
import 'package:photopin/core/firebase/firestore_setup.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/data_source/journal_data_source_impl.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/data/repository/journal_repository_impl.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/data_source/photo_data_source_impl.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/data/repository/photo_repository_impl.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/data_source/user_data_source_impl.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/data/repository/user_repository_impl.dart';

final getIt = GetIt.instance;

void di() {
  getIt.registerLazySingleton(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<FirestoreSetup>(() => FirestoreSetup());

  getIt.registerSingleton<UserDataSource>(
    UserDataSourceImpl(userStore: getIt.get<FirestoreSetup>().userFirestore()),
  );

  getIt.registerSingleton<UserRepository>(UserRepositoryImpl(getIt()));

  // userId 마다 firestore에서 받아오는 photo collection 이 달라져야함으로 싱글톤이 의미가 없음.
  getIt.registerFactoryParam<PhotoDataSource, String, void>(
    (userId, _) => PhotoDataSourceImpl(
      photoStore: getIt<FirestoreSetup>().photoFirestore(userId),
    ),
  );

  getIt.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(auth: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<PhotoRepository>(
    () => PhotoRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerFactory<AuthViewModel>(() => AuthViewModel(getIt()));

  getIt.registerFactoryParam<JournalDataSource, String, void>(
    (userId, _) => JournalDataSourceImpl(
      journalStore: getIt<FirestoreSetup>().journalFirestore(userId),
    ),
  );
  getIt.registerLazySingleton<JournalRepository>(
    () => JournalRepositoryImpl(dataSource: getIt()),
  );
}
