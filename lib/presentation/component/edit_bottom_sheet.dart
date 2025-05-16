import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/base_icon.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';
import 'package:photopin/presentation/component/text_limit_input_field.dart';

class EditBottomSheet extends StatefulWidget {
  final String? imageUrl;
  final DateTime dateTime;
  final String title;
  final String comment;
  final String journalId;
  final bool showJournalDropdown;
  final List<JournalModel> journals;

  final VoidCallback onTapClose;
  final Function(String title, String journalId, String comment) onTapApply;
  final VoidCallback onTapDelete;
  final VoidCallback? onClosing;

  const EditBottomSheet({
    super.key,
    this.imageUrl,
    required this.dateTime,
    required this.title,
    required this.comment,
    required this.onTapClose,
    required this.onTapApply,
    required this.onTapDelete,
    required this.journals,
    this.onClosing,
    this.showJournalDropdown = true,
    this.journalId = '',
  });

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController journalController = TextEditingController();
  String _journalId = '';

  String _formattedDateTime() => widget.dateTime.formatDateTimeString();

  @override
  void initState() {
    super.initState();
    titleController.value = TextEditingValue(text: widget.title);
    commentController.value = TextEditingValue(text: widget.comment);
  }

  @override
  void dispose() {
    widget.onClosing?.call();
    titleController.dispose();
    commentController.dispose();
    journalController.dispose();
    super.dispose();
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
                // TODO: 현재는 고정으로 16:9 비율, 추후 카메라 기능 들어오면 수정
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.imageUrl ??
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
                  Row(
                    spacing: 12,
                    children: [
                      const BaseIcon(
                        iconColor: AppColors.primary80,
                        size: 16,
                        iconData: Icons.calendar_month,
                      ),
                      Text(
                        _formattedDateTime(),
                        style: AppFonts.smallTextRegular,
                      ),
                    ],
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
                  widget.showJournalDropdown
                      ? Row(
                        children: [
                          const BaseIcon(
                            iconColor: AppColors.primary80,
                            size: 16,
                            iconData: Icons.note,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownMenu<String>(
                              controller: journalController,
                              inputDecorationTheme: const InputDecorationTheme(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              initialSelection:
                                  widget.journals.isNotEmpty
                                      ? widget.journalId
                                      : null,
                              menuStyle: MenuStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  AppColors.white,
                                ),
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                                elevation: WidgetStateProperty.all(2),
                              ),
                              onSelected: (value) {
                                _journalId = value!;
                              },
                              textStyle: AppFonts.smallTextRegular,
                              dropdownMenuEntries:
                                  widget.journals.isEmpty
                                      ? []
                                      : List.generate(widget.journals.length, (
                                        int index,
                                      ) {
                                        return DropdownMenuEntry(
                                          label: widget.journals[index].name,
                                          value: widget.journals[index].id,
                                        );
                                      }),
                            ),
                          ),
                        ],
                      )
                      : const SizedBox(),
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
                          titleController.text,
                          _journalId,
                          commentController.text,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BaseIconButton(
                      buttonType: ButtonType.small,
                      buttonColor: AppColors.warning,
                      iconName: Icons.delete,
                      buttonName: 'Delete',
                      onClick: widget.onTapDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      onClosing: widget.onClosing ?? () {},
    );
  }
}
