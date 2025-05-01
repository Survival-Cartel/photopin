import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/base_icon.dart';

class MainIconCard extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData iconData;
  final Color iconColor;
  const MainIconCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.iconData,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BaseIcon(iconColor: iconColor, iconData: iconData, size: 24),
            Text(title, style: AppFonts.smallTextRegular),
          ],
        ),
      ),
    );
  }
}
