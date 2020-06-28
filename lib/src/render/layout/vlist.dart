//ignore_for_file: lines_longer_than_80_chars
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class VListParentData extends ContainerBoxParentData<RenderBox> {
  BoxConstraints Function(double width) customCrossSize;

  double trailingMargin = 0.0;

  @override
  String toString() =>
      '${super.toString()}; customCrossSize=${customCrossSize != null}; trailingMargin=$trailingMargin';
}

class VListElement extends ParentDataWidget<VListParentData> {
  final BoxConstraints Function(double width) customCrossSize;

  final double trailingMargin;

  const VListElement({
    Key key,
    this.customCrossSize,
    this.trailingMargin = 0.0,
    @required Widget child,
  })  : assert(trailingMargin != null),
        super(key: key, child: child);

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is VListParentData);
    final parentData = renderObject.parentData as VListParentData;
    var needsLayout = false;

    if (parentData.customCrossSize != customCrossSize) {
      parentData.customCrossSize = customCrossSize;
      needsLayout = true;
    }

    if (parentData.trailingMargin != trailingMargin) {
      parentData.trailingMargin = trailingMargin;
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
    properties.add(FlagProperty('customSize',
        value: customCrossSize != null, ifTrue: 'using relative size'));
    properties.add(DoubleProperty('trailingMargin', trailingMargin));
  }

  @override
  Type get debugTypicalAncestorWidgetClass => VList;
}

class VList extends MultiChildRenderObjectWidget {
  VList({
    Key key,
    this.textBaseline = TextBaseline.alphabetic,
    this.baselineReferenceWidgetIndex = 0,
    // this.baselineOffset = 0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    List<Widget> children = const [],
  })  : assert(textBaseline != null),
        assert(baselineReferenceWidgetIndex != null),
        // assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        super(key: key, children: children);
  final TextBaseline textBaseline;
  final int baselineReferenceWidgetIndex;
  // final double baselineOffset;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection textDirection;
  bool get _needTextDirection =>
      crossAxisAlignment == CrossAxisAlignment.start ||
      crossAxisAlignment == CrossAxisAlignment.end;

  @protected
  TextDirection getEffectiveTextDirection(BuildContext context) =>
      textDirection ?? (_needTextDirection ? Directionality.of(context) : null);
  @override
  RenderRelativeWidthColumn createRenderObject(BuildContext context) =>
      RenderRelativeWidthColumn(
        textBaseline: textBaseline,
        baselineReferenceWidgetIndex: baselineReferenceWidgetIndex,
        // baselineOffset: baselineOffset,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: getEffectiveTextDirection(context),
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderRelativeWidthColumn renderObject) {
    renderObject
      ..textBaseline = textBaseline
      ..baselineReferenceWidgetIndex = baselineReferenceWidgetIndex
      // ..baselineOffset = baselineOffset
      ..crossAxisAlignment = crossAxisAlignment
      ..textDirection = getEffectiveTextDirection(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline,
        defaultValue: null));
    properties.add(IntProperty(
        'baselineReferenceWidgetNum', baselineReferenceWidgetIndex,
        defaultValue: 0));
    // properties
    // .add(DoubleProperty('baselineOffset', baselineOffset, defaultValue: 0));
    properties.add(EnumProperty<CrossAxisAlignment>(
        'crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
  }
}

class RenderRelativeWidthColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, VListParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, VListParentData>,
        DebugOverflowIndicatorMixin {
  RenderRelativeWidthColumn({
    List<RenderBox> children,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    int baselineReferenceWidgetIndex = 0,
    // double baselineOffset = 0,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection textDirection = TextDirection.ltr,
  })  : assert(textBaseline != null),
        assert(baselineReferenceWidgetIndex != null),
        // assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        _textBaseline = textBaseline,
        _baselineReferenceWidgetIndex = baselineReferenceWidgetIndex,
        // _baselineOffset = baselineOffset,
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

  int get baselineReferenceWidgetIndex => _baselineReferenceWidgetIndex;
  int _baselineReferenceWidgetIndex;
  set baselineReferenceWidgetIndex(int value) {
    if (_baselineReferenceWidgetIndex != value) {
      _baselineReferenceWidgetIndex = value;
      markNeedsLayout();
    }
  }

  // double get baselineOffset => _baselineOffset;
  // double _baselineOffset;
  // set baselineOffset(double value) {
  //   if (_baselineOffset != value) {
  //     _baselineOffset = value;
  //     markNeedsLayout();
  //   }
  // }

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
    if (crossAxisAlignment == CrossAxisAlignment.start ||
        crossAxisAlignment == CrossAxisAlignment.end) {
      assert(textDirection != null,
          'Vertical $runtimeType with $crossAxisAlignment has a null textDirection, so the alignment cannot be resolved.');
    }
    return true;
  }

  double _overflow;
  bool get _hasOverflow => _overflow > precisionErrorTolerance;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! VListParentData) {
      child.parentData = VListParentData();
    }
  }

  double _getIntrinsicSize({
    Axis sizingDirection,
    double
        extent, // the extent in the direction that isn't the sizing direction
    double Function(RenderBox child, double extent)
        childSize, // a method to find the size in the sizing direction
  }) {
    if (sizingDirection == Axis.vertical) {
      // INTRINSIC MAIN SIZE
      // Intrinsic main size is the smallest size the flex container can take
      // while maintaining the min/max-content contributions of its flex items.
      var inflexibleSpace = 0.0;
      var child = firstChild;
      while (child != null) {
        inflexibleSpace += childSize(child, extent);
        final childParentData = child.parentData as VListParentData;
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
        final childMainSize = child.getMaxIntrinsicHeight(double.infinity);
        final crossSize = childSize(child, childMainSize);
        maxCrossSize = math.max(maxCrossSize, crossSize);
        final childParentData = child.parentData as VListParentData;
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

  double distanceToBaseline;

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    return distanceToBaseline;
  }

  @override
  void performLayout() {
    distanceToBaseline = null;
    assert(_debugHasNecessaryDirections);
    assert(constraints != null);

    var crossSize = 0.0;
    var allocatedSize = 0.0; // Sum of the sizes of the non-flexible children.
    var child = firstChild;
    final relativeChildren = <RenderBox>[];
    while (child != null) {
      final childParentData = child.parentData as VListParentData;
      if (childParentData.customCrossSize != null) {
        relativeChildren.add(child);
      } else {
        final innerConstraints = BoxConstraints(maxWidth: constraints.maxWidth);
        child.layout(innerConstraints, parentUsesSize: true);
        crossSize = math.max(crossSize, child.size.width);
        allocatedSize += child.size.height + childParentData.trailingMargin;
      }
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }

    for (final child in relativeChildren) {
      final childParentData = child.parentData as VListParentData;
      assert(childParentData.customCrossSize != null);
      child.layout(childParentData.customCrossSize(crossSize),
          parentUsesSize: true);
      crossSize = math.max(crossSize, child.size.width);
      allocatedSize += child.size.height + childParentData.trailingMargin;
    }

    // Align items along the main axis.
    size = constraints.constrain(Size(crossSize, allocatedSize));
    final actualSize = size.height;
    crossSize = size.width;
    final actualSizeDelta = actualSize - allocatedSize;
    _overflow = math.max(0.0, -actualSizeDelta);
    // flipMainAxis is used to decide whether to lay out left-to-right/top-to-bottom (false), or
    // right-to-left/bottom-to-top (true). The _startIsTopLeft will return null if there's only
    // one child and the relevant direction is null, in which case we arbitrarily decide not to
    // flip, but that doesn't have any detectable effect.

    // Position elements
    var index = 0;
    var childMainPosition = 0.0;
    child = firstChild;
    while (child != null) {
      final childParentData = child.parentData as VListParentData;
      var childCrossPosition = 0.0;
      switch (crossAxisAlignment) {
        case CrossAxisAlignment.start:
          childCrossPosition = textDirection == TextDirection.ltr
              ? 0.0
              : crossSize - child.size.width;
          break;
        case CrossAxisAlignment.end:
          childCrossPosition = textDirection == TextDirection.rtl
              ? 0.0
              : crossSize - child.size.width;
          break;
        case CrossAxisAlignment.center:
          childCrossPosition = (crossSize - child.size.width) * 0.5;
          break;
        case CrossAxisAlignment.stretch:
        case CrossAxisAlignment.baseline:
          childCrossPosition = 0.0;
          break;
      }
      childParentData.offset = Offset(childCrossPosition, childMainPosition);

      if (index == baselineReferenceWidgetIndex) {
        distanceToBaseline =
            childMainPosition + child.getDistanceToBaseline(textBaseline);
      }

      childMainPosition += child.size.height + childParentData.trailingMargin;
      child = childParentData.nextSibling;
      index++;
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
    properties.add(IntProperty(
        'baselineReferenceWidgetIndex', baselineReferenceWidgetIndex));
  }
}
