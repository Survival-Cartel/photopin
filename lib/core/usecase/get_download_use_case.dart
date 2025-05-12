import 'package:photopin/storage/data/data_source/storage_data_source.dart';

class GetDownloadUseCase {
  final StorageDataSource _storageDataSource;
  final String userId;

  const GetDownloadUseCase({
    required this.userId,
    required StorageDataSource storageDataSource,
  }) : _storageDataSource = storageDataSource;

  Future<String> execute(String path) async {
    return await _storageDataSource.getDownloadUrl('$userId/$path');
  }
}
