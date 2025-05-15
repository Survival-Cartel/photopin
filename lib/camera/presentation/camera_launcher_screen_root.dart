import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photopin/core/enums/camera_stream_event.dart';
import 'package:photopin/camera/presentation/camera_view_model.dart';

class CameraLauncherScreenRoot extends StatefulWidget {
  final CameraViewModel viewModel;

  const CameraLauncherScreenRoot({super.key, required this.viewModel});

  @override
  State<StatefulWidget> createState() => _CameraLauncherScreenRootState();
}

class _CameraLauncherScreenRootState extends State<CameraLauncherScreenRoot> {
  StreamSubscription? _cameraEventStream;

  @override
  void initState() {
    super.initState();

    _cameraEventStream = widget.viewModel.eventStream.listen((
      CameraStreamEvent event,
    ) {
      if (mounted) {
        switch (event) {
          case CameraStreamEvent.done:
            context.pop();
          case CameraStreamEvent.cancel:
            context.pop();
        }
      }
    });

    mountCameraApp();
  }

  @override
  void dispose() {
    _cameraEventStream?.cancel();
    super.dispose();
  }

  void mountCameraApp() {
    widget.viewModel.launchCameraApp();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
