import 'package:flutter/widgets.dart';

import '../../render/layout/reset_dimension.dart';
import '../../render/layout/vlist.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

// \underset
class OverNode extends SlotableNode {
  final EquationRowNode base;
  final EquationRowNode above;

  OverNode({
    @required this.base,
    this.above,
  })  : assert(base != null),
        assert(above != null);

  // KaTeX's corresponding code is in /src/functions/utils/assembleSubSup.js
  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    final spacing = options.fontMetrics.bigOpSpacing5.cssEm.toLpUnder(options);
    return [
      BuildResult(
        italic: 0.0,
        options: options,
        widget: Padding(
          padding: EdgeInsets.only(top: spacing),
          child: VList(
            baselineReferenceWidgetIndex: 1,
            children: <Widget>[
              // TexBook Rule 13a
              ResetDimension(
                depth:
                    options.fontMetrics.bigOpSpacing1.cssEm.toLpUnder(options),
                minBottomPadding:
                    options.fontMetrics.bigOpSpacing3.cssEm.toLpUnder(options),
                child: childBuildResults[1].widget,
              ),
              childBuildResults[0].widget,
            ],
          ),
        ),
      )
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) => [
        options,
        options.havingStyle(options.style.sup()),
      ];

  @override
  List<EquationRowNode> computeChildren() => [base, above];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      OverNode(base: newChildren[0], above: newChildren[1]);
}
