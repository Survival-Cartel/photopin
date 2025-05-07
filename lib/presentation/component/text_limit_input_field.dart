import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class TextLimitInputField extends StatefulWidget {
  final String value;
  final String hintText;
  final int maxLength;
  final TextEditingController controller;

  const TextLimitInputField({
    super.key,
    required this.value,
    required this.controller,
    this.maxLength = 0,
    this.hintText = '',
  });

  @override
  State<TextLimitInputField> createState() => _TextLimitInputFieldState();
}

class _TextLimitInputFieldState extends State<TextLimitInputField> {
  late final TextEditingController _controller;

  @override
  initState() {
    super.initState();
    _controller = widget.controller;
    _controller.value = TextEditingValue(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (String a) {
        setState(() {});
      },
      style: AppFonts.smallTextRegular,
      controller: _controller,
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
