import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../font/metrics/font_metrics.dart';
import '../../parser/tex_parser/types.dart';
import '../../render/constants.dart';
import '../../render/layout/custom_layout.dart';
import '../../render/layout/reset_baseline.dart';
import '../../render/svg/delimiter.dart';
import '../../render/utils/render_box_offset.dart';
import '../../utils/iterable_extensions.dart';
import '../options.dart';
import '../size.dart';
import '../spacing.dart';
import '../syntax_tree.dart';
import 'math_atom.dart';

class LeftRightNode extends SlotableNode {
  final String leftDelim;
  final String rightDelim;
  final List<EquationRowNode> body;
  final List<String> middle;
  LeftRightNode({
    @required this.leftDelim,
    @required this.rightDelim,
    @required this.body,
    this.middle = const [],
  })  : assert(body.isNotEmpty),
        assert(body.every((element) => element != null)),
        assert(middle.length == body.length - 1);

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    final childWidgets =
        List.generate(2 + body.length + middle.length, (index) {
      if (index % 2 == 0) {
        return CustomLayoutId(
          id: _LeftRightId(isDelimiter: true, number: index ~/ 2 - 1),
          child: LayoutBuilder(
            builder: (context, constraints) => buildCustomSizedDelimWidget(
              index == 0
                  ? leftDelim
                  : index == 1 + body.length + middle.length
                      ? rightDelim
                      : middle[index ~/ 2 - 1],
              constraints.minHeight,
              options,
            ),
          ),
        );
      } else {
        return CustomLayoutId(
          id: _LeftRightId(isDelimiter: false, number: index ~/ 2),
          child: childBuildResults[index ~/ 2].widget,
        );
      }
    }, growable: false);
    return [
      BuildResult(
        italic: Measurement.zero,
        options: options,
        widget: CustomLayout<_LeftRightId>(
          delegate: LeftRightLayoutDelegate(options: options),
          children: childWidgets,
        ),
      )
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) =>
      List.filled(body.length, options, growable: false);

  @override
  List<EquationRowNode> computeChildren() => body;

  @override
  AtomType get leftType => AtomType.open;

  @override
  AtomType get rightType => AtomType.close;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      LeftRightNode(
        leftDelim: leftDelim,
        rightDelim: rightDelim,
        body: newChildren,
        middle: middle,
      );
}

class _LeftRightId {
  final bool isDelimiter;
  final int number;
  const _LeftRightId({
    @required this.isDelimiter,
    @required this.number,
  });

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is _LeftRightId &&
        o.isDelimiter == isDelimiter &&
        o.number == number;
  }

  @override
  int get hashCode => isDelimiter.hashCode ^ number.hashCode;
}

// TexBook Appendix B
const delimiterFactor = 901;
const delimiterShorfall = Measurement(value: 5.0, unit: Unit.pt);

// Delimiter layout is specified in TexBook Rule 19
class LeftRightLayoutDelegate extends CustomLayoutDelegate<_LeftRightId> {
  final Options options;
  // final bool fracLeftDelim;
  // final bool fracRightDelim;
  LeftRightLayoutDelegate({
    @required this.options,
    // this.fracLeftDelim = false,
    // this.fracRightDelim = false,
  });

  double height;

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<_LeftRightId, RenderBox> childrenTable) =>
      height;

  @override
  double getIntrinsicSize({
    Axis sizingDirection,
    bool max,
    double extent,
    double Function(RenderBox child, double extent) childSize,
    Map<_LeftRightId, RenderBox> childrenTable,
  }) =>
      0.0;

  @override
  Size performLayout(BoxConstraints constraints,
      Map<_LeftRightId, RenderBox> childrenTable, RenderBox renderBox) {
    final bodyChildren = (childrenTable.entries
            .where((entry) => !entry.key.isDelimiter)
            .toList(growable: false)
              ..sortBy<num>((e) => e.key.number))
        .map((e) => e.value)
        .toList(growable: false);
    final delimiterChildren = (childrenTable.entries
            .where((entry) => entry.key.isDelimiter)
            .toList(growable: false)
              ..sortBy<num>((e) => e.key.number))
        .map((e) => e.value)
        .toList(growable: false);

    for (final bodyChild in bodyChildren) {
      bodyChild.layout(infiniteConstraint, parentUsesSize: true);
    }

    final a = options.fontMetrics.axisHeight.cssEm.toLpUnder(options);
    final deltas = bodyChildren.map((element) =>
        math.max(element.layoutHeight - a, element.layoutDepth + a));
    final delta = deltas.max();

    final delimiterFullHeight = math.max(delta / 500 * delimiterFactor,
        2 * delta - delimiterShorfall.toLpUnder(options));

    for (final delimiter in delimiterChildren) {
      delimiter.layout(BoxConstraints(minHeight: delimiterFullHeight),
          parentUsesSize: true);
    }

    final spacingLeft = getSpacingSize(
            left: AtomType.open, right: AtomType.ord, style: options.style)
        .toLpUnder(options);

    final spacingMidLeft = getSpacingSize(
            left: AtomType.ord, right: AtomType.rel, style: options.style)
        .toLpUnder(options);

    final spacingMidRight = getSpacingSize(
            left: AtomType.rel, right: AtomType.ord, style: options.style)
        .toLpUnder(options);

    final spacingRight = getSpacingSize(
            left: AtomType.ord, right: AtomType.close, style: options.style)
        .toLpUnder(options);

    final childHeights = childrenTable.entries
        .map((entry) => entry.key.isDelimiter
            ? entry.value.size.height / 2 + a
            : entry.value.layoutHeight)
        .toList(growable: false);

    // final bodyHeights = bodyChildren.map((e) => e.layoutHeight);

    // final delimiterHeights =
    //     delimiterChildren.map((e) => e.size.height / 2 + a);

    height = childHeights.max();

    final bodyDepth = bodyChildren.map((e) => e.layoutDepth);

    final delimiterDepths = delimiterChildren.map((e) => e.size.height / 2 - a);

    final depth = [...bodyDepth, ...delimiterDepths].max();

    var index = 0;
    var currPos = 0.0;
    for (final entry in childrenTable.entries) {
      final child = entry.value;
      if (index == childrenTable.length - 1) {
        currPos += spacingRight;
      } else if (index != 0 && entry.key.isDelimiter) {
        currPos += spacingMidLeft;
      }
      child.offset = Offset(currPos, height - childHeights[index]);
      currPos += child.size.width;
      if (index == 0) {
        currPos += spacingLeft;
      } else if (index != childrenTable.length - 1 && entry.key.isDelimiter) {
        currPos += spacingMidRight;
      }
      index++;
    }
    return Size(currPos, height + depth);
  }
}

const stackLargeDelimiters = {
  '(', ')',
  '[', ']',
  '{', '}',
  '\u230a', '\u230b', // '\\lfloor', '\\rfloor',
  '\u2308', '\u2309', // '\\lceil', '\\rceil',
  '\u221a', // '\\surd'
};

// delimiters that always stack
const stackAlwaysDelimiters = {
  '\u2191', // '\\uparrow',
  '\u2193', // '\\downarrow',
  '\u2195', // '\\updownarrow',
  '\u21d1', // '\\Uparrow',
  '\u21d3', // '\\Downarrow',
  '\u21d5', // '\\Updownarrow',
  '|',
  // '\\|',
  // '\\vert',
  '\u2016', // '\\Vert', '\u2225'
  '\u2223', // '\\lvert', '\\rvert', '\\mid'
  '\u2225', // '\\lVert', '\\rVert',
  '\u27ee', // '\\lgroup',
  '\u27ef', // '\\rgroup',
  '\u23b0', // '\\lmoustache',
  '\u23b1', // '\\rmoustache',
};

// and delimiters that never stack
const stackNeverDelimiters = {
  '<',
  '>',
  '/',
};

Widget buildCustomSizedDelimWidget(
    String delim, double minDelimiterHeight, Options options) {
  List<DelimiterConf> sequence;
  if (stackNeverDelimiters.contains(delim)) {
    sequence = stackNeverDelimiterSequence;
  } else if (stackLargeDelimiters.contains(delim)) {
    sequence = stackLargeDelimiterSequence;
  } else {
    sequence = stackAlwaysDelimiterSequence;
  }

  var delimConf = sequence.firstWhereOrNull((element) =>
      getHeightForDelim(
        delim: delim,
        fontName: element.font.fontName,
        style: element.style,
        options: options,
      ) >
      minDelimiterHeight);
  if (stackNeverDelimiters.contains(delim)) {
    delimConf ??= sequence.last;
  }

  if (delimConf != null) {
    return makeChar(delim, delimConf.font, options);
  } else {
    return makeStakedDelim(delim, minDelimiterHeight, Mode.math, options);
  }
}

Widget makeStakedDelim(
    String delim, double minDelimiterHeight, Mode mode, Options options) {
  final conf = stackDelimiterConfs[delim];
  final topMetrics = getCharacterMetrics(
      character: conf.top, fontName: conf.font.fontName, mode: Mode.math);
  final repeatMetrics = getCharacterMetrics(
      character: conf.repeat, fontName: conf.font.fontName, mode: Mode.math);
  final bottomMetrics = getCharacterMetrics(
      character: conf.bottom, fontName: conf.font.fontName, mode: Mode.math);

  final topHeight =
      (topMetrics.height + topMetrics.depth).cssEm.toLpUnder(options);
  final repeatHeight =
      (repeatMetrics.height + repeatMetrics.depth).cssEm.toLpUnder(options);
  final bottomHeight =
      (bottomMetrics.height + bottomMetrics.depth).cssEm.toLpUnder(options);

  var middleHeight = 0.0;
  var middleFactor = 1;
  if (conf.middle != null) {
    final middleMetrics = getCharacterMetrics(
        character: conf.middle, fontName: conf.font.fontName, mode: Mode.math);
    middleHeight =
        (middleMetrics.height + middleMetrics.depth).cssEm.toLpUnder(options);
    middleFactor = 2;
  }

  final minHeight = topHeight + bottomHeight + middleHeight;
  final repeatCount = math
      .max(0, (minDelimiterHeight - minHeight) / (repeatHeight * middleFactor))
      .ceil();

  final realHeight = minHeight + repeatCount * middleFactor * repeatHeight;

  final axisHeight = options.fontMetrics.axisHeight.cssEm.toLpUnder(options);

  return ResetBaseline(
    height: realHeight / 2 + axisHeight,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        makeChar(conf.top, conf.font, options),
        for (var i = 0; i < repeatCount; i++)
          makeChar(conf.repeat, conf.font, options),
        if (conf.middle != null)
          makeChar(conf.middle, conf.font, options),
        if (conf.middle != null)
          for (var i = 0; i < repeatCount; i++)
            makeChar(conf.repeat, conf.font, options),
        makeChar(conf.bottom, conf.font, options),
      ],
    ),
  );
}

const size4Font = FontOptions(fontFamily: 'Size4');
const size1Font = FontOptions(fontFamily: 'Size1');

class StackDelimiterConf {
  final String top;
  final String middle;
  final String repeat;
  final String bottom;
  final FontOptions font;
  const StackDelimiterConf({
    this.top,
    this.middle,
    this.repeat,
    this.bottom,
    this.font = size4Font,
  });
}

const stackDelimiterConfs = {
  '\u2191': // '\\uparrow',
      StackDelimiterConf(
          top: '\u2191', repeat: '\u23d0', bottom: '\u23d0', font: size1Font),
  '\u2193': // '\\downarrow',
      StackDelimiterConf(
          top: '\u23d0', repeat: '\u23d0', bottom: '\u2193', font: size1Font),
  '\u2195': // '\\updownarrow',
      StackDelimiterConf(
          top: '\u2191', repeat: '\u23d0', bottom: '\u2193', font: size1Font),
  '\u21d1': // '\\Uparrow',
      StackDelimiterConf(
          top: '\u21d1', repeat: '\u2016', bottom: '\u2016', font: size1Font),
  '\u21d3': // '\\Downarrow',
      StackDelimiterConf(
          top: '\u2016', repeat: '\u2016', bottom: '\u21d3', font: size1Font),
  '\u21d5': // '\\Updownarrow',
      StackDelimiterConf(
          top: '\u21d1', repeat: '\u2016', bottom: '\u21d3', font: size1Font),
  '|': // '\\|' ,'\\vert',
      StackDelimiterConf(
          top: '\u2223', repeat: '\u2223', bottom: '\u2223', font: size1Font),
  '\u2016': // '\\Vert', '\u2225'
      StackDelimiterConf(
          top: '\u2016', repeat: '\u2016', bottom: '\u2016', font: size1Font),
  '\u2223': // '\\lvert', '\\rvert', '\\mid'
      StackDelimiterConf(
          top: '\u2223', repeat: '\u2223', bottom: '\u2223', font: size1Font),
  '\u2225': // '\\lVert', '\\rVert',
      StackDelimiterConf(
          top: '\u2225', repeat: '\u2225', bottom: '\u2225', font: size1Font),
  '(': StackDelimiterConf(top: '\u239b', repeat: '\u239c', bottom: '\u239d'),
  ')': StackDelimiterConf(top: '\u239e', repeat: '\u239f', bottom: '\u23a0'),
  '[': StackDelimiterConf(top: '\u23a1', repeat: '\u23a2', bottom: '\u23a3'),
  ']': StackDelimiterConf(top: '\u23a4', repeat: '\u23a5', bottom: '\u23a6'),
  '{': StackDelimiterConf(
      top: '\u23a7', middle: '\u23a8', bottom: '\u23a9', repeat: '\u23aa'),
  '}': StackDelimiterConf(
      top: '\u23ab', middle: '\u23ac', bottom: '\u23ad', repeat: '\u23aa'),
  '\u230a': // '\\lfloor',
      StackDelimiterConf(top: '\u23a2', repeat: '\u23a2', bottom: '\u23a3'),
  '\u230b': // '\\rfloor',
      StackDelimiterConf(top: '\u23a5', repeat: '\u23a5', bottom: '\u23a6'),
  '\u2308': // '\\lceil',
      StackDelimiterConf(top: '\u23a1', repeat: '\u23a2', bottom: '\u23a2'),
  '\u2309': // '\\rceil',
      StackDelimiterConf(top: '\u23a4', repeat: '\u23a5', bottom: '\u23a5'),
  '\u27ee': // '\\lgroup',
      StackDelimiterConf(top: '\u23a7', repeat: '\u23aa', bottom: '\u23a9'),
  '\u27ef': // '\\rgroup',
      StackDelimiterConf(top: '\u23ab', repeat: '\u23aa', bottom: '\u23ad'),
  '\u23b0': // '\\lmoustache',
      StackDelimiterConf(top: '\u23a7', repeat: '\u23aa', bottom: '\u23ad'),
  '\u23b1': // '\\rmoustache',
      StackDelimiterConf(top: '\u23ab', repeat: '\u23aa', bottom: '\u23a9'),
};
