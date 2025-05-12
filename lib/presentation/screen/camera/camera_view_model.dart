import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/core/usecase/launch_camera_use_case.dart';
import 'package:photopin/core/usecase/permission_checker_use_case.dart';
import 'package:photopin/core/usecase/save_photo_use_case.dart';
import 'package:photopin/core/usecase/upload_file_use_case.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/presentation/screen/camera/camera_state.dart';
import 'package:uuid/v4.dart';

import '../../../core/enums/image_mime.dart';

class CameraViewModel with ChangeNotifier {
  final CameraState _state = CameraState();
  final LaunchCameraUseCase _launchCameraUseCase;
  final PermissionCheckerUseCase _permissionCheckerUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final SavePhotoUseCase _savePhotoUseCase;

  final UuidV4 uuid = const UuidV4();

  CameraViewModel({
    required LaunchCameraUseCase launchCameraUseCase,
    required PermissionCheckerUseCase permisionCheckerUseCase,
    required UploadFileUseCase uploadFileUseCase,
    required SavePhotoUseCase savePhotoUseCase,
  }) : _launchCameraUseCase = launchCameraUseCase,
       _uploadFileUseCase = uploadFileUseCase,
       _permissionCheckerUseCase = permisionCheckerUseCase,
       _savePhotoUseCase = savePhotoUseCase;

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

      final String downloadUrl = await _uploadFileUseCase.execute(
        uuid.generate(),
        binaryData.bytes,
        ImageMime.jpg,
      );

      PhotoDto dto = PhotoDto(
        imageUrl: downloadUrl,
        latitude: position?.latitude,
        longitude: position?.longitude,
        dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
      );

      // Google Place API로 최초 저장 시 장소 이름 구해서 넣기
      await _savePhotoUseCase.execute(dto);

      return true;
    }

    // Case 2. 사진 촬영 취소
    return false;
  }
}
