import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/map_bottom_sheet.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_screen.dart';
import 'package:photopin/presentation/screen/map/map_view_model.dart';

class MapScreenRoot extends StatefulWidget {
  final MapViewModel mapViewModel;

  const MapScreenRoot({super.key, required this.mapViewModel});

  @override
  State<MapScreenRoot> createState() => _MapScreenRootState();
}

class _MapScreenRootState extends State<MapScreenRoot> {
  // collapsed 시트 높이 (핸들만 보임)
  static const double _minHeight = 104;
  // expanded 시트 높이
  static const double _maxHeight = 400;

  double _sheetHeight = _maxHeight;

  void _onHandleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _sheetHeight = (_sheetHeight - details.delta.dy).clamp(
        _minHeight,
        _maxHeight,
      );
    });
  }

  void _onHandleDragEnd(DragEndDetails details) {
    // 반쯤 이상 펼쳐져 있으면 완전 확장, 아니면 접기
    final mid = (_maxHeight + _minHeight) / 2;
    setState(() {
      _sheetHeight = _sheetHeight >= mid ? _maxHeight : _minHeight;
    });
  }

  void _onHandleTap() {
    setState(() {
      _sheetHeight = _sheetHeight == _minHeight ? _maxHeight : _minHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.mapViewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.mapViewModel.state.journal.name),
            centerTitle: true,
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              MapScreen(
                mapState: widget.mapViewModel.state,
                onAction: (action) {
                  switch (action) {
                    case OnDateRangeClick():
                      widget.mapViewModel.onAction(action);
                    case OnPhotoClick():
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final PhotoModel photo = widget
                              .mapViewModel
                              .state
                              .photos
                              .firstWhere(
                                (photo) => photo.id == action.photoId,
                              );
                          return MapBottomSheet(
                            title: widget.mapViewModel.state.journal.name,
                            imageUrl: photo.imageUrl,
                            dateTime: photo.dateTime,
                            location: photo.name,
                            comment: photo.comment,
                            onTapClose: () {
                              context.pop();
                            },
                            onTapEdit: () {},
                            onTapShare: () {},
                          );
                        },
                      );
                    case OnCancelClick():
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    case OnApplyFilterClick():
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    case OnEditClick():
                      // TODO: Handle this case.
                      throw UnimplementedError();
                    case OnShareClick():
                      // TODO: Handle this case.
                      throw UnimplementedError();
                  }
                },
              ),
              if (widget.mapViewModel.state.journal.id != '')
                MapBottomDragWidget(
                  sheetHeight: _sheetHeight,
                  onHandleDragUpdate: _onHandleDragUpdate,
                  onHandleDragEnd: _onHandleDragEnd,
                  onHandleTap: _onHandleTap,
                  photos: widget.mapViewModel.state.photos,
                  journal: widget.mapViewModel.state.journal,
                  onAction: widget.mapViewModel.onAction,
                ),
            ],
          ),
        );
      },
    );
  }
}

class MapBottomDragWidget extends StatelessWidget {
  final double sheetHeight;
  final void Function(DragUpdateDetails details) onHandleDragUpdate;
  final void Function(DragEndDetails details) onHandleDragEnd;
  final void Function() onHandleTap;
  final void Function(MapAction) onAction;
  final List<PhotoModel> photos;
  final JournalModel journal;

  const MapBottomDragWidget({
    super.key,
    required this.sheetHeight,
    required this.onHandleDragUpdate,
    required this.onHandleDragEnd,
    required this.onHandleTap,
    required this.photos,
    required this.journal,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      duration: const Duration(milliseconds: 200),
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: AppColors.gray5,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        spacing: 8,
        children: [
          // 2-1) 드래그 핸들
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: onHandleDragUpdate,
            onVerticalDragEnd: onHandleDragEnd,
            onTap: onHandleTap,
            child: Container(
              width: double.infinity,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          // 2-2) 날짜 슬라이더
          DateRangeSlider(
            startDate: journal.startDate,
            endDate: journal.endDate,
            onChanged: (start, end) {
              onAction(
                MapAction.onDateRangeClick(
                  startDate: start,
                  endDate: end,
                  journalId: journal.id,
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Timeline', style: AppFonts.smallTextRegular),
              FittedBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: AppColors.marker100,
                  ),
                  child: Center(
                    child: Text(
                      '${photos.length} Places',
                      style: AppFonts.smallerTextRegular,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 2-3) 사진 타임라인 (스크롤은 여기서만)
          Expanded(
            child: ListView.separated(
              itemCount: photos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, idx) {
                final photo = photos[idx];
                return TimeLineTile(
                  photoId: photo.id,
                  dateTime: photo.dateTime,
                  title: photo.name,
                  imageUrl: photo.imageUrl,
                  onTap: (photoId) {
                    onAction(MapAction.onPhotoClick(photoId));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
