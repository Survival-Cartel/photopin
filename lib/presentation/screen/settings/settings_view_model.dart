import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/usecase/permission_checker_use_case.dart';
import 'package:photopin/presentation/screen/settings/settings_action.dart';

class SettingsViewModel with ChangeNotifier {
  final PermissionCheckerUseCase _permissionCheckerUseCase;

  SettingsViewModel(this._permissionCheckerUseCase);

  Future<void> onAction(SettingsAction action) async {
    switch (action) {
      case CameraPermissionRequest():
        final PermissionStatus cameraPermission =
            await Permission.camera.status;

        if (cameraPermission.isDenied) {
          await Permission.camera.request();
          debugPrint('cameraPermission: ${cameraPermission}');
        } else if (cameraPermission.isPermanentlyDenied) {
          openAppSettings();
        }

        break;
      case PhotoPermissionRequest():
        final PermissionStatus photoPermission = await Permission.photos.status;
        if (photoPermission.isDenied) {
          await Permission.photos.request();
          debugPrint('PhotosPermission: ${photoPermission}');
        } else if (photoPermission.isPermanentlyDenied) {
          openAppSettings();
        }
        break;
      case LocationPermissionRequest():
        final PermissionStatus locationPermission =
            await Permission.location.status;

        if (locationPermission.isDenied) {
          await Permission.location.request();
          debugPrint('LocationPermissionRequres : ${locationPermission}');
        } else if (locationPermission.isPermanentlyDenied) {
          openAppSettings();
        }
        break;
    }
  }
}
