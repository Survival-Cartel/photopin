import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/core/domain/location.dart';
import 'package:photopin/core/enums/image_mime.dart';
import 'package:photopin/core/usecase/get_current_location_use_case.dart';
import 'package:photopin/core/usecase/get_place_name_use_case.dart';
import 'package:photopin/core/usecase/save_photo_use_case.dart';
import 'package:photopin/core/usecase/upload_file_in_storage_use_case.dart';
import 'package:photopin/photo/data/dto/photo_dto.dart';
import 'package:uuid/v4.dart';

class SavePictureInFirebaseUseCase {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final UploadFileInStorageUseCase _uploadFileInStorageUseCase;
  final GetPlaceNameUseCase _getPlaceNameUseCase;
  final SavePhotoUseCase _savePhotoUseCase;

  final UuidV4 uuid = const UuidV4();

  const SavePictureInFirebaseUseCase({
    required GetCurrentLocationUseCase getCurrentLocationUseCase,
    required UploadFileInStorageUseCase uploadFileInStorageUseCase,
    required GetPlaceNameUseCase getPlaceNameUseCase,
    required SavePhotoUseCase savePhotoUseCase,
  }) : _getCurrentLocationUseCase = getCurrentLocationUseCase,
       _uploadFileInStorageUseCase = uploadFileInStorageUseCase,
       _getPlaceNameUseCase = getPlaceNameUseCase,
       _savePhotoUseCase = savePhotoUseCase;

  Future<void> execute(BinaryData binaryData, ImageMime imageMime) async {
    final Location? location = await _getCurrentLocationUseCase.execute();

    if (location != null) {
      final String downloadUrl = await _uploadFileInStorageUseCase.execute(
        uuid.generate(),
        binaryData.bytes,
        imageMime,
      );

      final String placeName = await _getPlaceNameUseCase.execute(
        location: location,
      );

      PhotoDto dto = PhotoDto(
        name: placeName,
        imageUrl: downloadUrl,
        latitude: location.latitude,
        longitude: location.longitude,
        dateTimeMilli: DateTime.now().millisecondsSinceEpoch,
      );

      _savePhotoUseCase.execute(dto);
    }
  }
}
