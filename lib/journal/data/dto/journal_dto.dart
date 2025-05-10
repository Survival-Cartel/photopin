class JournalDto {
  final String? id;
  final String? name;
  final int? startDateMilli;
  final int? endDateMilli;
  final List<String>? tripWith;
  final String? comment;

  DateTime get startDate =>
      DateTime.fromMillisecondsSinceEpoch(startDateMilli ?? 0);

  DateTime get endDate =>
      DateTime.fromMillisecondsSinceEpoch(endDateMilli ?? 0);

  const JournalDto({
    this.id,
    this.name,
    this.tripWith,
    this.startDateMilli,
    this.endDateMilli,
    this.comment,
  });

  factory JournalDto.fromJson(Map<String, dynamic> json) => JournalDto(
    id: json['id'],
    name: json['name'],
    tripWith: json['tripWith'],
    startDateMilli: json['startDate'],
    endDateMilli: json['endDate'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tripWith': tripWith,
    'startDate': startDateMilli,
    'endDate': endDateMilli,
    'comment': comment,
  };
}
