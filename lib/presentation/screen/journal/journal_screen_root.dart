import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/core/debouncer.dart';
import 'package:photopin/presentation/screen/journal/journal_screen.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_action.dart';
import 'package:photopin/presentation/screen/journal/journal_view_model.dart';

class JournalScreenRoot extends StatelessWidget {
  final JournalViewModel viewModel;
  final Debouncer debouncer = Debouncer(milliseconds: 600);

  JournalScreenRoot({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return JournalScreen(
          state: viewModel.state,
          onAction: (JournalScreenAction action) async {
            switch (action) {
              case SearchJournal():
                debouncer.execute(() => viewModel.onAction(action));
              case OnTapJournalCard():
                context.push('${Routes.map}/${action.journalId}');
              case OnTapEdit():
                await viewModel.onAction(action);
              case SetSearchFilter():
                await viewModel.onAction(action);
              case OnSearchDateRange():
                await viewModel.onAction(action);
              case DeleteJournal():
                await viewModel.onAction(action);
            }
          },
        );
      },
    );
  }
}
