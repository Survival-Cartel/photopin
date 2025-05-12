import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/presentation/screen/camera/handler/camera_handler.dart';

class LaunchCameraUseCase {
  final CameraHandler _cameraHandler;

  LaunchCameraUseCase({required CameraHandler cameraHandler})
    : _cameraHandler = cameraHandler;

  Future<BinaryData?> execute() async {
    return await _cameraHandler.launch();
  }
}
