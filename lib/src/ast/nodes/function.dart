import 'package:flutter/widgets.dart';

import '../options.dart';
import '../syntax_tree.dart';

class FunctionNode extends SlotableNode {
  final EquationRowNode functionName;
  final EquationRowNode argument;

  FunctionNode({
    @required this.functionName,
    @required this.argument,
  });

  @override
  Widget buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions) {
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
