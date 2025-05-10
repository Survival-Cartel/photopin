import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
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
  @override
  Widget build(BuildContext context) {
    return widget.mapState.journal.id != ''
        ? PhotoPinMap(
          initialLocation:
              widget.mapState.photos.isNotEmpty
                  ? LatLng(
                    widget.mapState.photos.first.location.latitude,
                    widget.mapState.photos.first.location.longitude,
                  )
                  : const LatLng(37.5125, 127.1025),
          initialZoomLevel: 16,
          markers:
              widget.mapState.photos.isNotEmpty
                  ? widget.mapState.photos
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
                      .toSet()
                  : {},
          polylines:
              widget.mapState.photos.isNotEmpty
                  ? {
                    widget.mapState.journal.name:
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
          polyLineColor: AppColors.marker70,
        )
        : const Center(child: CircularProgressIndicator());
  }
}
