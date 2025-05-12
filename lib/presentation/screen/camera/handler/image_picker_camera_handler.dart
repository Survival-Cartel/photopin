import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photopin/core/domain/binary_data.dart';
import 'package:photopin/presentation/screen/camera/handler/camera_handler.dart';

class ImagePickerCameraHandler implements CameraHandler {
  final ImagePicker _imagePicker = ImagePicker();

  ImagePickerCameraHandler();

  @override
  Future<BinaryData?> launch() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);

    debugPrint('MIME TYPE ::: ${image?.mimeType}');
    debugPrint('NAME ::: ${image?.name}');

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();

      final BinaryData binary = BinaryData(bytes: imageBytes, mimeType: 'jpg');

      final result = await ImageGallerySaverPlus.saveFile(image.path);
      debugPrint("[Launcher] 갤러리 저장 결과: $result");
      return binary;
    } else {
      debugPrint("[Launcher] 사진 촬영 취소");
      return null;
    }
  }
}
