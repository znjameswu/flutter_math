import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/render_box_offset.dart';

class MinDimension extends SingleChildRenderObjectWidget {
  final double minHeight;
  final double minDepth;
  final double topPadding;
  final double bottomPadding;

  const MinDimension({
    Key key,
    this.minHeight = 0,
    this.minDepth = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderMinDimension createRenderObject(BuildContext context) =>
      RenderMinDimension(
        minHeight: minHeight,
        minDepth: minDepth,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
      );

  @override
  void updateRenderObject(
          BuildContext context, RenderMinDimension renderObject) =>
      renderObject
        ..minHeight = minHeight
        ..minDepth = minDepth
        ..topPadding = topPadding
        ..bottomPadding = bottomPadding;
}

class RenderMinDimension extends RenderProxyBox {
  RenderMinDimension({
    RenderBox child,
    double minHeight = 0,
    double minDepth = 0,
    double topPadding = 0,
    double bottomPadding = 0,
  })  : _minHeight = minHeight,
        _minDepth = minDepth,
        _topPadding = topPadding,
        _bottomPadding = bottomPadding,
        super(child);

  double get minHeight => _minHeight;
  double _minHeight;
  set minHeight(double value) {
    if (_minHeight != value) {
      _minHeight = value;
      markNeedsLayout();
    }
  }

  double get minDepth => _minDepth;
  double _minDepth;
  set minDepth(double value) {
    if (_minDepth != value) {
      _minDepth = value;
      markNeedsLayout();
    }
  }

  double get topPadding => _topPadding;
  double _topPadding;
  set topPadding(double value) {
    if (_topPadding != value) {
      _topPadding = value;
      markNeedsLayout();
    }
  }

  double get bottomPadding => _bottomPadding;
  double _bottomPadding;
  set bottomPadding(double value) {
    if (_bottomPadding != value) {
      _bottomPadding = value;
      markNeedsLayout();
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) => math.max(
        minHeight + minDepth,
        super.computeMinIntrinsicHeight(width) + topPadding + bottomPadding,
      );

  @override
  double computeMaxIntrinsicHeight(double width) => math.max(
        minHeight + minDepth,
        super.computeMaxIntrinsicHeight(width) + topPadding + bottomPadding,
      );

  var distanceToBaseline = 0.0;

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      distanceToBaseline;

  @override
  void performLayout() {
    child.layout(constraints, parentUsesSize: true);
    final childHeight = child.getDistanceToBaseline(TextBaseline.alphabetic);
    final childDepth = child.size.height - childHeight;
    final width = child.size.width;

    final height = math.max(minHeight, childHeight + topPadding);
    final depth = math.max(minDepth, childDepth + bottomPadding);

    child.offset = Offset(0, height - childHeight);
    size = constraints.constrain(Size(width, height + depth));
    distanceToBaseline = height;
  }
}