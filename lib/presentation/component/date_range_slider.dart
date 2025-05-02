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

  DateTime? _lastStartDay;
  DateTime? _lastEndDay;

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

  DateTime _toDate(double offset) =>
      widget.startDate.add(Duration(days: offset.toInt()));

  String _formatTop(DateTime s, DateTime e) {
    return '${_monthName(s.month)} ${s.day} - ${_monthName(e.month)} ${e.day}, ${e.year}';
  }

  @override
  Widget build(BuildContext context) {
    final totalDays =
        widget.endDate.difference(widget.startDate).inDays.toDouble();

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
            min: widget.startDate,
            max: widget.endDate,
            values: SfRangeValues(selStart, selEnd),
            interval: 1,
            //눈금
            activeColor: AppColors.primary100,
            dateIntervalType: DateIntervalType.days,
            onChanged: (SfRangeValues values) {
              final fullStart = values.start as DateTime;
              final fullEnd   = values.end   as DateTime;

              final dayStart = DateTime(fullStart.year, fullStart.month, fullStart.day);
              final dayEnd   = DateTime(fullEnd.year,   fullEnd.month,   fullEnd.day);

              setState(() {
                _startOffset = dayStart.difference(widget.startDate).inDays.toDouble();
                _endOffset   = dayEnd.difference(widget.startDate).inDays.toDouble();
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
