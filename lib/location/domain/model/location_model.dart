class LocationModel {
  final double latitude;
  final double longitude;

  const LocationModel({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
