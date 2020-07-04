import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ScreenShot extends StatelessWidget {
  final String name;
  final GlobalKey screenshotKey;
  final Widget child;

  const ScreenShot({
    Key key,
    @required this.screenshotKey,
    @required this.name,
    @required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => RepaintBoundary(
        key: screenshotKey,
        child: child,
      );

  void takeScreenShot() async {
    final boundary = screenshotKey.currentContext.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final directory = Directory.current;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    final imgFile = File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
  }
}
