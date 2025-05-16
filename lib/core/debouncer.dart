import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Timer? _timer;
  final int milliseconds;

  Debouncer({required this.milliseconds, Timer? timer}) : _timer = timer;

  void execute(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), () => action());
  }

  void dispose() {
    _timer?.cancel();
  }
}
