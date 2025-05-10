import 'package:cloud_firestore/cloud_firestore.dart';

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
    tripWith:
        (json['tripWith'] as List<dynamic>)
            .map((data) => data.toString())
            .toList(),
    startDateMilli: (json['startDate'] as Timestamp).millisecondsSinceEpoch,
    endDateMilli: (json['endDate'] as Timestamp).millisecondsSinceEpoch,
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
