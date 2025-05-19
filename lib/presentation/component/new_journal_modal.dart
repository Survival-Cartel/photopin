import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';
import 'package:photopin/presentation/component/photopin_head.dart';
import 'package:photopin/presentation/component/text_limit_input_field.dart';
import 'package:photopin/presentation/component/trip_with_chips.dart';

class NewJournalModal extends StatefulWidget {
  final String userName;
  final void Function({required JournalModel journal}) onSave;

  const NewJournalModal({
    super.key,
    required this.userName,
    required this.onSave,
  });

  @override
  State<NewJournalModal> createState() => _NewJournalModalState();
}

class _NewJournalModalState extends State<NewJournalModal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController tripWithController = TextEditingController();
  String dateRange = '여행 기간';
  DateTime? startDate;
  DateTime? endDate;
  List<String> tripWith = [];

  @override
  void dispose() {
    titleController.dispose();
    commentController.dispose();
    tripWithController.dispose();
    super.dispose();
  }

  Future<void> selectAndSaveDateRange(BuildContext context) async {
    final DateTimeRange? selectedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1999),
      lastDate: DateTime(2100, 12, 31),
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
              maxHeight: 600.0,
            ),
            child: child,
          ),
        );
      },
    );
    if (selectedDateRange != null) {
      setState(() {
        startDate = selectedDateRange.start;
        endDate = selectedDateRange.end;
        dateRange = selectedDateRange.start.formatDateRange(
          selectedDateRange.end,
        );
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      content: SizedBox(
        height: 360,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            const Center(child: PhotopinHead()),
            Center(
              child: Text(
                '* 이 들어간 입력은 필수 입니다.',
                style: AppFonts.smallerTextRegular,
              ),
            ),
            TextLimitInputField(
              controller: titleController,
              hintText: '* 여행 제목',
            ),
            TextLimitInputField(
              controller: commentController,
              hintText: '* 여행 설명',
            ),
            TextLimitInputField(
              controller: tripWithController,
              hintText: '여행한 친구 "," 로 구분하여 입력해주세요.',
              onChange: (value) {
                setState(() {
                  if (value.isEmpty) {
                    tripWith.clear();
                  } else {
                    tripWith =
                        value
                            .split(',')
                            .map((item) => item.trim())
                            .where((item) => item.isNotEmpty)
                            .toList();
                  }
                });
              },
            ),
            (tripWith.isNotEmpty)
                ? TripWithChips(tripWith: tripWith)
                : const SizedBox(),
            Center(
              child: BaseIconButton(
                buttonType: ButtonType.medium,
                buttonName: dateRange,
                iconName: CupertinoIcons.calendar_today,
                onClick: () async {
                  await selectAndSaveDateRange(context);
                },
                buttonColor: AppColors.secondary100,
              ),
            ),
            Center(
              child: BaseIconButton(
                buttonType: ButtonType.medium,
                buttonName: '저장하기',
                iconName: Icons.save,
                onClick: () {
                  final String title = titleController.text;
                  final String comment = commentController.text;

                  final JournalModel journal = JournalModel(
                    id: '',
                    name: title,
                    tripWith: tripWith,
                    startDateMilli: startDate?.millisecondsSinceEpoch ?? 0,
                    endDateMilli: endDate?.millisecondsSinceEpoch ?? 0,
                    comment: comment,
                  );

                  widget.onSave(journal: journal);
                },
                buttonColor: AppColors.primary80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
