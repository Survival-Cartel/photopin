import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:photopin/core/stream_event/stream_event.dart';

mixin EventNotifier on ChangeNotifier {
  late StreamController<StreamEvent> streamController;

  void initStreamController(StreamController<StreamEvent> event) {
    streamController = event;
  }

  void addEvent(StreamEvent event) {
    streamController.add(event);
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}
