import 'package:flutter/foundation.dart';
import '../options.dart';
import '../syntax_tree.dart';

class StyleNode extends TransparentNode {
  final List<GreenNode> children;
  final PartialOptions options;

  StyleNode({
    @required this.children,
    @required this.options,
  });

  @override
  List<Options> computeChildOptions(Options options) {
    // TODO: implement computeChildOptions
    return null;
  }

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<GreenNode> updateChildren(List<GreenNode> newChildren) {
    // TODO: implement updateChildren
    return null;
  }
}
