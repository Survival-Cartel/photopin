import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/enums/permission_allow_status.dart';
import 'package:photopin/core/enums/permission_type.dart';

class PermissionCheckUseCase {
  PermissionCheckUseCase();

  Future<PermissionAllowStatus> execute(PermissionType permission) async {
    switch (permission) {
      case PermissionType.camera:
        final PermissionStatus status =
        await Permission.camera.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();

        return _handleStatus(status);
      case PermissionType.photos:
        final PermissionStatus status =
        await Permission.photos.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();

        return _handleStatus(status);
      case PermissionType.location:
        final PermissionStatus status =
        await Permission.location.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();

        return _handleStatus(status);
      case PermissionType.notification:
        final PermissionStatus status =
        await Permission.notification.onPermanentlyDeniedCallback(() {
          openAppSettings();
        }).request();

        return _handleStatus(status);
    }
  }

  PermissionAllowStatus _handleStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.denied:
        return PermissionAllowStatus.denied;
      case PermissionStatus.granted:
        return PermissionAllowStatus.allow;
      case PermissionStatus.restricted:
        return PermissionAllowStatus.restricted;
      case PermissionStatus.limited:
        return PermissionAllowStatus.limited;
      case PermissionStatus.permanentlyDenied:
        return PermissionAllowStatus.denied;
      case PermissionStatus.provisional:
        return PermissionAllowStatus.denied;
    }
  }
}
