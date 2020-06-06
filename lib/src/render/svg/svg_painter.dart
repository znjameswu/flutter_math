import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgPainter extends CustomPainter {
  const SvgPainter(this.svg);

  final DrawableRoot svg;
  @override
  void paint(Canvas canvas, Size size) {
    // svg.clipCanvasToViewBox(canvas)
    // svg.scaleCanvasToViewBox(canvas, );
    svg.clipCanvasToViewBox(canvas);
    svg.draw(canvas, null);
  }

  @override
  bool shouldRepaint(SvgPainter oldDelegate) => oldDelegate.svg != this.svg;
}

class SvgPaint extends StatelessWidget {
  const SvgPaint({
    Key key,
    this.svg,
    this.fit = BoxFit.fitHeight,
    this.alignment = Alignment.topLeft,
  }) : super(key: key);

  final DrawableRoot svg;

  final AlignmentGeometry alignment;

  final BoxFit fit;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: fit,
        alignment: alignment,
        child: SizedBox(
          height: svg.viewport.height,
          width: svg.viewport.width,
          child: CustomPaint(painter: SvgPainter(svg)),
        ),
      );
}
