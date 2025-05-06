import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

part 'journal_model.freezed.dart';
part 'journal_model.g.dart';

@freezed
abstract class JournalModel with _$JournalModel {
  const factory JournalModel({
    required String id,
    required String name,
    required List<String> tripWith,
    required DateTime startDate,
    required DateTime endDate,
    required List<PhotoModel> photos,
    required String comment,
  }) = _JournalModel;
}
