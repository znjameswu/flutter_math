import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../render/layout/vlist.dart';
import '../../render/svg/stretchy.dart';
import '../../utils/unicode_literal.dart';
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
  BuildResult buildWidget(
          Options options, List<BuildResult> childBuildResults) =>
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
                    return Padding(
                      padding: EdgeInsets.only(top: 3 * defaultRuleThickness),
                      child: Container(
                        width: constraints.minWidth,
                        height: defaultRuleThickness, // TODO minRuleThickness
                        color: options.color,
                      ),
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
      );

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
      copyWith(base: newChildren[0]);

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'base': base.toJson(),
      'label': unicodeLiteral(label),
      // 'isStretchy': isStretchy,
      // 'isShifty': isShifty,
    });

  AccentUnderNode copyWith({
    EquationRowNode base,
    String label,
  }) =>
      AccentUnderNode(
        base: base ?? this.base,
        label: label ?? this.label,
      );
}
