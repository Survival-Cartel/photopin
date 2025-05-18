import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:photopin/storage/data/data_source/storage_data_source.dart';

class FakeStorageDataSource extends Fake implements StorageDataSource {
  final List<String> deletedFiles = [];
  final Map<String, String> uploadedFiles = {};

  @override
  Future<void> deleteFile(String fileUrl) async {
    deletedFiles.add(fileUrl);
    // 테스트에서는 실제 삭제를 하지 않음
  }

  @override
  Future<String> uploadFile(
    String path,
    Uint8List bytes,
    String? contentType,
  ) async {
    final String fakeUrl = 'https://fake-storage.com/$path';
    uploadedFiles[path] = fakeUrl;
    return fakeUrl;
  }

  void reset() {
    deletedFiles.clear();
    uploadedFiles.clear();
  }
}
