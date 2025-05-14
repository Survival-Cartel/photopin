import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photopin/camera/helper/camera_helper.dart';
import 'package:photopin/core/domain/image_data.dart';
import 'package:photopin/core/enums/image_mime.dart';

class ImagePickerCameraHelper implements CameraHelper {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<ImageData?> launch() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();

      final ImageData imageData = ImageData(
        bytes: imageBytes,
        mimeType: ImageMime.jpg,
        xFile: image,
      );

      return imageData;
    }

    return null;
  }
}
