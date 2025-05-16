import 'package:flutter/material.dart';
import 'package:photopin/core/domain/integration_model.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/compare_card.dart';
import 'package:photopin/presentation/component/grouplist_photos_timeline_tile.dart';
import 'package:photopin/presentation/component/integration_map.dart';
import 'package:photopin/presentation/component/move_bottom_sheet.dart';
import 'package:photopin/presentation/component/photopin_head.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_action.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_state.dart';

class CompareMapScreen extends StatelessWidget {
  final CompareMapState state;
  final void Function(CompareMapAction action) onAction;
  const CompareMapScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PhotopinHead(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      bottomSheet:
          state.sharedData.journal.id != ''
              ? MoveBottomSheet(
                body: MapBottomDragWidget(
                  myModel: state.myData,
                  sharedModel: state.sharedData,
                  onAction: onAction,
                ),
              )
              : const SizedBox(),
      body:
          state.sharedData.journal.id != ''
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  IntegrationMap(
                    models: [state.myData, state.sharedData],
                    onPhotoClick: (photoId, isCompare) {
                      onAction(
                        CompareMapAction.onPhotoClick(
                          photoId: photoId,
                          isCompare: isCompare,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      width: 170,
                      height: 76,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LineInfo(
                            info: 'My Routes',
                            color: AppColors.secondary100,
                          ),
                          _LineInfo(
                            info: 'Shared Routes',
                            color: AppColors.primary100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _LineInfo extends StatelessWidget {
  final String info;
  final Color color;
  const _LineInfo({required this.info, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Container(width: 16, height: 3, color: color),
        Text(info, style: AppFonts.smallTextRegular),
      ],
    );
  }
}

class MapBottomDragWidget extends StatelessWidget {
  final void Function(CompareMapAction) onAction;
  final IntegrationModel sharedModel;
  final IntegrationModel myModel;

  const MapBottomDragWidget({
    super.key,
    required this.onAction,
    required this.sharedModel,
    required this.myModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: CompareCard(
                  profileImageUrl: myModel.user.profileImg,
                  nameString: myModel.user.displayName,
                  journal: myModel.journal,
                  color: AppColors.secondary100,
                  photoString: '${myModel.photos.length} Photos',
                ),
              ),
              Expanded(
                child: GrouplistPhotosTimelineTile(
                  photos: myModel.photos,
                  onTap: (id) {
                    onAction(
                      CompareMapAction.onPhotoClick(
                        photoId: id,
                        isCompare: false,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: CompareCard(
                  profileImageUrl: sharedModel.user.profileImg,
                  nameString: sharedModel.user.displayName,
                  journal: sharedModel.journal,
                  color: AppColors.primary100,
                  photoString: '${sharedModel.photos.length} Photos',
                ),
              ),
              Expanded(
                child: GrouplistPhotosTimelineTile(
                  photos: sharedModel.photos,
                  onTap: (id) {
                    onAction(
                      CompareMapAction.onPhotoClick(
                        photoId: id,
                        isCompare: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
