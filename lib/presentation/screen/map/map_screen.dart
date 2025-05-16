import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/grouplist_photos_timeline_tile.dart';
import 'package:photopin/presentation/component/integration_map.dart';
import 'package:photopin/presentation/component/move_bottom_sheet.dart';
import 'package:photopin/presentation/component/text_chip.dart';
import 'package:photopin/presentation/component/trip_with_chips.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapScreen extends StatelessWidget {
  final MapState mapState;
  final bool isShareScreen;
  final void Function(MapAction) onAction;

  const MapScreen({
    super.key,
    required this.mapState,
    required this.onAction,
    required this.isShareScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mapState.mapModel.journal.name),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        actions:
            !(isShareScreen)
                ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      child: const Icon(Icons.share),
                      onTap: () {
                        onAction(
                          MapAction.onShareClick(mapState.mapModel.journal.id),
                        );
                      },
                    ),
                  ),
                ]
                : null,
      ),
      bottomSheet:
          mapState.mapModel.journal.id != ''
              ? MoveBottomSheet(
                body: MapBottomDragWidget(
                  photos: mapState.mapModel.photos,
                  journal: mapState.mapModel.journal,
                  onAction: onAction,
                ),
              )
              : const SizedBox(),
      body:
          mapState.mapModel.journal.id != ''
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  IntegrationMap(
                    models: [mapState.mapModel],
                    onPhotoClick: (photoId, isCompare) {
                      onAction(MapAction.onPhotoClick(photoId));
                    },
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: TripWithChips(
                      tripWith: mapState.mapModel.journal.tripWith,
                      color: AppColors.primary80,
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class MapBottomDragWidget extends StatelessWidget {
  final void Function(MapAction) onAction;
  final List<PhotoModel> photos;
  final JournalModel journal;

  const MapBottomDragWidget({
    super.key,
    required this.photos,
    required this.journal,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        DateRangeSlider(
          startDate: journal.startDate,
          endDate: journal.endDate,
          onChanged: (start, end) {
            onAction(
              MapAction.onDateRangeClick(
                startDate: start,
                endDate: end,
                journalId: journal.id,
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Timeline', style: AppFonts.smallTextRegular),
            TextChip(text: '${photos.length} Places'),
          ],
        ),
        Expanded(
          child: GrouplistPhotosTimelineTile(
            photos: photos,
            onTap: (id) => onAction(MapAction.onPhotoClick(id)),
          ),
        ),
      ],
    );
  }
}
