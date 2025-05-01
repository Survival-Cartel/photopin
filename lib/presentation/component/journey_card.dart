import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/journey_card_image.dart';

class JourneyCard extends StatelessWidget {
  final String imageUrl;
  final String journeyTitle;
  final DateTime startDate;
  final DateTime endDate;
  final int photoCount;
  final int markerCount;
  final VoidCallback onTap;

  const JourneyCard({
    super.key,
    required this.imageUrl,
    required this.journeyTitle,
    required this.photoCount,
    required this.markerCount,
    required this.startDate,
    required this.endDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          SizedBox(
            height: 144,
            child: JourneyCardImage(
              imageUrl: imageUrl,
              journeyTitle: journeyTitle,
              description: startDate.formatDateRange(endDate),
              bottomRadius: false,
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _IconText(
                  iconData: CupertinoIcons.photo,
                  count: photoCount,
                  title: 'photos',
                ),
                const Spacer(),
                _IconText(
                  iconData: CupertinoIcons.map_pin_ellipse,
                  count: markerCount,
                  title: 'locations',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData iconData;
  final int count;
  final String title;

  const _IconText({
    required this.iconData,
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(iconData, color: AppColors.gray3),
        Text(
          '$count',
          style: AppFonts.smallTextRegular.copyWith(color: AppColors.gray3),
        ),
        Text(
          title,
          style: AppFonts.smallTextRegular.copyWith(color: AppColors.gray3),
        ),
      ],
    );
  }
}
