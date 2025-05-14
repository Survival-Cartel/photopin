import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/enums/permission_type.dart';

class PermissionCheckUseCase {
  PermissionCheckUseCase();

  Future<void> execute(PermissionType permission) async {
    switch (permission) {
      case PermissionType.camera:
        await Permission.camera.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();
      case PermissionType.photos:
        await Permission.photos.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();
      case PermissionType.location:
        await Permission.location.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();
    }
  }
}
