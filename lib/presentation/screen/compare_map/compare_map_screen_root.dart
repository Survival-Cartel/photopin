import 'package:flutter/material.dart';
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
        return CompareMapScreen(state: viewModel.state, onAction: (action) {});
      },
    );
  }
}
