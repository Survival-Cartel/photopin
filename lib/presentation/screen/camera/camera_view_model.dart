import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/usecase/launch_camera_use_case.dart';
import 'package:photopin/core/usecase/permission_checker_use_case.dart';
import 'package:photopin/presentation/screen/camera/camera_state.dart';

class CameraViewModel with ChangeNotifier {
  final CameraState _state = CameraState();
  final LaunchCameraUseCase _launchCameraUseCase;
  final PermissionCheckerUseCase _permissionCheckerUseCase;

  CameraViewModel({
    required LaunchCameraUseCase launchCameraUseCase,
    required PermissionCheckerUseCase permisionCheckerUseCase,
  })
      : _launchCameraUseCase = launchCameraUseCase,
        _permissionCheckerUseCase = permisionCheckerUseCase;

  CameraState get state => _state;

  Future<LocationPermission?> _requestLocationPermision() async {
    debugPrint('[Geolocator] 위치 권한 확인 시작');
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 상태 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('[Geolocator] 위치 서비스 비활성화됨.');

      return null;
    }
    // 위치 권한 확인
    permission = await Geolocator.checkPermission();

    // 위치 권한 반환
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermission.denied;
      }
    }

    return permission;
  }

  Future<Position?> _determinePosition(
      LocationPermission locationPermission,) async {
    switch (locationPermission) {
      case LocationPermission.denied:
        return null;
      case LocationPermission.deniedForever:
        return null;
      case LocationPermission.whileInUse:
        return await Geolocator.getCurrentPosition();
      case LocationPermission.always:
        return await Geolocator.getCurrentPosition();
      case LocationPermission.unableToDetermine:
        return null;
    }
  }

  Future<bool> launchCameraApp() async {
    await _permissionCheckerUseCase.execute(Permission.camera);
    await _permissionCheckerUseCase.execute(Permission.photos);
    await _permissionCheckerUseCase.execute(Permission.location);
    LocationPermission? locationPermission = await _requestLocationPermision();
    Uint8List? imageByte = await _launchCameraUseCase.execute();


    // Case 1. 사진 촬영
    if (imageByte != null && locationPermission != null) {
      // 위치 정보 권한 획득
      final Position? position = await _determinePosition(locationPermission);
      debugPrint('Position: $position');

      // 위치 정보 Firestore에 저장
      // 사진을 Firebase Storage에 저장
      return true;
    }

    // Case 2. 사진 촬영 취소
    return false;
  }

  Future<void> getPermission() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !photosStatus.isGranted) {
      // 권한 없으면 여기서 조건 분기
    }
  }
}
