import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/journal/screen/journal_screen_action.dart';
import 'package:photopin/journal/screen/journal_screen_state.dart';
import 'package:photopin/presentation/component/base_tab.dart';
import 'package:photopin/presentation/component/journal_card.dart';
import 'package:photopin/presentation/component/search_bar.dart';

class JournalScreen extends StatelessWidget {
  final JournalScreenState state;
  final Function(JournalScreenAction action) onAction;

  const JournalScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journals')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BaseTab(
                labels: const ['All', 'Unread', 'Shares'],
                activeColors: const [
                  AppColors.primary100,
                  AppColors.primary100,
                  AppColors.primary100,
                ],
                onToggle: (int index) {},
              ),
              const SizedBox(height: 16),
              SearchBarWidget(
                placeholder: 'Active Routes: ',
                onChanged:
                    (String query) => onAction(
                      JournalScreenAction.searchJournal(query: query),
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading) {
                      return const Center(
                        heightFactor: 16,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.journals.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 18);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return JournalCard(
                          imageUrl: '',
                          journal: state.journals[index],
                          photoCount: 2,
                          onTap:
                              (String journalId) => onAction(
                                JournalScreenAction.onTapJournalCard(
                                  journalId: journalId,
                                ),
                              ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
