import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/core/enums/image_mime.dart';
import 'package:photopin/core/usecase/launch_camera_use_case.dart';
import 'package:photopin/core/enums/camera_stream_event.dart';
import 'package:photopin/presentation/screen/camera/usecase/launch_camera_check_permission_use_case.dart';
import 'package:photopin/presentation/screen/camera/usecase/save_picture_in_firebase_use_case.dart';

class CameraViewModel with ChangeNotifier {
  final LaunchCameraUseCase _launchCameraUseCase;
  final LaunchCameraCheckPermissionUseCase _launchCameraCheckPermissionUseCase;
  final SavePictureInFirebaseUseCase _savePictureInFirebaseUseCase;

  final StreamController<CameraStreamEvent> _eventController =
      StreamController<CameraStreamEvent>();

  CameraViewModel({
    required launchCameraUseCase,
    required launchCameraCheckPermissionUseCase,
    required savePictureInFirebaseUseCase,
  }) : _launchCameraUseCase = launchCameraUseCase,
       _launchCameraCheckPermissionUseCase = launchCameraCheckPermissionUseCase,
       _savePictureInFirebaseUseCase = savePictureInFirebaseUseCase;

  Stream<CameraStreamEvent> get eventStream => _eventController.stream;

  Future<void> launchCameraApp() async {
    bool isPermissionAllowed =
        await _launchCameraCheckPermissionUseCase.execute();

    if (isPermissionAllowed) {
      BinaryData? binaryData = await _launchCameraUseCase.execute();

      if (binaryData != null) {
        _eventController.add(CameraStreamEvent.done);
        await _savePictureInFirebaseUseCase.execute(binaryData, ImageMime.jpg);
      }
    }

    _eventController.add(CameraStreamEvent.cancel);
  }
}
