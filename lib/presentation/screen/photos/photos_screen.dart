import 'package:flutter/material.dart';
import 'package:photopin/presentation/component/edit_bottom_sheet.dart';
import 'package:photopin/presentation/component/journal_card_image.dart';
import 'package:photopin/presentation/component/map_filter.dart';
import 'package:photopin/presentation/screen/photos/photos_action.dart';
import 'package:photopin/presentation/screen/photos/photos_state.dart';

class PhotosScreen extends StatelessWidget {
  final PhotosState state;
  final void Function(PhotosAction) onAction;

  const PhotosScreen({super.key, required this.state, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: MapFilter(
                icons: const [
                  Icon(Icons.watch_later_rounded),
                  Icon(Icons.local_fire_department),
                  Icon(Icons.photo_library_sharp),
                ],
                labels: const ['Time', 'Heat Map', 'Photos'],
                initialIndex: 0,
                onSelected: (int index) {
                  // 필터 선택 처리 구현
                  // onAction(PhotosAction.filterChanged(index));
                },
              ),
            ),
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
                          childAspectRatio: 0.75, // 아이템의 가로:세로 비율
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
                              return Container(
                                height: 500,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                child: EditBottomSheet(
                                  imageUrl: photo.imageUrl,
                                  dateTime: photo.dateTime,
                                  comment: photo.comment,
                                  onTapClose: () => Navigator.pop(context),
                                  onTapApply: (selectJournal, newComment) {
                                    // 여기서 photo를 업데이트하는 적절한 액션을 생성
                                    // 예: onAction(PhotosAction.updatePhotoComment(photo.id, newComment));
                                    onAction(
                                      PhotosAction.applyClick(
                                        photo.copyWith(
                                          comment: newComment,
                                          journalId: selectJournal,
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  onTapCancel: () => Navigator.pop(context),
                                  journals: state.journals,
                                ),
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
}
