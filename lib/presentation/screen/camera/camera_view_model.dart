import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/usecase/launch_camera_use_case.dart';
import 'package:photopin/presentation/screen/camera/camera_state.dart';

class CameraViewModel with ChangeNotifier {
  final CameraState _state = CameraState();
  final LaunchCameraUseCase _launchCameraUseCase;

  CameraViewModel({required LaunchCameraUseCase launchCameraUseCase})
    : _launchCameraUseCase = launchCameraUseCase;

  CameraState get state => _state;

  Future<bool> launchCameraApp() async {
    Uint8List? imageByte = await _launchCameraUseCase.execute();

    // Case 1. 사진 촬영
    if (imageByte != null) {
      // 위치 정보 권한 획득

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
