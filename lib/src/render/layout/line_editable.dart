import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../ast/syntax_tree.dart';
import 'line.dart';

class EditableLine extends MultiChildRenderObjectWidget {
  EditableLine({
    Key key,
    this.crossAxisAlignment = CrossAxisAlignment.baseline,
    this.hintingColor,
    this.minDepth = 0.0,
    this.minHeight = 0.0,
    @required this.node,
    @required this.preferredLineHeight,
    this.selection = const TextSelection.collapsed(offset: -1),
    @required this.selectionColor,
    this.textBaseline = TextBaseline.alphabetic,
    this.textDirection,
    List<Widget> children = const [],
  })  : assert(textBaseline != null),
        // assert(baselineOffset != null),
        assert(crossAxisAlignment != null),
        super(key: key, children: children);

  final CrossAxisAlignment crossAxisAlignment;

  final Color hintingColor;

  final double minDepth;

  final double minHeight;

  final EquationRowNode node;

  final double preferredLineHeight;

  final TextSelection selection;

  final Color selectionColor;

  final TextBaseline textBaseline;

  final TextDirection textDirection;

  bool get _needTextDirection => true;

  @protected
  TextDirection getEffectiveTextDirection(BuildContext context) =>
      textDirection ?? (_needTextDirection ? Directionality.of(context) : null);

  @override
  RenderEditableLine createRenderObject(BuildContext context) =>
      RenderEditableLine(
        crossAxisAlignment: crossAxisAlignment,
        hintingColor: hintingColor,
        minDepth: minDepth,
        minHeight: minHeight,
        node: node,
        preferredLineHeight: preferredLineHeight,
        selection: selection,
        selectionColor: selectionColor,
        textBaseline: textBaseline,
        textDirection: getEffectiveTextDirection(context),
      );

  @override
  void updateRenderObject(
          BuildContext context, RenderEditableLine renderObject) =>
      renderObject
        ..crossAxisAlignment = crossAxisAlignment
        ..hintingColor = hintingColor
        ..minDepth = minDepth
        ..minHeight = minHeight
        ..node = node
        ..preferredLineHeight = preferredLineHeight
        ..selection = selection
        ..selectionColor = selectionColor
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

class RenderEditableLine extends RenderLine {
  RenderEditableLine({
    List<RenderBox> children,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.baseline,
    Color hintingColor,
    double minDepth,
    double minHeight,
    this.node,
    this.preferredLineHeight,
    TextSelection selection,
    @required Color selectionColor,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    TextDirection textDirection = TextDirection.ltr,
  })  : _hintingColor = hintingColor,
        _selection = selection,
        _selectionColor = selectionColor,
        super(
          children: children,
          crossAxisAlignment: crossAxisAlignment,
          minDepth: minDepth,
          minHeight: minHeight,
          textBaseline: textBaseline,
          textDirection: textDirection,
        );

  Color get hintingColor => _hintingColor;
  Color _hintingColor;
  set hintingColor(Color value) {
    if (_hintingColor != value) {
      _hintingColor = value;
      markNeedsPaint();
    }
  }

  EquationRowNode node;

  double preferredLineHeight;

  TextSelection get selection => _selection;
  TextSelection _selection;
  set selection(TextSelection value) {
    if (_selection != value) {
      _selection = value;
      markNeedsPaint();
    }
  }

  Color get selectionColor => _selectionColor;
  Color _selectionColor;
  set selectionColor(Color value) {
    if (_selectionColor != value) {
      _selectionColor = value;
      markNeedsPaint();
    }
  }

  int getCaretPositionForPoint(Offset globalOffset) {
    final localOffset = globalToLocal(globalOffset);
    var minDist = double.infinity;
    var minPosition = 0;
    for (var i = 0; i < caretPositions.length; i++) {
      final dist = (caretPositions[i] - localOffset.dx).abs();
      if (dist <= minDist) {
        minDist = dist;
        minPosition = i;
      }
    }
    return minPosition;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Only paint selection/hinting if the selection is in range
    if (_selection.end > -1 && _selection.start < childCount + 1) {
      if (!_selection.isCollapsed) {
        // Paint selection if not collapsed
        final startOffset = caretPositions[selection.start];
        final endOffset = caretPositions[selection.end];

        context.canvas.drawRect(
          Rect.fromLTRB(startOffset, 0, endOffset, size.height).shift(offset),
          Paint()
            ..style = PaintingStyle.fill
            ..color = _selectionColor,
        );
      } else if (_hintingColor != null) {
        // Paint hinting background if selection is collapsed
        context.canvas.drawRect(
          offset & size,
          Paint()
            ..style = PaintingStyle.fill
            ..color = _hintingColor,
        );
      }
    }
    super.paint(context, offset);
    return;
  }
}
