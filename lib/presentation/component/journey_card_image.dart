import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class JourneyCardImage extends StatelessWidget {
  final String imageUrl;
  final String journeyTitle;
  final String description;

  const JourneyCardImage({
    super.key,
    required this.imageUrl,
    required this.journeyTitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 192,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 64,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.black.withValues(alpha: 0.7),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Column(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                journeyTitle,
                style: AppFonts.normalTextBold.copyWith(color: AppColors.white),
              ),
              Text(
                description,
                style: AppFonts.smallerTextRegular.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
