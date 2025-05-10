import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/auth/auth_screen_root.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/presentation/screen/home/home_screen_root.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_root.dart';
import 'package:photopin/presentation/screen/map/map_screen_root.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';

final appRouter = GoRouter(
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
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) {
        final AuthViewModel viewModel = getIt<AuthViewModel>();
        return AuthScreenRoot(authViewModel: viewModel);
      },
    ),
    GoRoute(
      path: '${Routes.map}/:userId/:journalId',
      builder: (BuildContext context, GoRouterState state) {
        final String userId = state.pathParameters['userId']!;
        final String journalId = state.pathParameters['journalId']!;

        final MapViewModel viewModel = getIt<MapViewModel>(param1: userId);

        viewModel.init(journalId);

        return MapScreenRoot(mapViewModel: viewModel);
      },
    ),
  ],
);
