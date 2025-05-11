import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_screen.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';

class HomeScreenRoot extends StatefulWidget {
  final HomeViewModel viewModel;
  const HomeScreenRoot({super.key, required this.viewModel});

  @override
  State<HomeScreenRoot> createState() => _HomeScreenRootState();
}

class _HomeScreenRootState extends State<HomeScreenRoot> {
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
        return HomeScreen(
          state: widget.viewModel.state,
          onAction: (action) {
            switch (action) {
              case CameraClick():
              // 수정
              case NewJournalClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case ShareClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case RecentActivityClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case SeeAllClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case MyJounalClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case FindUser():
                widget.viewModel.onAction(action);
              case FindJounals():
                widget.viewModel.onAction(action);
            }
          },
        );
      },
    );
  }
}
