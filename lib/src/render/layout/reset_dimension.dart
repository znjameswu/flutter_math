import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/render_box_offset.dart';
import 'custom_layout.dart';

/// I would like to use [CustomSingleChildLayout] provided by flutter
/// But that thing does not allow parent to depend on children. BS.
class ResetDimension extends StatelessWidget {
  final double height;
  final double depth;
  final Widget child;
  ResetDimension({
    Key key,
    @required this.height,
    @required this.depth,
    @required this.child,
  }) : super();

  @override
  Widget build(BuildContext context) => CustomLayout<int>(
        delegate: ResetDimensionLayoutDelegate(
          height: height,
          depth: depth,
        ),
        children: <Widget>[
          CustomLayoutId(id: 0, child: child),
        ],
      );
}

class ResetDimensionLayoutDelegate extends IntrinsicLayoutDelegate<int> {
  final double height;
  final double depth;
  ResetDimensionLayoutDelegate({
    Key key,
    @required this.height,
    @required this.depth,
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
      return AxisConfiguration(
        size: childSize(childrenTable[0]),
        offsetTable: {0: 0.0},
      );
    } else {
      final childHeight = (isComputingIntrinsics
          ? childSize(childrenTable[0])
          : childrenTable[0].layoutHeight);
      final childDepth = childSize(childrenTable[0]) - childHeight;

      final finalHeight = height != null ? height : childHeight;
      final finalDepth = depth != null ? depth : childDepth;
      return AxisConfiguration(
        size: finalHeight + finalDepth,
        offsetTable: {
          0: finalHeight - childHeight,
        },
      );
    }
  }
}
