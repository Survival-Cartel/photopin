import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:photopin/storage/data/data_source/storage_data_source.dart';

class FirebaseStorageDataSource implements StorageDataSource {
  final Reference _storage;

  FirebaseStorageDataSource({required FirebaseStorage storage})
    : _storage = storage.ref();

  /// [path]로 Storage 내부 버킷의 경로를 전달합니다.
  @override
  Future<void> uploadFile(String path, Uint8List bytes) async {
    try {
      final UploadTask uploadTask = _storage.putData(bytes);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    } catch (e) {
      print('업로드 파일 레전드 오류 발생: $e');
      rethrow;
    }
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    try {
      final String downloadUrl = await _storage.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('다운로드 URL 가져오는 중 레전드 오류 발생: $e');
      rethrow;
    }
  }
}
