import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class CameraLauncherScreen extends StatefulWidget {
  const CameraLauncherScreen({super.key});
  @override
  State<StatefulWidget> createState() => _CameraLauncherScreenState();
}

class _CameraLauncherScreenState extends State<CameraLauncherScreen> {
  @override
  void initState() {
    super.initState();
    // 위젯이 빌드되고나서 첫 프레임이 그려진 후에 비동기 작업을 예약
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchCameraAndSave();
    });
  }

  Future<void> _launchCameraAndSave() async {
    if (!mounted) return;

    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted || !photosStatus.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('카메라 또는 저장 권한이 필요합니다.')));
        context.pop();
      }
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      try {
        final result = await ImageGallerySaverPlus.saveFile(image.path);
        debugPrint("[Launcher] 갤러리 저장 결과: $result");

        if (result != null && result['isSuccess']) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('사진이 갤러리에 저장되었습니다.')));
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('사진 갤러리 저장 실패')));
          }
        }
      } catch (e) {
        debugPrint("[Launcher] 갤러리 저장 중 오류 발생: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사진 저장 중 오류: ${e.toString()}')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('사진 촬영이 취소되었습니다.')));
      }
    }

    // 촬영 성공, 저장 성공/실패, 또는 취소 여부와 관계없이 카메라 피커가 닫히면 다른 화면으로 이동
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
  }
}
