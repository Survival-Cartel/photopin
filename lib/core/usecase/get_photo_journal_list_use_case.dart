import 'package:photopin/core/domain/photo_journal_list_model.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:rxdart/rxdart.dart';

class GetPhotoJournalListUseCase {
  final JournalRepository _journalRepository;
  final PhotoRepository _photoRepository;

  const GetPhotoJournalListUseCase({
    required JournalRepository journalRepository,
    required PhotoRepository photoRepository,
  }) : _journalRepository = journalRepository,
       _photoRepository = photoRepository;

  Stream<PhotoJournalListModel> execute() {
    final journalsStream = _journalRepository.watchJournals();
    final photosStream = _photoRepository.watchPhotos();

    return Rx.combineLatest2(journalsStream, photosStream, (
      List<JournalModel> journals,
      List<PhotoModel> photos,
    ) {
      return PhotoJournalListModel(journals: journals, photos: photos);
    });
  }
}
