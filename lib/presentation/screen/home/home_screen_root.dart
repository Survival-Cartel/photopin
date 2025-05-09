import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_screen.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';

class HomeScreenRoot extends StatelessWidget {
  final HomeViewModel homeViewModel;
  const HomeScreenRoot({super.key, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: homeViewModel,
      builder: (context, child) {
        return HomeScreen(
          homeState: homeViewModel.homeState,
          onAction: (action) {
            switch (action) {
              case CameraClick():
                print('gg');
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
              case ViewAllClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case MyJounalClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case FindUser():
                homeViewModel.onAction(action);
              case FindJounals():
                homeViewModel.onAction(action);
            }
          },
        );
      },
    );
  }
}
