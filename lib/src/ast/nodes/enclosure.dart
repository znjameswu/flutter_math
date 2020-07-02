import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../render/layout/custom_layout.dart';
import '../../render/utils/render_box_offset.dart';
import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';

class EnclosureNode extends SlotableNode {
  final EquationRowNode base;

  final bool hasBorder;

  // If null, will default to options.color
  final Color bordercolor;

  final Color backgroundcolor;

  final List<String> notation;

  final Measurement horizontalPadding;

  final Measurement verticalPadding;

  EnclosureNode({
    @required this.base,
    @required this.hasBorder,
    this.bordercolor,
    this.backgroundcolor = Colors.transparent,
    this.notation,
    this.horizontalPadding = Measurement.zero,
    this.verticalPadding = Measurement.zero,
  }) : assert(base != null);

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    final horizontalPadding = this.horizontalPadding.toLpUnder(options);
    final verticalPadding = this.verticalPadding.toLpUnder(options);

    Widget widget = Stack(
      children: <Widget>[
        Container(
          color: backgroundcolor,
          decoration: hasBorder
              ? BoxDecoration(
                  border: Border.all(
                    // TODO minRuleThickness
                    width:
                        options.fontMetrics.fboxrule.cssEm.toLpUnder(options),
                    color: bordercolor ?? options.color,
                  ),
                )
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: childBuildResults[0].widget,
          ),
        ),
        if (notation.contains('updiagnoalstrike'))
          Positioned(
            child: LayoutBuilder(
              builder: (context, constraints) => CustomPaint(
                size: constraints.biggest,
                painter: LinePainter(
                  startRelativeX: 0,
                  startRelativeY: 1,
                  endRelativeX: 1,
                  endRelativeY: 0,
                  lineWidth: 0.046.cssEm.toLpUnder(options),
                  color: bordercolor ?? options.color,
                ),
              ),
            ),
          ),
        if (notation.contains('downdiagnoalstrike'))
          Positioned(
            child: LayoutBuilder(
              builder: (context, constraints) => CustomPaint(
                size: constraints.biggest,
                painter: LinePainter(
                  startRelativeX: 0,
                  startRelativeY: 0,
                  endRelativeX: 1,
                  endRelativeY: 1,
                  lineWidth: 0.046.cssEm.toLpUnder(options),
                  color: bordercolor ?? options.color,
                ),
              ),
            ),
          ),
      ],
    );
    if (notation.contains('horizontalstrike')) {
      widget = CustomLayout<int>(
        delegate: HorizontalStrikeDelegate(
          vShift: options.fontMetrics.xHeight.cssEm.toLpUnder(options) / 2,
          ruleThickness:
              options.fontMetrics.defaultRuleThickness.cssEm.toLpUnder(options),
          color: bordercolor ?? options.color,
        ),
        children: <Widget>[
          CustomLayoutId(
            id: 0,
            child: widget,
          ),
        ],
      );
    }
    return [
      BuildResult(
        options: options,
        italic: 0.0,
        widget: widget,
      ),
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) => [options];

  @override
  List<EquationRowNode> computeChildren() => [base];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      EnclosureNode(
        base: newChildren[0],
        hasBorder: hasBorder,
        bordercolor: bordercolor,
        backgroundcolor: backgroundcolor,
        notation: notation,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
      );
}

class LinePainter extends CustomPainter {
  final double startRelativeX;
  final double startRelativeY;
  final double endRelativeX;
  final double endRelativeY;
  final double lineWidth;
  final Color color;

  const LinePainter({
    @required this.startRelativeX,
    @required this.startRelativeY,
    @required this.endRelativeX,
    @required this.endRelativeY,
    @required this.lineWidth,
    @required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(startRelativeX * size.width, startRelativeY * size.height),
      Offset(endRelativeX * size.width, endRelativeY * size.height),
      Paint()
        ..strokeWidth = lineWidth
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => this != oldDelegate;
}

class HorizontalStrikeDelegate extends CustomLayoutDelegate<int> {
  final double ruleThickness;
  final double vShift;
  final Color color;

  HorizontalStrikeDelegate({
    @required this.ruleThickness,
    @required this.vShift,
    @required this.color,
  });

  var height = 0.0;
  var width = 0.0;

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<int, RenderBox> childrenTable) =>
      height;

  @override
  double getIntrinsicSize(
          {Axis sizingDirection,
          bool max,
          double extent,
          double Function(RenderBox child, double extent) childSize,
          Map<int, RenderBox> childrenTable}) =>
      childSize(childrenTable[0], double.infinity);

  @override
  Size performLayout(BoxConstraints constraints,
      Map<int, RenderBox> childrenTable, RenderBox renderBox) {
    childrenTable[0].layout(constraints, parentUsesSize: true);
    height = childrenTable[0].layoutHeight;
    width = childrenTable[0].size.width;
    return childrenTable[0].size;
  }

  @override
  void additionalPaint(PaintingContext context, Offset offset) {
    context.canvas.drawLine(
      Offset(
        offset.dx,
        offset.dy + height - vShift,
      ),
      Offset(
        offset.dx + width,
        offset.dy + height - vShift,
      ),
      Paint()
        ..strokeWidth = ruleThickness
        ..color = color,
    );
  }
}
