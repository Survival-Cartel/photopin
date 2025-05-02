import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class CompareCard extends StatelessWidget {
  final String profileImageUrl;
  final String nameString;
  final DateTime dateTime;
  final String timeMessage;
  final String photoMessage;
  final String location;
  final Color color;

  const CompareCard({
    super.key,
    required this.profileImageUrl,
    required this.nameString,
    required this.dateTime,
    required this.timeMessage,
    required this.photoMessage,
    required this.location,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                CircleAvatar(
                  maxRadius: 16,
                  backgroundImage: NetworkImage(profileImageUrl),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameString,
                        style: AppFonts.mediumTextBold,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        dateTime.formatDateTimeString(),
                        style: AppFonts.smallTextRegular.copyWith(
                          color: AppColors.gray2,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _IconText(
            color: color,
            timeMessage: timeMessage,
            iconData: CupertinoIcons.timer_fill,
          ),
          _IconText(
            color: color,
            timeMessage: photoMessage,
            iconData: CupertinoIcons.photo,
          ),
          _IconText(
            color: color,
            timeMessage: timeMessage,
            iconData: CupertinoIcons.map_pin_ellipse,
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({
    required this.color,
    required this.timeMessage,
    required this.iconData,
  });

  final Color color;
  final IconData iconData;
  final String timeMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(iconData, color: color, size: 12),
        Text(timeMessage, style: AppFonts.smallTextRegular),
      ],
    );
  }
}
