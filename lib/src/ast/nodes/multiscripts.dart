import 'package:flutter/widgets.dart';

import '../options.dart';
import '../syntax_tree.dart';

/// Word:   _     ^
/// Latex:  _     ^
/// MathML: msub  msup  mmultiscripts
///
class MultiscriptsNode extends SlotableNode {
  final bool alignPostscripts;

  final EquationRowNode base;

  final EquationRowNode sub;
  final EquationRowNode sup;
  final EquationRowNode presub;
  final EquationRowNode presup;

  MultiscriptsNode({
    this.alignPostscripts,
    @required this.base,
    this.sub,
    this.sup,
    this.presub,
    this.presup,
  });

  @override
  Widget buildWidget(Options options, List<Widget> childWidgets, List<Options> childOptions) {
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
  ParentableNode<EquationRowNode> updateChildren(List<EquationRowNode> newChildren) {
    // TODO: implement updateChildren
    throw UnimplementedError();
  }

  
}
