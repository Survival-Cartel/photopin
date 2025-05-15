import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';

class GrouplistPhotosTimelineTile extends StatelessWidget {
  final List<PhotoModel> photos;
  final void Function(String id) onTap;
  const GrouplistPhotosTimelineTile({
    super.key,
    required this.photos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GroupedListView<PhotoModel, DateTime>(
      elements: photos,
      groupBy:
          (photo) => DateTime(
            photo.dateTime.year,
            photo.dateTime.month,
            photo.dateTime.day,
          ),
      groupSeparatorBuilder:
          (date) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 8,
              children: [
                Expanded(child: Container(height: 1, color: AppColors.gray4)),
                Text(date.formDateString(), style: AppFonts.smallTextRegular),
                Expanded(child: Container(height: 1, color: AppColors.gray4)),
              ],
            ),
          ),
      itemBuilder: (context, photo) {
        return TimeLineTile(
          photoId: photo.id,
          dateTime: photo.dateTime,
          title: photo.name,
          imageUrl: photo.imageUrl,
          onTap: onTap,
        );
      },
      separator: const SizedBox(height: 4),
      order: GroupedListOrder.ASC,
    );
  }
}
