import 'package:get_it/get_it.dart';
import 'package:photopin/core/firebase/firestore_setup.dart';

final getIt = GetIt.instance;

void di() {
  getIt.registerLazySingleton<FirestoreSetup>(() => FirestoreSetup());
}
