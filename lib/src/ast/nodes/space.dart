import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../render/layout/reset_baseline.dart';
import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';
import '../types.dart';

class SpaceNode extends LeafNode {
  final Measurement height;
  final Measurement width;
  final Measurement depth;
  final bool noBreak;
  final Color background;
  final Mode mode;
  SpaceNode({
    @required this.height,
    @required this.width,
    this.depth = Measurement.zero,
    this.noBreak = false,
    this.background = Colors.transparent,
    @required this.mode,
  });

  @override
  List<BuildResult> buildWidget(
      Options options, List<List<BuildResult>> childBuildResults) {
    final height = this.height.toLpUnder(options);
    final depth = this.depth.toLpUnder(options);
    final width = this.width.toLpUnder(options);
    final topMost = math.max(height, -depth);
    final bottomMost = math.min(height, -depth);
    return [
      BuildResult(
        widget: ResetBaseline(
          height: topMost,
          child: Container(
            height: topMost - bottomMost,
            width: math.max(0.0, width),
          ),
        ),
        options: options,
        italic: 0.0,
      )
    ];
  }

  @override
  AtomType get leftType => AtomType.spacing;

  @override
  AtomType get rightType => AtomType.spacing;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;
}
