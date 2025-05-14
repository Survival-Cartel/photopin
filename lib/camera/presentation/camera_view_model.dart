import 'dart:async';

import 'package:photopin/camera/usecase/launch_camera_check_permission_use_case.dart';
import 'package:photopin/camera/usecase/launch_camera_use_case.dart';
import 'package:photopin/camera/usecase/save_picture_in_device_use_case.dart';
import 'package:photopin/camera/usecase/save_picture_in_firebase_use_case.dart';
import 'package:photopin/core/domain/image_data.dart';
import 'package:photopin/core/enums/image_mime.dart';
import 'package:photopin/core/enums/camera_stream_event.dart';

class CameraViewModel {
  final LaunchCameraUseCase _launchCameraUseCase;
  final LaunchCameraCheckPermissionUseCase _launchCameraCheckPermissionUseCase;
  final SavePictureInFirebaseUseCase _savePictureInFirebaseUseCase;
  final SavePictureInDeviceUseCase _savePictureInDeviceUseCase;

  final StreamController<CameraStreamEvent> _eventController =
      StreamController<CameraStreamEvent>();

  CameraViewModel({
    required LaunchCameraUseCase launchCameraUseCase,
    required LaunchCameraCheckPermissionUseCase
    launchCameraCheckPermissionUseCase,
    required SavePictureInFirebaseUseCase savePictureInFirebaseUseCase,
    required SavePictureInDeviceUseCase savePictureInDeviceUseCase,
  }) : _launchCameraUseCase = launchCameraUseCase,
       _launchCameraCheckPermissionUseCase = launchCameraCheckPermissionUseCase,
       _savePictureInDeviceUseCase = savePictureInDeviceUseCase,
       _savePictureInFirebaseUseCase = savePictureInFirebaseUseCase;

  Stream<CameraStreamEvent> get eventStream => _eventController.stream;

  Future<void> launchCameraApp() async {
    bool isPermissionAllowed =
        await _launchCameraCheckPermissionUseCase.execute();

    if (isPermissionAllowed) {
      ImageData? imageData = await _launchCameraUseCase.execute();

      if (imageData != null) {
        _eventController.add(CameraStreamEvent.done);
        await _savePictureInDeviceUseCase.execute(imageData.xFile.path);
        await _savePictureInFirebaseUseCase.execute(imageData, ImageMime.jpg);
      }
    }

    _eventController.add(CameraStreamEvent.cancel);
  }
}
