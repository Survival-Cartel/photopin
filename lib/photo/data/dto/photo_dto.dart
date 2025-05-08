class PhotoDto {
  final String? id;
  final String? name;
  final DateTime? dateTime;
  final String? journalId;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final String? comment;

  const PhotoDto({
    this.id,
    this.name,
    this.dateTime,
    this.journalId,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.comment,
  });

  factory PhotoDto.fromJson(Map<String, dynamic> json) => PhotoDto(
    id: json['id'],
    name: json['name'],
    dateTime: json['dateTime'],
    journalId: json['journalId'],
    imageUrl: json['imageUrl'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dateTime': dateTime,
    'journalId': journalId,
    'imageUrl': imageUrl,
    'latitude': latitude,
    'longitude': longitude,
    'comment': comment,
  };
}
