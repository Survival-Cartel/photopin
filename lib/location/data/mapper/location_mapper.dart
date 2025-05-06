import 'package:photopin/location/data/dto/location_dto.dart';
import 'package:photopin/location/domain/model/location_model.dart';

extension LocationMapper on LocationDto {
  LocationModel toModel() {
    return LocationModel(latitude: latitude ?? 0, longitude: longitude ?? 0);
  }
}
