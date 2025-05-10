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

  DateTime _toDate(double offset) => DateTime(
    widget.startDate.year,
    widget.startDate.month,
    widget.startDate.day,
  ).add(Duration(days: offset.toInt()));

  String _formatTop(DateTime s, DateTime e) {
    return '${_monthName(s.month)} ${s.day} - ${_monthName(e.month)} ${e.day}, ${e.year}';
  }

  @override
  Widget build(BuildContext context) {
    // 전체 날짜 범위 계산
    final totalDays =
        widget.endDate.difference(widget.startDate).inDays.toDouble();

    // 초기값 설정
    _startOffset ??= 0.0;
    _endOffset ??= totalDays;

    final selStart = _toDate(_startOffset!);
    final selEnd = _toDate(_endOffset!);

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
                  _formatTop(selStart, selEnd),
                  style: AppFonts.smallerTextRegular.copyWith(
                    color: AppColors.primary80,
                  ),
                ),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0.0,
            max: totalDays,
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

              // 새 날짜 계산
              final dayStart = _toDate(newStartOffset);
              final dayEnd = _toDate(newEndOffset);

              setState(() {
                _startOffset = newStartOffset;
                _endOffset = newEndOffset;
              });

              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () {
                widget.onChanged(dayStart, dayEnd);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
