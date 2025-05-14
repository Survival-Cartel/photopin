import 'package:photopin/core/domain/compare_model.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/user/data/repository/user_repository.dart';
import 'package:photopin/user/domain/model/user_model.dart';

class GetCompareModelUseCase {
  final JournalRepository _journalRepository;
  final PhotoRepository _photoRepository;
  final UserRepository _userRepository;

  GetCompareModelUseCase({
    required JournalRepository journalRepository,
    required PhotoRepository photoRepository,
    required UserRepository userRepository,
  }) : _journalRepository = journalRepository,
       _photoRepository = photoRepository,
       _userRepository = userRepository;

  Future<CompareModel> execute({
    required String userId,
    required String journalId,
  }) async {
    final UserModel user = (await _userRepository.findOne(userId))!;
    final JournalModel journal = (await _journalRepository.findOne(journalId))!;
    final List<PhotoModel> photos = await _photoRepository
        .findPhotosByJournalId(journalId);

    return CompareModel(user: user, journal: journal, photos: photos);
  }
}
