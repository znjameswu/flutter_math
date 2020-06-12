import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/nullable_plus.dart';
import '../utils/render_box_offset.dart';
import 'custom_layout.dart';

class MathOrd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomLayout<int>(delegate: null);
  }
}

class MathOrdLayoutDelegate extends IntrinsicLayoutDelegate<int> {
  final double height;
  final double depth;
  const MathOrdLayoutDelegate({
    @required this.height,
    @required this.depth,
  });

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<int, RenderBox> childrenTable) =>
      nPlus(
        childrenTable[0].offset.dy,
        childrenTable[0].getDistanceToBaseline(baseline, onlyReal: true),
      );

  @override
  AxisConfiguration<int> performIntrinsicLayout({
    Axis layoutDirection,
    double Function(RenderBox child) childSize,
    Map<int, RenderBox> childrenTable,
    bool isComputingIntrinsics,
  }) {
    if (layoutDirection == Axis.horizontal) {
      return AxisConfiguration(
        size: childrenTable[0].size.width,
        offsetTable: {0: 0},
      );
    } else {
      return AxisConfiguration(
        size: height + depth,
        offsetTable: {
          0: height -
              childrenTable[0].getDistanceToBaseline(TextBaseline.alphabetic)
        },
      );
    }
  }
}

Text makeOrdText(String a) {
  return Text(
    a,
    textAlign: TextAlign.start,
    textDirection: TextDirection.ltr,
    softWrap: false,
    overflow: TextOverflow.visible,
    textScaleFactor: 1,
    maxLines: 1,
  );
}
