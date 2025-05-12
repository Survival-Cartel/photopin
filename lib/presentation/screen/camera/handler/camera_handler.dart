import 'package:flutter/services.dart';

abstract interface class CameraHandler {
  Future<Uint8List?> launch();
}
