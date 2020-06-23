import 'package:flutter/widgets.dart';

import '../options.dart';
import '../syntax_tree.dart';

// enum LimitsBehavior {
//   //ignore: constant_identifier_names
//   Default,
//   subsup,
//   underover,
// }

class NaryOperatorNode extends SlotableNode {
  final String operator;
  final EquationRowNode lowerLimit;
  final EquationRowNode upperLimit;
  final EquationRowNode naryand;
  final bool limits;

  NaryOperatorNode({
    @required this.operator,
    @required this.lowerLimit,
    @required this.upperLimit,
    @required this.naryand,
    this.limits,
  });

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
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
  AtomType get leftType => throw UnimplementedError();

  @override
  // TODO: implement rightType
  AtomType get rightType => throw UnimplementedError();

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
