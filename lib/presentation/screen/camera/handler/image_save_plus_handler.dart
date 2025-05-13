import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:photopin/presentation/screen/camera/handler/image_save_handler.dart';

class ImageSavePlusHandler implements ImageSaveHandler {
  @override
  Future saveFile(String path) async {
    return await ImageGallerySaverPlus.saveFile(path);
  }
}
