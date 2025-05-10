import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/home/home_screen_root.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_root.dart';
import 'package:photopin/presentation/screen/main/main_screen.dart';

final appRouter = GoRouter(
  initialLocation: Routes.home,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreenRoot(homeViewModel: getIt());
      },
    ),
    GoRoute(
      path: Routes.journal,
      builder: (BuildContext context, GoRouterState state) {
        return JournalScreenRoot(viewModel: getIt());
      },
    ),
    StatefulShellRoute(
      builder: (context, state, navigationSheel) =>
        MainScreen(navigationSheel: navigationSheel),
      branches:
    ),
  ],
);
