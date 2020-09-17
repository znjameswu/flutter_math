//ignore_for_file: lines_longer_than_80_chars
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../utils/render_box_offset.dart';

class LineParentData extends ContainerBoxParentData<RenderBox> {
  // The first canBreakBefore has no effect
  bool canBreakBefore = false;

  BoxConstraints Function(double height, double depth) customCrossSize;

  double trailingMargin = 0.0;

  bool alignerOrSpacer = false;

  @override
  String toString() =>
      '${super.toString()}; canBreakBefore = $canBreakBefore; customSize = ${customCrossSize != null}; trailingMargin = $trailingMargin; alignerOrSpacer = $alignerOrSpacer';
}

class LineElement extends ParentDataWidget<LineParentData> {
  final bool canBreakBefore;
  final BoxConstraints Function(double height, double depth) customCrossSize;
  final double trailingMargin;
  final bool alignerOrSpacer;

  const LineElement({
    Key key,
    this.canBreakBefore = false,
    this.customCrossSize,
    this.trailingMargin = 0.0,
    this.alignerOrSpacer = false,
    @required Widget child,
  })  : assert(trailingMargin != null),
        super(key: key, child: child);

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is LineParentData);
    final parentData = renderObject.parentData as LineParentData;
    var needsLayout = false;

    if (parentData.canBreakBefore != canBreakBefore) {
      parentData.canBreakBefore = canBreakBefore;
      needsLayout = true;
    }

    if (parentData.customCrossSize != customCrossSize) {
      parentData.customCrossSize = customCrossSize;
      needsLayout = true;
    }

    if (parentData.trailingMargin != trailingMargin) {
      parentData.trailingMargin = trailingMargin;
      needsLayout = true;
    }

    if (parentData.alignerOrSpacer != alignerOrSpacer) {
      parentData.alignerOrSpacer = alignerOrSpacer;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('canBreakBefore',
        value: canBreakBefore, ifTrue: 'allow breaking before'));
    properties.add(FlagProperty('customSize',
        value: customCrossSize != null, ifTrue: 'using relative size'));
    properties.add(DoubleProperty('trailingMargin', trailingMargin));
    properties.add(FlagProperty('alignerOrSpacer',
        value: alignerOrSpacer, ifTrue: 'is a alignment symbol'));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Line;
}

/// Line provides abilities for line breaks, delim-sizing and background color indicator.
class Line extends MultiChildRenderObjectWidget {
  Line({
    Key key,
    this.crossAxisAlignment = CrossAxisAlignment.baseline,
    this.minDepth = 0.0,
    this.minHeight = 0.0,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDirection,
    List<Widget> children = const [],
  })  : assert(textBaseline != null),
        // assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        super(key: key, children: children);

  final CrossAxisAlignment crossAxisAlignment;

  final double minDepth;

  final double minHeight;

  final TextBaseline textBaseline;

  final TextDirection textDirection;

  bool get _needTextDirection => true;

  @protected
  TextDirection getEffectiveTextDirection(BuildContext context) =>
      textDirection ?? (_needTextDirection ? Directionality.of(context) : null);

  @override
  RenderLine createRenderObject(BuildContext context) => RenderLine(
        crossAxisAlignment: crossAxisAlignment,
        minDepth: minDepth,
        minHeight: minHeight,
        textBaseline: textBaseline,
        textDirection: getEffectiveTextDirection(context),
      );

  @override
  void updateRenderObject(BuildContext context, RenderLine renderObject) =>
      renderObject
        ..crossAxisAlignment = crossAxisAlignment
        ..minDepth = minDepth
        ..minHeight = minHeight
        ..textBaseline = textBaseline
        ..textDirection = getEffectiveTextDirection(context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline,
        defaultValue: null));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}

// RenderLine
class RenderLine extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, LineParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, LineParentData>,
        DebugOverflowIndicatorMixin {
  RenderLine({
    List<RenderBox> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.baseline,
    double minDepth,
    double minHeight,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    TextDirection textDirection = TextDirection.ltr,
  })  : assert(textBaseline != null),
        assert(crossAxisAlignment != null),
        _crossAxisAlignment = crossAxisAlignment,
        _minDepth = minDepth,
        _minHeight = minHeight,
        _textBaseline = textBaseline,
        _textDirection = textDirection {
    addAll(children);
  }

  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  CrossAxisAlignment _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
      markNeedsLayout();
    }
  }

  double get minDepth => _minDepth;
  double _minDepth;
  set minDepth(double value) {
    if (_minDepth != value) {
      _minDepth = value;
      markNeedsLayout();
    }
  }

  double get minHeight => _minHeight;
  double _minHeight;
  set minHeight(double value) {
    if (_minHeight != value) {
      _minHeight = value;
      markNeedsLayout();
    }
  }

  TextBaseline get textBaseline => _textBaseline;
  TextBaseline _textBaseline;
  set textBaseline(TextBaseline value) {
    if (_textBaseline != value) {
      _textBaseline = value;
      markNeedsLayout();
    }
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  bool get _debugHasNecessaryDirections {
    assert(crossAxisAlignment != null);
    assert(textDirection != null,
        'Horizontal $runtimeType has a null textDirection, so the alignment cannot be resolved.');
    return true;
  }

  double _overflow;
  bool get _hasOverflow => _overflow > precisionErrorTolerance;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! LineParentData) {
      child.parentData = LineParentData();
    }
  }

  double _getIntrinsicSize({
    Axis sizingDirection,
    double
        extent, // the extent in the direction that isn't the sizing direction
    double Function(RenderBox child, double extent)
        childSize, // a method to find the size in the sizing direction
  }) {
    if (sizingDirection == Axis.horizontal) {
      // INTRINSIC MAIN SIZE
      // Intrinsic main size is the smallest size the flex container can take
      // while maintaining the min/max-content contributions of its flex items.
      var inflexibleSpace = 0.0;
      var child = firstChild;
      while (child != null) {
        inflexibleSpace += childSize(child, extent);
        final childParentData = child.parentData as LineParentData;
        child = childParentData.nextSibling;
      }
      return inflexibleSpace;
    } else {
      // INTRINSIC CROSS SIZE
      // Intrinsic cross size is the max of the intrinsic cross sizes of the
      // children, after the flexible children are fit into the available space,
      // with the children sized using their max intrinsic dimensions.
      var maxCrossSize = 0.0;
      var child = firstChild;
      while (child != null) {
        final childMainSize = child.getMaxIntrinsicWidth(double.infinity);
        final crossSize = childSize(child, childMainSize);
        maxCrossSize = math.max(maxCrossSize, crossSize);
        final childParentData = child.parentData as LineParentData;
        child = childParentData.nextSibling;
      }
      return maxCrossSize;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) => _getIntrinsicSize(
        sizingDirection: Axis.horizontal,
        extent: height,
        childSize: (RenderBox child, double extent) =>
            child.getMinIntrinsicWidth(extent),
      );

  @override
  double computeMaxIntrinsicWidth(double height) => _getIntrinsicSize(
        sizingDirection: Axis.horizontal,
        extent: height,
        childSize: (RenderBox child, double extent) =>
            child.getMaxIntrinsicWidth(extent),
      );

  @override
  double computeMinIntrinsicHeight(double width) => _getIntrinsicSize(
        sizingDirection: Axis.vertical,
        extent: width,
        childSize: (RenderBox child, double extent) =>
            child.getMinIntrinsicHeight(extent),
      );

  @override
  double computeMaxIntrinsicHeight(double width) => _getIntrinsicSize(
        sizingDirection: Axis.vertical,
        extent: width,
        childSize: (RenderBox child, double extent) =>
            child.getMaxIntrinsicHeight(extent),
      );

  double maxHeightAboveBaseline = 0.0;

  double maxHeightAboveEndBaseline = 0.0;

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    return maxHeightAboveBaseline;
  }

  @protected
  List<double> caretPositions;

  @override
  void performLayout() {
    assert(_debugHasNecessaryDirections);
    assert(constraints != null);

    // First pass, layout fixed-sized children to calculate height and depth
    maxHeightAboveBaseline = 0.0;
    var maxDepthBelowBaseline = 0.0;
    var child = firstChild;
    final relativeChildren = <RenderBox>[];
    final alignerAndSpacers = <RenderBox>[];
    while (child != null) {
      final childParentData = child.parentData as LineParentData;
      if (childParentData.customCrossSize != null) {
        relativeChildren.add(child);
      } else if (childParentData.alignerOrSpacer) {
        alignerAndSpacers.add(child);
      } else {
        // final innerConstraints =
        //     BoxConstraints(maxHeight: constraints.maxHeight);
        child.layout(infiniteConstraint, parentUsesSize: true);
        final distance = child.getDistanceToBaseline(textBaseline);
        maxHeightAboveBaseline = math.max(maxHeightAboveBaseline, distance);
        maxDepthBelowBaseline =
            math.max(maxDepthBelowBaseline, child.size.height - distance);
      }
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    // Second pass, layout custom-sized children
    for (final child in relativeChildren) {
      final childParentData = child.parentData as LineParentData;
      assert(childParentData.customCrossSize != null);
      child.layout(
        childParentData.customCrossSize(
            maxHeightAboveBaseline, maxDepthBelowBaseline),
        parentUsesSize: true,
      );
      final distance = child.getDistanceToBaseline(textBaseline);
      maxHeightAboveBaseline = math.max(maxHeightAboveBaseline, distance);
      maxDepthBelowBaseline =
          math.max(maxDepthBelowBaseline, child.size.height - distance);
    }

    // Apply mininmum size constraint
    maxHeightAboveBaseline = math.max(maxHeightAboveBaseline, minHeight);
    maxDepthBelowBaseline = math.max(maxDepthBelowBaseline, minDepth);

    // Third pass. Calculate column width separate by aligners and spacers.
    //
    // Also determine offset for each children in the meantime, as if there are
    // no aligning instructions. If there are indeed none, this will be the
    // final pass.
    child = firstChild;
    var mainPos = 0.0;
    var lastColPosition = mainPos;
    final colWidths = <double>[];
    caretPositions = [mainPos];
    while (child != null) {
      final childParentData = child.parentData as LineParentData;
      if (childParentData.alignerOrSpacer) {
        child.layout(BoxConstraints.tightFor(width: 0.0), parentUsesSize: true);
        colWidths.add(mainPos - lastColPosition);
        lastColPosition = mainPos;
      }
      childParentData.offset =
          Offset(mainPos, maxHeightAboveBaseline - child.layoutHeight);
      mainPos += child.size.width + childParentData.trailingMargin;

      caretPositions.add(mainPos);
      child = childParentData.nextSibling;
    }

    size = constraints.constrain(
        Size(mainPos, maxHeightAboveBaseline + maxDepthBelowBaseline));
    _overflow = mainPos - size.width;

    // If we have no aligners or spacers, no need to do the fourth pass.
    if (alignerAndSpacers.isEmpty) return;

    // If we are have no aligning instructions, no need to do the fourth pass.
    if (this.alignColWidth == null) {
      // Report column width
      alignColWidth = colWidths;
      return;
    }

    // If the code reaches here, means we have aligners/spacers and the
    // aligning instructions.

    // First report first column width.
    alignColWidth = List.of(alignColWidth, growable: false)
      ..[0] = colWidths.first;

    // We will determine the width of the spacers using aligning instructions
    ///
    ///       Aligner     Spacer      Aligner
    ///         |           |           |
    ///       x | f o o b a |         r | z z z
    ///         |           |-------|   |
    ///     y y | f         | o o b a r |
    ///         |   |-------|           |
    /// Index:  0           1           2
    /// Col: 0        1           2
    ///
    var aligner = true;
    var index = 0;
    for (final alignerOrSpacer in alignerAndSpacers) {
      if (aligner) {
        alignerOrSpacer.layout(BoxConstraints.tightFor(width: 0.0),
            parentUsesSize: true);
      } else {
        alignerOrSpacer.layout(
          BoxConstraints.tightFor(
            width: alignColWidth[index] +
                alignColWidth[index + 1] -
                colWidths[index] -
                colWidths[index + 1],
          ),
          parentUsesSize: true,
        );
      }
      aligner = !aligner;
      index++;
    }

    // Fourth pass, determine position for each children
    child = firstChild;
    mainPos = 0.0;
    caretPositions
      ..clear()
      ..add(mainPos);
    while (child != null) {
      final childParentData = child.parentData as LineParentData;
      childParentData.offset =
          Offset(mainPos, maxHeightAboveBaseline - child.layoutHeight);
      mainPos += child.size.width + childParentData.trailingMargin;

      caretPositions.add(mainPos);
      child = childParentData.nextSibling;
    }
    size = constraints.constrain(
        Size(mainPos, maxHeightAboveBaseline + maxDepthBelowBaseline));
    _overflow = mainPos - size.width;
  }

  List<double> alignColWidth;

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  // List<Rect> get rects {
  //   final constraints = this.constraints;
  //   if (constraints is BreakableBoxConstraints) {
  //     var i = 0;
  //     var crossPos = 0.0;
  //     final res = <Rect>[];
  //     for (final size in size.lineSizes) {
  //       final mainPos = i == 0
  //           ? 0.0
  //           : constraints.maxWidthFirstLine - constraints.maxWidthBodyLines;
  //       res.add(Rect.fromLTWH(mainPos, crossPos, size.width, size.height));
  //       crossPos += size.height;
  //       i++;
  //     }
  //     return res;
  //   } else {
  //     return [Rect.fromLTWH(0, 0, size.width, size.height)];
  //   }
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      defaultPaint(context, offset);
      return;
    }

    if (size.isEmpty) return;

    context.pushClipRect(
        needsCompositing, offset, Offset.zero & size, defaultPaint);
    assert(() {
      // Only set this if it's null to save work. It gets reset to null if the
      // _direction changes.
      final debugOverflowHints = <DiagnosticsNode>[
        ErrorDescription(
          'The edge of the $runtimeType that is overflowing has been marked '
          'in the rendering with a yellow and black striped pattern. This is '
          'usually caused by the contents being too big for the $runtimeType.',
        ),
        ErrorHint(
          'Consider applying a flex factor (e.g. using an Expanded widget) to '
          'force the children of the $runtimeType to fit within the available '
          'space instead of being sized to their natural size.',
        ),
        ErrorHint(
          'This is considered an error condition because it indicates that there '
          'is content that cannot be seen. If the content is legitimately bigger '
          'than the available space, consider clipping it with a ClipRect widget '
          'before putting it in the flex, or using a scrollable container rather '
          'than a Flex, like a ListView.',
        ),
      ];

      // Simulate a child rect that overflows by the right amount. This child
      // rect is never used for drawing, just for determining the overflow
      // location and amount.
      Rect overflowChildRect;
      overflowChildRect = Rect.fromLTWH(0.0, 0.0, size.width + _overflow, 0.0);

      paintOverflowIndicator(
          context, offset, Offset.zero & size, overflowChildRect,
          overflowHints: debugOverflowHints);
      return true;
    }());
  }

  @override
  Rect describeApproximatePaintClip(RenderObject child) =>
      _hasOverflow ? Offset.zero & size : null;

  @override
  String toStringShort() {
    var header = super.toStringShort();
    if (_overflow is double && _hasOverflow) header += ' OVERFLOWING';
    return header;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline,
        defaultValue: null));
    // properties.add(DoubleProperty('baselineOffset', baselineOffset));
  }
}
