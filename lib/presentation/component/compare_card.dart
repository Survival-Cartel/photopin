import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/trip_with_chips.dart';

class CompareCard extends StatelessWidget {
  final String profileImageUrl;
  final String nameString;
  final JournalModel journal;
  final String photoString;
  final Color color;

  const CompareCard({
    super.key,
    required this.profileImageUrl,
    required this.nameString,
    required this.journal,
    required this.photoString,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
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
                        journal.startDate.formatDateRange(journal.endDate),
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
          Align(
            alignment: Alignment.centerLeft,
            child: TripWithChips(
              tripWith: journal.tripWith,
              color: color,
              maxLength: 3,
            ),
          ),
          _IconText(
            color: color,
            timeMessage: photoString,
            iconData: CupertinoIcons.photo,
          ),
          _IconText(
            color: color,
            timeMessage: journal.name,
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
        Icon(iconData, color: color, size: 20),
        Text(
          timeMessage,
          style: AppFonts.smallTextRegular,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
