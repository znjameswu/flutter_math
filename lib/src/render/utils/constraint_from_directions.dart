import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

BoxConstraints constraintsFromDirection({
  @required Axis mainDirection,
  double min = 0.0,
  double max = double.infinity,
  double crossMin = 0.0,
  double crossMax = double.infinity,
}) {
  if (mainDirection == Axis.horizontal) {
    return BoxConstraints(
      minWidth: min,
      maxWidth: max,
      minHeight: crossMin,
      maxHeight: crossMax,
    );
  } else {
    return BoxConstraints(
      minHeight: min,
      maxHeight: max,
      minWidth: crossMin,
      maxWidth: crossMax,
    );
  }
}
