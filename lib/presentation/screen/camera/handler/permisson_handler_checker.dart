import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/presentation/screen/camera/handler/permission_checker.dart';

class PermissionHandlerChecker implements PermissionChecker<Permission> {
  @override
  Future<void> check(Permission permission) async {
    final PermissionStatus status = await permission.request();

    switch (status) {
      case PermissionStatus.denied:
        debugPrint('PermissionStatus : denied');
      case PermissionStatus.granted:
        debugPrint('PermissionStatus : granted');
      case PermissionStatus.restricted:
        debugPrint('PermissionStatus : restricted');
      case PermissionStatus.limited:
        debugPrint('PermissionStatus : limited');
      case PermissionStatus.permanentlyDenied:
        debugPrint('PermissionStatus : permanentlyDenied');
      case PermissionStatus.provisional:
        debugPrint('PermissionStatus : provisional');
    }
  }
}
