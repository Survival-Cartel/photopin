import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/journal_card_image.dart';

// [showEditButton]과 [onTapEdit]은 함께 되어야 합니다.
class JournalCard extends StatelessWidget {
  final JournalModel journal;
  final Function(String journalId) onTap;
  final Function(String journalId)? onTapEdit;
  final String? imageUrl;
  final int photoCount;
  final bool showEditButton;

  const JournalCard({
    super.key,
    required this.onTap,
    required this.journal,
    required this.imageUrl,
    required this.photoCount,
    this.showEditButton = false,
    this.onTapEdit = null,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 144,
          child: Stack(
            children: [
              Positioned(
                child: GestureDetector(
                  onTap: () => onTap(journal.id),
                  behavior: HitTestBehavior.opaque,
                  child: JournalCardImage(
                    imageUrl:
                        imageUrl ??
                        'https://web.cau.ac.kr/_images/_board/skin/album/1//no_image.gif',
                    journeyTitle: journal.name,
                    description: journal.comment,
                    bottomRadius: false,
                  ),
                ),
              ),
              showEditButton
                  ? Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () => onTapEdit?.call(journal.id),
                      behavior: HitTestBehavior.opaque,
                      child: CircleAvatar(
                        maxRadius: 18,
                        backgroundColor: AppColors.black.withValues(alpha: 0.4),
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primary60,
                          size: 20,
                        ),
                      ),
                    ),
                  )
                  : const SizedBox(),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onTap(journal.id),
          behavior: HitTestBehavior.opaque,
          child: Container(
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
        ),
      ],
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
