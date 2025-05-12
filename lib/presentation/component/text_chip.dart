import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class TextChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const TextChip({
    super.key,
    required this.text,
    this.color = AppColors.marker100,
    this.textColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: AppFonts.smallerTextRegular.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
