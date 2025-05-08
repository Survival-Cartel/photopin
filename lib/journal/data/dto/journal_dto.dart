class JournalDto {
  final String? id;
  final String? name;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? tripWith;
  final String? comment;

  const JournalDto({
    this.id,
    this.name,
    this.tripWith,
    this.startDate,
    this.endDate,
    this.comment,
  });

  factory JournalDto.fromJson(Map<String, dynamic> json) => JournalDto(
    id: json['id'],
    name: json['name'],
    tripWith: json['tripWith'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tripWith': tripWith,
    'startDate': startDate,
    'endDate': endDate,
    'comment': comment,
  };
}
