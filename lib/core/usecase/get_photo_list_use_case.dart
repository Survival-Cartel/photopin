import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class GetPhotoListUseCase {
  final PhotoRepository _photoRepository;

  const GetPhotoListUseCase({required PhotoRepository photoRepository})
    : _photoRepository = photoRepository;

  Future<List<PhotoModel>> execute() async {
    return await _photoRepository.findAll();
  }
}
