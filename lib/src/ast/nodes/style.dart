import 'package:flutter/foundation.dart';

import '../options.dart';
import '../syntax_tree.dart';

class StyleNode extends TransparentNode {
  final List<GreenNode> children;
  final OptionsDiff optionsDiff;

  StyleNode({
    @required this.children,
    @required this.optionsDiff,
  });

  @override
  List<Options> computeChildOptions(Options options) =>
      List.filled(children.length, options.merge(optionsDiff), growable: false);

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<GreenNode> updateChildren(List<GreenNode> newChildren) =>
      copyWith(children: newChildren);

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'children': children.map((e) => e.toJson()),
      'optionsDiff': optionsDiff.toString(),
    });

  StyleNode copyWith({
    List<GreenNode> children,
    OptionsDiff optionsDiff,
  }) =>
      StyleNode(
        children: children ?? this.children,
        optionsDiff: optionsDiff ?? this.optionsDiff,
      );
}
