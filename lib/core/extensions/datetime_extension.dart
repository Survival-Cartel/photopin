extension DatetimeExtension on DateTime {
  String _monthName(int m) {
    const full = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return full[m - 1];
  }

  String _monthAbbr(int m) {
    const a = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return a[m - 1];
  }

  /// 인자로 들어오는 값은 해당 값보다 이후의 날이어야합니다.
  String formatDateRange(DateTime after) {
    // after가 현재 날짜보다 이전이면 예외 발생
    if (after.isBefore(this)) {
      throw ArgumentError('인자로 들어오는 값은 해당 값보다 이후의 날이어야합니다.');
    }

    // 이제 formatDateRange 로직 구현
    if (month != after.month) {
      // 다른 달인 경우의 처리
      return '${_monthName(month)} $day - ${_monthName(after.month)} ${after.day}, $year';
    } else {
      // 같은 달인 경우의 처리
      return '${_monthName(month)} $day-${after.day}, $year';
    }
  }

  String formDateString() {
    return '${_monthAbbr(month)} $day';
  }

  String formMeridiem() {
    return hour >= 12 ? 'PM' : 'AM';
  }
}
