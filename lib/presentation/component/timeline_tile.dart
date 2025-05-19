import 'package:flutter/material.dart';
import 'package:photopin/core/enums/timeline_divide.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class TimeLineTile extends StatelessWidget {
  final DateTime dateTime;
  final String title;
  final String imageUrl;
  final String photoId;
  final void Function(String photoId) onTap;

  const TimeLineTile({
    super.key,
    required this.dateTime,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(photoId);
      },
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Row(
          children: [
            switch (dateTime.formQuaterDivide()) {
              TimelineDivide.morning => const Icon(
                Icons.wb_twilight,
                color: AppColors.marker90,
              ),
              TimelineDivide.day => const Icon(
                Icons.light_mode,
                color: AppColors.marker50,
              ),
              TimelineDivide.night => const Icon(
                Icons.nightlight_round,
                color: AppColors.marker40,
              ),
              TimelineDivide.dawn => const Icon(
                Icons.nights_stay,
                color: AppColors.marker80,
              ),
              TimelineDivide.unknown => const Icon(
                Icons.help_outline,
                color: AppColors.secondary80,
              ),
            },
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppFonts.smallTextRegular),
                  Text(
                    dateTime.formOnlyTime(),
                    style: AppFonts.smallerTextRegular.copyWith(
                      color: AppColors.gray3,
                    ),
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
