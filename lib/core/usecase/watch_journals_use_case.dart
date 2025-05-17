import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class WatchJournalsUseCase {
  final JournalRepository _journalRepository;
  final PhotoRepository _photoRepository;

  const WatchJournalsUseCase({
    required JournalRepository journalRepository,
    required PhotoRepository photoRepository,
  }) : _journalRepository = journalRepository,
       _photoRepository = photoRepository;

  Stream<JournalPhotoCollection> execute() async* {
    await for (final journals in _journalRepository.watchJournals()) {
      final Map<String, List<PhotoModel>> photoMap = {};

      journals.sort((a, b) => a.startDate.compareTo(b.startDate));

      final photoFutures =
          journals.map((journal) async {
            final photos = await _photoRepository.findPhotosByJournalId(
              journal.id,
            );

            return MapEntry(journal.id, photos);
          }).toList();

      final photoEntries = await Future.wait(photoFutures);

      photoMap.addEntries(photoEntries);

      yield JournalPhotoCollection(journals: journals, photoMap: photoMap);
    }
  }
}
