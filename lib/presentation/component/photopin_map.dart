import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// todo: 모델 클래스 생성 후 업데이트
/// [initialZoomLevel] 의 경우 맵이 생성 될 때의 줌 정도를 나타냅니다. 값이 클 수록 확대가 됩니다.
/// 현재 map 의 경우 모델 클래스가 없어 복잡한 인자를 받지 못하는 상태입니다.
/// 모델 클래스 생성 후 업데이트 될 예정입니다.
class PhotoPinMap extends StatefulWidget {
  final LatLng initialLocation;
  final double initialZoomLevel;
  final Set<Marker> markers;
  final Map<String, List<LatLng>> polylines;
  final Color polyLineColor;

  const PhotoPinMap({
    super.key,
    required this.initialLocation,
    required this.initialZoomLevel,
    required this.markers,
    required this.polylines,
    required this.polyLineColor,
  });

  @override
  State<PhotoPinMap> createState() => PhotoPinMapState();
}

class PhotoPinMapState extends State<PhotoPinMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Polyline> _wholePolylines = {};
  bool showPolyline = true;
  double showPolylineZoomLevel = 18;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.markers != oldWidget.markers) {
      _getPolyLines(widget.polylines);
    }

    super.didUpdateWidget(oldWidget);
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  void _getPolyLines(Map<String, List<LatLng>> polylines) {
    Set<Polyline> remotePolylines =
        polylines.keys.map((id) {
          return Polyline(
            polylineId: PolylineId(id),
            points: widget.polylines[id]!,
            color: widget.polyLineColor,
            width: 6,
          );
        }).toSet();

    setState(() {
      _wholePolylines = remotePolylines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation,
          zoom: widget.initialZoomLevel,
        ),
        myLocationEnabled: true, // ✅ 내 위치 파란 점
        myLocationButtonEnabled: true, // ✅ 오른쪽 버튼 표시
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        buildingsEnabled: false,
        clusterManagers:
            widget.polylines.keys.map((id) {
              return ClusterManager(clusterManagerId: ClusterManagerId(id));
            }).toSet(),
        polylines: showPolyline ? _wholePolylines : {},
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
        },
        markers: widget.markers,
      ),
    );
  }
}
