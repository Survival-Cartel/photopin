import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/photo/data/data_source/photo_data_source.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';

class PhotoDataSourceImpl implements PhotoDataSource {
  final CollectionReference<PhotoDto> photoStore;

  const PhotoDataSourceImpl({required this.photoStore});

  @override
  Future<PhotoDto> findPhotoById(String id) async {
    final QuerySnapshot<PhotoDto> snapshot = await photoStore
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

    final QuerySnapshot<PhotoDto> snapshot = await photoStore.get().timeout(
      const Duration(seconds: 8),
      onTimeout: () => throw FirestoreError.timeOutError,
    );

    snapshot.docs.map((e) => photoDtos.add(e.data()));

    return photoDtos;
  }

  @override
  Future<List<PhotoDto>> findPhotosByJournalId(String journalId) async {
    final List<PhotoDto> photoDtos = [];

    await photoStore
        .where('journalId', isEqualTo: journalId)
        .orderBy('dateTime')
        .get()
        .then((QuerySnapshot<PhotoDto> value) {
          for (DocumentSnapshot<PhotoDto> snapshot in value.docs) {
            photoDtos.add(snapshot.data()!);
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
    await photoStore.doc(photoId).delete();
  }

  @override
  Future<void> savePhoto(PhotoDto dto) async {
    final DocumentReference<PhotoDto> photodoc = await photoStore.add(dto);
    final String docId = photodoc.id;

    await photoStore.doc(docId).update({'id': docId});
  }
}
