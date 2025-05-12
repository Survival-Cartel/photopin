import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/core/usecase/launch_camera_use_case.dart';
import 'package:photopin/core/usecase/permission_checker_use_case.dart';
import 'package:photopin/core/usecase/upload_file_use_case.dart';
import 'package:photopin/presentation/screen/camera/camera_state.dart';

import '../../../core/enums/image_mime.dart';

class CameraViewModel with ChangeNotifier {
  final CameraState _state = CameraState();
  final LaunchCameraUseCase _launchCameraUseCase;
  final PermissionCheckerUseCase _permissionCheckerUseCase;
  final UploadFileUseCase _uploadFileUseCase;

  CameraViewModel({
    required LaunchCameraUseCase launchCameraUseCase,
    required PermissionCheckerUseCase permisionCheckerUseCase,
    required UploadFileUseCase uploadFileUseCase,
  }) : _launchCameraUseCase = launchCameraUseCase,
       _uploadFileUseCase = uploadFileUseCase,
       _permissionCheckerUseCase = permisionCheckerUseCase;

  CameraState get state => _state;

  Future<bool> checkLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission?> _requestLocationPermision() async {
    bool isServiceEnabled = await checkLocationServiceEnabled();

    if (isServiceEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationPermission.denied;
        }
      }

      return permission;
    }

    return null;
  }

  Future<Position?> _determinePosition(
    LocationPermission locationPermission,
  ) async {
    switch (locationPermission) {
      case LocationPermission.denied:
        return null;
      case LocationPermission.deniedForever:
        return null;
      case LocationPermission.unableToDetermine:
        return null;
      case LocationPermission.whileInUse:
        return await Geolocator.getCurrentPosition();
      case LocationPermission.always:
        return await Geolocator.getCurrentPosition();
    }
  }

  Future<bool> launchCameraApp() async {
    await _permissionCheckerUseCase.execute(Permission.camera);
    await _permissionCheckerUseCase.execute(Permission.photos);

    LocationPermission? locationPermission = await _requestLocationPermision();
    BinaryData? binaryData = await _launchCameraUseCase.execute();

    if (binaryData != null && locationPermission != null) {
      final Position? position = await _determinePosition(locationPermission);
      debugPrint('Position: $position');

      // 위치 정보 Firestore에 저장
      // 이거 해야도밈

      // 사진을 Firebase Storage에 저장
      await _uploadFileUseCase.execute('ABC', binaryData.bytes, ImageMime.jpg);
      return true;
    }

    // Case 2. 사진 촬영 취소
    return false;
  }
}
