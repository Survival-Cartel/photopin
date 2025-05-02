import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class BaseButton extends StatelessWidget {
  final ButtonType buttonType;
  final String buttonName;
  final VoidCallback onClick;

  const BaseButton({
    super.key,
    required this.buttonName,
    required this.onClick,
    required this.buttonType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Container(
        width: buttonType.width,
        height: buttonType.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary100,
        ),
        child: Center(
          child: Text(
            buttonName,
            style: AppFonts.normalTextBold.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }
}
