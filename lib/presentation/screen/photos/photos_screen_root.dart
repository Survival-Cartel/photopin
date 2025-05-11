import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/photos/photos_view_model.dart';

class PhotosScreenRoot extends StatefulWidget {
  final PhotosViewModel viewModel;
  const PhotosScreenRoot({super.key, required this.viewModel});

  @override
  State<PhotosScreenRoot> createState() => _PhotosScreenRootState();
}

class _PhotosScreenRootState extends State<PhotosScreenRoot> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return PhotosScreen(
          
        )
      },
    );
  }
}