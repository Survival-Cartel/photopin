import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:photopin/core/stream_event/stream_event.dart';

abstract class EventNotifier with ChangeNotifier {
  StreamController<StreamEvent> streamController;

  EventNotifier({
    required this.streamController,
  });

  void addEvent(StreamEvent event) {
    streamController.add(event);
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }


}