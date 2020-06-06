//ignore_for_file: lines_longer_than_80_chars
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'column.dart';

class RelativeHeight extends ParentDataWidget<CrossSizeParentData> {
  final double relativeHeight;
  final FlexFit fit;
  const RelativeHeight({
    Key key,
    this.relativeHeight = 1.0,
    this.fit = FlexFit.loose,
    @required Widget child,
  })  : assert(relativeHeight != null),
        assert(relativeHeight <= 1.0),
        assert(relativeHeight >= 0),
        assert(fit != null),
        super(
          key: key,
          child: child,
        );
  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is CrossSizeParentData);
    final parentData = renderObject.parentData as CrossSizeParentData;
    var needsLayout = false;

    if (parentData.relativeCrossSize != relativeHeight) {
      parentData.relativeCrossSize = relativeHeight;
      needsLayout = true;
    }

    if (parentData.fit != fit) {
      parentData.fit = fit;
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
    properties.add(DoubleProperty('relativeHeight', relativeHeight));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => RelativeHeightRow;
}

class RelativeHeightRow extends MultiChildRenderObjectWidget {
  RelativeHeightRow({
    Key key,
    this.textBaseline = TextBaseline.alphabetic,
    // this.baselineReferenceWidgetNum = 0,
    this.baselineOffset = 0,
    this.crossAxisAlignment = CrossAxisAlignment.baseline,
    this.textDirection,
    List<Widget> children = const [],
  })  : assert(textBaseline != null),
        // assert(baselineReferenceWidgetNum != null),
        // assert(baselineReferenceWidgetNum >= 0),
        // assert(baselineReferenceWidgetNum < children.length),
        assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        super(key: key, children: children);
  final TextBaseline textBaseline;
  // final int baselineReferenceWidgetNum;
  final double baselineOffset;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  bool get _needTextDirection => true;

  @protected
  TextDirection getEffectiveTextDirection(BuildContext context) =>
      textDirection ?? (_needTextDirection ? Directionality.of(context) : null);
  @override
  RenderRelativeHeightRow createRenderObject(BuildContext context) =>
      RenderRelativeHeightRow(
        textBaseline: textBaseline,
        // baselineReferenceWidgetNum: baselineReferenceWidgetNum,
        baselineOffset: baselineOffset,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: getEffectiveTextDirection(context),
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderRelativeHeightRow renderObject) {
    renderObject
      ..textBaseline = textBaseline
      // ..baselineReferenceWidgetNum = baselineReferenceWidgetNum
      ..baselineOffset = baselineOffset
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline,
        defaultValue: null));
    // properties.add(IntProperty(
    //     'baselineReferenceWidgetNum', baselineReferenceWidgetNum,
    //     defaultValue: 0));
    properties
        .add(DoubleProperty('baselineOffset', baselineOffset, defaultValue: 0));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}

class RenderRelativeHeightRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CrossSizeParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CrossSizeParentData>,
        DebugOverflowIndicatorMixin {
  RenderRelativeHeightRow({
    List<RenderBox> children,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    // int baselineReferenceWidgetNum = 0,
    double baselineOffset = 0,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.baseline,
    TextDirection textDirection = TextDirection.ltr,
  })  : assert(textBaseline != null),
        // assert(baselineReferenceWidgetNum != null),
        // assert(baselineReferenceWidgetNum >= 0),
        assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        _textBaseline = textBaseline,
        // _baselineReferenceWidgetNum = baselineReferenceWidgetNum,
        _baselineOffset = baselineOffset,
        _crossAxisAlignment = crossAxisAlignment,
        _textDirection = textDirection {
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

  // int get baselineReferenceWidgetNum => _baselineReferenceWidgetNum;
  // int _baselineReferenceWidgetNum;
  // set baselineReferenceWidgetNum(int value) {
  //   if (_baselineReferenceWidgetNum != value) {
  //     _baselineReferenceWidgetNum = value;
  //     markNeedsLayout();
  //   }
  // }

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
    if (child.parentData is! CrossSizeParentData) {
      child.parentData = CrossSizeParentData();
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
        final childParentData = child.parentData as CrossSizeParentData;
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
        final childParentData = child.parentData as CrossSizeParentData;
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

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    return maxHeightAboveBaseline + baselineOffset;
    // var child = firstChild;
    // //ignore: avoid_returning_null
    // if (child == null) return null;
    // for (var i = 0; i < baselineReferenceWidgetNum; i++) {
    //   child = (child.parentData as CrossSizeParentData).nextSibling;
    // }
    // final childParentData = child.parentData as CrossSizeParentData;
    // final childBaselineDistance = child.getDistanceToActualBaseline(baseline) ??
    //     (baseline == TextBaseline.alphabetic
    //         ? child.size.height / 2
    //         : child.size.height);
    // return childParentData.offset.dy + childBaselineDistance + baselineOffset;
  }

  double _getMainSize(RenderBox child) => child.size.width;
  double _getCrossSize(RenderBox child) => child.size.height;

  @override
  void performLayout() {
    assert(_debugHasNecessaryDirections);
    assert(constraints != null);

    var allocatedSize = 0.0; // Sum of the sizes of the non-flexible children.
    maxHeightAboveBaseline = 0.0;
    var maxDepthBelowBaseline = 0.0;
    var child = firstChild;
    final relativeChildren = <RenderBox>[];
    while (child != null) {
      final childParentData = child.parentData as CrossSizeParentData;
      final innerConstraints = BoxConstraints(maxHeight: constraints.maxHeight);
      child.layout(innerConstraints, parentUsesSize: true);
      if (childParentData.relativeCrossSize != null) {
        relativeChildren.add(child);
      } else {
        final distance = child.getDistanceToBaseline(textBaseline);
        maxHeightAboveBaseline = math.max(maxHeightAboveBaseline, distance);
        maxDepthBelowBaseline =
            math.max(maxDepthBelowBaseline, child.size.height - distance);
      }
      allocatedSize += _getMainSize(child);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    var crossSize = maxHeightAboveBaseline + maxDepthBelowBaseline;

    for (final relativeChild in relativeChildren) {
      final childParentData = relativeChild.parentData as CrossSizeParentData;
      assert(childParentData.relativeCrossSize != null);
      final maxChildExtent = crossSize * childParentData.relativeCrossSize;
      BoxConstraints innerConstraints;
      switch (childParentData.fit) {
        case FlexFit.tight:
          innerConstraints = BoxConstraints(
              minWidth: maxChildExtent, maxHeight: maxChildExtent);
          break;
        case FlexFit.loose:
          innerConstraints = BoxConstraints(maxHeight: maxChildExtent);
          break;
      }
      relativeChild.layout(innerConstraints, parentUsesSize: true);
    }

    // Align items along the main axis.
    size = constraints.constrain(Size(allocatedSize, crossSize));
    final actualSize = size.width;
    crossSize = size.height;
    final actualSizeDelta = actualSize - allocatedSize;
    _overflow = math.max(0.0, -actualSizeDelta);
    // flipMainAxis is used to decide whether to lay out left-to-right/top-to-bottom (false), or
    // right-to-left/bottom-to-top (true). The _startIsTopLeft will return null if there's only
    // one child and the relevant direction is null, in which case we arbitrarily decide not to
    // flip, but that doesn't have any detectable effect.

    // Position elements
    var childMainPosition = 0.0;
    child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as CrossSizeParentData;

      // Only support baseline alignment to avoid unecessary code complexity.
      assert(crossAxisAlignment == CrossAxisAlignment.baseline);
      var childCrossPosition = childParentData.relativeCrossSize != null
          ? (crossSize - child.size.height) / 2
          : maxHeightAboveBaseline - child.getDistanceToBaseline(textBaseline);
      // else {
      //   childCrossPosition = 0.0;
      // }
      childParentData.offset = Offset(childMainPosition, childCrossPosition);

      childMainPosition += _getMainSize(child);
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) =>
      defaultHitTestChildren(result, position: position);

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
