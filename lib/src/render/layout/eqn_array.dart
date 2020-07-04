import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../ast/nodes/matrix.dart';
import '../../utils/iterable_extensions.dart';
import '../constants.dart';
import '../utils/render_box_offset.dart';
import 'line.dart';

class EqnArrayParentData extends ContainerBoxParentData<RenderBox> {}

class EqnArray extends MultiChildRenderObjectWidget {
  final double ruleThickness;
  final double jotSize;
  final double arrayskip;
  final List<MatrixSeparatorStyle> hlines;
  final List<double> rowSpacings;

  EqnArray({
    Key key,
    @required this.ruleThickness,
    @required this.jotSize,
    @required this.arrayskip,
    @required this.hlines,
    @required this.rowSpacings,
    @required List<Widget> children,
  }) : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) => RenderEqnArray(
      ruleThickness: ruleThickness,
      jotSize: jotSize,
      arrayskip: arrayskip,
      hlines: hlines,
      rowSpacings: rowSpacings);
}

class RenderEqnArray extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EqnArrayParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EqnArrayParentData>,
        DebugOverflowIndicatorMixin {
  RenderEqnArray({
    List<RenderBox> children,
    @required double ruleThickness,
    @required double jotSize,
    @required double arrayskip,
    @required List<MatrixSeparatorStyle> hlines,
    @required List<double> rowSpacings,
  })  : _ruleThickness = ruleThickness,
        _jotSize = jotSize,
        _arrayskip = arrayskip,
        _hlines = hlines,
        _rowSpacings = rowSpacings {
    addAll(children);
  }

  double get ruleThickness => _ruleThickness;
  double _ruleThickness;
  set ruleThickness(double value) {
    if (_ruleThickness != value) {
      _ruleThickness = value;
      markNeedsLayout();
    }
  }

  double get jotSize => _jotSize;
  double _jotSize;
  set jotSize(double value) {
    if (_jotSize != value) {
      _jotSize = value;
      markNeedsLayout();
    }
  }

  double get arrayskip => _arrayskip;
  double _arrayskip;
  set arrayskip(double value) {
    if (_arrayskip != value) {
      _arrayskip = value;
      markNeedsLayout();
    }
  }

  List<MatrixSeparatorStyle> get hlines => _hlines;
  List<MatrixSeparatorStyle> _hlines;
  set hlines(List<MatrixSeparatorStyle> value) {
    if (_hlines != value) {
      _hlines = value;
      markNeedsLayout();
    }
  }

  List<double> get rowSpacings => _rowSpacings;
  List<double> _rowSpacings;
  set rowSpacings(List<double> value) {
    if (_rowSpacings != value) {
      _rowSpacings = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! EqnArrayParentData) {
      child.parentData = EqnArrayParentData();
    }
  }

  List<double> hlinePos = [];

  double width = 0.0;

  @override
  void performLayout() {
    final nonAligningChildren = <RenderBox>[];
    // First pass, calculate width for each column.
    var child = firstChild;
    final colWidths = <double>[];
    while (child != null) {
      if (child is RenderLine) {
        child.alignColWidth = null;
        child.layout(infiniteConstraint, parentUsesSize: true);
        final childColWidth = child.alignColWidth;
        if (childColWidth != null) {
          for (var i = 0; i < childColWidth.length; i++) {
            if (i >= colWidths.length) {
              colWidths.add(childColWidth[i]);
            } else {
              colWidths[i] = math.max(
                colWidths[i],
                childColWidth[i],
              );
            }
          }
        } else {
          nonAligningChildren.add(child);
        }
      } else {
        child.layout(infiniteConstraint, parentUsesSize: true);
        colWidths[0] = math.max(
          colWidths[0],
          child.size.width,
        );
      }
      child = (child.parentData as EqnArrayParentData).nextSibling;
    }

    final nonAligningChildrenWidth =
        nonAligningChildren.map((e) => e.size.width).max() ?? 0.0;
    final aligningChildrenWidth = colWidths.sum();
    width = math.max(nonAligningChildrenWidth, aligningChildrenWidth);

    // Second pass, re-layout each RenderLine using column width constraint
    var index = 0;
    var vPos = 0.0;
    hlinePos.add(vPos);
    index++;
    child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as EqnArrayParentData;
      var hPos = 0.0;
      if (child is RenderLine && child.alignColWidth != null) {
        child.alignColWidth = colWidths;
        // Hack: We use a different constraint to trigger another layout or 
        // else it would be bypassed
        child.layout(BoxConstraints(maxWidth: aligningChildrenWidth), 
            parentUsesSize: true);
        hPos = (width - aligningChildrenWidth) / 2 +
            colWidths[0] -
            child.alignColWidth[0];
      } else {
        hPos = (width - child.size.width) / 2;
      }
      vPos += math.max(child.layoutHeight, 0.7 * arrayskip);
      childParentData.offset = Offset(
        hPos,
        vPos - child.layoutHeight,
      );
      vPos += math.max(child.layoutDepth, 0.3 * arrayskip) +
          jotSize +
          rowSpacings[index - 1];
      hlinePos.add(vPos);
      vPos += hlines[index] != null ? ruleThickness : 0.0;
      index++;

      child = childParentData.nextSibling;
    }

    size = Size(width, vPos);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
    for (var i = 0; i < hlines.length; i++) {
      if (hlines[i] != null) {
        context.canvas.drawLine(
          Offset(0, hlinePos[i] + ruleThickness / 2),
          Offset(width, hlinePos[i] + ruleThickness / 2),
          Paint()..strokeWidth = ruleThickness,
        );
      }
    }
  }
}
