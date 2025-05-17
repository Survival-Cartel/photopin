import 'package:flutter/material.dart';

extension DateTimeRangeExtension on DateTimeRange {
  /// [DateTimeRange] 객체의 [start]를 00시 00분 00초 ~ [end]를 23시 59분 59초로 변경합니다.
  DateTimeRange toDayRange() {
    final DateTime startOfDay = DateTime(
      start.year,
      start.month,
      start.day,
      0,
      0,
      0,
    );

    final DateTime endOfDay = DateTime(
      end.year,
      end.month,
      end.day,
      23,
      59,
      59,
    );

    return DateTimeRange(start: startOfDay, end: endOfDay);
  }
}
