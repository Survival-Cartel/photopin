import 'package:photopin/camera/data/repository/local_device_repository.dart';

class SavePictureInDeviceUseCase {
  final LocalDeviceRepository _localDeviceRepository;

  const SavePictureInDeviceUseCase({
    required LocalDeviceRepository localDeviceRepository,
  }) : _localDeviceRepository = localDeviceRepository;

  Future<void> execute(String path) async {
    await _localDeviceRepository.saveFile(path);
  }
}
