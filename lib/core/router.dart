import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/auth/auth_screen_root.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/presentation/screen/camera/camera_launcher_screen.dart';
import 'package:photopin/presentation/screen/home/home_screen_root.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_root.dart';
import 'package:photopin/presentation/screen/journal/journal_view_model.dart';
import 'package:photopin/presentation/screen/main/main_screen_root.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';
import 'package:photopin/presentation/screen/map/map_screen_root.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';

final appRouter = GoRouter(
  initialLocation: Routes.login,
  redirect: (BuildContext context, GoRouterState state) {
    final User? currentUser = getIt<FirebaseAuth>().currentUser;
    final bool isLoggedIn = currentUser != null;
    final bool isGoingToLogin = state.matchedLocation == Routes.login;

    if (isLoggedIn && isGoingToLogin) {
      return Routes.home;
    }

    if (!isLoggedIn && !isGoingToLogin) {
      if (state.matchedLocation.startsWith('${Routes.map}/') &&
          state.pathParameters.containsKey('userId')) {
        return null;
      }
      return Routes.login;
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) {
        final AuthViewModel viewModel = getIt<AuthViewModel>();

        return AuthScreenRoot(authViewModel: viewModel);
      },
    ),
    GoRoute(
      path: '${Routes.map}/:journalId',
      builder: (BuildContext context, GoRouterState state) {
        final String userId = getIt<FirebaseAuth>().currentUser!.uid;
        final String journalId = state.pathParameters['journalId']!;

        final MapViewModel viewModel = getIt<MapViewModel>(param1: userId);

        viewModel.init(journalId);

        return MapScreenRoot(mapViewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.camera,
      builder: (context, state) {
        return const CameraLauncherScreen();
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        final MainScreenViewModel mainScreenViewModel = getIt();

        mainScreenViewModel.init();

        return MainScreenRoot(
          navigationShell: navigationShell,
          viewModel: mainScreenViewModel,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) {
                final String userId = getIt<FirebaseAuth>().currentUser!.uid;
                return HomeScreenRoot(
                  viewModel: getIt<HomeViewModel>(param1: userId),
                );
              },
              routes: [
                GoRoute(
                  path: '${Routes.map}/:userId/:journalId',
                  builder: (BuildContext context, GoRouterState state) {
                    final String userId = state.pathParameters['userId']!;
                    final String journalId = state.pathParameters['journalId']!;

                    final MapViewModel viewModel = getIt<MapViewModel>(
                      param1: userId,
                    );

                    viewModel.init(journalId);

                    return MapScreenRoot(mapViewModel: viewModel);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.journal,
              builder: (context, state) {
                final String userId = getIt<FirebaseAuth>().currentUser!.uid;
                return JournalScreenRoot(
                  viewModel: getIt<JournalViewModel>(param1: userId),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
