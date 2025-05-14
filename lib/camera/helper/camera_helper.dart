import 'package:photopin/core/domain/image_data.dart';

abstract interface class CameraHelper {
  Future<ImageData?> launch();
}
