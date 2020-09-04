import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../render/layout/reset_dimension.dart';
import '../../render/layout/shift_baseline.dart';
import '../../render/layout/vlist.dart';
import '../../render/svg/static.dart';
import '../../render/svg/stretchy.dart';
import '../../render/symbols/make_symbol.dart';
import '../../utils/unicode_literal.dart';
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
        accentSymbolWidget = makeBaseSymbol(
          symbol: accentRenderConfigs[label].overChar,
          variantForm: false,
          atomType: AtomType.ord,
          mode: Mode.text,
          options: options,
        ).widget;
      }

      // Non stretchy accent can not contribute to overall width, thus they must
      // fit exactly with the width even if it means overflow.
      accentWidget = LayoutBuilder(
        builder: (context, constraints) => ResetDimension(
          depth: 0.0, // Cut off xHeight
          width: constraints.minWidth, // Ensure width
          child: ShiftBaseline(
            // \tilde is submerged below baseline in KaTeX fonts
            relativePos: 1.0,
            // Shift baseline up by xHeight
            offset: -options.fontMetrics.xHeight.cssEm.toLpUnder(options),
            child: accentSymbolWidget,
          ),
        ),
      );
    } else {
      // Strechy accent
      accentWidget = LayoutBuilder(
        builder: (context, constraints) {
          // \overline needs a special case, as KaTeX does.
          if (label == '\u00AF') {
            final defaultRuleThickness = options
                .fontMetrics.defaultRuleThickness.cssEm
                .toLpUnder(options);
            return Padding(
              padding: EdgeInsets.only(bottom: 3 * defaultRuleThickness),
              child: Container(
                width: constraints.minWidth,
                height: defaultRuleThickness, // TODO minRuleThickness
                color: options.color,
              ),
            );
          } else {
            var svgWidget = strechySvgSpan(
              accentRenderConfigs[label].overImageName,
              constraints.minWidth,
              options,
            );
            // \horizBrace also needs a special case, as KaTeX does.
            if (label == '\u23de') {
              return Padding(
                padding: EdgeInsets.only(bottom: 0.1.cssEm.toLpUnder(options)),
                child: svgWidget,
              );
            } else {
              return svgWidget;
            }
          }
        },
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
              customCrossSize: (width) =>
                  BoxConstraints(minWidth: width - 2 * skew),
              hShift: skew,
              child: accentWidget,
            ),
            // Set min height
            ResetDimension(
              height: options.fontMetrics.xHeight.cssEm.toLpUnder(options),
              minTopPadding: 0,
              child: childBuildResults[0].widget,
            ),
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
      copyWith(base: newChildren[0]);

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'base': base.toJson(),
      'label': unicodeLiteral(label),
      'isStretchy': isStretchy,
      'isShifty': isShifty,
    });

  AccentNode copyWith({
    EquationRowNode base,
    String label,
    bool isStretchy,
    bool isShifty,
  }) =>
      AccentNode(
        base: base ?? this.base,
        label: label ?? this.label,
        isStretchy: isStretchy ?? this.isStretchy,
        isShifty: isShifty ?? this.isShifty,
      );
}
