import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../render/layout/line_editable.dart';
import '../../utils/render_box_extensions.dart';
import '../controller.dart';

abstract class MathSelectionManager implements TextSelectionDelegate {
  // bool get toolbarVisible;
  // set toolbarVisible(bool value);

  // bool get handleVisible;
  // set handleVisible(bool value);

  BuildContext get context;

  bool get hasFocus;

  bool get forcePressEnabled;

  bool get selectionEnabled;

  bool showToolbar();

  void hideToolbar();

  void hide();

  MathController controller;

  double get preferredLineHeight;

  @mustCallSuper
  void handleSelectionChanged(
      TextSelection selection, SelectionChangedCause cause,
      {bool rebuildOverlay = true}) {
    controller.selection = selection;
  }

  void selectPositionAt({
    @required Offset from,
    Offset to,
    @required SelectionChangedCause cause,
  }) {
    final fromPosition = getPositionForOffset(from);
    final toPosition = to == null ? fromPosition : getPositionForOffset(to);
    handleSelectionChanged(
      TextSelection(baseOffset: fromPosition, extentOffset: toPosition),
      cause,
    );
  }

  RenderEditableLine getRenderLineAtOffset(Offset globalOffset) {
    final rootRenderBox = this.rootRenderBox;
    final rootOffset = rootRenderBox.globalToLocal(globalOffset);
    final constrainedOffset = Offset(
      rootOffset.dx.clamp(0.0, rootRenderBox.size.width) as double,
      rootOffset.dy.clamp(0.0, rootRenderBox.size.height) as double,
    );
    return (controller.ast.greenRoot.key.currentContext.findRenderObject()
                as RenderEditableLine)
            .hittestFindLowest<RenderEditableLine>(constrainedOffset) ??
        controller.ast.greenRoot.key.currentContext.findRenderObject()
            as RenderEditableLine;
  }

  RenderBox get rootRenderBox => context.findRenderObject() as RenderBox;

  int getPositionForOffset(Offset globalOffset) {
    final target = getRenderLineAtOffset(globalOffset);
    final caretIndex = target.getCaretIndexForPoint(globalOffset);
    return target.node.pos + target.node.caretPositions[caretIndex];
  }

  Offset getLocalEndpointForPosition(int position) {
    final node = controller.ast.findNodesManagesPosition(position);
    var caretIndex = node.caretPositions
        .indexWhere((caretPosition) => caretPosition >= position);
    if (caretIndex == -1) {
      caretIndex = node.caretPositions.length - 1;
    }
    final renderLine =
        node.key.currentContext.findRenderObject() as RenderEditableLine;
    final globalOffset = renderLine.getEndpointForCaretIndex(caretIndex);

    return rootRenderBox.globalToLocal(globalOffset);
  }

  TextSelection getWordRangeAtPoint(Offset globalOffset) {
    final target = getRenderLineAtOffset(globalOffset);
    final caretIndex = target.getNearestLeftCaretIndexForPoint(globalOffset);
    final node = target.node;
    final extentCaretIndex = math.max(
      0,
      caretIndex + 1 >= node.caretPositions.length
          ? caretIndex - 1
          : caretIndex + 1,
    );
    final base = node.pos + node.caretPositions[caretIndex];
    final extent = node.pos + node.caretPositions[extentCaretIndex];
    return TextSelection(
      baseOffset: math.min(base, extent),
      extentOffset: math.max(base, extent),
    );
  }

  TextSelection getWordsRangeInRange({
    @required Offset from,
    @required Offset to,
  }) {
    final range1 = getWordRangeAtPoint(from);
    final range2 = getWordRangeAtPoint(to);

    if (range1.start <= range2.start) {
      return TextSelection(baseOffset: range1.start, extentOffset: range2.end);
    } else {
      return TextSelection(baseOffset: range1.end, extentOffset: range2.start);
    }
  }

  Rect getLocalEditingRegion();

  bool handleKeyEvents(RawKeyEvent key) => false;

  // Following are overrides from TextSelectionDelegate

  void bringIntoView(TextPosition position) {}

  @override
  TextEditingValue get textEditingValue => TextEditingValue(
        text: _stubString,
        selection:
            TextSelection(baseOffset: 0, extentOffset: _stubString.length),
      ); // TODO

  set textEditingValue(TextEditingValue value) {
    // do nothing
  }
}

const _stubString = 'THIS IS A PLACEHOLDER VALUE FOR PROTOTYPING';
