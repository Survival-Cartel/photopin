import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/base_icon.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import '../../core/styles/app_font.dart';

class RecentActivityTile extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final VoidCallback onTap;

  const RecentActivityTile({
    super.key,
    required this.title,
    required this.dateTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary40,
                shape: BoxShape.circle,
              ),
              child: BaseIcon(
                iconColor: AppColors.primary100,
                iconData: Icons.link,
                size: 18,
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Link shared: $title',
                    style: AppFonts.smallTextBold.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    dateTime.timeAgoFromNow(),
                    style: AppFonts.smallerTextRegular.copyWith(
                      color: AppColors.gray2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
