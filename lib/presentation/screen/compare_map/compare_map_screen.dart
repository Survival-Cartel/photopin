import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as package;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/domain/integration_model.dart';
import 'package:photopin/core/domain/photo_cluster_item.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/compare_card.dart';
import 'package:photopin/presentation/component/custom_map_marker.dart';
import 'package:photopin/presentation/component/grouplist_photos_timeline_tile.dart';
import 'package:photopin/presentation/component/photopin_head.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_action.dart';
import 'package:photopin/presentation/screen/compare_map/compare_map_state.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class CompareMapScreen extends StatefulWidget {
  final CompareMapState state;
  final void Function(CompareMapAction action) onAction;
  const CompareMapScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<CompareMapScreen> createState() => _CompareMapScreenState();
}

class _CompareMapScreenState extends State<CompareMapScreen> {
  static const double _minHeight = 160;

  late package.ClusterManager<PhotoClusterItem> _clusterManager;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool showPolyline = true;
  double showPolylineZoomLevel = 17;

  static const double _maxHeight = 400;

  Set<Marker> markers = {};

  double _sheetHeight = _maxHeight;

  @override
  void initState() {
    super.initState();
    _initClusterManager([
      ...widget.state.sharedData.photos,
      ...widget.state.myData.photos,
    ]);
  }

  @override
  void didUpdateWidget(CompareMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.sharedData.photos != oldWidget.state.myData.photos) {
      _clusterManager.setItems([
        ...widget.state.sharedData.photos.map(
          (p) => PhotoClusterItem(photo: p),
        ),
        ...widget.state.myData.photos.map((p) => PhotoClusterItem(photo: p)),
      ]);
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
      final isCompare = widget.state.sharedData.photos.contains(photo);

      final isFirst = photo.id == widget.state.sharedData.photos.first.id;
      final isLast = photo.id == widget.state.sharedData.photos.last.id;

      final isMyFirst = photo.id == widget.state.myData.photos.first.id;
      final isMYLast = photo.id == widget.state.myData.photos.last.id;

      final icon = await CustomMapMarker(
        imageUrl: photo.imageUrl,
        outlineColor: isCompare ? AppColors.primary100 : AppColors.secondary100,
        tooltip:
            isFirst
                ? 'Start'
                : isLast
                ? 'End'
                : isMyFirst
                ? 'start'
                : isMYLast
                ? 'end'
                : '',
      ).toBitmapDescriptor(
        logicalSize: const Size(60, 60),
        imageSize: const Size(180, 180),
      );
      return Marker(
        markerId: MarkerId(photo.id),
        position: cluster.location,
        icon: icon,
        // onTap: () => widget.onAction(MapAction.onPhotoClick(photo.id)),
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

  void _onHandleDragEnd(DragEndDetails details) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PhotopinHead(),
        centerTitle: true,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      bottomSheet:
          widget.state.sharedData.journal.id != ''
              ? MapBottomDragWidget(
                sheetHeight: _sheetHeight,
                onHandleDragUpdate: _onHandleDragUpdate,
                onHandleDragEnd: _onHandleDragEnd,
                onHandleTap: _onHandleTap,
                onAction: widget.onAction,
                sharedModel: widget.state.sharedData,
                myModel: widget.state.myData,
              )
              : const SizedBox(),
      body:
          widget.state.sharedData.journal.id != ''
              ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  widget.state.sharedData.photos.isNotEmpty
                      ? PhotoPinMap(
                        initialLocation: LatLng(
                          widget
                              .state
                              .sharedData
                              .photos
                              .first
                              .location
                              .latitude,
                          widget
                              .state
                              .sharedData
                              .photos
                              .first
                              .location
                              .longitude,
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
                                  widget.state.myData.journal.id:
                                      widget.state.myData.photos
                                          .map(
                                            (photo) => LatLng(
                                              photo.location.latitude,
                                              photo.location.longitude,
                                            ),
                                          )
                                          .toList(),
                                  widget.state.sharedData.journal.id:
                                      widget.state.sharedData.photos
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
                    child: Container(
                      width: 170,
                      height: 76,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.white,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LineInfo(
                            info: 'My Routes',
                            color: AppColors.secondary100,
                          ),
                          _LineInfo(
                            info: 'Shared Routes',
                            color: AppColors.primary100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _LineInfo extends StatelessWidget {
  final String info;
  final Color color;
  const _LineInfo({required this.info, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Container(width: 16, height: 3, color: color),
        Text(info, style: AppFonts.smallTextRegular),
      ],
    );
  }
}

class MapBottomDragWidget extends StatelessWidget {
  final double sheetHeight;
  final void Function(DragUpdateDetails details) onHandleDragUpdate;
  final void Function(DragEndDetails details) onHandleDragEnd;
  final void Function() onHandleTap;
  final void Function(CompareMapAction) onAction;
  final IntegrationModel sharedModel;
  final IntegrationModel myModel;

  const MapBottomDragWidget({
    super.key,
    required this.sheetHeight,
    required this.onHandleDragUpdate,
    required this.onHandleDragEnd,
    required this.onHandleTap,
    required this.onAction,
    required this.sharedModel,
    required this.myModel,
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
          Expanded(
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CompareCard(
                          profileImageUrl: myModel.user.profileImg,
                          nameString: myModel.user.displayName,
                          journal: myModel.journal,
                          color: AppColors.secondary100,
                          photoString: '${myModel.photos.length} Photos',
                        ),
                      ),
                      Expanded(
                        child: GrouplistPhotosTimelineTile(
                          photos: myModel.photos,
                          onTap: (id) {},
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: CompareCard(
                          profileImageUrl: sharedModel.user.profileImg,
                          nameString: sharedModel.user.displayName,
                          journal: sharedModel.journal,
                          color: AppColors.primary100,
                          photoString: '${sharedModel.photos.length} Photos',
                        ),
                      ),
                      Expanded(
                        child: GrouplistPhotosTimelineTile(
                          photos: sharedModel.photos,
                          onTap: (id) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
