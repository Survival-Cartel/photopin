import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/base_icon.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';
import 'package:photopin/presentation/component/text_limit_input_field.dart';
import 'package:photopin/presentation/component/edit_bottom_sheet.dart';

class JournalEditBottomSheet extends EditBottomSheet<JournalModel> {
  const JournalEditBottomSheet({
    super.key,
    required super.item,
    required super.onTapClose,
    required super.onTapApply,
    required super.onTapCancel,
    super.thumbnailUrl,
  });

  @override
  State<JournalEditBottomSheet> createState() => _JournalEditBottomSheetState();
}

class _JournalEditBottomSheetState extends State<JournalEditBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setController(title: widget.item.name, comment: widget.item.comment);
  }

  @override
  void dispose() {
    titleController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void setController({String title = '', String comment = ''}) {
    titleController.value = TextEditingValue(text: title);
    commentController.value = TextEditingValue(text: comment);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppColors.white,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextLimitInputField(
                      controller: titleController,
                      hintText: 'Write Title',
                      maxLength: 30,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onTapClose();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.gray2,
                    ),
                  ),
                ],
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.thumbnailUrl ??
                            'https://web.cau.ac.kr/_images/_board/skin/album/1//no_image.gif',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                spacing: 8,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final DateTimeRange? range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(1999),
                        lastDate: DateTime(2100, 12, 31),
                        initialDateRange: DateTimeRange(
                          start: widget.item.startDate,
                          end: widget.item.endDate,
                        ),
                        saveText: '저장',
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

                      if (range != null) {
                        final updatedJournal = widget.item.copyWith(
                          startDateMilli: range.start.millisecondsSinceEpoch,
                          endDateMilli: range.end.millisecondsSinceEpoch,
                        );

                        widget.onTapApply(updatedJournal);
                      }
                    },
                    child: Row(
                      spacing: 12,
                      children: [
                        const BaseIcon(
                          iconColor: AppColors.primary80,
                          size: 16,
                          iconData: Icons.calendar_month,
                        ),
                        Text(
                          widget.item.startDate.formatDateRange(
                            widget.item.endDate,
                          ),
                          style: AppFonts.smallTextRegular,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      const BaseIcon(
                        iconColor: AppColors.secondary100,
                        size: 16,
                        iconData: Icons.comment,
                      ),
                      Expanded(
                        child: TextLimitInputField(
                          controller: commentController,
                          hintText: 'Write Comment',
                          maxLength: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: BaseIconButton(
                      buttonType: ButtonType.small,
                      buttonColor: AppColors.primary100,
                      iconName: Icons.edit,
                      buttonName: 'Apply',
                      onClick: () {
                        widget.onTapApply(
                          widget.item.copyWith(
                            name: titleController.text,
                            comment: commentController.text,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BaseIconButton(
                      buttonType: ButtonType.small,
                      buttonColor: AppColors.warning,
                      iconName: Icons.cancel,
                      buttonName: 'Cancel',
                      onClick: widget.onTapCancel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }
}
