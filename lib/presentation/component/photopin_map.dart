import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photopin/core/styles/app_color.dart';

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
  final Color comparePolylineColor;
  final void Function(GoogleMapController)? onMapCreated;
  final void Function()? onCameraIdle;
  final void Function(CameraPosition)? onCameraMove;

  const PhotoPinMap({
    super.key,
    required this.initialLocation,
    required this.initialZoomLevel,
    required this.markers,
    required this.polylines,
    required this.polyLineColor,
    this.onMapCreated,
    this.onCameraIdle,
    this.onCameraMove,
    this.comparePolylineColor = AppColors.primary80,
  });

  @override
  State<PhotoPinMap> createState() => PhotoPinMapState();
}

class PhotoPinMapState extends State<PhotoPinMap> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
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
        onMapCreated: widget.onMapCreated,
        buildingsEnabled: false,
        polylines:
            List.generate(widget.polylines.keys.length, (index) {
              if (index == 0) {
                return Polyline(
                  polylineId: PolylineId(
                    widget.polylines.keys.elementAt(index),
                  ),
                  points:
                      widget.polylines[widget.polylines.keys.elementAt(index)]!,
                  color: widget.polyLineColor,
                  width: 6,
                );
              } else {
                return Polyline(
                  polylineId: PolylineId(
                    widget.polylines.keys.elementAt(index),
                  ),
                  points:
                      widget.polylines[widget.polylines.keys.elementAt(index)]!,
                  color: widget.comparePolylineColor,
                  width: 6,
                );
              }
            }).toSet(),
        onCameraMove: widget.onCameraMove,
        onCameraIdle: () async {
          widget.onCameraIdle?.call();
        },
        markers: widget.markers,
      ),
    );
  }
}
