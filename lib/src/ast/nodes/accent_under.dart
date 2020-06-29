import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../render/layout/vlist.dart';
import '../../render/svg/stretchy.dart';
import '../accents.dart';
import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';

class AccentUnderNode extends SlotableNode {
  final EquationRowNode base;
  final String label;
  // final bool isStretchy;
  // final bool isShifty;
  AccentUnderNode({
    @required this.base,
    @required this.label,
    // @required this.isStretchy,
    // @required this.isShifty,
  });

  @override
  List<BuildResult> buildSlotableWidget(
          Options options, List<BuildResult> childBuildResults) =>
      [
        BuildResult(
          options: options,
          italic: childBuildResults[0].italic,
          skew: childBuildResults[0].skew,
          widget: VList(
            baselineReferenceWidgetIndex: 0,
            children: <Widget>[
              VListElement(
                trailingMargin:
                    label == '\u007e' ? 0.12.cssEm.toLpUnder(options) : 0.0,
                // Special case for \utilde
                child: childBuildResults[0].widget,
              ),
              VListElement(
                customCrossSize: (width) => BoxConstraints(minWidth: width),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (label == '\u00AF') {
                      final defaultRuleThickness = options
                          .fontMetrics.defaultRuleThickness.cssEm
                          .toLpUnder(options);
                      return Container(
                        padding:
                            EdgeInsets.only(bottom: 3 * defaultRuleThickness),
                        width: constraints.minWidth,
                        height: defaultRuleThickness, // TODO minRuleThickness
                        color: Colors.black,
                      );
                    } else {
                      return strechySvgSpan(
                        accentRenderConfigs[label].underImageName,
                        constraints.minWidth,
                        options,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        )
      ];

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
      AccentUnderNode(
        base: newChildren[0],
        label: label,
      );
}
