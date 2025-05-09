import 'package:flutter/cupertino.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/journal_card_image.dart';

class JournalCard extends StatelessWidget {
  final JournalModel journal;
  final Function(String journalId) onTap;
  final String imageUrl;
  final int photoCount;

  const JournalCard({
    super.key,
    required this.onTap,
    required this.journal,
    required this.imageUrl,
    required this.photoCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(journal.id),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          SizedBox(
            height: 144,
            child: JournalCardImage(
              imageUrl: imageUrl,
              journeyTitle: journal.name,
              description: journal.comment,
              bottomRadius: false,
            ),
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _IconText(
                  iconData: CupertinoIcons.calendar_today,
                  title: journal.startDate.formatDateRange(journal.endDate),
                ),
                const Spacer(),
                _IconText(
                  iconData: CupertinoIcons.photo,
                  count: photoCount,
                  title: ' photos',
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
  final int? count;
  final String title;

  const _IconText({required this.iconData, this.count, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: AppColors.gray3),
        const SizedBox(width: 8),
        count != null
            ? Text(
              '$count',
              style: AppFonts.smallTextRegular.copyWith(color: AppColors.gray3),
            )
            : const SizedBox(),
        Text(
          title,
          style: AppFonts.smallTextRegular.copyWith(color: AppColors.gray3),
        ),
      ],
    );
  }
}
