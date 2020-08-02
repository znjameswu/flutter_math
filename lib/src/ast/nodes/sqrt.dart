import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../render/constants.dart';
import '../../render/layout/custom_layout.dart';
import '../../render/layout/layout_builder_baseline.dart';
import '../../render/layout/reset_baseline.dart';
import '../../render/layout/reset_dimension.dart';
import '../../render/svg/delimiter.dart';
import '../../render/svg/svg_geomertry.dart';
import '../../render/svg/svg_string.dart';
import '../../render/utils/render_box_offset.dart';
import '../../utils/iterable_extensions.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

/// Word:   \sqrt   \sqrt(index & base)
/// Latex:  \sqrt   \sqrt[index]{base}
/// MathML: msqrt   mroot

class SqrtNode extends SlotableNode {
  final EquationRowNode index;
  final EquationRowNode base;
  SqrtNode({
    @required this.index,
    @required this.base,
  }) : assert(base != null);

  @override
  List<BuildResult> buildSlotableWidget(
          Options options, List<BuildResult> childBuildResults) =>
      [
        BuildResult(
          options: options,
          widget: CustomLayout<_SqrtPos>(
            delegate: SqrtLayoutDelegate(
              options: options,
              baseOptions: childBuildResults[1].options,
              indexOptions: childBuildResults[0]?.options,
            ),
            children: <Widget>[
              CustomLayoutId(
                  id: _SqrtPos.base, child: childBuildResults[1].widget),
              CustomLayoutId(
                  id: _SqrtPos.surd,
                  child: LayoutBuilderPreserveBaseline(
                    builder: (context, constraints) => sqrtSvg(
                        minDelimiterHeight: constraints.minHeight,
                        baseWidth: constraints.minWidth,
                        options: options),
                  )),
              if (index != null)
                CustomLayoutId(
                    id: _SqrtPos.ind, child: childBuildResults[0].widget),
            ],
          ),
          italic: 0.0,
        )
      ];

  @override
  List<Options> computeChildOptions(Options options) => [
        options.havingStyle(MathStyle.scriptscript),
        options.havingStyle(options.style.cramp()),
      ];

  @override
  List<EquationRowNode> computeChildren() => [index, base];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      copyWith(index: newChildren[0], base: newChildren[1]);

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'index': index.toJson(),
      'base': base.toJson(),
    });

  SqrtNode copyWith({
    EquationRowNode index,
    EquationRowNode base,
  }) =>
      SqrtNode(
        index: index ?? this.index,
        base: base ?? this.base,
      );
}

enum _SqrtPos {
  base,
  ind, // Name collision here
  surd,
}

// Square roots are handled in the TeXbook pg. 443, Rule 11.
class SqrtLayoutDelegate extends CustomLayoutDelegate<_SqrtPos> {
  final Options options;
  final Options baseOptions;
  final Options indexOptions;

  SqrtLayoutDelegate({
    @required this.options,
    @required this.baseOptions,
    @required this.indexOptions,
  });
  var heightAboveBaseline = 0.0;
  var svgHorizontalPos = 0.0;
  var svgVerticalPos = 0.0;
  DrawableRoot svgRoot;

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<_SqrtPos, RenderBox> childrenTable) =>
      heightAboveBaseline;

  @override
  double getIntrinsicSize({
    Axis sizingDirection,
    bool max,
    double extent,
    double Function(RenderBox child, double extent) childSize,
    Map<_SqrtPos, RenderBox> childrenTable,
  }) =>
      0;

  @override
  Size performLayout(BoxConstraints constraints,
      Map<_SqrtPos, RenderBox> childrenTable, RenderBox renderBox) {
    final base = childrenTable[_SqrtPos.base];
    final index = childrenTable[_SqrtPos.ind];
    final surd = childrenTable[_SqrtPos.surd];

    base.layout(infiniteConstraint, parentUsesSize: true);
    index?.layout(infiniteConstraint, parentUsesSize: true);

    final baseHeight = base.layoutHeight;
    // final baseDepth = base.layoutDepth;
    final baseWidth = base.size.width;
    final indexHeight = index?.layoutHeight ?? 0.0;
    final indexWidth = index?.size?.width ?? 0.0;

    final theta = baseOptions.fontMetrics.defaultRuleThickness.cssEm
        .toLpUnder(baseOptions);
    var phi = baseOptions.style > MathStyle.text
        ? baseOptions.fontMetrics.xHeight.cssEm.toLpUnder(baseOptions)
        : theta;
    var psi = theta + 0.25 * phi.abs();

    final minSqrtHeight = base.size.height + psi + theta;

    // Pick sqrt svg
    surd.layout(BoxConstraints(minWidth: baseWidth, minHeight: minSqrtHeight),
        parentUsesSize: true);
    final advanceWidth = getSqrtAdvanceWidth(minSqrtHeight, baseWidth, options);

    // Parameters for index
    // from KaTeX/src/katex.less
    final indexRightPadding = -10.0.mu.toLpUnder(options);
    // KaTeX chose a way to large value (5mu). We will use a smaller one.
    final indexLeftPadding = 0.5.pt.toLpUnder(options);

    // Horizontal layout
    final sqrtHorizontalPos =
        math.max(0.0, indexLeftPadding + indexWidth + indexRightPadding);
    final width = sqrtHorizontalPos + surd.size.width;
    svgHorizontalPos = sqrtHorizontalPos;

    // Vertical layout
    final delimDepth = surd.layoutDepth;
    final ruleWidth = surd.layoutHeight;
    if (delimDepth > base.size.height + psi) {
      psi += 0.5 * (delimDepth - base.size.height - psi);
    }
    final bodyHeight = baseHeight + psi + ruleWidth;
    final bodyDepth = surd.size.height - bodyHeight;
    final indexShift = 0.6 * (bodyHeight - bodyDepth);
    final sqrtVerticalPos =
        math.max(0.0, indexHeight + indexShift - baseHeight - psi - ruleWidth);
    heightAboveBaseline = bodyHeight + sqrtVerticalPos;
    final fullHeight = sqrtVerticalPos + surd.size.height;

    base.offset = Offset(
        sqrtHorizontalPos + advanceWidth, heightAboveBaseline - baseHeight);
    index?.offset = Offset(sqrtHorizontalPos - indexRightPadding - indexWidth,
        heightAboveBaseline - indexShift - indexHeight);
    surd.offset = Offset(sqrtHorizontalPos, sqrtVerticalPos);

    return Size(width, fullHeight);
  }
}

const sqrtDelimieterSequence = [
  // DelimiterConf(mainRegular, MathStyle.scriptscript),
  // DelimiterConf(mainRegular, MathStyle.script),
  DelimiterConf(mainRegular, MathStyle.text),
  DelimiterConf(size1Regular, MathStyle.text),
  DelimiterConf(size2Regular, MathStyle.text),
  DelimiterConf(size3Regular, MathStyle.text),
  DelimiterConf(size4Regular, MathStyle.text),
];

const vbPad = 80;
const emPad = vbPad / 1000;

// We use a different strategy of picking \\surd font than KaTeX
// KaTeX chooses the style and font of the \\surd to cover inner at *normalsize*
// We will use a highly similar strategy while sticking to the strict meaning
// of TexBook Rule 11. We do not choose the style at *normalsize*
double getSqrtAdvanceWidth(
    double minDelimiterHeight, double baseWidth, Options options) {
  // final newOptions = options.havingBaseSize();
  final delimConf = sqrtDelimieterSequence.firstWhereOrNull(
    (element) =>
        getHeightForDelim(
          delim: '\u221A', // √
          fontName: element.font.fontName,
          style: element.style,
          options: options,
        ) >
        minDelimiterHeight,
  );
  if (delimConf != null) {
    final delimOptions = options.havingStyle(delimConf.style);
    if (delimConf?.font?.fontName == 'Main-Regular') {
      final advanceWidth = 0.833.cssEm.toLpUnder(delimOptions);
      return advanceWidth;
    } else {
      // We will directly apply corresponding font

      final advanceWidth = 1.0.cssEm.toLpUnder(delimOptions);

      return advanceWidth;
    }
  } else {
    final advanceWidth = 1.056.cssEm.toLpUnder(options);
    return advanceWidth;
  }
}

// We use a different strategy of picking \\surd font than KaTeX
// KaTeX chooses the style and font of the \\surd to cover inner at *normalsize*
// We will use a highly similar strategy while sticking to the strict meaning
// of TexBook Rule 11. We do not choose the style at *normalsize*
Widget sqrtSvg({double minDelimiterHeight, double baseWidth, Options options}) {
  // final newOptions = options.havingBaseSize();
  final delimConf = sqrtDelimieterSequence.firstWhereOrNull(
    (element) =>
        getHeightForDelim(
          delim: '\u221A', // √
          fontName: element.font.fontName,
          style: element.style,
          options: options,
        ) >
        minDelimiterHeight,
  );

  final extraViniculum = 0.0; //math.max(0.0, options)
  // final ruleWidth =
  //     options.fontMetrics.sqrtRuleThickness.cssEm.toLpUnder(options);
  // TODO: support Settings.minRuleThickness.

  // These are the known height + depth for \u221A
  if (delimConf != null) {
    final fontHeight = const {
      'Main-Regular': 1.0,
      'Size1-Regular': 1.2,
      'Size2-Regular': 1.8,
      'Size3-Regular': 2.4,
      'Size4-Regular': 3.0,
    }[delimConf.font.fontName];
    final delimOptions = options.havingStyle(delimConf.style);
    final viewPortHeight =
        (fontHeight + extraViniculum + emPad).cssEm.toLpUnder(delimOptions);
    if (delimConf?.font?.fontName == 'Main-Regular') {
      // We will be vertically stretching the sqrtMain path (by viewPort vs
      // viewBox) to mimic the height of \u221A under Main-Regular font and
      // corresponding Mathstyle.
      final advanceWidth = 0.833.cssEm.toLpUnder(delimOptions);
      final viewPortWidth = advanceWidth + baseWidth;
      final viewBoxHeight = 1000 + 1000 * extraViniculum + vbPad;
      final viewBoxWidth = viewPortWidth.lp.toCssEmUnder(delimOptions) * 1000;
      final svgPath = sqrtPath('sqrtMain', extraViniculum, viewBoxHeight);
      return ResetBaseline(
        height: (options.fontMetrics.sqrtRuleThickness + extraViniculum)
            .cssEm
            .toLpUnder(delimOptions),
        child: ResetDimension(
          minTopPadding: -emPad.cssEm.toLpUnder(delimOptions),
          child: svgWidgetFromPath(
            svgPath,
            Size(viewPortWidth, viewPortHeight),
            Rect.fromLTWH(0, 0, viewBoxWidth, viewBoxHeight),
            options.color,
            Alignment.topLeft,
            BoxFit.fill,
          ),
        ),
      );
    } else {
      // We will directly apply corresponding font

      final advanceWidth = 1.0.cssEm.toLpUnder(delimOptions);
      final viewPortWidth = math.max(
        advanceWidth + baseWidth,
        1.02.cssEm.toCssEmUnder(delimOptions),
      );
      final viewBoxHeight = (1000 + vbPad) * fontHeight;
      final viewBoxWidth = viewPortWidth.lp.toCssEmUnder(delimOptions) * 1000;
      final svgPath = sqrtPath('sqrt${delimConf.font.fontName.substring(0, 5)}',
          extraViniculum, viewBoxHeight);
      return ResetBaseline(
        height: (options.fontMetrics.sqrtRuleThickness + extraViniculum)
            .cssEm
            .toLpUnder(delimOptions),
        child: ResetDimension(
          minTopPadding: -emPad.cssEm.toLpUnder(delimOptions),
          child: svgWidgetFromPath(
            svgPath,
            Size(viewPortWidth, viewPortHeight),
            Rect.fromLTWH(0, 0, viewBoxWidth, viewBoxHeight),
            options.color,
            Alignment.topLeft,
            BoxFit.fitHeight,
          ),
        ),
      );
    }
  } else {
    // We will use the viewBoxHeight parameter in sqrtTall path
    final viewPortHeight =
        minDelimiterHeight + (extraViniculum + emPad).cssEm.toLpUnder(options);
    final viewBoxHeight = 1000 * minDelimiterHeight.lp.toCssEmUnder(options) +
        extraViniculum +
        vbPad;
    final advanceWidth = 1.056.cssEm.toLpUnder(options);
    final viewPortWidth = advanceWidth + baseWidth;
    final viewBoxWidth = viewPortWidth.lp.toCssEmUnder(options) * 1000;
    final svgPath = sqrtPath('sqrtTall', extraViniculum, viewBoxHeight);
    return ResetBaseline(
      height: (options.fontMetrics.sqrtRuleThickness + extraViniculum)
          .cssEm
          .toLpUnder(options),
      child: ResetDimension(
        minTopPadding: -emPad.cssEm.toLpUnder(options),
        child: svgWidgetFromPath(
          svgPath,
          Size(viewPortWidth, viewPortHeight),
          Rect.fromLTWH(0, 0, viewBoxWidth, viewBoxHeight),
          options.color,
          Alignment.topLeft,
          BoxFit.fitHeight,
        ),
      ),
    );
  }
}
