import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class PhotopinHead extends StatelessWidget {
  const PhotopinHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Photopin',
      style: AppFonts.mediumTextBold.copyWith(color: AppColors.primary100),
    );
  }
}
