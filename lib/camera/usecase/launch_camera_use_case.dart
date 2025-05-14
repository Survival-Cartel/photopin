import 'package:photopin/camera/helper/camera_helper.dart';
import 'package:photopin/core/domain/image_data.dart';

class LaunchCameraUseCase {
  final CameraHelper _cameraHelper;

  LaunchCameraUseCase({required CameraHelper cameraHelper})
    : _cameraHelper = cameraHelper;

  Future<ImageData?> execute() async {
    return await _cameraHelper.launch();
  }
}
