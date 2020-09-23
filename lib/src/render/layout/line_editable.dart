import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../ast/syntax_tree.dart';
import '../../utils/num_extension.dart';
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
    this.startHandleLayerLink,
    this.endHandleLayerLink,
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

  final LayerLink startHandleLayerLink;

  final LayerLink endHandleLayerLink;

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
        startHandleLayerLink: startHandleLayerLink,
        endHandleLayerLink: endHandleLayerLink,
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
        ..startHandleLayerLink = startHandleLayerLink
        ..endHandleLayerLink = endHandleLayerLink
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
    LayerLink startHandleLayerLink,
    LayerLink endHandleLayerLink,
    TextBaseline textBaseline = TextBaseline.alphabetic,
    TextDirection textDirection = TextDirection.ltr,
  })  : _hintingColor = hintingColor,
        _selection = selection,
        _selectionColor = selectionColor,
        _startHandleLayerLink = startHandleLayerLink,
        _endHandleLayerLink = endHandleLayerLink,
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

  LayerLink get startHandleLayerLink => _startHandleLayerLink;
  LayerLink _startHandleLayerLink;
  set startHandleLayerLink(LayerLink value) {
    if (_startHandleLayerLink != value) {
      _startHandleLayerLink = value;
      markNeedsPaint();
    }
  }

  LayerLink get endHandleLayerLink => _endHandleLayerLink;
  LayerLink _endHandleLayerLink;
  set endHandleLayerLink(LayerLink value) {
    if (_endHandleLayerLink != value) {
      _endHandleLayerLink = value;
      markNeedsPaint();
    }
  }

  int getCaretIndexForPoint(Offset globalOffset) {
    final localOffset = globalToLocal(globalOffset);
    var minDist = double.infinity;
    var minPosition = 0;
    for (var i = 0; i < caretOffsets.length; i++) {
      final dist = (caretOffsets[i] - localOffset.dx).abs();
      if (dist <= minDist) {
        minDist = dist;
        minPosition = i;
      }
    }
    return minPosition;
  }

  // Will always attempt to get the nearest left caret
  int getNearestLeftCaretIndexForPoint(Offset globalOffset) {
    final localOffset = globalToLocal(globalOffset);
    var index = 0;
    while (
        caretOffsets[index] <= localOffset.dx && index < caretOffsets.length) {
      index++;
    }
    return math.max(0, index - 1);
  }

  Offset getEndpointForCaretIndex(int index) {
    final dx = caretOffsets[index.clampInt(0, caretOffsets.length - 1)];
    final dy = size.height;
    return localToGlobal(Offset(dx, dy));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Only paint selection/hinting if the part of the selection is in range
    if (_selection.end >= 0 && _selection.start <= childCount) {
      if (_selection.isCollapsed) {
        if (_hintingColor != null) {
          // Paint hinting background if selection is collapsed
          context.canvas.drawRect(
            offset & size,
            Paint()
              ..style = PaintingStyle.fill
              ..color = _hintingColor,
          );
        }
      } else {
        // Paint selection if not collapsed
        final startOffset = caretOffsets[math.max(0, selection.start)];
        final endOffset = caretOffsets[math.min(childCount, selection.end)];

        context.canvas.drawRect(
          Rect.fromLTRB(startOffset, 0, endOffset, size.height).shift(offset),
          Paint()
            ..style = PaintingStyle.fill
            ..color = _selectionColor,
        );

        if (startHandleLayerLink != null) {
          context.pushLayer(
            LeaderLayer(
              link: startHandleLayerLink,
              offset: Offset(startOffset, size.height) + offset,
            ),
            emptyPaintFunction,
            Offset.zero,
          );
        }
        if (endHandleLayerLink != null) {
          context.pushLayer(
            LeaderLayer(
              link: endHandleLayerLink,
              offset: Offset(endOffset, size.height) + offset,
            ),
            emptyPaintFunction,
            Offset.zero,
          );
        }
      }
    }

    super.paint(context, offset);
    return;
  }
}

void emptyPaintFunction(PaintingContext context, Offset offset) {}
