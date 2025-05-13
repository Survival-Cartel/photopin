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
        .orderBy('dateTime')
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
    await _photoStore.doc(photoId).delete();
  }

  @override
  Future<void> savePhoto(PhotoDto dto) async {
    final DocumentReference<PhotoDto> photodoc = await _photoStore.add(dto);
    final String docId = photodoc.id;

    await _photoStore.doc(docId).update({'id': docId});
  }
}
