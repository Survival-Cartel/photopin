import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/alert_share_link.dart';
import 'package:photopin/presentation/component/map_bottom_sheet.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_screen.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';

class MapScreenRoot extends StatefulWidget {
  final MapViewModel mapViewModel;
  final String userId;
  final bool isShareScreen;

  const MapScreenRoot({
    super.key,
    required this.mapViewModel,
    required this.userId,
    required this.isShareScreen,
  });

  @override
  State<MapScreenRoot> createState() => _MapScreenRootState();
}

class _MapScreenRootState extends State<MapScreenRoot> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.mapViewModel,
      builder: (context, child) {
        return MapScreen(
          isShareScreen: widget.isShareScreen,
          mapState: widget.mapViewModel.state,
          onAction: (action) {
            switch (action) {
              case OnDateRangeClick():
                widget.mapViewModel.onAction(action);
              case OnPhotoClick():
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    final PhotoModel photo = widget.mapViewModel.state.photos
                        .firstWhere((photo) => photo.id == action.photoId);
                    return MapBottomSheet(
                      title: widget.mapViewModel.state.journal.name,
                      imageUrl: photo.imageUrl,
                      dateTime: photo.dateTime,
                      location: photo.name,
                      comment: photo.comment,
                      onTapClose: () {
                        context.pop();
                      },
                      onTapEdit: () {},
                      onTapShare: () {},
                    );
                  },
                );
              case OnShareClick():
                showDialog(
                  context: context,
                  builder: (context) {
                    final String url =
                        'photopin://photopin.cartel.com/compare/${widget.userId}/${action.journalId}';
                    return AlertShareLink(
                      url: url,
                      onClick: () {
                        Clipboard.setData(ClipboardData(text: url));
                        context.pop();
                      },
                    );
                  },
                );
            }
          },
        );
      },
    );
  }
}
