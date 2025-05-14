import 'dart:typed_data';

import 'package:photopin/core/enums/image_mime.dart';

class BinaryData {
  final Uint8List bytes;
  final ImageMime mimeType;

  const BinaryData({required this.bytes, required this.mimeType});
}
