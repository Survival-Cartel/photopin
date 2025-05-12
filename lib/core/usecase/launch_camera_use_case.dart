import 'dart:typed_data';

import 'package:photopin/presentation/screen/camera/handler/camera_handler.dart';

class LaunchCameraUseCase {
  final CameraHandler _cameraHandler;

  LaunchCameraUseCase({required CameraHandler cameraHandler})
    : _cameraHandler = cameraHandler;

  Future<Uint8List?> execute() async {
    Uint8List? imageByte = await _cameraHandler.launch();

    return imageByte;
  }
}
