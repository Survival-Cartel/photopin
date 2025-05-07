import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photopin/location/domain/model/location_model.dart';

part 'photo_model.g.dart';
part 'photo_model.freezed.dart';

@freezed
abstract class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required String id,
    required String name,
    required DateTime dateTime,
    required String journalId,
    required String imageUrl,
    required LocationModel location,
    required String comment,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);
}
