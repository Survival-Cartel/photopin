import 'package:flutter/material.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/map_bottom_sheet.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_screen.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';

class MapScreenRoot extends StatefulWidget {
  final MapViewModel mapViewModel;

  const MapScreenRoot({super.key, required this.mapViewModel});

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
          mapState: widget.mapViewModel.state,
          onAction: (action) {
            switch (action) {
              case OnDateRangeClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case OnPhotoClick():
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    print(
                      'widget.mapViewModel.state.journal ${widget.mapViewModel.state.journal}',
                    );
                    final PhotoModel photo = widget.mapViewModel.state.photos
                        .firstWhere((photo) => photo.id == action.photoId);
                    return MapBottomSheet(
                      title: widget.mapViewModel.state.journal.name,
                      imageUrl: photo.imageUrl,
                      dateTime: photo.dateTime,
                      location: photo.name,
                      comment: photo.comment,
                      onTapClose: () {},
                      onTapEdit: () {},
                      onTapShare: () {},
                    );
                  },
                );
              case OnCancelClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case OnApplyFilterClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case OnEditClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case OnShareClick():
                // TODO: Handle this case.
                throw UnimplementedError();
            }
          },
        );
      },
    );
  }
}
