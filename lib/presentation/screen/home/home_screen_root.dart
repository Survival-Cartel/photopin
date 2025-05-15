import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/new_journal_modal.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/home/home_action.dart';
import 'package:photopin/presentation/screen/home/home_screen.dart';
import 'package:photopin/presentation/screen/home/home_view_model.dart';

class HomeScreenRoot extends StatelessWidget {
  final HomeViewModel viewModel;
  const HomeScreenRoot({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return HomeScreen(
          state: viewModel.state,
          onAction: (action) {
            switch (action) {
              case CameraClick():
                break;
              case NewJournalClick():
                showDialog(
                  context: context,
                  builder: (context) {
                    return NewJournalModal(
                      userName: viewModel.state.currentUser.displayName,
                      onSave: ({required JournalModel journal}) {
                        viewModel.onAction(
                          HomeAction.newJournalSave(journal: journal),
                        );
                        context.pop();
                      },
                    );
                  },
                );
              case ShareClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case RecentActivityClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case SeeAllClick():
                // TODO: Handle this case.
                throw UnimplementedError();
              case MyJournalClick(id: final journalId):
                context.push('${Routes.map}/$journalId');
              case FindUser():
                viewModel.onAction(action);
              case FindJounals():
                viewModel.onAction(action);
              case NewJournalSave():
                break;
            }
          },
        );
      },
    );
  }
}
