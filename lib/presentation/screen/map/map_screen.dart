import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/custom_map_marker.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/component/text_chip.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';
import 'package:photopin/presentation/component/trip_with_chips.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

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
          Expanded(
            child: GroupedListView<PhotoModel, DateTime>(
              elements: photos,
              groupBy:
                  (photo) => DateTime(
                    photo.dateTime.year,
                    photo.dateTime.month,
                    photo.dateTime.day,
                  ),
              groupSeparatorBuilder:
                  (date) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Container(height: 1, color: AppColors.gray4),
                        ),
                        Text(
                          date.formDateString(),
                          style: AppFonts.smallTextRegular,
                        ),
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
              order: GroupedListOrder.ASC,
            ),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final MapState mapState;
  final void Function(MapAction) onAction;

  const MapScreen({super.key, required this.mapState, required this.onAction});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double _minHeight = 104;

  static const double _maxHeight = 400;

  Set<Marker> markers = {};

  double _sheetHeight = _maxHeight;

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    if (widget.mapState.photos != oldWidget.mapState.photos) {
      _preloadImagesForMarkers(
        widget.mapState.journal.id,
        widget.mapState.photos,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _preloadImagesForMarkers(
      widget.mapState.journal.id,
      widget.mapState.photos,
    );
    super.initState();
  }

  Future<void> _initMarkers(String journalId, List<PhotoModel> photos) async {
    Set<Marker> tempMarkers = {};

    if (photos.isEmpty) {
      setState(() {
        markers = {};
      });
      return;
    }
    BitmapDescriptor icon;

    for (int index = 0; index < photos.length; index++) {
      if (index == 0) {
        icon = await CustomMapMarker(
          imageUrl: photos[index].imageUrl,
          tooltip: 'Start',
        ).toBitmapDescriptor(
          logicalSize: const Size(60, 60),
          imageSize: const Size(180, 180),
        );
      } else if (index == photos.length - 1) {
        icon = await CustomMapMarker(
          imageUrl: photos[index].imageUrl,
          tooltip: 'End',
        ).toBitmapDescriptor(
          logicalSize: const Size(60, 60),
          imageSize: const Size(180, 180),
        );
      } else {
        icon = await CustomMapMarker(
          imageUrl: photos[index].imageUrl,
        ).toBitmapDescriptor(
          logicalSize: const Size(60, 60),
          imageSize: const Size(180, 180),
        );
      }
      tempMarkers.add(
        Marker(
          markerId: MarkerId(photos[index].id),
          position: LatLng(
            photos[index].location.latitude,
            photos[index].location.longitude,
          ),
          clusterManagerId: ClusterManagerId(journalId),
          consumeTapEvents: true,
          icon: icon,
          onTap:
              () => widget.onAction(MapAction.onPhotoClick(photos[index].id)),
        ),
      );
    }

    if (tempMarkers.isNotEmpty || markers.isNotEmpty) {
      setState(() {
        markers = tempMarkers;
      });
    }
  }

  void _onHandleDragEnd(DragEndDetails details) {
    // 반쯤 이상 펼쳐져 있으면 완전 확장, 아니면 접기
    final mid = (_maxHeight + _minHeight) / 2;
    setState(() {
      _sheetHeight = _sheetHeight >= mid ? _maxHeight : _minHeight;
    });
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _sheetHeight = (_sheetHeight - details.delta.dy).clamp(
        _minHeight,
        _maxHeight,
      );
    });
  }

  void _onHandleTap() {
    setState(() {
      _sheetHeight = _sheetHeight == _minHeight ? _maxHeight : _minHeight;
    });
  }

  Future<void> _preloadImagesForMarkers(
    String journalId,
    List<PhotoModel> photos,
  ) async {
    List<Future<void>> precacheFutures = [];

    for (PhotoModel photo in photos) {
      precacheFutures.add(precacheImage(NetworkImage(photo.imageUrl), context));
    }

    await Future.wait(precacheFutures);
    _initMarkers(journalId, photos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mapState.journal.name),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(child: const Icon(Icons.share)),
          ),
        ],
      ),
      bottomSheet:
          widget.mapState.journal.id != ''
              ? MapBottomDragWidget(
                sheetHeight: _sheetHeight,
                onHandleDragUpdate: _onHandleDragUpdate,
                onHandleDragEnd: _onHandleDragEnd,
                onHandleTap: _onHandleTap,
                photos: widget.mapState.photos,
                journal: widget.mapState.journal,
                onAction: widget.onAction,
              )
              : const SizedBox(),
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
                        markers: markers,
                        polylines: {
                          widget.mapState.journal.id:
                              widget.mapState.photos
                                  .map(
                                    (photo) => LatLng(
                                      photo.location.latitude,
                                      photo.location.longitude,
                                    ),
                                  )
                                  .toList(),
                        },
                        polyLineColor: AppColors.secondary100,
                      )
                      : const PhotoPinMap(
                        initialLocation: LatLng(37.5125, 127.1025),
                        initialZoomLevel: 16,
                        markers: {},
                        polylines: {},
                        polyLineColor: AppColors.marker70,
                      ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: TripWithChips(
                      tripWith: widget.mapState.journal.tripWith,
                      color: AppColors.primary80,
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
