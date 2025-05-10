import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapScreen extends StatelessWidget {
  final MapState mapState;
  final void Function(MapAction) onAction;

  const MapScreen({super.key, required this.mapState, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          !mapState.isLoading
              ? PhotoPinMap(
                initialLocation: LatLng(
                  mapState.photos.first.location.latitude,
                  mapState.photos.first.location.longitude,
                ),
                initialZoomLevel: 16,
                markers:
                    mapState.photos.map((photo) {
                      return Marker(
                        markerId: MarkerId(photo.id),
                        position: LatLng(
                          photo.location.latitude,
                          photo.location.longitude,
                        ),
                        onTap: () {
                          onAction(MapAction.onPhotoClick(photo.id));
                        },
                      );
                    }).toSet(),
                polylines: {
                  mapState.journal.name:
                      mapState.photos
                          .map(
                            (photo) => LatLng(
                              photo.location.latitude,
                              photo.location.longitude,
                            ),
                          )
                          .toList(),
                },
                polyLineColor: AppColors.marker70,
              )
              : const CircularProgressIndicator(),
    );
  }
}
