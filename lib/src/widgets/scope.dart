import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'controller.dart';
import 'cursor_timer.dart';
import 'flutter_math.dart';

class FlutterMathScope extends ChangeNotifier {
  FlutterMathMode get mode => _mode;
  FlutterMathMode _mode;
  set mode(FlutterMathMode value) {
    if (_mode != value) {
      _mode = value;
      notifyListeners();
    }
  }

  FlutterMathController get controller => _controller;
  FlutterMathController _controller;
  set controller(FlutterMathController value) {
    if (_controller != value) {
      // _controller.removeListener(listener);
      _controller = value;
      // _controller.addListener(listener)
      notifyListeners();
    }
  }

  // TODO

  CursorTimer _cursorTimer;
  CursorTimer get cursorTimer => _cursorTimer;

  ValueNotifier<bool> get showCursor => cursorTimer.value;
}
