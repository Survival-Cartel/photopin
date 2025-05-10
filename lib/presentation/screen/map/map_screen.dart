import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapScreen extends StatelessWidget {
  final MapState mapState;
  final void Function(MapAction) onAction;

  const MapScreen({super.key, required this.mapState, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return PhotoPinMap(
      initialLocation: LatLng(
        mapState.photos.first.location.latitude,
        mapState.photos.first.location.longitude,
      ),
      initialZoomLevel: 13,
      markers: null,
      polylines: {},
      polyLineColor: null,
    );
  }
}
