import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class CustomMapMarker extends StatelessWidget {
  final String imageUrl;
  final Color outlineColor;
  final String tooltip;

  const CustomMapMarker({
    super.key,
    required this.imageUrl,
    this.outlineColor = AppColors.secondary100,
    this.tooltip = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
          child: Container(
            padding:
                tooltip != ''
                    ? const EdgeInsets.symmetric(horizontal: 4)
                    : null,
            decoration: BoxDecoration(
              color: AppColors.marker50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(tooltip, style: AppFonts.smallerTextRegular),
          ),
        ),
        CircleAvatar(
          maxRadius: 20,
          backgroundColor: outlineColor,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
