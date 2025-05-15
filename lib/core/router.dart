import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/camera/presentation/camera_launcher_screen_root.dart';
import 'package:photopin/camera/presentation/camera_view_model.dart';
import 'package:photopin/core/di/di_setup.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/auth/auth_screen_root.dart';
import 'package:photopin/presentation/screen/auth/auth_view_model.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_screen_root.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_view_model.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_screen_root.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_view_model.dart';
import 'package:photopin/presentation/screen/home/home_screen_root.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_root.dart';
import 'package:photopin/presentation/screen/journal/journal_view_model.dart';
import 'package:photopin/presentation/screen/main/main_screen_root.dart';
import 'package:photopin/presentation/screen/main/main_view_model.dart';
import 'package:photopin/presentation/screen/map/map_screen_root.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';
import 'package:photopin/presentation/screen/photos/photos_screen_root.dart';
import 'package:photopin/presentation/screen/photos/photos_view_model.dart';
import 'package:photopin/presentation/screen/settings/settings_screen_root.dart';
import 'package:photopin/presentation/screen/settings/settings_view_model.dart';

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

        viewModel.init(journalId, userId);

        return MapScreenRoot(mapViewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.camera,
      builder: (context, state) {
        final String userId = getIt<FirebaseAuth>().currentUser!.uid;

        return CameraLauncherScreenRoot(
          viewModel: getIt<CameraViewModel>(param1: userId),
        );
      },
    ),
    GoRoute(
      path: '${Routes.compareMap}/:userId/:journalId/:myJournalId',
      builder: (BuildContext context, GoRouterState state) {
        final String compareUserId = state.pathParameters['userId']!;
        final String compareJournalId = state.pathParameters['journalId']!;
        final String myJournalId = state.pathParameters['myJournalId']!;

        final String myUserId = getIt<FirebaseAuth>().currentUser!.uid;

        final CompareMapViewModel viewModel = getIt<CompareMapViewModel>(
          param1: compareUserId,
          param2: myUserId,
        );

        viewModel.init(
          sharedUserId: compareUserId,
          sharedJournalId: compareJournalId,
          myUserId: myUserId,
          myJournalId: myJournalId,
        );

        return CompareMapScreenRoot(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: '${Routes.map}/:userId/:journalId',
      builder: (BuildContext context, GoRouterState state) {
        final String compareUserId = state.pathParameters['userId']!;
        final String compareJournalId = state.pathParameters['journalId']!;

        final MapViewModel viewModel = getIt<MapViewModel>(
          param1: compareUserId,
        );

        viewModel.init(compareJournalId, compareUserId);

        return MapScreenRoot(mapViewModel: viewModel);
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

                final HomeViewModel viewModel = getIt<HomeViewModel>(
                  param1: userId,
                );

                viewModel.init();

                return HomeScreenRoot(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  path: '${Routes.compare}/:userId/:journalId',
                  builder: (BuildContext context, GoRouterState state) {
                    final String compareUserId =
                        state.pathParameters['userId']!;
                    final String compareJournalId =
                        state.pathParameters['journalId']!;

                    final String myUserId =
                        getIt<FirebaseAuth>().currentUser!.uid;

                    final CompareDialogViewModel viewModel =
                        getIt<CompareDialogViewModel>(param1: myUserId);

                    viewModel.init();

                    return CompareDialogScreenRoot(
                      viewModel: viewModel,
                      compareUserId: compareUserId,
                      compareJournalId: compareJournalId,
                    );
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

                final JournalViewModel viewModel = getIt<JournalViewModel>(
                  param1: userId,
                );

                viewModel.init();

                return JournalScreenRoot(viewModel: viewModel);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.unknown,
              builder: (context, state) {
                return const Center(
                  child: Text(
                    'Page not found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.photos,
              builder: (context, state) {
                final String userId = getIt<FirebaseAuth>().currentUser!.uid;
                return PhotosScreenRoot(
                  viewModel: getIt<PhotosViewModel>(param1: userId),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (context, state) {
                return SettingsScreenRoot(
                  viewModel: getIt<SettingsViewModel>(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
