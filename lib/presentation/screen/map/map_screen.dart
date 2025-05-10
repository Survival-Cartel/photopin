import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/date_range_slider.dart';
import 'package:photopin/presentation/component/photopin_map.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';
import 'package:photopin/presentation/screen/map/map_action.dart';
import 'package:photopin/presentation/screen/map/map_state.dart';

class MapScreen extends StatelessWidget {
  final MapState mapState;
  final void Function(MapAction) onAction;

  const MapScreen({super.key, required this.mapState, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mapState.journal.name), centerTitle: true),
      body:
          !mapState.isLoading
              ? SafeArea(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PhotoPinMap(
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
                    ),

                    DraggableScrollableSheet(
                      initialChildSize: 0.4, // 초기 높이 (화면의 40%)
                      minChildSize: 0.05, // 최소 높이 (드래그 핸들만 보이는 상태)
                      maxChildSize: 0.4, // 최대 높이 (화면의 80%)
                      builder: (
                        BuildContext context,
                        ScrollController scrollController,
                      ) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 40,
                                height: 5,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2.5),
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  controller: scrollController,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  children: [
                                    DateRangeSlider(
                                      startDate: mapState.journal.startDate,
                                      endDate: mapState.journal.endDate,
                                      onChanged:
                                          (
                                            DateTime startDate,
                                            DateTime endDate,
                                          ) {},
                                    ),
                                    const SizedBox(height: 8),
                                    ...mapState.photos.map((photo) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: TimeLineTile(
                                          dateTime: photo.dateTime,
                                          title: photo.name,
                                          imageUrl: photo.imageUrl,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
