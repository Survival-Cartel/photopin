import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/presentation/screen/camera/handler/permission_checker.dart';

class PermissionCheckerUseCase {
  final PermissionChecker _permissionChecker;

  const PermissionCheckerUseCase({required PermissionChecker permissionChecker})
    : _permissionChecker = permissionChecker;

  Future<void> execute(Permission permission) async {
    await _permissionChecker.check(permission);
  }
}
