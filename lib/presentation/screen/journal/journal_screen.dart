import 'package:flutter/material.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/journal_edit_bottom_sheet.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_action.dart';
import 'package:photopin/presentation/screen/journal/journal_state.dart';
import 'package:photopin/presentation/component/journal_card.dart';
import 'package:photopin/presentation/component/search_bar.dart';

class JournalScreen extends StatefulWidget {
  final JournalState state;
  final Function(JournalScreenAction action) onAction;

  const JournalScreen({super.key, required this.state, required this.onAction});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SearchBarWidget(
              initFilterOption: widget.state.searchFilterOption,
              initRange: widget.state.searchDateTimeRange,
              onDateTimeRangeSearch: (DateTimeRange range) {
                widget.onAction(
                  JournalScreenAction.onSearchDateRange(range: range),
                );
              },
              placeholder:
                  widget.state.searchFilterOption == SearchFilterOption.title
                      ? '제목을 검색하세요.'
                      : '날짜를 검색하세요.',
              onChangedOption: (SearchFilterOption option) {
                widget.onAction(
                  JournalScreenAction.setSerchFilter(option: option),
                );
              },
              onChanged: (String query) {
                widget.onAction(
                  JournalScreenAction.searchJournal(query: query),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (widget.state.isLoading) {
                    return const Center(
                      heightFactor: 16,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    itemCount: widget.state.journals.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 18);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      String? thumbnailUrl =
                          widget
                                      .state
                                      .photoMap[widget.state.journals[index].id]
                                      ?.isNotEmpty ==
                                  true
                              ? widget
                                  .state
                                  .photoMap[widget.state.journals[index].id]!
                                  .first
                                  .imageUrl
                              : null;
                      int? photoCount =
                          widget
                              .state
                              .photoMap[widget.state.journals[index].id]
                              ?.length;

                      return JournalCard(
                        imageUrl: thumbnailUrl,
                        journal: widget.state.journals[index],
                        photoCount: photoCount ?? 0,
                        onTapEdit: (String journalId) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              final JournalModel journal =
                                  widget.state.journals[index];

                              return JournalEditBottomSheet(
                                journal: journal,
                                title: journal.name,
                                thumbnailUrl: thumbnailUrl,
                                comment: journal.comment,
                                onTapClose: () => Navigator.pop(context),
                                onTapApply: (JournalModel journal) {
                                  widget.onAction(
                                    JournalScreenAction.onTapEdit(
                                      journal: journal,
                                    ),
                                  );

                                  Navigator.pop(context);
                                },
                                onTapCancel: () => Navigator.pop(context),
                              );
                            },
                          );
                        },
                        showEditButton: true,
                        onTap:
                            (String journalId) => widget.onAction(
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
    );
  }
}
