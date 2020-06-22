import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ResetBaseline extends SingleChildRenderObjectWidget {
  final double height;
  const ResetBaseline({
    Key key,
    @required this.height,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderResetBaseline createRenderObject(BuildContext context) =>
      RenderResetBaseline();
}

class RenderResetBaseline extends RenderProxyBox {
  RenderResetBaseline({double height, RenderBox child})
      : _height = height,
        super(child);

  double get height => _height;
  double _height;
  set height(double value) {
    if (_height != value) {
      _height = value;
      markNeedsLayout();
    }
  }

  @override
  // ignore: avoid_returning_null
  double computeDistanceToActualBaseline(TextBaseline baseline) => height;
}
