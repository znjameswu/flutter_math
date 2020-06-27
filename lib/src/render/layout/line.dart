//ignore_for_file: lines_longer_than_80_chars
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../utils/iterable_extensions.dart';
import 'breakable/breakable_box.dart';
import 'breakable/breakable_constraints.dart';
import 'breakable/breakable_offset.dart';
import 'breakable/breakable_size.dart';

class LineParentData extends ContainerBreakableBoxParentData<RenderBox> {

  // The first canBreakBefore will be ignored
  bool canBreakBefore;

  BoxConstraints Function(double height, double depth) customCrossSize;

  // The last trailing spacing will be ignored
  double trailingSpacing;

  /// Margin with the end of last sibling on the main axis
  ///
  /// If [mainMargin] > 0, this behavior can be easilty simulated by [Padding].
  /// This property is for the sole purpose of negative [mainMargin]
  // double mainMargin;

  @override
  String toString() =>
      '${super.toString()}; canBreakBefore = $canBreakBefore; customSize = ${customCrossSize != null}; trailingSpacing = $trailingSpacing';
}

class LineElement extends ParentDataWidget<LineParentData> {
  final bool canBreakBefore;
  final BoxConstraints Function(double height, double depth) customCrossSize;
  final double trailingSpacing;

  const LineElement({
    Key key,
    this.canBreakBefore = false,
    this.customCrossSize,
    @required this.trailingSpacing,
    @required Widget child,
  }) : super(
          key: key,
          child: child,
        );
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

    if (parentData.trailingSpacing != trailingSpacing) {
      parentData.trailingSpacing = trailingSpacing;
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
    properties.add(DoubleProperty('trailingSpacing', trailingSpacing));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Line;
}

/// Line provides abilities for line breaks, delim-sizing and background color indicator.
class Line extends MultiChildRenderObjectWidget {
  Line({
    Key key,
    this.textBaseline = TextBaseline.alphabetic,
    this.baselineOffset = 0,
    this.crossAxisAlignment = CrossAxisAlignment.baseline,
    this.textDirection,
    this.background,
    List<Widget> children = const [],
  })  : assert(textBaseline != null),
        assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        super(key: key, children: children);
  final TextBaseline textBaseline;
  final double baselineOffset;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  bool get _needTextDirection => true;
  final ValueNotifier<Color> background;

  @protected
  TextDirection getEffectiveTextDirection(BuildContext context) =>
      textDirection ?? (_needTextDirection ? Directionality.of(context) : null);
  @override
  RenderLine createRenderObject(BuildContext context) => RenderLine(
        textBaseline: textBaseline,
        baselineOffset: baselineOffset,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: getEffectiveTextDirection(context),
        background: background,
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderLine renderObject) {
    renderObject
      ..textBaseline = textBaseline
      ..baselineOffset = baselineOffset
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context)
      ..background = background;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline,
        defaultValue: null));
    properties
        .add(DoubleProperty('baselineOffset', baselineOffset, defaultValue: 0));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}

class RenderLine extends RenderBreakableBox
    with
        ContainerRenderObjectMixin<RenderBox, LineParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, LineParentData>,
        DebugOverflowIndicatorMixin {
  RenderLine({
    List<RenderBox> children,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    double baselineOffset = 0,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.baseline,
    TextDirection textDirection = TextDirection.ltr,
    ValueNotifier<Color> background,
  })  : assert(textBaseline != null),
        assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        _textBaseline = textBaseline,
        _baselineOffset = baselineOffset,
        _crossAxisAlignment = crossAxisAlignment,
        _textDirection = textDirection,
        _background = background {
    addAll(children);
  }

  TextBaseline get textBaseline => _textBaseline;
  TextBaseline _textBaseline;
  set textBaseline(TextBaseline value) {
    if (_textBaseline != value) {
      _textBaseline = value;
      markNeedsLayout();
    }
  }

  double get baselineOffset => _baselineOffset;
  double _baselineOffset;
  set baselineOffset(double value) {
    if (_baselineOffset != value) {
      _baselineOffset = value;
      markNeedsLayout();
    }
  }

  CrossAxisAlignment get crossAxisAlignment => _crossAxisAlignment;
  CrossAxisAlignment _crossAxisAlignment;
  set crossAxisAlignment(CrossAxisAlignment value) {
    if (_crossAxisAlignment != value) {
      _crossAxisAlignment = value;
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

  ValueNotifier<Color> get background => _background;
  ValueNotifier<Color> _background;
  set background(ValueNotifier<Color> value) {
    // assert(value != null);
    if (attached && _background != null) {
      _background.removeListener(markNeedsPaint);
    }
    _background = value;
    if (attached && _background != null) {
      _background.addListener(markNeedsPaint);
    }
    markNeedsPaint();
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
  void attach(PipelineOwner owner) {
    super.attach(owner);
    background?.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    background?.removeListener(markNeedsPaint);
    super.detach();
  }

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
    return maxHeightAboveBaseline + baselineOffset;
  }

  @override
  void performLayout() {
    assert(_debugHasNecessaryDirections);
    assert(constraints != null);

    // var allocatedSize = 0.0; // Sum of the sizes of the non-flexible children.
    maxHeightAboveBaseline = 0.0;
    var maxDepthBelowBaseline = 0.0;
    var child = firstChild;
    final delimiters = <RenderBox>[];
    while (child != null) {
      final childParentData = child.parentData as LineParentData;
      final innerConstraints = BoxConstraints(maxHeight: constraints.maxHeight);
      child.layout(innerConstraints, parentUsesSize: true);
      if (childParentData.customCrossSize != null) {
        delimiters.add(child);
      } else {
        final distance = child.getDistanceToBaseline(textBaseline);
        maxHeightAboveBaseline = math.max(maxHeightAboveBaseline, distance);
        maxDepthBelowBaseline =
            math.max(maxDepthBelowBaseline, child.size.height - distance);
      }
      // allocatedSize += _getMainSize(child);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    // var crossSize = maxHeightAboveBaseline + maxDepthBelowBaseline;

    for (final delimeter in delimiters) {
      final childParentData = delimeter.parentData as LineParentData;
      delimeter.layout(
        childParentData.customCrossSize(
            maxHeightAboveBaseline, maxDepthBelowBaseline),
        parentUsesSize: true,
      );
    }

    final layoutProxy = _BreakableLayoutProxy(
      constraints: constraints,
      firstChild: firstChild,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
    );

    final layoutSize = layoutProxy.layout();

    size = constraints.constrain(layoutSize);

    _overflow = 0;
    for (var i = 0; i < size.lineSizes.length; i++) {
      _overflow = math.max(
          _overflow, layoutSize.lineSizes[i].width - size.lineSizes[i].width);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

  List<Rect> get rects {
    final constraints = this.constraints;
    if (constraints is BreakableBoxConstraints) {
      var i = 0;
      var crossPos = 0.0;
      final res = <Rect>[];
      for (final size in size.lineSizes) {
        final mainPos = i == 0
            ? 0.0
            : constraints.maxWidthFirstLine - constraints.maxWidthRestLines;
        res.add(Rect.fromLTWH(mainPos, crossPos, size.width, size.height));
        crossPos += size.height;
        i++;
      }
      return res;
    } else {
      return [Rect.fromLTWH(0, 0, size.width, size.height)];
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_hasOverflow) {
      if (_background != null) {
        for (final rect in rects) {
          context.canvas.drawRect(
            rect.shift(offset),
            Paint()
              ..style = PaintingStyle.fill
              ..color = _background?.value ?? Colors.transparent,
          );
        }
      }
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
      overflowChildRect = Rect.fromLTWH(0.0, 0.0, 0.0, size.height + _overflow);

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
    properties.add(DoubleProperty('baselineOffset', baselineOffset));
  }
}

class _BreakableLayoutProxy {
  double maxHeightAboveBaseline;
  double maxHeightAboveEndBaseline;

  final BoxConstraints constraints;
  final RenderBox firstChild;
  final CrossAxisAlignment crossAxisAlignment;
  final TextBaseline textBaseline;

  double maxWidthFirstLine;
  double maxWidthRestLines;
  double mainPosRestLines;

  _BreakableLayoutProxy({
    this.constraints,
    this.firstChild,
    this.crossAxisAlignment,
    this.textBaseline,
  })  : maxWidthFirstLine = constraints is BreakableBoxConstraints
            ? constraints.maxWidthFirstLine
            : double.infinity,
        maxWidthRestLines = constraints is BreakableBoxConstraints
            ? constraints.maxWidthRestLines
            : double.infinity,
        mainPosRestLines = constraints is BreakableBoxConstraints
            ? constraints.restLineStartPos
            : 0.0;

  var currLineNum = 0;
  var currLineCrossPos = 0.0;
  double get currLineMaxWidth =>
      currLineNum == 0 ? maxWidthFirstLine : maxWidthRestLines;
  double get currLineMainPos => currLineNum == 0 ? 0.0 : mainPosRestLines;
  var currLineFinalHeight = 0.0;
  var currLineFinalHeightAboveBaseline = 0.0;
  final currLineWaitingChildren = <RenderBox>[];
  // final currLineWaitingChildrenMainPos = <double>[];
  final currLineWaitingSizes = <Size>[];
  final currLineWaitingBaseline = <double>[];
  final lastBreakableLineOffsets = <Offset>[];

  var childMainPosition = 0.0;

  BreakableSize layout() {
    final lineSizes = <Size>[];
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as LineParentData;

      // Judge if we need to start a new line
      var needStartAtNewLine = true;
      // If this line is currently emptpy, then we must fill the line with
      // SOMETHING, even it overflows
      if (childMainPosition == 0) {
        needStartAtNewLine = false;
      } else {
        // If current line can accomodate, then fill it.
        if (child is RenderBreakableBox) {
          final innerConstraints = BreakableBoxConstraints(
            minWidth: constraints.minWidth,
            maxWidthFirstLine: currLineMaxWidth - childMainPosition,
            maxWidthRestLines: maxWidthRestLines,
            minHeight: constraints.minHeight,
            maxHeight: constraints.maxHeight - currLineCrossPos,
          );
          child.layout(innerConstraints, parentUsesSize: true);
        }
        final childMinWidth = (child is RenderBreakableBox)
            ? child.size.lineSizes.first.width
            : child.size.width;
        if (childMainPosition + childMinWidth <= currLineMaxWidth) {
          needStartAtNewLine = false;
        }
      }

      if (needStartAtNewLine) {
        finalizeCurrLine();
        lineSizes.add(layoutWaitingChildren());
        advanceNextLine();
      }

      if (child is RenderBreakableBox) {
        final innerConstraints = BreakableBoxConstraints(
          minWidth: constraints.minWidth,
          maxWidthFirstLine: currLineMaxWidth - childMainPosition,
          maxWidthRestLines: maxWidthRestLines,
          minHeight: constraints.minHeight,
          maxHeight: constraints.maxHeight - currLineCrossPos,
        );
        child.layout(innerConstraints, parentUsesSize: true);
        if (child.size.lineSizes.length == 1) {
          addWaitingSize(
              child, child.size, child.getDistanceToBaseline(textBaseline));
        } else {
          addWaitingSize(child, child.size.lineSizes.first,
              child.getDistanceToBaseline(textBaseline));
          lastBreakableLineOffsets.add(Offset(
            currLineMainPos + childMainPosition,
            currLineFinalHeightAboveBaseline -
                child.getDistanceToBaseline(textBaseline),
          ));

          finalizeCurrLine();
          lineSizes.add(layoutWaitingChildren());
          advanceNextLine();

          for (var i = 1; i < child.size.lineSizes.length - 1; i++) {
            final size = child.size.lineSizes[i];

            lastBreakableLineOffsets
                .add(Offset(currLineMainPos, currLineCrossPos));
            lineSizes.add(size);

            currLineNum++;
            currLineCrossPos += size.height;
          }

          addWaitingSize(child, child.size.lineSizes.last,
              child.getDistanceToEndBaseline(textBaseline));
        }
      } else {
        final a = child.getDistanceToBaseline(textBaseline);
        addWaitingSize(
            child, child.size, child.getDistanceToBaseline(textBaseline));
      }

      child = childParentData.nextSibling;
    }
    finalizeCurrLine();
    lineSizes.add(layoutWaitingChildren());
    return BreakableSize(lineSizes);
  }

  void finalizeCurrLine() {
    var currLineMaxHeightAboveBaseline = 0.0;
    var currLineMaxDepthBelowBaseline = 0.0;
    for (var i = 0; i < currLineWaitingSizes.length; i++) {
      currLineMaxHeightAboveBaseline =
          math.max(currLineMaxHeightAboveBaseline, currLineWaitingBaseline[i]);
      currLineMaxDepthBelowBaseline = math.max(currLineMaxDepthBelowBaseline,
          currLineWaitingSizes[i].height - currLineWaitingBaseline[i]);
    }
    currLineFinalHeightAboveBaseline = currLineMaxHeightAboveBaseline;
    currLineFinalHeight =
        currLineMaxHeightAboveBaseline + currLineMaxDepthBelowBaseline;

    maxHeightAboveBaseline ??= currLineMaxHeightAboveBaseline;
    maxHeightAboveEndBaseline = currLineMaxHeightAboveBaseline;
  }

  Size layoutWaitingChildren() {
    var childMainPos = 0.0;
    // Position the children that are waiting for layout on the current line
    for (var i = 0; i < currLineWaitingChildren.length; i++) {
      final child = currLineWaitingChildren[i];

      final childParentData = child.parentData as LineParentData;
      // final currLineMainPos = currLineNum == 0 ? 0.0 : mainPosRestLines;
      // Only support baseline alignment to avoid unecessary code complexity.
      assert(crossAxisAlignment == CrossAxisAlignment.baseline);
      // For relative child, they will always be centered.
      final childCrossPos =
          currLineFinalHeightAboveBaseline - currLineWaitingBaseline[i];
      final currentOffset = Offset(
        currLineMainPos + childMainPos,
        currLineCrossPos + childCrossPos,
      );
      if (child is RenderBreakableBox && lastBreakableLineOffsets.isNotEmpty) {
        lastBreakableLineOffsets.add(currentOffset);
        childParentData.offset =
            BreakableOffset(List.from(lastBreakableLineOffsets));
        lastBreakableLineOffsets.clear();
      } else {
        childParentData.offset = currentOffset;
      }

      childMainPos += currLineWaitingSizes[i].width;
    }
    return Size(
      childMainPos,
      currLineFinalHeight,
    );
  }

  void advanceNextLine() {
    // Clear up variables for the next line
    currLineNum++;
    childMainPosition = 0;
    currLineCrossPos += currLineFinalHeight;
    currLineWaitingChildren.clear();
    currLineWaitingSizes.clear();
    currLineWaitingBaseline.clear();
  }

  void addWaitingSize(RenderBox child, Size size, double heightAboveBaseline) {
    currLineWaitingChildren.add(child);
    currLineWaitingSizes.add(size);
    currLineWaitingBaseline.add(heightAboveBaseline);
    childMainPosition += size.width;
  }
}
