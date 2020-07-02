import 'dart:ui';

import 'package:meta/meta.dart';

class SizePreserveBaseline {
  final double height;
  final double depth;
  final double width;
  const SizePreserveBaseline({
    @required this.height,
    @required this.depth,
    @required this.width,
  });

  SizePreserveBaseline.fromSize({
    @required Size size,
    @required this.height,
  })  : depth = size.height - height,
        width = size.width;

  Size asSize() => Size(width, height + depth);

  SizePreserveBaseline operator *(double operand) => SizePreserveBaseline(
      height: height * operand, depth: depth * operand, width: width * operand);
  SizePreserveBaseline operator /(double operand) => SizePreserveBaseline(
      height: height / operand, depth: depth / operand, width: width / operand);
  SizePreserveBaseline operator ~/(double operand) => SizePreserveBaseline(
      height: (height ~/ operand).toDouble(),
      depth: (depth ~/ operand).toDouble(),
      width: (width ~/ operand).toDouble());
  SizePreserveBaseline operator %(double operand) => SizePreserveBaseline(
      height: height % operand, depth: depth % operand, width: width % operand);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SizePreserveBaseline &&
        o.height == height &&
        o.depth == depth &&
        o.width == width;
  }

  @override
  int get hashCode => height.hashCode ^ depth.hashCode ^ width.hashCode;

  @override
  String toString() =>
      'SizePreserveBaseline(height: $height, depth: $depth, width: $width)';
}
