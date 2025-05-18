import 'dart:async';

import 'package:photopin/core/enums/action_type.dart';
import 'package:photopin/core/enums/error_type.dart';
import 'package:photopin/core/stream_event/stream_event.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:photopin/photo/data/mapper/photo_mapper.dart';
import 'package:photopin/photo/data/repository/photo_repository.dart';

class SavePhotoUseCase {
  final PhotoRepository _photoRepository;
  final StreamController<StreamEvent> streamController;

  const SavePhotoUseCase(this._photoRepository, this.streamController);

  Future<void> execute(PhotoDto dto) async {
    try {
      await _photoRepository.savePhoto(dto.toModel());
      streamController.add(const StreamEvent.success(ActionType.photoSave));
    } catch (e) {
      streamController.add(const StreamEvent.error(ErrorType.photoSave));
    }
  }
}
