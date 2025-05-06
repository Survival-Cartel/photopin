import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'photo_model.freezed.dart';

@freezed
abstract class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required String id,
    required String name,
    required DateTime dateTime,
    required String journalId,
    required String imageUrl,
    required LatLng location,
    required String comment,
  }) = _PhotoModel;
}
