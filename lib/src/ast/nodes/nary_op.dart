import 'package:flutter/widgets.dart';
import 'package:flutter_math/src/font/metrics/font_metrics.dart';
import 'package:flutter_math/src/render/layout/shift_baseline.dart';
import 'package:flutter_math/src/render/svg/static.dart';

import '../../render/layout/line.dart';
import '../../render/layout/multiscripts.dart';
import '../../render/layout/reset_dimension.dart';
import '../../render/layout/vlist.dart';
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
  final bool limits;
  bool get canlimits => _naryDefaultLimit.contains(operator);

  final bool allowLargeOp; // for \smallint

  NaryOperatorNode({
    @required this.operator,
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.naryand,
    this.limits,
    this.allowLargeOp = true,
  }) : assert(naryand != null);

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    final large =
        allowLargeOp && (options.style.size == MathStyle.display.size);
    final font = large
        ? FontOptions(fontFamily: 'Size2')
        : FontOptions(fontFamily: 'Size1');
    Widget operatorWidget;
    CharacterMetrics symbolMetrics;
    if (!stashedOvalNaryOperator.containsKey(operator)) {
      symbolMetrics = lookupChar(operator, font, Mode.math);
      final symbolWidget =
          makeChar(operator, font, symbolMetrics, options, needItalic: true);
      operatorWidget = symbolWidget;
    } else {
      final baseSymbol = stashedOvalNaryOperator[operator];
      symbolMetrics = lookupChar(baseSymbol, font, Mode.math);
      final baseSymbolWidget =
          makeChar(baseSymbol, font, symbolMetrics, options, needItalic: true);

      final oval = staticSvg(
          '${operator == '\u222F' ? 'oiint' : 'oiiint'}'
          'Size${large ? '2' : '1'}',
          options);

      operatorWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ResetDimension(
            horizontalAlignment: CrossAxisAlignment.start,
            width: 0.0,
            child: ShiftBaseline(
              offset: large ? 0.08.cssEm.toLpUnder(options) : 0.0,
              child: oval,
            ),
          ),
          baseSymbolWidget,
        ],
      );
    }

    // Attach limits to the base symbol
    if (lowerLimit != null || upperLimit != null) {
      // Should we place the limit as under/over or sub/sup
      final shouldLimits = limits ??
          (_naryDefaultLimit.contains(operator) &&
              options.style.size == MathStyle.display.size);
      final italic = symbolMetrics.italic.cssEm.toLpUnder(options);
      if (!shouldLimits) {
        operatorWidget = Multiscripts(
          italic: italic,
          isBaseCharacterBox: false,
          baseOptions: options,
          base: operatorWidget,
          sub: childBuildResults[0]?.widget,
          subOptions: childBuildResults[0]?.options,
          sup: childBuildResults[1]?.widget,
          supOptions: childBuildResults[1]?.options,
        );
      } else {
        final spacing =
            options.fontMetrics.bigOpSpacing5.cssEm.toLpUnder(options);
        operatorWidget = Padding(
          padding: EdgeInsets.only(
            top: upperLimit != null ? spacing : 0,
            bottom: lowerLimit != null ? spacing : 0,
          ),
          child: VList(
            baselineReferenceWidgetIndex: upperLimit != null ? 1 : 0,
            children: [
              if (upperLimit != null)
                VListElement(
                  hShift: 0.5 * italic,
                  child: ResetDimension(
                    depth: options.fontMetrics.bigOpSpacing3.cssEm
                        .toLpUnder(options),
                    minBottomPadding: options.fontMetrics.bigOpSpacing1.cssEm
                        .toLpUnder(options),
                    child: childBuildResults[1].widget,
                  ),
                ),
              operatorWidget,
              if (lowerLimit != null)
                VListElement(
                  hShift: -0.5 * italic,
                  child: ResetDimension(
                    height: options.fontMetrics.bigOpSpacing4.cssEm
                        .toLpUnder(options),
                    minTopPadding: options.fontMetrics.bigOpSpacing2.cssEm
                        .toLpUnder(options),
                    child: childBuildResults[0].widget,
                  ),
                ),
            ],
          ),
        );
      }
    }
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

const stashedOvalNaryOperator = {
  '\u222F': '\u222C',
  '\u2230': '\u222D',
};
