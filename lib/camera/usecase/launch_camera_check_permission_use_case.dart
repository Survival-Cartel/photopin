import 'package:photopin/core/enums/permission_allow_status.dart';
import 'package:photopin/core/enums/permission_type.dart';
import 'package:photopin/core/usecase/permission_check_use_case.dart';

class LaunchCameraCheckPermissionUseCase {
  final PermissionCheckUseCase _permissionCheckUseCase;

  const LaunchCameraCheckPermissionUseCase({
    required PermissionCheckUseCase permissionCheckUseCase,
  }) : _permissionCheckUseCase = permissionCheckUseCase;

  Future<bool> execute() async {
    PermissionAllowStatus cameraStatus = await _permissionCheckUseCase.execute(
      PermissionType.camera,
    );

    if (cameraStatus != PermissionAllowStatus.allow) return false;

    PermissionAllowStatus photosStatus = await _permissionCheckUseCase.execute(
      PermissionType.photos,
    );

    if (photosStatus != PermissionAllowStatus.allow) return false;

    PermissionAllowStatus locationStatus = await _permissionCheckUseCase
        .execute(PermissionType.location);

    if (locationStatus != PermissionAllowStatus.allow) return false;

    return true;
  }
}
