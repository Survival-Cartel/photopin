import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // 🔑 권한 패키지 추가

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kSeoulCenter = CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울시청
    zoom: 14.0,
  );

  static const CameraPosition _kLotteTower = CameraPosition(
    bearing: 90.0,
    target: LatLng(37.5130, 127.1025), // 잠실 롯데타워
    tilt: 45.0,
    zoom: 17.0,
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // ✅ 위치 권한 요청
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
        initialCameraPosition: _kSeoulCenter,
        myLocationEnabled: true,        // ✅ 내 위치 파란 점
        myLocationButtonEnabled: true,  // ✅ 오른쪽 버튼 표시
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToLotteTower,
        label: const Text('Go to Lotte Tower'),
        icon: const Icon(Icons.location_city),
      ),
    );
  }

  Future<void> _goToLotteTower() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLotteTower));
  }
}
