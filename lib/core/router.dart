import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/auth/auth_screen_root.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/presentation/screen/home/home_screen_root.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_root.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_view_model.dart';

final appRouter = GoRouter(
  initialLocation: Routes.login,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreenRoot(viewModel: getIt<HomeViewModel>());
      },
    ),
    GoRoute(
      path: Routes.journal,
      builder: (BuildContext context, GoRouterState state) {
        final String userId = state.pathParameters['id']!;

        return JournalScreenRoot(
          viewModel: getIt<JournalViewModel>(param1: userId),
        );
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) {
        return AuthScreenRoot(authViewModel: getIt<AuthViewModel>());
      },
    ),
  ],
);
