import 'dart:typed_data';

class BinaryData {
  final Uint8List bytes;
  final String mimeType;

  const BinaryData({required this.bytes, required this.mimeType});
}
