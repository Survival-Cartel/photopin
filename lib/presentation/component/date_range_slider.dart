import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DateRangeSlider extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime startDate, DateTime endDate) onChanged;

  const DateRangeSlider({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  @override
  State<DateRangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<DateRangeSlider> {
  double? _startOffset;
  double? _endOffset;

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  String _monthName(int m) {
    const full = [
      '',
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
    return full[m];
  }

  String _monthAbbr(int m) {
    const a = [
      '',
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
    return a[m];
  }

  DateTime _toStartDate(double offset) => DateTime(
    widget.startDate.year,
    widget.startDate.month,
    widget.startDate.day,
  ).add(Duration(days: offset.toInt()));

  DateTime _toEndDate(double offset) {
    final base = widget.startDate.add(Duration(days: offset.toInt()));

    return DateTime(base.year, base.month, base.day, 23, 59, 59, 999);
  }

  @override
  Widget build(BuildContext context) {
    final isDayTrip = widget.endDate.difference(widget.startDate).inDays == 0;

    // 전체 날짜 범위 계산
    final totalTimes =
        isDayTrip
            ? 23.0
            : widget.endDate.difference(widget.startDate).inDays.toDouble();

    // 초기값 설정
    _startOffset ??= 0.0;
    _endOffset ??= totalTimes;

    DateTime selStart, selEnd;
    if (isDayTrip) {
      selStart = widget.startDate.add(Duration(hours: _startOffset!.toInt()));
      selEnd = widget.startDate
          .add(Duration(hours: _endOffset!.toInt()))
          .add(const Duration(minutes: 59, seconds: 59, milliseconds: 999));
    } else {
      selStart = widget.startDate.add(Duration(days: _startOffset!.toInt()));
      selEnd = widget.startDate
          .add(Duration(days: _endOffset!.toInt()))
          .add(
            const Duration(
              hours: 23,
              minutes: 59,
              seconds: 59,
              milliseconds: 999,
            ),
          );
    }

    String formatTop(DateTime s, DateTime e) {
      if (isDayTrip) {
        return '${_monthName(s.month)}, ${s.day}, ${s.year}';
      } else {
        return '${_monthName(s.month)} ${s.day} - ${_monthName(e.month)} ${e.day}, ${e.year}';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date Range', style: AppFonts.smallerTextBold),
                Text(
                  formatTop(selStart, selEnd),
                  style: AppFonts.smallerTextRegular.copyWith(
                    color: AppColors.primary80,
                  ),
                ),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0.0,
            max: totalTimes,
            values: SfRangeValues(_startOffset!, _endOffset!),
            interval: 1,
            stepSize: 1.0,
            // 슬라이더가 정확히 1.0 단위로만 이동하도록 설정 (하루 단위)
            showLabels: false,
            showTicks: false,
            activeColor: AppColors.primary100,
            enableTooltip: false,
            onChanged: (SfRangeValues values) {
              // 값을 정수로 반올림하여 정확히 날짜 단위로만 이동하게 함
              final double newStartOffset = values.start.roundToDouble();
              final double newEndOffset = values.end.roundToDouble();

              // 시작과 끝이 같거나 역전된 경우 (최소 1의 차이 필요)
              if (newEndOffset - newStartOffset < 1.0) {
                return; // 변경 취소
              }

              setState(() {
                _startOffset = newStartOffset;
                _endOffset = newEndOffset;
              });

              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () {
                DateTime start, end;

                if (isDayTrip) {
                  final baseDate = DateTime(
                    widget.startDate.year,
                    widget.startDate.month,
                    widget.startDate.day,
                  );
                  start = baseDate.add(Duration(hours: newStartOffset.toInt()));
                  end = baseDate
                      .add(Duration(hours: newEndOffset.toInt() + 1))
                      .subtract(const Duration(milliseconds: 1));
                } else {
                  start = _toStartDate(newStartOffset);
                  end = _toEndDate(newEndOffset);
                }

                widget.onChanged(start, end);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  isDayTrip
                      ? [
                        Text(
                          '0:00',
                          style: AppFonts.smallerTextRegular.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '24:00',
                          style: AppFonts.smallerTextRegular.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ]
                      : [
                        Text(
                          '${_monthAbbr(widget.startDate.month)} ${widget.startDate.day}',
                          style: AppFonts.smallerTextRegular.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${_monthAbbr(widget.endDate.month)} ${widget.endDate.day}',
                          style: AppFonts.smallerTextRegular.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
            ),
          ),
        ],
      ),
    );
  }
}
