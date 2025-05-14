import 'package:photopin/core/domain/binary_data.dart';

abstract interface class CameraHandler {
  Future<BinaryData?> launch();
}
