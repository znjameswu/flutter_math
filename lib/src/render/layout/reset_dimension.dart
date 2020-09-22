import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../utils/render_box_offset.dart';

class ResetDimension extends SingleChildRenderObjectWidget {
  final double height;
  final double depth;
  final double width;
  final CrossAxisAlignment horizontalAlignment;

  const ResetDimension({
    Key key,
    this.height,
    this.depth,
    this.width,
    this.horizontalAlignment,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderResetDimension createRenderObject(BuildContext context) =>
      RenderResetDimension(
        layoutHeight: height,
        layoutWidth: width,
        layoutDepth: depth,
        horizontalAlignment: horizontalAlignment,
      );

  @override
  void updateRenderObject(
          BuildContext context, RenderResetDimension renderObject) =>
      renderObject
        ..layoutHeight = height
        ..layoutDepth = depth
        ..layoutWidth = width
        ..horizontalAlignment = horizontalAlignment;
}

class RenderResetDimension extends RenderShiftedBox {
  RenderResetDimension({
    RenderBox child,
    double layoutHeight,
    double layoutDepth,
    double layoutWidth,
    CrossAxisAlignment horizontalAlignment,
  })  : _layoutHeight = layoutHeight,
        _layoutDepth = layoutDepth,
        _layoutWidth = layoutWidth,
        _horizontalAlignment = horizontalAlignment,
        super(child);

  // @override
  // void setupParentData(RenderObject child) {
  //   if (child.parentData is! BoxParentData) child.parentData = BoxParentData();
  // }

  double get layoutHeight => _layoutHeight;
  double _layoutHeight;
  set layoutHeight(double value) {
    if (_layoutHeight != value) {
      _layoutHeight = value;
      markNeedsLayout();
    }
  }

  double get layoutDepth => _layoutDepth;
  double _layoutDepth;
  set layoutDepth(double value) {
    if (_layoutDepth != value) {
      _layoutDepth = value;
      markNeedsLayout();
    }
  }

  double get layoutWidth => _layoutWidth;
  double _layoutWidth;
  set layoutWidth(double value) {
    if (_layoutWidth != value) {
      _layoutWidth = value;
      markNeedsLayout();
    }
  }

  CrossAxisAlignment get horizontalAlignment => _horizontalAlignment;
  CrossAxisAlignment _horizontalAlignment;
  set horizontalAlignment(CrossAxisAlignment value) {
    if (_horizontalAlignment != value) {
      _horizontalAlignment = value;
      markNeedsLayout();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      layoutWidth ?? super.computeMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      layoutWidth ?? super.computeMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) {
    if (layoutHeight == null && layoutDepth == null) {
      return super.computeMinIntrinsicHeight(width);
    }
    if (layoutHeight != null && layoutDepth != null) {
      return layoutHeight + layoutDepth;
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (layoutHeight == null && layoutDepth == null) {
      return super.computeMaxIntrinsicHeight(width);
    }
    if (layoutHeight != null && layoutDepth != null) {
      return layoutHeight + layoutDepth;
    }
    return 0;
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) =>
      layoutHeight ?? super.computeDistanceToActualBaseline(baseline);

  @override
  void performLayout() {
    child.layout(constraints, parentUsesSize: true);
    final childHeight = child.getDistanceToBaseline(TextBaseline.alphabetic);
    final childDepth = child.size.height - childHeight;
    final childWidth = child.size.width;

    final height = layoutHeight ?? childHeight;
    final depth = layoutDepth ?? childDepth;
    final width = layoutWidth ?? childWidth;

    var dx = 0.0;
    switch (horizontalAlignment) {
      case CrossAxisAlignment.start:
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        break;
      case CrossAxisAlignment.end:
        dx = width - childWidth;
        break;
      case CrossAxisAlignment.center:
      default:
        dx = (width - childWidth) / 2;
        break;
    }
    child.offset = Offset(dx, height - childHeight);
    size = constraints.constrain(Size(width, height + depth));
  }
}

// class ResetDimensionLayoutDelegate extends IntrinsicLayoutDelegate<int> {
//   final double height;
//   final double depth;
//   final double width;
//   final double minTopPadding;
//   final double minBottomPadding;
//   final CrossAxisAlignment alignment;
//   ResetDimensionLayoutDelegate({
//     Key key,
//     @required this.height,
//     @required this.depth,
//     this.width,
//     this.minTopPadding,
//     this.minBottomPadding,
//     this.alignment,
//   });

//   var distanceToBaseline = 0.0;

//   @override
//   double computeDistanceToActualBaseline(
//           TextBaseline baseline, Map<int, RenderBox> childrenTable) =>
//       distanceToBaseline;

//   @override
//   AxisConfiguration<int> performIntrinsicLayout({
//     Axis layoutDirection,
//     double Function(RenderBox child) childSize,
//     Map<int, RenderBox> childrenTable,
//     bool isComputingIntrinsics,
//   }) {
//     if (layoutDirection == Axis.horizontal) {
//       final childWidth = childSize(childrenTable[0]);
//       final finalWidth = width ?? childWidth;
//       var offset = 0.0;
//       switch (alignment) {
//         case CrossAxisAlignment.start:
//           break;
//         case CrossAxisAlignment.end:
//           offset = finalWidth - childWidth;
//           break;
//         case CrossAxisAlignment.center:
//         case CrossAxisAlignment.stretch:
//         case CrossAxisAlignment.baseline:
//         default:
//           offset = (finalWidth - childWidth) / 2;
//           break;
//       }
//       return AxisConfiguration(
//         size: finalWidth,
//         offsetTable: {0: offset},
//       );
//     } else {
//       final childHeight = (isComputingIntrinsics
//           ? childSize(childrenTable[0])
//           : childrenTable[0].layoutHeight);
//       final childDepth = childSize(childrenTable[0]) - childHeight;

//       var finalHeight = 0.0;
//       if (height != null && minTopPadding != null) {
//         finalHeight = math.max(
//           height,
//           minTopPadding + childHeight,
//         );
//       } else {
//         finalHeight = height ?? ((minTopPadding ?? 0.0) + childHeight);
//       }
//       // final finalHeight = math.max(
//       //   height ?? childHeight,
//       //   (minTopPadding ?? -double.infinity) + childHeight,
//       // );
//       var finalDepth = 0.0;
//       if (depth != null && minBottomPadding != null) {
//         finalDepth = math.max(
//           depth,
//           minBottomPadding + childDepth,
//         );
//       } else {
//         finalDepth = depth ?? ((minBottomPadding ?? 0.0) + childDepth);
//       }
//       // final finalDepth = math.max(
//       //   depth ?? childDepth,
//       //   (minBottomPadding ?? -double.infinity) + childDepth,
//       // );

//       distanceToBaseline = finalHeight;
//       return AxisConfiguration(
//         size: finalHeight + finalDepth,
//         offsetTable: {
//           0: finalHeight - childHeight,
//         },
//       );
//     }
//   }
// }
