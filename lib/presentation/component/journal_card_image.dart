import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class JournalCardImage extends StatelessWidget {
  final String imageUrl;
  final String journeyTitle;
  final String description;
  final bool bottomRadius;

  const JournalCardImage({
    super.key,
    required this.imageUrl,
    required this.journeyTitle,
    required this.description,
    this.bottomRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 192,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: bottomRadius ? const Radius.circular(12) : Radius.zero,
            ),
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
            borderRadius: BorderRadius.vertical(
              bottom: bottomRadius ? const Radius.circular(12) : Radius.zero,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                journeyTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.normalTextBold.copyWith(color: AppColors.white),
              ),
              Text(
                description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
