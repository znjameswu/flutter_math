import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../render/layout/layout_builder_baseline.dart';
import '../../render/layout/shift_baseline.dart';
import '../../render/layout/vlist.dart';
import '../../render/svg/stretchy.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

class StretchyOpNode extends SlotableNode {
  final EquationRowNode above;

  final EquationRowNode below;

  final String symbol;

  StretchyOpNode({
    @required this.above,
    @required this.below,
    @required this.symbol,
  }) : assert(above != null || below != null);

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    final verticalPadding = 2.0.mu.toLpUnder(options);
    return [
      BuildResult(
        options: options,
        italic: 0.0,
        widget: VList(
          baselineReferenceWidgetIndex: above != null ? 1 : 0,
          children: <Widget>[
            if (above != null)
              Padding(
                padding: EdgeInsets.only(bottom: verticalPadding),
                child: childBuildResults[0].widget,
              ),
            VListElement(
              // From katex.less/x-arrow-pad
              customCrossSize: (width) => BoxConstraints(
                  minWidth: width + 1.0.cssEm.toLpUnder(options)),
              child: LayoutBuilderPreserveBaseline(
                builder: (context, constraints) => ShiftBaseline(
                  relativePos: 0.5,
                  offset: options.fontMetrics.xHeight.cssEm.toLpUnder(options),
                  child: strechySvgSpan(
                    stretchyOpMapping[symbol] ?? symbol,
                    constraints.minWidth,
                    options,
                  ),
                ),
              ),
            ),
            if (below != null)
              Padding(
                padding: EdgeInsets.only(top: verticalPadding),
                child: childBuildResults[1].widget,
              )
          ],
        ),
      )
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) => [
        options.havingStyle(options.style.sup()),
        options.havingStyle(options.style.sub()),
      ];

  @override
  List<EquationRowNode> computeChildren() => [above, below];

  @override
  AtomType get leftType => AtomType.rel;

  @override
  AtomType get rightType => AtomType.rel;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      StretchyOpNode(
        above: newChildren[0],
        below: newChildren[1],
        symbol: symbol,
      );
}

const stretchyOpMapping = {
  '\u2190': 'xleftarrow',
  '\u2192': 'xrightarrow',
};

const katexStretchyOpExtension = {
  'xLeftarrow',
  'xRightarrow',
  'xleftrightarrow',
  'xLeftrightarrow',
  'xhookleftarrow',
  'xhookrightarrow',
  'xmapsto',
  'xrightharpoondown',
  'xrightharpoonup',
  'xleftharpoondown',
  'xleftharpoonup',
  'xrightleftharpoons',
  'xleftrightharpoons',
  'xlongequal',
  'xtwoheadrightarrow',
  'xtwoheadleftarrow',
  'xtofrom',
  'xrightleftarrows',
  'xrightequilibrium',
  'xleftequilibrium',
};
