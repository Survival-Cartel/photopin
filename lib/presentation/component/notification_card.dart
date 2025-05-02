import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/base_icon.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final DateTime dateTime;
  final String badgeTitle;
  final IconData iconData;
  final VoidCallback onTapDetail;
  final bool isRead;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.dateTime,
    required this.badgeTitle,
    required this.onTapDetail,
    this.iconData = Icons.visibility,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: 118,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseIcon(
            iconColor: AppColors.primary100,
            iconData: iconData,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppFonts.smallTextBold.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      dateTime.timeAgoFromNow(),
                      style: AppFonts.smallerTextRegular.copyWith(
                        color: AppColors.gray2,
                      ),
                    ),
                  ],
                ),
                Text(
                  message,
                  style: AppFonts.smallerTextRegular.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NotificationBadge(title: badgeTitle),
                    GestureDetector(
                      onTap: onTapDetail,
                      child: Text(
                        'View Details',
                        style: AppFonts.smallTextRegular.copyWith(
                          color: AppColors.primary100,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              const SizedBox(height: 5.85),
              Container(
                key: Key('read_checker'),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: isRead ? AppColors.white : AppColors.primary100,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final String title;

  const _NotificationBadge({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.gray5,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          Icon(Icons.link, size: 18, color: AppColors.gray1),
          Text(
            title,
            style: AppFonts.smallerTextRegular.copyWith(color: AppColors.gray1),
          ),
        ],
      ),
    );
  }
}
