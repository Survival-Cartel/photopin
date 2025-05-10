import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapScreen extends StatefulWidget {
  final MapState mapState;
  final void Function(MapAction) onAction;

  const MapScreen({super.key, required this.mapState, required this.onAction});

  @override
  _MapScreenState createState() => _MapScreenState();
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
      ),
      body:
          !widget.mapState.isLoading
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // 1) 지도 or 로딩 인디케이터
                  PhotoPinMap(
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
                  ),

                  // 2) 커스텀 바텀 시트
                  AnimatedContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    duration: const Duration(milliseconds: 200),
                    height: _sheetHeight,
                    decoration: const BoxDecoration(
                      color: AppColors.gray5,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      spacing: 8,
                      children: [
                        // 2-1) 드래그 핸들
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragUpdate: _onHandleDragUpdate,
                          onVerticalDragEnd: _onHandleDragEnd,
                          onTap: _onHandleTap,
                          child: Container(
                            width: 40,
                            height: 6,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        // 2-2) 날짜 슬라이더
                        DateRangeSlider(
                          startDate: widget.mapState.journal.startDate,
                          endDate: widget.mapState.journal.endDate,
                          onChanged: (start, end) {
                            // TODO: 날짜 범위 필터 로직
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Timeline', style: AppFonts.smallTextRegular),
                            Container(
                              width: 64,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(999),
                                color: AppColors.marker100,
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.mapState.photos.length} Places',
                                  style: AppFonts.smallerTextRegular,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 2-3) 사진 타임라인 (스크롤은 여기서만)
                        Expanded(
                          child: ListView.separated(
                            itemCount: widget.mapState.photos.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 4),
                            itemBuilder: (context, idx) {
                              final photo = widget.mapState.photos[idx];
                              return TimeLineTile(
                                dateTime: photo.dateTime,
                                title: photo.name,
                                imageUrl: photo.imageUrl,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
