import 'package:photopin/core/domain/journal_photo_collection.dart';
import 'package:photopin/core/usecase/get_photo_journal_list_use_case.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'dart:async';

class WatchPhotoCollectionUseCase {
  final GetPhotoJournalListUseCase _getPhotoJournalListUseCase;

  WatchPhotoCollectionUseCase({
    required GetPhotoJournalListUseCase getPhotoJournalListUseCase,
  }) : _getPhotoJournalListUseCase = getPhotoJournalListUseCase;

  Stream<JournalPhotoCollection> execute() {
    final StreamController<JournalPhotoCollection> controller =
        StreamController<JournalPhotoCollection>();

    _getPhotoJournalListUseCase.execute().listen(
      (stream) {
        final Map<String, List<PhotoModel>> photoMap = stream.photos.fold(
          <String, List<PhotoModel>>{},
          (map, photo) {
            final journalId = photo.journalId;

            if (journalId != "N/A") {
              if (map.containsKey(journalId)) {
                map[journalId]!.add(photo);
              } else {
                map[journalId] = [photo];
              }
            }
            return map;
          },
        );

        final journalPhotoCollection = JournalPhotoCollection(
          journals: stream.journals,
          photoMap: photoMap,
        );

        controller.add(journalPhotoCollection);
      },
      onDone: () {
        controller.close();
      },
    );

    return controller.stream;
  }
}
