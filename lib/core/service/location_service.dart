import 'package:photopin/core/domain/location.dart';

abstract interface class LocationService {
  Future<Location?> currentPosition();
}
