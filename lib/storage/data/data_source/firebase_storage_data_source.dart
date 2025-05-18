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

  @override
  Future<void> deleteFile(String fileUrl) async {
    try {
      if (fileUrl.isEmpty) {
        debugPrint('삭제할 파일 URL이 비어있습니다.');
        return;
      }

      debugPrint('삭제 시도할 파일 URL: $fileUrl');

      // URL에서 파일 경로 추출
      // URL 형식 예시: http://10.0.2.2:9199/v0/b/survival-photopin.firebasestorage.app/o/Fn7hk6y7SvBsYOsxmnKsSOIywQKh%2F0e5202af-a9bd-41e8-8706-e84b8d8ff773?alt=media&token=...

      try {
        final Uri uri = Uri.parse(fileUrl);
        final pathSegments = uri.pathSegments;

        if (pathSegments.isNotEmpty) {
          // 'o' 다음에 오는 경로 부분이 실제 파일 경로
          int oIndex = pathSegments.indexOf('o');
          if (oIndex >= 0 && oIndex + 1 < pathSegments.length) {
            String encodedPath = pathSegments[oIndex + 1];
            String decodedPath = Uri.decodeComponent(encodedPath);

            debugPrint('추출된 파일 경로: $decodedPath');

            // 사용자 ID가 포함된 경로에서 파일 이름만 추출
            // 형식: {userId}/{fileName}
            List<String> pathParts = decodedPath.split('/');

            if (pathParts.length >= 2) {
              String fileName = pathParts.last;
              debugPrint('추출된 파일 이름: $fileName');

              // 사용자 경로(path) 하위의 파일 참조 생성
              Reference fileRef = _directoryRef.child(fileName);
              await fileRef.delete();

              debugPrint('파일 삭제 완료: ${fileRef.fullPath}');
              return;
            }
          }
        }

        debugPrint('URL에서 파일 경로를 추출할 수 없음: $fileUrl');
      } catch (e) {
        debugPrint('URL 파싱 오류: $e');
      }

      // 경로 추출 실패 시 다른 방법 시도
      try {
        // URL의 마지막 부분에서 파일 이름 추출 시도
        String fileName = fileUrl.split('/').last.split('?').first;
        if (fileName.contains('%2F')) {
          fileName = fileName.split('%2F').last;
        }

        debugPrint('대체 방법으로 추출한 파일 이름: $fileName');

        Reference fileRef = _directoryRef.child(fileName);
        await fileRef.delete();

        debugPrint('파일 삭제 완료 (대체 방법): ${fileRef.fullPath}');
      } catch (e) {
        debugPrint('대체 방법 파일 삭제 오류: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('파일 삭제 오류 발생: $e');
      rethrow;
    }
  }
}
