class JournalModel {
  final String id;
  final String name;
  final List<String> tripWith;
  final int startDateMilli;
  final int endDateMilli;
  final String comment;

  DateTime get startDate => DateTime.fromMillisecondsSinceEpoch(startDateMilli);
  DateTime get endDate => DateTime.fromMillisecondsSinceEpoch(endDateMilli);

  const JournalModel({
    required this.id,
    required this.name,
    required this.tripWith,
    required this.startDateMilli,
    required this.endDateMilli,
    required this.comment,
  });

  @override
  String toString() {
    return 'JournalModel(id: $id, name: $name, tripWith: $tripWith, startDate: $startDate, endDate: $endDate, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalModel &&
        other.id == id &&
        other.name == name &&
        other.tripWith == tripWith &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.comment == comment &&
        other.startDateMilli == startDateMilli &&
        other.endDateMilli == endDateMilli;
  }

  @override
  int get hashCode => id.hashCode;

  JournalModel copyWith({
    String? id,
    String? name,
    List<String>? tripWith,
    int? startDateMilli,
    int? endDateMilli,
    String? comment,
  }) {
    return JournalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tripWith: tripWith ?? this.tripWith,
      startDateMilli: startDateMilli ?? this.startDateMilli,
      endDateMilli: endDateMilli ?? this.endDateMilli,
      comment: comment ?? this.comment,
    );
  }
}
