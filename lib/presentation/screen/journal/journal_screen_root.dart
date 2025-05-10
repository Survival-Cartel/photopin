import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/journal/journal_screen.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_action.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_view_model.dart';

class JournalScreenRoot extends StatefulWidget {
  final JournalViewModel viewModel;

  const JournalScreenRoot({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() => _JournalScreenRootState();
}

class _JournalScreenRootState extends State<JournalScreenRoot> {
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
        return JournalScreen(
          state: widget.viewModel.state,
          onAction: (JournalScreenAction action) async {
            switch (action) {
              case SearchJournal():
                await widget.viewModel.onAction(action);
              case OnTapJournalCard():
                context.push('${Routes.map}/${action.journalId}');
            }
          },
        );
      },
    );
  }
}
