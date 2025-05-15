import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as package;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/domain/photo_cluster_item.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/custom_map_marker.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/grouplist_photos_timeline_tile.dart';
import 'package:photopin/presentation/component/move_bottom_sheet.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/component/text_chip.dart';
import 'package:photopin/presentation/component/trip_with_chips.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapScreen extends StatefulWidget {
  final MapState mapState;
  final bool isShareScreen;
  final void Function(MapAction) onAction;

  const MapScreen({
    super.key,
    required this.mapState,
    required this.onAction,
    required this.isShareScreen,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late package.ClusterManager<PhotoClusterItem> _clusterManager;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool showPolyline = true;
  double showPolylineZoomLevel = 17;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initClusterManager(widget.mapState.photos);
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mapState.photos != oldWidget.mapState.photos) {
      _clusterManager.setItems(
        widget.mapState.photos.map((p) => PhotoClusterItem(photo: p)).toList(),
      );
    }
  }

  void _initClusterManager(List<PhotoModel> photos) {
    _clusterManager = package.ClusterManager<PhotoClusterItem>(
      photos.map((p) => PhotoClusterItem(photo: p)).toList(),
      _updateMarkers,
      markerBuilder: _markerBuilder,
      stopClusteringZoom: 18,
    );
  }

  Future<Marker> Function(package.Cluster<PhotoClusterItem>)
  get _markerBuilder => (cluster) async {
    if (cluster.isMultiple) {
      final bmp = await _createClusterBitmap(cluster.count);
      return Marker(
        markerId: MarkerId(cluster.getId()),
        position: cluster.location,
        icon: bmp,
      );
    } else {
      final photo = cluster.items.first.photo;
      final isFirst = photo.id == widget.mapState.photos.first.id;
      final isLast = photo.id == widget.mapState.photos.last.id;

      final icon = await CustomMapMarker(
        imageUrl: photo.imageUrl,
        tooltip:
            isFirst
                ? 'Start'
                : isLast
                ? 'End'
                : '',
      ).toBitmapDescriptor(
        logicalSize: const Size(60, 60),
        imageSize: const Size(180, 180),
      );
      return Marker(
        markerId: MarkerId(photo.id),
        position: cluster.location,
        consumeTapEvents: true,
        icon: icon,
        onTap: () => widget.onAction(MapAction.onPhotoClick(photo.id)),
      );
    }
  };

  // 클러스터 카운트를 원형 위젯으로 그려서 BitmapDescriptor 로 변환
  Future<BitmapDescriptor> _createClusterBitmap(int count) async {
    final widget = Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return widget.toBitmapDescriptor();
  }

  void _updateMarkers(Set<Marker> m) {
    setState(() {
      markers = m; // 기존 필드를 대체
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mapState.journal.name),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        actions:
            !(widget.isShareScreen)
                ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      child: const Icon(Icons.share),
                      onTap: () {
                        widget.onAction(
                          MapAction.onShareClick(widget.mapState.journal.id),
                        );
                      },
                    ),
                  ),
                ]
                : null,
      ),
      bottomSheet:
          widget.mapState.journal.id != ''
              ? MoveBottomSheet(
                body: MapBottomDragWidget(
                  photos: widget.mapState.photos,
                  journal: widget.mapState.journal,
                  onAction: widget.onAction,
                ),
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
                        onMapCreated: (controller) {
                          if (!_controller.isCompleted) {
                            _controller.complete(controller);
                            _clusterManager.setMapId(controller.mapId);
                          }
                        },
                        onCameraMove: _clusterManager.onCameraMove,
                        onCameraIdle: () async {
                          final double zoomLevel =
                              await (await _controller.future).getZoomLevel();
                          if (zoomLevel >= showPolylineZoomLevel) {
                            setState(() {
                              showPolyline = true;
                            });
                          } else {
                            setState(() {
                              showPolyline = false;
                            });
                          }
                          _clusterManager.updateMap();
                        },
                        initialZoomLevel: 16,
                        markers: markers,
                        polylines:
                            showPolyline
                                ? {
                                  widget.mapState.journal.id:
                                      widget.mapState.photos
                                          .map(
                                            (photo) => LatLng(
                                              photo.location.latitude,
                                              photo.location.longitude,
                                            ),
                                          )
                                          .toList(),
                                }
                                : {},
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

class MapBottomDragWidget extends StatelessWidget {
  final void Function(MapAction) onAction;
  final List<PhotoModel> photos;
  final JournalModel journal;

  const MapBottomDragWidget({
    super.key,
    required this.photos,
    required this.journal,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
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
          child: GrouplistPhotosTimelineTile(
            photos: photos,
            onTap: (id) => onAction(MapAction.onPhotoClick(id)),
          ),
        ),
      ],
    );
  }
}
