import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';

class PhotoDataSourceImpl implements PhotoDataSource {
  final CollectionReference<PhotoDto> _photoStore;
  const PhotoDataSourceImpl({required CollectionReference<PhotoDto> photoStore})
    : _photoStore = photoStore;

  @override
  Future<PhotoDto> findPhotoById(String id) async {
    final QuerySnapshot<PhotoDto> snapshot = await _photoStore
        .where('id', isEqualTo: id)
        .get()
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    for (final docSnapshot in snapshot.docs) {
      return docSnapshot.data();
    }

    throw FirestoreError.notFoundError;
  }

  @override
  Future<List<PhotoDto>> findPhotos() async {
    final List<PhotoDto> photoDtos = [];

    await _photoStore
        .orderBy('dateTime', descending: true)
        .get()
        .then((snapshot) {
          for (var doc in snapshot.docs) {
            photoDtos.add(doc.data());
          }
        })
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    return photoDtos;
  }

  @override
  Future<List<PhotoDto>> findPhotosByJournalId(String journalId) async {
    final List<PhotoDto> photoDtos = [];

    await _photoStore
        .where('journalId', isEqualTo: journalId)
        .orderBy('dateTime', descending: true)
        .get()
        .then((snapshot) {
          for (var doc in snapshot.docs) {
            photoDtos.add(doc.data());
          }
        })
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    return photoDtos;
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    try {
      await _photoStore.doc(photoId).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> savePhoto(PhotoDto dto) async {
    try {
      final DocumentReference<PhotoDto> photodoc = await _photoStore.add(dto);
      final String docId = photodoc.id;

      await _photoStore.doc(docId).update({'id': docId});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updatePhoto(PhotoDto photoDto) async {
    try {
      await _photoStore.doc(photoDto.id).set(photoDto, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<PhotoDto>> watchPhotos() {
    try {
      return _photoStore
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } catch (e) {
      throw FirestoreError.notFoundError;
    }
  }
}
