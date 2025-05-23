import 'package:flutter/material.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/confirm_dialog.dart';
import 'package:photopin/presentation/component/journal_card_image.dart';
import 'package:photopin/presentation/component/map_filter.dart';
import 'package:photopin/presentation/component/photo_edit_bottom_sheet.dart';
import 'package:photopin/presentation/screen/photos/photos_action.dart';
import 'package:photopin/presentation/screen/photos/photos_state.dart';

class PhotosScreen extends StatelessWidget {
  final PhotosState state;
  final void Function(PhotosAction) onAction;

  const PhotosScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final List<String> journalNames =
        state.journals.map((journal) => journal.name).toList();

    final filterLabels = ['All', ...journalNames];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MapFilter(
              labels: filterLabels,
              selectedIndex: state.selectedFilterIndex,
              onSelected: (int index) {
                // 필터 선택 처리 구현
                onAction(PhotosAction.photoFilterClick(index));
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Builder(
                builder: (context) {
                  // 로딩 중일 때는 로딩 인디케이터 표시
                  if (state.isLoading) {
                    return const Center(
                      heightFactor: 16,
                      child: CircularProgressIndicator(),
                    );
                  }

                  // 사진이 비어있을 때는 안내 메시지 표시
                  if (state.photos.isEmpty) {
                    return const Center(child: Text('No photos available'));
                  }

                  // 사진 목록을 그리드로 표시
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 가로로 2개씩 표시
                          crossAxisSpacing: 10, // 가로 간격
                          mainAxisSpacing: 10, // 세로 간격
                          childAspectRatio: 1, // 아이템의 가로:세로 비율
                        ),
                    itemCount: state.photos.length,
                    itemBuilder: (context, index) {
                      final photo = state.photos[index];

                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return PhotoEditBottomSheet(
                                title: photo.name,
                                thumbnailUrl: photo.imageUrl,
                                dateTime: photo.dateTime,
                                comment: photo.comment,
                                journalId: photo.journalId,
                                journals: _getFilteredJournalEntries(photo),
                                onTapClose: () => Navigator.pop(context),
                                onTapApply: (
                                  photoName,
                                  selectJournal,
                                  newComment,
                                ) {
                                  // 여기서 photo를 업데이트하는 적절한 액션을 생성
                                  // 예: onAction(PhotosAction.updatePhotoComment(photo.id, newComment));
                                  onAction(
                                    PhotosAction.applyClick(
                                      photo.copyWith(
                                        name: photoName,
                                        comment: newComment,
                                        journalId: selectJournal,
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                onTapDelete: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmDialog(
                                        title: '사진 삭제',
                                        content:
                                            '"${photo.name}" 사진을 삭제하시겠습니까? 삭제 후 되돌릴 수 없습니다.',
                                        confirmText: '삭제',
                                        cancelText: '취소',
                                        onTapCancel:
                                            () => Navigator.pop(context),
                                        onTapConfirm: () {
                                          onAction(
                                            PhotosAction.deleteClick(photo.id),
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
                        child: JournalCardImage(
                          imageUrl: photo.imageUrl,
                          journeyTitle: photo.name,
                          description: photo.comment,
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

  List<JournalModel> _getFilteredJournalEntries(PhotoModel photoModel) {
    if (state.journals.isEmpty) return [];

    // 사진 날짜가 저널 기간에 포함되는 저널만 필터링
    final filteredJournals =
        state.journals.where((journal) {
          return photoModel.dateTime.isAfter(
                journal.startDate.subtract(const Duration(days: 1)),
              ) &&
              photoModel.dateTime.isBefore(
                journal.endDate.add(const Duration(days: 1)),
              );
        }).toList();
    return filteredJournals;
  }
}
