import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/screen/journal/journal_screen_action.dart';
import 'package:photopin/presentation/screen/journal/journal_state.dart';
import 'package:photopin/presentation/component/base_tab.dart';
import 'package:photopin/presentation/component/journal_card.dart';
import 'package:photopin/presentation/component/search_bar.dart';

class JournalScreen extends StatelessWidget {
  final JournalState state;
  final Function(JournalScreenAction action) onAction;

  const JournalScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                  (String query) =>
                      onAction(JournalScreenAction.searchJournal(query: query)),
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
                      String? thumbnailUrl =
                          state
                                      .photoMap[state.journals[index].id]
                                      ?.isNotEmpty ==
                                  true
                              ? state
                                  .photoMap[state.journals[index].id]!
                                  .first
                                  .imageUrl
                              : null;
                      int? photoCount =
                          state.photoMap[state.journals[index].id]?.length;

                      return JournalCard(
                        imageUrl: thumbnailUrl,
                        journal: state.journals[index],
                        photoCount: photoCount ?? 0,
                        onTapEdit: (String journalId) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              final JournalModel journal =
                                  state.journals[index];

                              return FittedBox(
                                // decoration                                child: EditBottomSheet(
                                  title: journal.name,
                                  imageUrl: thumbnailUrl,
                                  dateTime: journal.startDate,
                                  comment: journal.comment,
                                  journalId: journalId,
                                  onTapClose: () => Navigator.pop(context),
                                  showJournalDropdown: false,
                                  onTapApply: (
                                    title,
                                    selectJournal,
                                    newComment,
                                  ) {
                                    // 여기서 photo를 업데이트하는 적절한 액션을 생성
                                    // 예: onAction(PhotosAction.updatePhotoComment(photo.id, newComment));
                                    // onAction(
                                    //   PhotosAction.applyClick(
                                    //     photo.copyWith(
                                    //       name: photoName,
                                    //       comment: newComment,
                                    //       journalId: selectJournal,
                                    //     ),
                                    //   ),
                                    // );
                                    Navigator.pop(context);
                                  },
                                  onTapCancel: () => Navigator.pop(context),
                                  journals: state.journals,
                                ),
                              );
                            },
                          );
                        },
                        showEditButton: true,
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
    );
  }
}
