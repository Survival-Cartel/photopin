import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class GetPhotoListWithJournalIdUseCase {
  final PhotoRepository _photoRepository;

  GetPhotoListWithJournalIdUseCase({required PhotoRepository photoRepository})
    : _photoRepository = photoRepository;

  Future<List<PhotoModel>> execute(String journalId) async {
    return await _photoRepository.findPhotosByJournalId(journalId);
  }
}
