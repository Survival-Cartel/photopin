import 'package:flutter/material.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_font.dart';

import '../../core/styles/app_color.dart';

class BaseIconButton extends StatelessWidget {
  final ButtonType buttonType;
  final IconData iconName;
  final String buttonName;
  final Color buttonColor;
  final VoidCallback onClick;

  const BaseIconButton({
    super.key,
    required this.buttonType,
    required this.iconName,
    required this.buttonName,
    required this.onClick,
    required this.buttonColor,
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
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconName, color: AppColors.white, size: 16),
            SizedBox(width: 8),
            Text(
              buttonName,
              style: AppFonts.mediumTextRegular.copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
