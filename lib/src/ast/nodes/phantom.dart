import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../render/layout/reset_dimension.dart';
import '../options.dart';
import '../syntax_tree.dart';
import '../types.dart';

class PhantomNode extends LeafNode {
  Mode get mode => Mode.math;

  // TODO: suppress editbox in edit mode
  // If we use arbitrary GreenNode here, then we will face the danger of
  // transparent node
  final EquationRowNode phantomChild;

  final bool zeroWidth;
  final bool zeroHeight;
  PhantomNode({
    @required this.phantomChild,
    this.zeroHeight = false,
    this.zeroWidth = false,
  });

  @override
  List<BuildResult> buildWidget(
      Options options, List<List<BuildResult>> childBuildResults) {
    final phantomRedNode =
        SyntaxNode(parent: null, value: phantomChild, pos: 0);
    final phantomResult = phantomRedNode.buildWidget(options)[0];
    Widget widget = Opacity(
      opacity: 0.0,
      child: phantomResult.widget,
    );
    if (this.zeroHeight) {
      widget = ResetDimension(height: 0, depth: 0, child: widget);
    }
    if (this.zeroWidth) {
      widget = ResetDimension(width: 0, child: widget);
    }
    return [
      BuildResult(
        widget: widget,
        options: options,
        italic: phantomResult.italic,
      ),
    ];
  }

  @override
  AtomType get leftType => phantomChild.leftType;

  @override
  AtomType get rightType => phantomChild.rightType;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      phantomChild.shouldRebuildWidget(oldOptions, newOptions);

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'phantomChild': phantomChild.toJson(),
      if (zeroWidth != false) 'zeroWidth': zeroWidth,
      if (zeroHeight != false) 'zeroHeight': zeroHeight,
    });
}
