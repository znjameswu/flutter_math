import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ShiftBaseline extends SingleChildRenderObjectWidget {
  const ShiftBaseline({
    Key key,
    this.relativePos,
    this.offset = 0,
    Widget child,
  })  : assert(offset != null),
        super(key: key, child: child);

  final double relativePos;

  final double offset;

  @override
  RenderShiftBaseline createRenderObject(BuildContext context) =>
      RenderShiftBaseline(relativePos: relativePos, offset: offset);

  @override
  void updateRenderObject(
      BuildContext context, RenderShiftBaseline renderObject) {
    renderObject
      ..relativePos = relativePos
      ..offset = offset;
  }
}

class RenderShiftBaseline extends RenderProxyBox {
  RenderShiftBaseline({
    RenderBox child,
    double relativePos,
    double offset = 0,
  })  : assert(offset != null),
        _relativePos = relativePos,
        _offset = offset {
    this.child = child;
  }

  double get relativePos => _relativePos;
  double _relativePos;
  set relativePos(double value) {
    if (_relativePos != value) {
      _relativePos = value;
      markNeedsLayout();
    }
  }

  double get offset => _offset;
  double _offset;
  set offset(double value) {
    if (_offset != value) {
      _offset = value;
      markNeedsLayout();
    }
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    if (relativePos != null) {
      final childHeight = child.size.height;
      return relativePos * childHeight + offset;
    }
    if (child != null) {
      assert(!debugNeedsLayout);
      final childBaselineDistance = child.getDistanceToActualBaseline(baseline);
      //ignore: avoid_returning_null
      if (childBaselineDistance == null) return null;
      return childBaselineDistance +
          (child.parentData as BoxParentData).offset.dy;
    } else {
      return super.computeDistanceToActualBaseline(baseline);
    }
  }

  // @override
  // void paint(PaintingContext context, Offset offset) {
  //   if (child != null) {
  //     final childParentData = child.parentData as BoxParentData;
  //     context.paintChild(child, childParentData.offset + offset);
  //   }
  // }

  // @override
  // bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
  //   if (child != null) {
  //     final childParentData = child.parentData as BoxParentData;
  //     return result.addWithPaintOffset(
  //       offset: childParentData.offset,
  //       position: position,
  //       hitTest: (BoxHitTestResult result, Offset transformed) {
  //         assert(transformed == position - childParentData.offset);
  //         return child.hitTest(result, position: transformed);
  //       },
  //     );
  //   }
  //   return false;
  // }
}
