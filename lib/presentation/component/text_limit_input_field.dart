import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class TextLimitInputField extends StatefulWidget {
  final String hintText;
  final int maxLength;
  final TextEditingController controller;
  final void Function(String changeText)? onChange;

  const TextLimitInputField({
    super.key,
    required this.controller,
    this.maxLength = 0,
    this.hintText = '',
    this.onChange,
  });

  @override
  State<TextLimitInputField> createState() => _TextLimitInputFieldState();
}

class _TextLimitInputFieldState extends State<TextLimitInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String value) {
        // TextField 재빌드용 setState 호출
        setState(() {});
        widget.onChange?.call(value);
      },
      style: AppFonts.smallTextRegular,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        isDense: true,
        suffixText:
            widget.maxLength != 0
                ? '${widget.controller.text.length}/${widget.maxLength}'
                : '',
        suffixStyle: AppFonts.smallTextRegular.copyWith(
          fontSize: 12,
          color:
              widget.maxLength != 0 &&
                      widget.controller.text.length > widget.maxLength
                  ? AppColors.warning
                  : AppColors.black,
        ),
      ),
    );
  }
}
