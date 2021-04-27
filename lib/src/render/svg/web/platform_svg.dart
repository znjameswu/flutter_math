import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/canvas_kit/canvas_kit.dart';
import 'fake_flutter_svg.dart'
    if (dart.library.io) 'package:flutter_svg/svg.dart';
import 'fake_html.dart' if (dart.library.html) 'dart:html' as html;
import 'fake_ui.dart' if (dart.library.html) 'dart:ui' as ui;

// ignore: avoid_classes_with_only_static_members
class PlatformSvg {
  static final Random _random = Random();

  /// Returns an SVG widget based on the current platform.
  ///
  /// If [forcePlatformView] is `true`, an [HtmlElementView] will be used
  /// on web, even when on CanvasKit.
  static Widget string(
    String svgString, {
    double width = 24,
    double height = 24,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    String? hashCode,
    bool forcePlatformView = false,
  }) {
    if (kIsWeb && (!isCanvasKit || forcePlatformView)) {
      hashCode ??= String.fromCharCodes(
          List<int>.generate(128, (i) => _random.nextInt(256)));
      ui.platformViewRegistry.registerViewFactory('img-svg-$hashCode',
          (int viewId) {
        // final base64 = base64Encode(utf8.encode(svgString));
        // final base64String = 'data:image/svg+xml;base64,$base64';
        final utf8String = 'data:image/svg+xml;utf8,$svgString';
        final element = html.ImageElement(
          // src: base64String,
          src: utf8String,
          width: width.toInt(),
          height: height.toInt(),
        );
        element.style.verticalAlign = 'top';
        return element;
      });
      // return Container(
      //   width: width,
      //   height: width,
      //   alignment: Alignment.center,
      //   child:
      return HtmlElementView(
        viewType: 'img-svg-$hashCode',
        // ),
      );
    }
    return SvgPicture.string(
      svgString,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}
