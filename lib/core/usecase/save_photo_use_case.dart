import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/photo/data/mapper/photo_mapper.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';

class SavePhotoUseCase {
  final PhotoRepository _photoRepository;

  const SavePhotoUseCase(this._photoRepository);

  Future<void> execute(PhotoDto dto) async {
    await _photoRepository.savePhoto(dto.toModel());
  }
}
