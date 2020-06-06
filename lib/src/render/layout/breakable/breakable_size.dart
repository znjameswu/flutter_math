import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_math/src/render/layout/breakable/breakable_constraints.dart';

import 'breakable_offset.dart';
import '../../../utils/iterable_extensions.dart';

class BreakableSize extends Size {
  final List<Size> lineSizes;
  BreakableSize(this.lineSizes)
      : super(lineSizes.map((e) => e.width).max(),
            lineSizes.map((e) => e.height).sum());

  BreakableSize.copy(BreakableSize source)
      : lineSizes = source.lineSizes,
        super(
            source.lineSizes.fold(0, (a, b) => a + b.width),
            source.lineSizes.fold(
                0, (curr, next) => curr > next.height ? curr : next.height));

  factory BreakableSize.fromSize(Size size) => BreakableSize([size]);

  OffsetBase operator -(OffsetBase other) {
    if (other is BreakableOffset) {
      assert(other.lineOffsets.length == lineSizes.length);
      final res = <Size>[];
      for (var i = 0; i < lineSizes.length; i++) {
        res[i] = (lineSizes[i] - (other.lineOffsets[i] ?? Offset.zero)) as Size;
      }
      return BreakableSize(res);
    }
    if (other is BreakableSize) {
      assert(other.lineSizes.length == lineSizes.length);
      final res = <Offset>[];
      for (var i = 0; i < lineSizes.length; i++) {
        res[i] = (lineSizes[i] - other.lineSizes[i]) as Offset;
      }
      return BreakableOffset(res);
    }
    throw ArgumentError(other);
  }

  Size operator +(Offset other) {
    if (other is BreakableOffset) {
      assert(other.lineOffsets.length == lineSizes.length);
      final res = <Size>[];
      for (var i = 0; i < lineSizes.length; i++) {
        res[i] = lineSizes[i] + (other.lineOffsets[i] ?? Offset.zero);
      }
      return BreakableSize(res);
    }
    throw ArgumentError(other);
  }

  BreakableSize operator *(double operand) =>
      BreakableSize(lineSizes.map((lineSize) => lineSize * operand).toList());

  BreakableSize operator /(double operand) =>
      BreakableSize(lineSizes.map((lineSize) => lineSize / operand).toList());

  BreakableSize operator ~/(double operand) =>
      BreakableSize(lineSizes.map((lineSize) => lineSize ~/ operand).toList());

  BreakableSize operator %(double operand) =>
      BreakableSize(lineSizes.map((lineSize) => lineSize % operand).toList());

  bool contains(Offset offset) {
    if (offset is BreakableOffset) {
      assert(offset.lineOffsets.length == lineSizes.length);
      for (var i = 0; i < lineSizes.length; i++) {
        if (offset.lineOffsets[i] != null &&
            !lineSizes[i].contains(offset.lineOffsets[i])) {
          return false;
        }
      }
      return true;
    }
    throw ArgumentError(offset);
  }

  BreakableSize get flipped =>
      BreakableSize(lineSizes.map((lineSize) => lineSize.flipped).toList());

  @override
  bool operator ==(dynamic other) =>
      other is BreakableSize && listEquals(this.lineSizes, other.lineSizes);

  @override
  int get hashCode => hashList(lineSizes);

  @override
  String toString() => 'BreakableSize[${lineSizes.join(", ")}]';

  Rect formRect(Offset offset, BreakableBoxConstraints constraints) {
    if (offset is BreakableOffset) {
      return offset & this;
    } else {
      final restLineRight =
          lineSizes.skip(1).map((e) => e.width + constraints.restLineStartPos);
      return Rect.fromLTRB(
        offset.dx + math.min(0.0, constraints.restLineStartPos),
        offset.dy,
        offset.dx + [lineSizes.first.width, ...restLineRight].max(),
        offset.dy + lineSizes.map((e) => e.height).sum(),
      );
    }
  }
}
