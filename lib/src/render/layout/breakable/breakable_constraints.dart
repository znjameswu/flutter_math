import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'breakable_size.dart';

class BreakableBoxConstraints extends BoxConstraints {
  final double maxWidthFirstLine;
  final double maxWidthRestLines;
  const BreakableBoxConstraints({
    double minWidth = 0.0,
    this.maxWidthFirstLine = double.infinity,
    this.maxWidthRestLines = double.infinity,
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  })  : assert(maxWidthFirstLine >= 0),
        assert(maxWidthRestLines >= 0),
        super(
            minWidth: minWidth,
            maxWidth: maxWidthFirstLine,
            minHeight: minHeight,
            maxHeight: maxHeight);
  BreakableBoxConstraints.fromBox({
    BoxConstraints boxConstraints,
    this.maxWidthRestLines = double.infinity,
  })  : assert(maxWidthRestLines >= 0),
        maxWidthFirstLine = boxConstraints.maxWidth,
        super(
          minWidth: boxConstraints.minWidth,
          maxWidth: boxConstraints.maxWidth,
          minHeight: boxConstraints.minHeight,
          maxHeight: boxConstraints.maxHeight,
        );

  double get restLineStartPos => maxWidthFirstLine - maxWidthRestLines;

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
        maxWidthRestLines: maxWidthRestLines ?? this.maxWidthRestLines,
      );

  @override
  BreakableBoxConstraints deflate(EdgeInsets edges) {
    final res = super.deflate(edges);
    return BreakableBoxConstraints.fromBox(
      boxConstraints: res,
      maxWidthRestLines:
          math.max(res.minWidth, maxWidthRestLines - edges.horizontal),
    );
  }

  @override
  BreakableBoxConstraints loosen() => BreakableBoxConstraints.fromBox(
        boxConstraints: super.loosen(),
        maxWidthRestLines: maxWidthRestLines,
      );

  @override
  BreakableBoxConstraints enforce(BoxConstraints constraints) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super.enforce(constraints),
        maxWidthRestLines: maxWidthRestLines
            .clamp(constraints.minWidth, constraints.maxWidth)
            .toDouble(),
      );

  @override
  BreakableBoxConstraints tighten({double width, double height}) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super.tighten(width: width, height: height),
        maxWidthRestLines: width == null
            ? maxWidthRestLines
            : width.clamp(minWidth, maxWidthRestLines).toDouble(),
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
        maxWidthRestLines: maxWidthRestLines,
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
                maxWidth: i == 0 ? maxWidthFirstLine : maxWidthRestLines,
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
                maxWidth: i == 0 ? maxWidthFirstLine : maxWidthRestLines,
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
        maxWidthRestLines: maxWidthRestLines * factor,
      );

  @override
  BreakableBoxConstraints operator /(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super / factor,
        maxWidthRestLines: maxWidthRestLines / factor,
      );

  @override
  BreakableBoxConstraints operator ~/(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super ~/ factor,
        maxWidthRestLines: (maxWidthRestLines ~/ factor).toDouble(),
      );

  @override
  BreakableBoxConstraints operator %(double factor) =>
      BreakableBoxConstraints.fromBox(
        boxConstraints: super % factor,
        maxWidthRestLines: maxWidthRestLines % factor,
      );

  @override
  bool operator ==(dynamic other) =>
      other is BreakableBoxConstraints &&
      super == other &&
      maxWidthRestLines == other.maxWidthRestLines;

  @override
  int get hashCode => hashValues(super.hashCode, maxWidthRestLines);

  @override
  String toString() =>
      'Breakable${super.toString()}(maxWidthFirstLine: $maxWidthFirstLine, maxWidthRestLines: $maxWidthRestLines)';
}
