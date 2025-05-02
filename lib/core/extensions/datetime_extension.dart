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

  /// DateTime 인스턴스를 현재 시간과 비교하여 다음과 같은 형식의 문자열로 반환합니다.
  /// - 'just now' : 현재 시간과 1분 이내의 차이
  /// - 'X minutes ago' : 현재 시간과 1시간 이내의 차이
  /// - 'X hours ago' : 현재 시간과 1일 이내의 차이
  /// - 'X days ago' : 현재 시간과 1달 이내의 차이
  /// - 'X months ago' : 현재 시간과 1년 이내의 차이
  /// - 'X years ago' : 현재 시간과 1년 이상의 차이
  String timeAgoFromNow() {
    final now = DateTime.now();

    if (isAfter(now)) {
      throw ArgumentError('미래 시간은 허용되지 않습니다.');
    }

    final Duration diff = now.difference(this);

    final int days = diff.inDays;
    final int hours = diff.inHours;
    final int minutes = diff.inMinutes;

    if (days >= 365) return '${days ~/ 365} years ago';
    if (days >= 30) return '${days ~/ 30} months ago';
    if (days >= 7) return '${days ~/ 7} weeks ago';
    if (days >= 1) return '$days days ago';
    if (hours >= 1) return '$hours hours ago';
    if (minutes >= 1) return '$minutes minutes ago';

    return 'just now';
  }
}
