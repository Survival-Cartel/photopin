import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart'
    as package;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/domain/integration_model.dart';
import 'package:photopin/core/domain/photo_cluster_item.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/custom_map_marker.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class IntegrationMap extends StatefulWidget {
  final List<IntegrationModel> models;
  final void Function(String photoId, bool isCompare) onPhotoClick;

  const IntegrationMap({
    super.key,
    required this.models,
    required this.onPhotoClick,
  });

  @override
  State<IntegrationMap> createState() => _IntegrationMapState();
}

class _IntegrationMapState extends State<IntegrationMap> {
  late package.ClusterManager<PhotoClusterItem> _clusterManager;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool _showPolyline = true;
  final double _showPolylineZoomLevel = 10;
  late LatLng _initialLatLng;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initialLatLng = _calculateInitialLocation(widget.models);
    _initClusterManager();
  }

  @override
  void didUpdateWidget(IntegrationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.models != oldWidget.models) {
      _updateClusterItems();
    }
  }

  /// 모든 사진의 평균 위치를 계산하여 초기 지도 중심점을 설정
  LatLng _calculateInitialLocation(List<IntegrationModel> models) {
    final List<PhotoModel> allPhotos =
        models.expand((model) => model.photos).toList();

    if (allPhotos.isEmpty) {
      return const LatLng(37.513, 127.1027);
    }

    final bool isCompare = widget.models.length > 1;

    if (isCompare) {
      final double avgLatitude =
          allPhotos
              .map((photo) => photo.location.latitude)
              .reduce((a, b) => a + b) /
          allPhotos.length;

      final double avgLongitude =
          allPhotos
              .map((photo) => photo.location.longitude)
              .reduce((a, b) => a + b) /
          allPhotos.length;

      return LatLng(avgLatitude, avgLongitude);
    }

    return LatLng(
      models.first.photos.first.location.latitude,
      models.first.photos.first.location.longitude,
    );
  }

  /// 클러스터 매니저 초기화
  void _initClusterManager() {
    final List<PhotoModel> photos =
        widget.models.expand((model) => model.photos).toList();
    final List<PhotoClusterItem> items =
        photos.map((p) => PhotoClusterItem(photo: p)).toList();

    _clusterManager = package.ClusterManager<PhotoClusterItem>(
      items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      stopClusteringZoom: _showPolylineZoomLevel,
    );
  }

  /// 클러스터 아이템 업데이트
  void _updateClusterItems() {
    final List<PhotoClusterItem> items =
        widget.models
            .expand((model) => model.photos)
            .map((photo) => PhotoClusterItem(photo: photo))
            .toList();

    _clusterManager.setItems(items);
  }

  /// 마커 생성 함수
  Future<Marker> Function(package.Cluster<PhotoClusterItem>)
  get _markerBuilder => (cluster) async {
    if (cluster.isMultiple) {
      return _buildClusterMarker(cluster);
    } else {
      return _buildPhotoMarker(cluster);
    }
  };

  /// 다중 사진 클러스터 마커 생성
  Future<Marker> _buildClusterMarker(
    package.Cluster<PhotoClusterItem> cluster,
  ) async {
    final BitmapDescriptor bmp = await _createClusterBitmap(cluster.count);

    return Marker(
      markerId: MarkerId(cluster.getId()),
      position: cluster.location,
      icon: bmp,
    );
  }

  /// 단일 사진 마커 생성
  Future<Marker> _buildPhotoMarker(
    package.Cluster<PhotoClusterItem> cluster,
  ) async {
    final PhotoModel photo = cluster.items.first.photo;
    final bool isCompare =
        widget.models.length > 1 && widget.models.last.photos.contains(photo);

    final BitmapDescriptor icon = await _createPhotoMarkerIcon(
      photo,
      isCompare,
    );

    return Marker(
      markerId: MarkerId(photo.id),
      position: cluster.location,
      icon: icon,
      consumeTapEvents: true,
      onTap: () => widget.onPhotoClick(photo.id, isCompare),
    );
  }

  /// 사진 마커 아이콘 생성
  Future<BitmapDescriptor> _createPhotoMarkerIcon(
    PhotoModel photo,
    bool isCompare,
  ) async {
    final Color outlineColor =
        isCompare ? AppColors.primary100 : AppColors.secondary100;
    final String tooltip = _getPhotoTooltip(photo);

    return CustomMapMarker(
      imageUrl: photo.imageUrl,
      outlineColor: outlineColor,
      tooltip: tooltip,
    ).toBitmapDescriptor(
      logicalSize: const Size(60, 60),
      imageSize: const Size(180, 180),
    );
  }

  /// 사진 툴팁 생성 (시작/끝 표시)
  String _getPhotoTooltip(PhotoModel photo) {
    if (widget.models.length > 1) {
      // 비교 모드
      if (photo.id == widget.models.last.photos.first.id) return 'Start';
      if (photo.id == widget.models.last.photos.last.id) return 'End';
    }

    // 기본 모드
    if (photo.id == widget.models.first.photos.first.id) return 'start';
    if (photo.id == widget.models.first.photos.last.id) return 'end';

    return '';
  }

  /// 클러스터 카운트를 원형 위젯으로 그려서 BitmapDescriptor로 변환
  Future<BitmapDescriptor> _createClusterBitmap(int count) async {
    final Widget countWidget = Container(
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

    return countWidget.toBitmapDescriptor();
  }

  /// 마커 업데이트 콜백
  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  /// 폴리라인 데이터 생성
  Map<String, List<LatLng>> _buildPolylines() {
    if (!_showPolyline) {
      return {};
    }

    return Map.fromEntries(
      widget.models.map(
        (model) => MapEntry(
          model.journal.id,
          model.photos
              .map(
                (photo) =>
                    LatLng(photo.location.latitude, photo.location.longitude),
              )
              .toList(),
        ),
      ),
    );
  }

  /// 카메라 이동 완료 시 줌 레벨에 따라 폴리라인 표시 여부 결정
  Future<void> _onCameraIdle() async {
    final GoogleMapController controller = await _controller.future;
    final double zoomLevel = await controller.getZoomLevel();

    setState(() {
      _showPolyline = zoomLevel >= _showPolylineZoomLevel;
    });

    _clusterManager.updateMap();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoPinMap(
      initialLocation: _initialLatLng,
      onMapCreated: (controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
          _clusterManager.setMapId(controller.mapId);
        }
      },
      onCameraMove: _clusterManager.onCameraMove,
      onCameraIdle: _onCameraIdle,
      initialZoomLevel: 8,
      markers: _markers,
      polylines: _buildPolylines(),
      polyLineColor: AppColors.secondary100,
    );
  }
}
