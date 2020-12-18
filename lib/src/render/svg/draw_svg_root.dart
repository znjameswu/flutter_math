import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

void drawSvgRoot(DrawableRoot svgRoot, PaintingContext context, Offset offset) {
  final canvas = context.canvas;
  canvas.save();
  canvas.translate(offset.dx, offset.dy);
  canvas.scale(
    svgRoot.viewport.width / svgRoot.viewport.viewBox.width,
    svgRoot.viewport.height / svgRoot.viewport.viewBox.height,
  );
  canvas.clipRect(Rect.fromLTWH(0.0, 0.0, svgRoot.viewport.viewBox.width,
      svgRoot.viewport.viewBox.height));
  svgRoot.draw(canvas, Rect.largest);
  canvas.restore();
}
