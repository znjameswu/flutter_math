import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_math/src/ast/accents.dart';
import 'package:flutter_math/src/render/constants.dart';
import 'package:flutter_math/src/render/layout/shift_baseline.dart';
import 'package:flutter_math/src/render/svg/stretchy.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../render/layout/custom_layout.dart';
import '../../render/svg/svg_string_from_path.dart';
import '../../render/symbols/make_atom.dart';
import '../../render/utils/render_box_offset.dart';
import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';
import '../types.dart';

class AccentNode extends SlotableNode {
  final EquationRowNode base;
  final String label;
  final bool isStretchy;
  final bool isShifty;
  AccentNode({
    @required this.base,
    @required this.label,
    @required this.isStretchy,
    @required this.isShifty,
  });

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    // Checking of character box is done automatically by the passing of
    // BuildResult, so we don't need to check it here.
    final skew = isShifty ? childBuildResults[0].skew : 0.0;
    return [
      BuildResult(
        options: options,
        italic: childBuildResults[0].italic,
        skew: childBuildResults[0].skew,
        widget: CustomLayout<_AccentPos>(
          delegate: AccentLayoutDelegate(
            skew: skew,
            options: options,
          ),
          children: <Widget>[
            CustomLayoutId(
              id: _AccentPos.base,
              child: childBuildResults[0].widget,
            ),
            CustomLayoutId(
              id: _AccentPos.accent,
              child: !isStretchy
                  ? ShiftBaseline(
                      offset:
                          -options.fontMetrics.xHeight.cssEm.toLpUnder(options),
                      child: makeAtom(
                        symbol: label,
                        variantForm: false,
                        atomType: AtomType.ord,
                        mode: Mode.text,
                        options: options,
                      )[0]
                          .widget,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) => strechySvgSpan(
                        accentRenderConfigs[label].overImageName,
                        constraints.minWidth,
                        options,
                      ),
                    ),
            ),
          ],
        ),
      )
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) =>
      [options.havingCrampedStyle()];

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
      List<EquationRowNode> newChildren) {
    // TODO: implement updateChildren
    throw UnimplementedError();
  }
}

enum _AccentPos {
  base,
  accent,
}

class AccentLayoutDelegate extends CustomLayoutDelegate<_AccentPos> {
  final double skew;
  final Options options;

  var layoutHeight = 0.0;

  AccentLayoutDelegate({
    @required this.skew,
    @required this.options,
  });
  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<_AccentPos, RenderBox> childrenTable) =>
      layoutHeight;

  @override
  double getIntrinsicSize({
    Axis sizingDirection,
    bool max,
    double extent,
    double Function(RenderBox child, double extent) childSize,
    Map<_AccentPos, RenderBox> childrenTable,
  }) {
    // TODO: implement getIntrinsicSize
    throw UnimplementedError();
  }

  @override
  Size performLayout(BoxConstraints constraints,
      Map<_AccentPos, RenderBox> childrenTable, RenderBox renderBox) {
    final base = childrenTable[_AccentPos.base];
    final accent = childrenTable[_AccentPos.accent];

    base.layout(infiniteConstraint, parentUsesSize: true);
    accent.layout(BoxConstraints(minWidth: base.size.width - 2 * skew),
        parentUsesSize: true);

    final baseHeight = base.layoutHeight;

    // var delta = math.min(
    //   baseHeight,
    //   options.fontMetrics.xHeight.cssEm.toLpUnder(options),
    // );

    final accentHorizontalShift =
        skew + (base.size.width - accent.size.width) * 0.5;

    final baseHorizontalPos =
        accentHorizontalShift < 0 ? -accentHorizontalShift : 0.0;

    final baseVerticalPos = accent.layoutHeight;

    base.offset = Offset(baseHorizontalPos, baseVerticalPos);
    accent.offset = Offset(baseHorizontalPos + accentHorizontalShift, 0.0);

    layoutHeight = baseVerticalPos + baseHeight;

    return Size(
      math.max(
        baseHorizontalPos + base.size.width,
        baseHorizontalPos + accentHorizontalShift + accent.size.width,
      ),
      baseVerticalPos + base.size.height,
    );
  }
}
