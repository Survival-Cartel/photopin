import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/presentation/screen/camera/service/camera_service.dart';

class LaunchCameraUseCase {
  final CameraService _cameraService;

  LaunchCameraUseCase({required CameraService cameraService})
    : _cameraService = cameraService;

  Future<BinaryData?> execute() async {
    return await _cameraService.launch();
  }
}
