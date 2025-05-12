import 'package:flutter/services.dart';

abstract interface class StorageDataSource {
  Future<void> uploadFile(String path, Uint8List bytes);
  Future<String> getDownloadUrl(String path);
}
