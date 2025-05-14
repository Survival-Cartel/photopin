import 'package:geolocator/geolocator.dart';
import 'package:photopin/core/domain/location.dart';
import 'package:photopin/presentation/screen/camera/services/location_service.dart';

class GeolocatorLocationService implements LocationService {
  @override
  Future<Location?> currentPosition() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();

    if (isEnabled) {
      Position position = await Geolocator.getCurrentPosition();
      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } else {
      await Geolocator.openLocationSettings();
      return null;
    }
  }
}
