import 'package:get_it/get_it.dart';
import 'package:photopin/core/firebase/firestore_setup.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/data_source/user_data_source_impl.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/data/repository/user_repository_impl.dart';

final getIt = GetIt.instance;

void di() {
  getIt.registerSingleton<UserDataSource>(
    UserDataSourceImpl(userStore: getIt.get<FirestoreSetup>().userFirestore()),
  );

  getIt.registerSingleton<UserRepository>(UserRepositoryImpl(getIt()));

  getIt.registerLazySingleton<FirestoreSetup>(() => FirestoreSetup());
}
