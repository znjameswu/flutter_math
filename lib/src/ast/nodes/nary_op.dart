import 'package:flutter/widgets.dart';

import '../../render/layout/line.dart';
import '../../render/layout/multiscripts.dart';
import '../../render/symbols/make_atom.dart';
import '../options.dart';
import '../size.dart';
import '../spacing.dart';
import '../style.dart';
import '../syntax_tree.dart';
import '../types.dart';

// enum LimitsBehavior {
//   //ignore: constant_identifier_names
//   Default,
//   subsup,
//   underover,
// }

class NaryOperatorNode extends SlotableNode {
  final String operator;
  final EquationRowNode lowerLimit;
  final EquationRowNode upperLimit;
  final EquationRowNode naryand;
  bool _limits;
  bool get limits => _limits ??= _naryDefaultLimit.contains(operator);

  final bool allowLargeOp; // for \smallint

  NaryOperatorNode({
    @required this.operator,
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.naryand,
    bool limits,
    this.allowLargeOp = true,
  })  : assert(naryand != null),
        _limits = limits;

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    final large = allowLargeOp && (options.style == MathStyle.display);
    final font = large
        ? FontOptions(fontFamily: 'Size2')
        : FontOptions(fontFamily: 'Size1');
    final symbolMetrics = lookupChar(operator, font, Mode.math);
    final symbolWidget =
        makeChar(operator, font, symbolMetrics, options, needItalic: true);
    final operatorWidget = lowerLimit == null && upperLimit == null
        ? symbolWidget
        : Multiscripts(
            italic: symbolMetrics.italic.cssEm.toLpUnder(options),
            isBaseCharacterBox: false,
            baseOptions: options,
            base: symbolWidget,
            sub: childBuildResults[0]?.widget,
            subOptions: childBuildResults[0]?.options,
            sup: childBuildResults[1]?.widget,
            supOptions: childBuildResults[1]?.options,
          );
    final widget = Line(children: [
      LineElement(
        child: operatorWidget,
        trailingMargin:
            getSpacingSize(AtomType.op, naryand.leftType, options.style)
                .toLpUnder(options),
      ),
      LineElement(
        child: childBuildResults[2].widget,
        trailingMargin: 0.0,
      ),
    ]);
    return [
      BuildResult(
        widget: widget,
        options: options,
        italic: childBuildResults[2].italic,
      ),
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) => [
        options.havingStyle(options.style.sub()),
        options.havingStyle(options.style.sup()),
        options,
      ];

  @override
  List<EquationRowNode> computeChildren() => [lowerLimit, upperLimit, naryand];

  @override
  AtomType get leftType => AtomType.op;

  @override
  AtomType get rightType => naryand.rightType;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      NaryOperatorNode(
        operator: operator,
        lowerLimit: newChildren[0],
        upperLimit: newChildren[1],
        naryand: newChildren[2],
      );
}

const _naryDefaultLimit = {
  '\u220F',
  '\u2210',
  '\u2211',
  '\u22c0',
  '\u22c1',
  '\u22c2',
  '\u22c3',
  '\u2a00',
  '\u2a01',
  '\u2a02',
  '\u2a04',
  '\u2a06',
};
