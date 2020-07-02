import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

String svgStringFromPath(
        String path, Size viewPort, Rect viewBox, Color color) =>
    '<svg width= "${viewPort.width}" height="${viewPort.height}" '
    'viewBox="${viewBox.left} ${viewBox.top} '
    '${viewBox.width} ${viewBox.height}">'
    '<path fill="rgb(${color.red},${color.green},${color.blue})" d="$path"></path>'
    '</svg>';

Widget svgWidgetFromPath(String path, Size viewPort, Rect viewBox, Color color,
    [Alignment align = Alignment.topLeft, BoxFit fit = BoxFit.fill]) {
  final svgString = svgStringFromPath(path, viewPort, viewBox, color);
  return Container(
    height: viewPort.height,
    width: viewPort.width,
    child: SvgPicture.string(
      svgString,
      width: viewPort.width, // There is some funcky bug with futter_svg
      height: viewPort.height,
      fit: fit,
      alignment: align,
    ),
  );
}
