import 'package:flutter/widgets.dart';

import '../../render/layout/reset_dimension.dart';
import '../../render/layout/vlist.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

// \underset
class UnderNode extends SlotableNode {
  final EquationRowNode base;
  // final EquationRowNode above;
  final EquationRowNode below;
  UnderNode({
    @required this.base,
    // this.above,
    @required this.below,
  })  : assert(base != null),
        assert(below != null);

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
          padding: EdgeInsets.only(bottom: spacing),
          child: VList(
            baselineReferenceWidgetIndex: 0,
            children: <Widget>[
              childBuildResults[0].widget,
              // TexBook Rule 13a
              ResetDimension(
                height:
                    options.fontMetrics.bigOpSpacing2.cssEm.toLpUnder(options),
                minTopPadding:
                    options.fontMetrics.bigOpSpacing4.cssEm.toLpUnder(options),
                child: childBuildResults[1].widget,
              ),
            ],
          ),
        ),
      )
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) => [
        options,
        options.havingStyle(options.style.sub()),
      ];

  @override
  List<EquationRowNode> computeChildren() => [base, below];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      UnderNode(base: newChildren[0], below: newChildren[1]);
}
