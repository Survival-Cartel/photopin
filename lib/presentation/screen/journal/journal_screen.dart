import 'package:flutter/material.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/confirm_dialog.dart';
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
                  JournalScreenAction.setSearchFilter(option: option),
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
                                onTapDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmDialog(
                                        title: '저널 삭제',
                                        content:
                                            '"${journal.name}" 저널을 삭제하시겠습니까? 삭제 후 되돌릴 수 없습니다.',
                                        confirmText: '삭제',
                                        cancelText: '취소',
                                        onTapCancel:
                                            () => Navigator.pop(context),
                                        onTapConfirm: () {
                                          widget.onAction(
                                            JournalScreenAction.deleteJournal(
                                              journalId: journal.id,
                                            ),
                                          );

                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  );

                                  Navigator.pop(context);
                                },
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
