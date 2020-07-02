import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'breakable_size.dart';

class BreakableBoxConstraints extends BoxConstraints {
  final double maxWidthFirstLine;
  final double maxWidthBodyLines;
  final double lastLineRightMargin;
  const BreakableBoxConstraints({
    double minWidth = 0.0,
    this.maxWidthFirstLine = double.infinity,
    this.maxWidthBodyLines = double.infinity,
    this.lastLineRightMargin = 0.0,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  })  : assert(maxWidthFirstLine >= 0),
        assert(maxWidthBodyLines >= 0),
        super(
            minWidth: minWidth,
            maxWidth: maxWidthFirstLine,
            minHeight: minHeight,
            maxHeight: maxHeight);
  BreakableBoxConstraints.fromBox({
    BoxConstraints boxConstraints,
    this.maxWidthBodyLines = double.infinity,
    double maxWidthLastLine,
  })  : assert(maxWidthBodyLines >= 0),
        maxWidthFirstLine = boxConstraints.maxWidth,
        lastLineRightMargin = maxWidthLastLine ?? maxWidthBodyLines,
        super(
          minWidth: boxConstraints.minWidth,
          maxWidth: boxConstraints.maxWidth,
          minHeight: boxConstraints.minHeight,
          maxHeight: boxConstraints.maxHeight,
        );

  double get restLineStartPos => maxWidthFirstLine - maxWidthBodyLines;

  @override
  BreakableBoxConstraints copyWith({
    double minWidth,
    double maxWidth,
    double minHeight,
    double maxHeight,
    double maxWidthFirstLine,
    double maxWidthRestLines,
  }) =>
      BreakableBoxConstraints(
        minWidth: minWidth ?? this.minWidth,
        minHeight: minHeight ?? this.minHeight,
        maxHeight: maxHeight ?? this.maxHeight,
        maxWidthFirstLine:
            maxWidthFirstLine ?? (maxWidth ?? this.maxWidthFirstLine),
        maxWidthBodyLines: maxWidthRestLines ?? this.maxWidthBodyLines,
      );

  @override
  BreakableBoxConstraints deflate(EdgeInsets edges) {
    final res = super.deflate(edges);
    return BreakableBoxConstraints.fromBox(
      boxConstraints: res,
      maxWidthBodyLines:
          math.max(res.minWidth, maxWidthBodyLines - edges.horizontal),
    );
  }

  @override
  BreakableBoxConstraints loosen() => BreakableBoxConstraints.fromBox(
        boxConstraints: super.loosen(),
        maxWidthBodyLines: maxWidthBodyLines,
      );

  @override
  BreakableBoxConstraints enforce(BoxConstraints constraints) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super.enforce(constraints),
        maxWidthBodyLines: maxWidthBodyLines
            .clamp(constraints.minWidth, constraints.maxWidth)
            .toDouble(),
      );

  @override
  BreakableBoxConstraints tighten({double width, double height}) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super.tighten(width: width, height: height),
        maxWidthBodyLines: width == null
            ? maxWidthBodyLines
            : width.clamp(minWidth, maxWidthBodyLines).toDouble(),
      );

  @override
  BreakableBoxConstraints get flipped =>
      throw UnsupportedError('BreakableBoxConstraint does not support flip');
  // BreakableBoxConstraints.fromBox(
  //       boxConstraints: super.flipped,
  //       maxWidthFirstLine: maxWidthFirstLine,
  //       maxWidthRestLines: maxWidthRestLines,
  //     );

  @override
  BreakableBoxConstraints widthConstraints() => BreakableBoxConstraints.fromBox(
        boxConstraints: super.widthConstraints(),
        maxWidthBodyLines: maxWidthBodyLines,
      );

  @override
  BoxConstraints heightConstraints() => BreakableBoxConstraints.fromBox(
        boxConstraints: super.heightConstraints(),
      );

  @override
  double constrainWidth([double width = double.infinity]) {
    // TODO: implement constrainWidth
    return super.constrainWidth(width);
  }

  @override
  double constrainHeight([double height = double.infinity]) {
    // TODO: implement constrainHeight
    return super.constrainHeight(height);
  }

  @override
  BreakableSize constrain(Size size) {
    if (size is BreakableSize) {
      var remainingHeight = maxHeight;
      final lineSizes = List<Size>.filled(size.lineSizes.length, null);
      for (var i = 0; i < size.lineSizes.length; i++) {
        lineSizes[i] = BoxConstraints(
                minWidth: minWidth,
                maxWidth: i == 0 ? maxWidthFirstLine : maxWidthBodyLines,
                minHeight: minHeight,
                maxHeight: remainingHeight)
            .constrain(size.lineSizes[i]);
        remainingHeight =
            math.max(minHeight, remainingHeight - lineSizes[i].height);
      }
      //TODO: debug
      return BreakableSize(lineSizes);
    }
    throw ArgumentError(size);
  }

  @override
  Size constrainDimensions(double width, double height) =>
      throw UnsupportedError(
          'BreakableConstraint cannno be used to constrain width * height');

  @override
  BreakableSize constrainSizeAndAttemptToPreserveAspectRatio(Size size) {
    if (size is BreakableSize) {
      var remainingHeight = maxHeight;
      final lineSizes = List<Size>.filled(size.lineSizes.length, null);
      for (var i = 0; i < size.lineSizes.length; i++) {
        lineSizes[i] = BoxConstraints(
                minWidth: minWidth,
                maxWidth: i == 0 ? maxWidthFirstLine : maxWidthBodyLines,
                minHeight: minHeight,
                maxHeight: remainingHeight)
            .constrainSizeAndAttemptToPreserveAspectRatio(size.lineSizes[i]);
        remainingHeight =
            math.max(minHeight, remainingHeight - lineSizes[i].height);
      }
      //TODO: debug
      return BreakableSize(lineSizes);
    }
    throw ArgumentError(size);
  }

  @override
  Size get biggest => throw UnsupportedError(
      'BreakableConstraint\'s biggest size is not unique.');

  @override
  BreakableSize get smallest => BreakableSize([super.smallest]);

  @override
  BreakableBoxConstraints operator *(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super * factor,
        maxWidthBodyLines: maxWidthBodyLines * factor,
      );

  @override
  BreakableBoxConstraints operator /(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super / factor,
        maxWidthBodyLines: maxWidthBodyLines / factor,
      );

  @override
  BreakableBoxConstraints operator ~/(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super ~/ factor,
        maxWidthBodyLines: (maxWidthBodyLines ~/ factor).toDouble(),
      );

  @override
  BreakableBoxConstraints operator %(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super % factor,
        maxWidthBodyLines: maxWidthBodyLines % factor,
      );

  @override
  bool operator ==(dynamic other) =>
      other is BreakableBoxConstraints &&
      super == other &&
      maxWidthBodyLines == other.maxWidthBodyLines;

  @override
  int get hashCode => hashValues(super.hashCode, maxWidthBodyLines);

  @override
  String toString() =>
      'Breakable${super.toString()}(maxWidthFirstLine: $maxWidthFirstLine, '
      'maxWidthRestLines: $maxWidthBodyLines)';
}
