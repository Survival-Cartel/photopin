import 'package:flutter/services.dart';

abstract interface class StorageDataSource {
  Future<String> uploadFile(String path, Uint8List bytes, String? contentType);
}
