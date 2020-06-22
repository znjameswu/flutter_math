import 'package:flutter/widgets.dart';

import '../options.dart';
import '../syntax_tree.dart';

class LeftRightNode extends SlotableNode {
  final String leftDelim;
  final String rightDelim;
  final List<EquationRowNode> body;
  final List<String> middle;
  LeftRightNode({
    @required this.leftDelim,
    @required this.rightDelim,
    @required this.body,
    this.middle = const [],
  }) : assert(middle.length == body.length - 1);

  @override
  List<BuildResult> buildWidget(
      Options options, List<List<BuildResult>> childBuildResults) {
    // TODO: implement buildWidget
    throw UnimplementedError();
  }

  @override
  List<Options> computeChildOptions(Options options) {
    // TODO: implement computeChildOptions
    throw UnimplementedError();
  }

  @override
  List<EquationRowNode> computeChildren() {
    // TODO: implement computeChildren
    throw UnimplementedError();
  }

  @override
  // TODO: implement leftType
  AtomType get leftType => AtomType.open;

  @override
  // TODO: implement rightType
  AtomType get rightType => AtomType.close;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) {
    // TODO: implement shouldRebuildWidget
    throw UnimplementedError();
  }

  @override
  ParentableNode<EquationRowNode> updateChildren(
      List<EquationRowNode> newChildren) {
    // TODO: implement updateChildren
    throw UnimplementedError();
  }
}
