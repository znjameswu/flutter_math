import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/render_box_offset.dart';
import 'custom_layout.dart';

/// I would like to use [CustomSingleChildLayout] provided by flutter
/// But that thing does not allow parent to depend on children. BS.
class ResetDimension extends StatelessWidget {
  final double height;
  final double depth;
  final double width;
  final double minTopPadding;
  final double minBottomPadding;
  final CrossAxisAlignment alignment;
  final Widget child;
  const ResetDimension({
    Key key,
    this.height,
    this.depth,
    this.width,
    this.minTopPadding,
    this.minBottomPadding,
    this.alignment = CrossAxisAlignment.center,
    @required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) => CustomLayout<int>(
        delegate: ResetDimensionLayoutDelegate(
          height: height,
          depth: depth,
          width: width,
          minTopPadding: minTopPadding,
          minBottomPadding: minBottomPadding,
          alignment: alignment,
        ),
        children: <Widget>[
          CustomLayoutId(id: 0, child: child),
        ],
      );
}

class ResetDimensionLayoutDelegate extends IntrinsicLayoutDelegate<int> {
  final double height;
  final double depth;
  final double width;
  final double minTopPadding;
  final double minBottomPadding;
  final CrossAxisAlignment alignment;
  ResetDimensionLayoutDelegate({
    Key key,
    @required this.height,
    @required this.depth,
    this.width,
    this.minTopPadding,
    this.minBottomPadding,
    this.alignment,
  });

  var distanceToBaseline = 0.0;

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<int, RenderBox> childrenTable) =>
      distanceToBaseline;

  @override
  AxisConfiguration<int> performIntrinsicLayout({
    Axis layoutDirection,
    double Function(RenderBox child) childSize,
    Map<int, RenderBox> childrenTable,
    bool isComputingIntrinsics,
  }) {
    if (layoutDirection == Axis.horizontal) {
      final childWidth = childSize(childrenTable[0]);
      final finalWidth = width ?? childWidth;
      var offset = 0.0;
      switch (alignment) {
        case CrossAxisAlignment.start:
          break;
        case CrossAxisAlignment.end:
          offset = finalWidth - childWidth;
          break;
        case CrossAxisAlignment.center:
        case CrossAxisAlignment.stretch:
        case CrossAxisAlignment.baseline:
        default:
          offset = (finalWidth - childWidth) / 2;
          break;
      }
      return AxisConfiguration(
        size: finalWidth,
        offsetTable: {0: offset},
      );
    } else {
      final childHeight = (isComputingIntrinsics
          ? childSize(childrenTable[0])
          : childrenTable[0].layoutHeight);
      final childDepth = childSize(childrenTable[0]) - childHeight;

      final finalHeight = math.max(
        height ?? childHeight,
        (minTopPadding ?? -double.infinity) + childHeight,
      );
      final finalDepth = math.max(
        depth ?? childDepth,
        (minBottomPadding ?? -double.infinity) + childDepth,
      );

      distanceToBaseline = finalHeight;
      return AxisConfiguration(
        size: finalHeight + finalDepth,
        offsetTable: {
          0: finalHeight - childHeight,
        },
      );
    }
  }
}
