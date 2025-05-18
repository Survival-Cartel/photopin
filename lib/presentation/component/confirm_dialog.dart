import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  final VoidCallback onTapConfirm;
  final VoidCallback onTapCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onTapConfirm,
    required this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onTapConfirm,
          child: Text(
            confirmText,
            style: AppFonts.smallTextRegular.copyWith(
              color: AppColors.primary100,
            ),
          ),
        ),
        TextButton(
          onPressed: onTapCancel,
          child: Text(
            cancelText,
            style: AppFonts.smallTextRegular.copyWith(color: AppColors.warning),
          ),
        ),
      ],
    );
  }
}
