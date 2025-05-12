import 'package:flutter/services.dart';
import 'package:photopin/storage/data/data_source/storage_data_source.dart';

class UploadFileUseCase {
  final StorageDataSource _storageDataSource;

  const UploadFileUseCase(this._storageDataSource);

  Future<void> execute(
    String fileName,
    Uint8List bytes,
    String mimeType,
  ) async {
    await _storageDataSource.uploadFile(fileName, bytes, mimeType);
  }
}
