import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  // 위치 정보 권한 확인 및 현재 위치 가져오기
  Future<Position?> _determinePosition() async {
    debugPrint('[Geolocator] 위치 권한 확인 시작');
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 상태 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('[Geolocator] 위치 서비스 비활성화됨.');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('위치 서비스가 꺼져 있습니다.')));
      }
      return null;
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('위치 정보 접근 권한이 거부되었습니다.')),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('[Geolocator] 위치 권한 영구 거부됨.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 권한이 영구 거부되었습니다. 설정에서 변경해주세요.')),
        );
      }

      // TODO: 설정에서 권한 변경
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();

      debugPrint(
        '[Geolocator] 현재 위치 획득: ${position.latitude}, ${position.longitude}',
      );

      return position;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('위치 가져오기 오류: ${e.toString()}')));
      }

      return null;
    }
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

    Position? position = await _determinePosition();

    debugPrint('[Launcher] Position: $position');

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
