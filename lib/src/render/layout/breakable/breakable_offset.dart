import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'breakable_size.dart';

class BreakableOffset extends Offset {
  final List<Offset> lineOffsets;
  BreakableOffset(this.lineOffsets)
      : super(lineOffsets[0]?.dx ?? 0, lineOffsets[0]?.dy ?? 0);
  BreakableOffset.extend(List<Offset> partialLineOffsets, int len,
      [Offset fill])
      : assert(partialLineOffsets.length <= len),
        lineOffsets = partialLineOffsets
          ..addAll(List.filled(len - partialLineOffsets.length, fill,
              growable: false)),
        super(partialLineOffsets[0]?.dx ?? 0, partialLineOffsets[0]?.dy ?? 0);

  BreakableOffset scale(double scaleX, double scaleY) =>
      BreakableOffset(lineOffsets
          .map((lineOffset) => lineOffset?.scale(scaleX, scaleY))
          .toList());

  BreakableOffset translate(double translateX, double translateY) =>
      BreakableOffset(lineOffsets
          .map((lineOffset) => lineOffset?.translate(translateX, translateY))
          .toList());

  BreakableOffset operator -() => this.scale(-1, -1);

  BreakableOffset operator -(Offset other) {
    if (other is BreakableOffset) {
      assert(other.lineOffsets.length == lineOffsets.length);
      final res = <Offset>[];
      for (var i = 0; i < lineOffsets.length; i++) {
        res[i] = (lineOffsets[i] == null || other.lineOffsets[i] == null)
            ? null
            : lineOffsets[i] - other.lineOffsets[i];
      }
      return BreakableOffset(res);
    }
    throw ArgumentError(other);
  }

  BreakableOffset operator +(Offset other) {
    List<Offset> otherLineOffsets;
    if (other is BreakableOffset) {
      assert(other.lineOffsets.length == lineOffsets.length);
      otherLineOffsets = other.lineOffsets;
    } else {
      otherLineOffsets = List.filled(this.lineOffsets.length, other);
    }
    final res = <Offset>[];
    for (var i = 0; i < lineOffsets.length; i++) {
      res.add(lineOffsets[i] + otherLineOffsets[i]);
    }
    return BreakableOffset(res);
  }

  BreakableOffset operator *(double operand) => this.scale(operand, operand);

  BreakableOffset operator /(double operand) =>
      this.scale(1 / operand, 1 / operand);

  BreakableOffset operator ~/(double operand) => BreakableOffset(lineOffsets
      .map((lineOffset) => (lineOffset == null) ? null : lineOffset ~/ operand)
      .toList());

  BreakableOffset operator %(double operand) => BreakableOffset(lineOffsets
      .map((lineOffset) => (lineOffset == null) ? null : lineOffset % operand)
      .toList());

  Rect operator &(Size other) {
    if (other is BreakableSize) {
      final breakableRects = <Rect>[];
      for (var i = 0; i < other.lineSizes.length; i++) {
        final offset =
            i < this.lineOffsets.length ? this.lineOffsets[i] : Offset.zero;
        breakableRects.add(offset & other.lineSizes[i]);
      }
      return Rect.fromLTRB(
        breakableRects.map((e) => e.left).reduce(math.min),
        breakableRects.map((e) => e.top).reduce(math.min),
        breakableRects.map((e) => e.right).reduce(math.max),
        breakableRects.map((e) => e.bottom).reduce(math.max),
      );
    } else {
      return this.lineOffsets[0] & other;
    }
  }

  @override
  bool operator ==(dynamic other) {
    if (other is BreakableOffset) {
      return listEquals(this.lineOffsets, other.lineOffsets);
    }
    return false;
  }

  @override
  int get hashCode => hashList(lineOffsets);

  @override
  String toString() => 'BreakableOffset[${lineOffsets.join(", ")}]';

  static final zero = BreakableOffset([Offset(0, 0)]);
}
