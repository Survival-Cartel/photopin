class LocationDto {
  final double? latitude;
  final double? longitude;

  const LocationDto({this.latitude, this.longitude});

  factory LocationDto.fromJson(Map<String, dynamic> json) =>
      LocationDto(latitude: json['latitude'], longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };
}
