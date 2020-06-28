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
  final CrossAxisAlignment alignment;
  final Widget child;
  ResetDimension({
    Key key,
    this.height,
    this.depth,
    this.width,
    this.alignment = CrossAxisAlignment.center,
    @required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) => CustomLayout<int>(
        delegate: ResetDimensionLayoutDelegate(
          height: height,
          depth: depth,
          width: width,
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
  final CrossAxisAlignment alignment;
  ResetDimensionLayoutDelegate({
    Key key,
    @required this.height,
    @required this.depth,
    this.width,
    this.alignment,
  });

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<int, RenderBox> childrenTable) =>
      height;

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

      final finalHeight = height ?? childHeight;
      final finalDepth = depth ?? childDepth;
      return AxisConfiguration(
        size: finalHeight + finalDepth,
        offsetTable: {
          0: finalHeight - childHeight,
        },
      );
    }
  }
}
