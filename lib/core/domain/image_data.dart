import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:photopin/core/enums/image_mime.dart';

class ImageData {
  final Uint8List bytes;
  final ImageMime mimeType;
  final XFile xFile;

  const ImageData({
    required this.bytes,
    required this.mimeType,
    required this.xFile,
  });
}
