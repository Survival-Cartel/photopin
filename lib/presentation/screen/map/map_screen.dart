import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/component/text_chip.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapScreen extends StatefulWidget {
  final MapState mapState;
  final void Function(MapAction) onAction;

  const MapScreen({super.key, required this.mapState, required this.onAction});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mapState.journal.name),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(child: const Icon(Icons.share)),
          ),
        ],
      ),
      body:
          widget.mapState.journal.id != ''
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  widget.mapState.photos.isNotEmpty
                      ? PhotoPinMap(
                        initialLocation: LatLng(
                          widget.mapState.photos.first.location.latitude,
                          widget.mapState.photos.first.location.longitude,
                        ),
                        initialZoomLevel: 16,
                        markers:
                            widget.mapState.photos
                                .map(
                                  (photo) => Marker(
                                    markerId: MarkerId(photo.id),
                                    position: LatLng(
                                      photo.location.latitude,
                                      photo.location.longitude,
                                    ),
                                    onTap:
                                        () => widget.onAction(
                                          MapAction.onPhotoClick(photo.id),
                                        ),
                                  ),
                                )
                                .toSet(),
                        polylines: {
                          widget.mapState.journal.name:
                              widget.mapState.photos
                                  .map(
                                    (photo) => LatLng(
                                      photo.location.latitude,
                                      photo.location.longitude,
                                    ),
                                  )
                                  .toList(),
                        },
                        polyLineColor: AppColors.marker70,
                      )
                      : const PhotoPinMap(
                        initialLocation: LatLng(37.5125, 127.1025),
                        initialZoomLevel: 16,
                        markers: {},
                        polylines: {},
                        polyLineColor: AppColors.marker70,
                      ),
                  MapBottomDragWidget(
                    sheetHeight: _sheetHeight,
                    onHandleDragUpdate: _onHandleDragUpdate,
                    onHandleDragEnd: _onHandleDragEnd,
                    onHandleTap: _onHandleTap,
                    photos: widget.mapState.photos,
                    journal: widget.mapState.journal,
                    onAction: widget.onAction,
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
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
              TextChip(text: '${photos.length} Places'),
            ],
          ),
          // 2-3) 사진 타임라인 (스크롤은 여기서만)
          Expanded(
            child: GroupedListView<PhotoModel, String>(
              elements: photos,
              groupBy: (photo) => photo.dateTime.formDateString(),
              groupSeparatorBuilder:
                  (date) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Container(height: 1, color: AppColors.gray4),
                        ),
                        Text(date, style: AppFonts.smallTextRegular),
                        Expanded(
                          child: Container(height: 1, color: AppColors.gray4),
                        ),
                      ],
                    ),
                  ),
              itemBuilder: (context, photo) {
                return TimeLineTile(
                  photoId: photo.id,
                  dateTime: photo.dateTime,
                  title: photo.name,
                  imageUrl: photo.imageUrl,
                  onTap: (id) => onAction(MapAction.onPhotoClick(id)),
                );
              },
              separator: const SizedBox(height: 4),
              order: GroupedListOrder.DESC, // or ASC
            ),
          ),
        ],
      ),
    );
  }
}
