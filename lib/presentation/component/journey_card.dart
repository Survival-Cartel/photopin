import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

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
          _ImageCard(
            imageUrl: imageUrl,
            journeyTitle: journeyTitle,
            startDate: startDate,
            endDate: endDate,
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

class _ImageCard extends StatelessWidget {
  const _ImageCard({
    required this.imageUrl,
    required this.journeyTitle,
    required this.startDate,
    required this.endDate,
  });

  final String imageUrl;
  final String journeyTitle;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          height: 144,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
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
                startDate.formatDateRange(endDate),
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
