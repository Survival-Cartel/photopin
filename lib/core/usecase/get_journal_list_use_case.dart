import 'package:photopin/journal/domain/model/journal_model.dart';

class GetJournalListUseCase {
  GetJournalListUseCase();

  // TODO: 추후에 Repository로 동작하도록 변경
  final List<JournalModel> journalModelFixtures = [
    JournalModel(
      id: '1',
      name: 'Spain Sagrada Famillia',
      comment: 'Nice',
      startDateMilli: DateTime(2025, 05, 04, 12, 11, 13).millisecondsSinceEpoch,
      endDateMilli: DateTime(2025, 05, 05, 13, 34, 23).millisecondsSinceEpoch,
      tripWith: [],
    ),
    JournalModel(
      id: '2',
      name: 'Seoul',
      comment: 'Nice',
      startDateMilli: DateTime(2025, 05, 06, 14, 25, 33).millisecondsSinceEpoch,
      endDateMilli: DateTime(2025, 05, 08, 19, 27, 23).millisecondsSinceEpoch,
      tripWith: [],
    ),
    JournalModel(
      id: '3',
      name: 'Tokyo Trip',
      comment: 'Nice',
      startDateMilli: DateTime(2025, 05, 09, 12).millisecondsSinceEpoch,
      endDateMilli: DateTime(2025, 05, 09, 18).millisecondsSinceEpoch,
      tripWith: [],
    ),
    JournalModel(
      id: '4',
      name: 'Toronto Travel',
      comment: 'Nice',
      startDateMilli: DateTime(2025, 05, 10, 18).millisecondsSinceEpoch,
      endDateMilli: DateTime(2025, 05, 12, 22, 38, 20).millisecondsSinceEpoch,
      tripWith: [],
    ),
  ];

  Future<List<JournalModel>> execute() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return journalModelFixtures;
  }
}
