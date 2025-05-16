import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/photos/photos_action.dart';
import 'package:photopin/presentation/screen/photos/photos_screen.dart';
import 'package:photopin/presentation/screen/photos/photos_view_model.dart';

class PhotosScreenRoot extends StatefulWidget {
  final PhotosViewModel viewModel;
  const PhotosScreenRoot({super.key, required this.viewModel});

  @override
  State<PhotosScreenRoot> createState() => _PhotosScreenRootState();
}

class _PhotosScreenRootState extends State<PhotosScreenRoot> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return PhotosScreen(
          state: widget.viewModel.state,
          onAction: (action) {
            switch (action) {
              case PhotoFilterClick():
                widget.viewModel.onAction(action);
              case PhotoCardClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case PhotoApplyClick():
                widget.viewModel.onAction(action);
              case PhotoDeleteClick():
                widget.viewModel.onAction(action);
            }
          },
        );
      },
    );
  }
}
