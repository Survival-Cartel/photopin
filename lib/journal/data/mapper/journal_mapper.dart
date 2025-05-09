import 'package:photopin/journal/data/dto/journal_dto.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';

extension JournalMapper on JournalDto {
  JournalModel toModel() {
    return JournalModel(
      id: id ?? 'N/A',
      startDate: startDate ?? DateTime(1999, 1, 1),
      endDate: endDate ?? DateTime(1999, 1, 1),
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
      startDate: startDate,
      endDate: endDate,
      tripWith: tripWith,
      comment: comment,
    );
  }
}
