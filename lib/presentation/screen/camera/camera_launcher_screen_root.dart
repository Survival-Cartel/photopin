import 'package:flutter/material.dart';
import 'package:photopin/presentation/screen/camera/camera_view_model.dart';

class CameraLauncherScreenRoot extends StatefulWidget {
  final CameraViewModel viewModel;

  const CameraLauncherScreenRoot({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() => _CameraLauncherScreenRootState();
}

class _CameraLauncherScreenRootState extends State<CameraLauncherScreenRoot> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.launchCameraApp();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
