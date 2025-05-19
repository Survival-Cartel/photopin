import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/routes.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_action.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_screen.dart';
import 'package:photopin/presentation/screen/compare_dialog/compare_dialog_view_model.dart';

class CompareDialogScreenRoot extends StatelessWidget {
  final CompareDialogViewModel viewModel;
  final String compareUserId;
  final String compareJournalId;
  const CompareDialogScreenRoot({
    super.key,
    required this.viewModel,
    required this.compareUserId,
    required this.compareJournalId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return CompareDialogScreen(
            state: viewModel.state,
            onAction: (action) {
              switch (action) {
                case OnApply():
                  if (action.journalId == '') {
                    context.push(
                      '${Routes.map}/$compareUserId/$compareJournalId',
                    );
                    return;
                  }
                  context.push(
                    '${Routes.compareMap}/$compareUserId/$compareJournalId/${action.journalId}',
                  );
              }
            },
          );
        },
      ),
    );
  }
}
