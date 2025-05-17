import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/user/data/data_source/user_data_source.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

class UserDataSourceImpl implements UserDataSource {
  final CollectionReference<UserDto> userStore;

  const UserDataSourceImpl({required this.userStore});

  @override
  Future<void> saveUser(UserDto dto) async {
    await userStore.doc(dto.id).set(dto, SetOptions(merge: true));
  }

  @override
  Future<void> deleteUser(String userId) async {
    await userStore.doc(userId).delete();
  }

  @override
  Future<UserDto> findUserByEmail(String email) async {
    final QuerySnapshot<UserDto> user = await userStore
        .where('email', isEqualTo: email)
        .get()
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    return user.docs.first.data();
  }

  @override
  Future<UserDto> findUserById(String id) async {
    final QuerySnapshot<UserDto> user = await userStore
        .where('id', isEqualTo: id)
        .get()
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    return user.docs.first.data();
  }

  @override
  Future<List<UserDto>> findUsers() async {
    final QuerySnapshot<UserDto> users = await userStore.get().timeout(
      const Duration(seconds: 8),
      onTimeout: () => throw FirestoreError.timeOutError,
    );

    return users.docs.map((e) => e.data()).toList();
  }
}
