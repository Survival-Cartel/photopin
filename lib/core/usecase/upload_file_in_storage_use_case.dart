import 'package:flutter/services.dart';
import 'package:photopin/core/enums/image_mime.dart';
import 'package:photopin/storage/data/data_source/storage_data_source.dart';

class UploadFileInStorageUseCase {
  final StorageDataSource _storageDataSource;

  const UploadFileInStorageUseCase(this._storageDataSource);

  Future<String> execute(
    String fileName,
    Uint8List bytes,
    ImageMime mimeType,
  ) async {
    return await _storageDataSource.uploadFile(fileName, bytes, mimeType.type);
  }
}
