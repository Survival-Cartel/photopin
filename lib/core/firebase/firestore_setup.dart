import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/core/firebase/firestore_collections.dart';
import 'package:photopin/journal/data/dto/journal_dto.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/user/data/dto/user_dto.dart';

class FirestoreSetup {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<PhotoDto> photoFirestore(String userId) {
    return firestore
        .collection(FirestoreCollections.userCollection)
        .doc(userId)
        .collection(FirestoreCollections.photoCollection)
        .withConverter(
          fromFirestore: (snapShot, _) => PhotoDto.fromJson(snapShot.data()!),
          toFirestore: (dto, _) => dto.toJson(),
        );
  }

  CollectionReference<JournalDto> journalFirestore(String userId) {
    return firestore
        .collection(FirestoreCollections.userCollection)
        .doc(userId)
        .collection(FirestoreCollections.journalCollection)
        .withConverter(
          fromFirestore: (snapShot, _) => JournalDto.fromJson(snapShot.data()!),
          toFirestore: (dto, _) => dto.toJson(),
        );
  }

  CollectionReference<UserDto> userFirestore() {
    return firestore
        .collection(FirestoreCollections.userCollection)
        .withConverter(
          fromFirestore: (snapShot, _) => UserDto.fromJson(snapShot.data()!),
          toFirestore: (dto, _) => dto.toJson(),
        );
  }
}
