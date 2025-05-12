import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photopin/storage/data/data_source/storage_data_source.dart';

class FirebaseStorageDataSource implements StorageDataSource {
  final String path;

  final Reference _directoryRef;

  FirebaseStorageDataSource({
    required FirebaseStorage storage,
    required this.path,
  }) : _directoryRef = storage.ref(path);

  /// [path]로 Storage 내부 버킷의 'test/' 경로 **하위의 파일 이름 또는 경로**를 전달합니다.
  /// 예: 'my_photo.jpg', 'subfolder/document.pdf'
  /// [path]로 Storage 내부 버킷의 'test/' 경로 하위의 파일 이름 또는 경로를 전달합니다.
  /// [contentType]은 파일의 MIME 타입입니다 (예: 'image/jpeg', 'image/png', 'application/pdf').
  @override
  Future<String> uploadFile(
    String path,
    Uint8List bytes,
    String? contentType,
  ) async {
    try {
      final Reference fileRef = _directoryRef.child(path);

      final SettableMetadata? metadata =
          contentType != null
              ? SettableMetadata(contentType: contentType)
              : null;

      final UploadTask uploadTask = fileRef.putData(bytes, metadata);
      final TaskSnapshot snapshot = await uploadTask;

      debugPrint(
        '파일 업로드 완료: ${snapshot.ref.fullPath}, ContentType: ${snapshot.metadata?.contentType}',
      );

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('업로드 파일 오류 발생: $e');
      rethrow;
    }
  }
}
