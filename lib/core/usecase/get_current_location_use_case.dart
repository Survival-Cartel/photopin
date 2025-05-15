import 'package:photopin/core/domain/location.dart';
import 'package:photopin/core/service/location_service.dart';

class GetCurrentLocationUseCase {
  final LocationService _geoService;

  const GetCurrentLocationUseCase({required LocationService geoService})
    : _geoService = geoService;

  Future<Location?> execute() async {
    return await _geoService.currentPosition();
  }
}
