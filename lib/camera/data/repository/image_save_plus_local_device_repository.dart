import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:photopin/camera/data/repository/local_device_repository.dart';

class ImageSavePlusLocalDeviceRepository implements LocalDeviceRepository {
  @override
  Future<void> saveFile(String path) async {
    await ImageGallerySaverPlus.saveFile(path);
  }
}
