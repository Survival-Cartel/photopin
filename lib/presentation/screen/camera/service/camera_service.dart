import 'package:photopin/core/domain/binary_data.dart';

abstract interface class CameraService {
  Future<BinaryData?> launch();
}
