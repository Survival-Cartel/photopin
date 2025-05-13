

sealed class SettingsAction {
  factory SettingsAction.cameraPermissionRequest() = CameraPermissionRequest;

  factory SettingsAction.photoPermissionRequest() = PhotoPermissionRequest;

  factory SettingsAction.locationPermissionRequest() =
      LocationPermissionRequest;
}

class CameraPermissionRequest implements SettingsAction {}

class PhotoPermissionRequest implements SettingsAction {}

class LocationPermissionRequest implements SettingsAction {}
