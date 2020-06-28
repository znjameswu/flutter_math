import 'package:flutter/widgets.dart';

import '../../render/constants.dart';
import '../../render/layout/custom_layout.dart';
import '../../render/layout/reset_dimension.dart';
import '../../render/layout/shift_baseline.dart';
import '../../render/layout/vlist.dart';
import '../../render/svg/static.dart';
import '../../render/svg/stretchy.dart';
import '../../render/symbols/make_atom.dart';
import '../../render/utils/render_box_offset.dart';
import '../accents.dart';
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
    Widget accentWidget;
    if (!isStretchy) {
      Widget accentSymbolWidget;
      // Following comment are selected from KaTeX:
      //
      // Before version 0.9, \vec used the combining font glyph U+20D7.
      // But browsers, especially Safari, are not consistent in how they
      // render combining characters when not preceded by a character.
      // So now we use an SVG.
      // If Safari reforms, we should consider reverting to the glyph.
      if (label == '\u2192') {
        // We need non-null baseline. Because ShiftBaseline cannot deal with a
        // baseline distance of null due to Flutter rendering pipeline design.
        accentSymbolWidget = staticSvg('vec', options, needBaseline: true);
      } else {
        accentSymbolWidget = makeAtom(
          symbol: accentRenderConfigs[label].overChar,
          variantForm: false,
          atomType: AtomType.ord,
          mode: Mode.text,
          options: options,
        )[0]
            .widget;
      }

      // Non stretchy accent can not contribute to overall width, thus they must
      // fit exactly with the width even if it means overflow.
      accentWidget = LayoutBuilder(
        builder: (context, constraints) => ResetDimension(
          depth: 0.0, // Cut off xHeight
          width: constraints.minWidth, // Ensure width
          child: ShiftBaseline(
            // Shift baseline up by xHeight
            offset: -options.fontMetrics.xHeight.cssEm.toLpUnder(options),
            child: accentSymbolWidget,
          ),
        ),
      );
    } else {
      accentWidget = LayoutBuilder(
        builder: (context, constraints) => strechySvgSpan(
          accentRenderConfigs[label].overImageName,
          constraints.minWidth,
          options,
        ),
      );
    }
    return [
      BuildResult(
        options: options,
        italic: childBuildResults[0].italic,
        skew: childBuildResults[0].skew,
        widget: VList(
          baselineReferenceWidgetIndex: 1,
          children: <Widget>[
            VListElement(
              customCrossSize: (width) => BoxConstraints(minWidth: width),
              child: Padding(
                // To shift the center by 1 * skew
                padding: EdgeInsets.only(left: 2 * skew),
                child: accentWidget,
              ),
            ),
            childBuildResults[0].widget,
          ],
        ),
      )
    ];
    // return [
    //   BuildResult(
    //     options: options,
    //     italic: childBuildResults[0].italic,
    //     skew: childBuildResults[0].skew,
    //     widget: CustomLayout<_AccentPos>(
    //       delegate: AccentLayoutDelegate(
    //         skew: skew,
    //         options: options,
    //       ),
    //       children: <Widget>[
    //         CustomLayoutId(
    //           id: _AccentPos.base,
    //           child: childBuildResults[0].widget,
    //         ),
    //         CustomLayoutId(
    //           id: _AccentPos.accent,
    //           child: accentWidget,
    //         ),
    //       ],
    //     ),
    //   )
    // ];
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
          List<EquationRowNode> newChildren) =>
      AccentNode(
        base: newChildren[0],
        label: label,
        isStretchy: isStretchy,
        isShifty: isShifty,
      );
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

    final accentHorizontalShift =
        skew + (base.size.width - accent.size.width) * 0.5;

    final baseHorizontalPos =
        accentHorizontalShift < 0 ? -accentHorizontalShift : 0.0;

    final baseVerticalPos = accent.layoutHeight;

    base.offset = Offset(baseHorizontalPos, baseVerticalPos);
    accent.offset = Offset(baseHorizontalPos + accentHorizontalShift, 0.0);

    layoutHeight = baseVerticalPos + baseHeight;

    return Size(
      // math.max(
      baseHorizontalPos + base.size.width,
      //   baseHorizontalPos + accentHorizontalShift + accent.size.width,
      // ),
      baseVerticalPos + base.size.height,
    );
  }
}
