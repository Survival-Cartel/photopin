import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/map_bottom_sheet.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_action.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_screen.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_view_model.dart';

class CompareMapScreenRoot extends StatelessWidget {
  final CompareMapViewModel viewModel;
  const CompareMapScreenRoot({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return CompareMapScreen(
          state: viewModel.state,
          onAction: (action) {
            switch (action) {
              case OnPhotoClick():
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    if (action.isCompare) {
                      final PhotoModel photo = viewModel.state.sharedData.photos
                          .firstWhere((photo) => photo.id == action.photoId);
                      return MapBottomSheet(
                        title: viewModel.state.sharedData.journal.name,
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
                    } else {
                      final PhotoModel photo = viewModel.state.myData.photos
                          .firstWhere((photo) => photo.id == action.photoId);
                      return MapBottomSheet(
                        title: viewModel.state.myData.journal.name,
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
                    }
                  },
                );
            }
          },
        );
      },
    );
  }
}
