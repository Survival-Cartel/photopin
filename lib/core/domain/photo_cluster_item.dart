import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class PhotoClusterItem with ClusterItem {
  final PhotoModel photo;

  PhotoClusterItem({required this.photo});

  @override
  LatLng get location =>
      LatLng(photo.location.latitude, photo.location.longitude);
}
