import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class GetJournalListUseCase {
  final JournalRepository _journalRepository;
  final PhotoRepository _photoRepository;

  const GetJournalListUseCase({
    required JournalRepository journalRepository,
    required PhotoRepository photoRepository,
  }) : _journalRepository = journalRepository,
       _photoRepository = photoRepository;

  Future<JournalPhotoCollection> execute() async {
    List<JournalModel> journals = await _journalRepository.findAll();

    final Map<String, List<PhotoModel>> photoMap = {};

    for (final journal in journals) {
      final List<PhotoModel> photos = await _photoRepository
          .findPhotosByJournalId(journal.id);

      photoMap[journal.id] = photos;
    }

    return JournalPhotoCollection(journals: journals, photoMap: photoMap);
  }
}
