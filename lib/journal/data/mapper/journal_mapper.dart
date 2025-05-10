import 'package:photopin/journal/data/dto/journal_dto.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

extension JournalMapper on JournalDto {
  JournalModel toModel() {
    return JournalModel(
      id: id ?? 'N/A',
      startDateMilli: startDateMilli ?? 0,
      endDateMilli: endDateMilli ?? 0,
      tripWith: tripWith ?? [],
      name: name ?? 'N/A',
      comment: comment ?? 'N/A',
    );
  }
}

extension JournalModelMapper on JournalModel {
  JournalDto toDto() {
    return JournalDto(
      id: id,
      name: name,
      startDateMilli: startDateMilli,
      endDateMilli: endDateMilli,
      tripWith: tripWith,
      comment: comment,
    );
  }
}
