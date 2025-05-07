import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/base_icon.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';
import 'package:photopin/presentation/component/text_limit_input_field.dart';

class EditBottomSheet extends StatefulWidget {
  final String imageUrl;
  final DateTime dateTime;
  final String comment;
  final List<String> journalNames;

  final VoidCallback onTapClose;
  final Function(String journalName, String comment) onTapApply;
  final VoidCallback onTapCancel;
  final VoidCallback? onClosing;

  const EditBottomSheet({
    super.key,
    required this.imageUrl,
    required this.dateTime,
    required this.comment,
    required this.onTapClose,
    required this.onTapApply,
    required this.onTapCancel,
    required this.journalNames,
    this.onClosing,
  });

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController journalController = TextEditingController();

  String _formattedDateTime() => widget.dateTime.formatDateTimeString();

  @override
  void initState() {
    super.initState();
    commentController.value = TextEditingValue(text: widget.comment);
  }

  @override
  void dispose() {
    widget.onClosing?.call();
    commentController.dispose();
    journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            spacing: 16,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Edit',
                    style: AppFonts.mediumTextBold.copyWith(
                      color: AppColors.textColor,
                    ),
                  ),
                  const Spacer(),
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
                      image: NetworkImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                spacing: 12,
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
                  Row(
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
                          initialSelection: widget.journalNames[0],
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStateProperty.all(
                              AppColors.white,
                            ),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            elevation: WidgetStateProperty.all(2),
                          ),
                          textStyle: AppFonts.smallTextRegular,
                          dropdownMenuEntries: List.generate(
                            widget.journalNames.length,
                            (int index) {
                              return DropdownMenuEntry(
                                label: widget.journalNames[index],
                                value: widget.journalNames[index],
                              );
                            },
                          ),
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
                          journalController.text,
                          commentController.text,
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
