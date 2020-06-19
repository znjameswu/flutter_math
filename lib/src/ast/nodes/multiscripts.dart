import 'package:flutter/widgets.dart';

import '../../render/layout/multiscripts.dart';
import '../options.dart';
import '../style.dart';
import '../syntax_tree.dart';
import 'math_atom.dart';

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
    this.alignPostscripts = false,
    @required this.base,
    this.sub,
    this.sup,
    this.presub,
    this.presup,
  });

  @override
  Widget buildWidget(
    Options options,
    List<Widget> childWidgets,
    List<Options> childOptions,
  ) =>
      Multiscripts(
        alignPostscripts: alignPostscripts,
        italic: base.italic,
        isBaseCharacterBox: base.flattenedChildList.length == 1 &&
            base.flattenedChildList[0] is MathAtomNode,
        baseOptions: childOptions[0],
        subOptions: childOptions[1],
        supOptions: childOptions[2],
        presubOptions: childOptions[3],
        presupOptions: childOptions[4],
        base: childWidgets[0],
        sub: childWidgets[1],
        sup: childWidgets[2],
        presub: childWidgets[3],
        presup: childWidgets[4],
      );

  @override
  List<Options> computeChildOptions(Options options) {
    final subOptions = options.havingStyle(options.style.sub());
    final supOptions = options.havingStyle(options.style.sup());
    return [options, subOptions, supOptions, subOptions, supOptions];
  }

  @override
  List<EquationRowNode> computeChildren() => [base, sub, sup, presub, presup];

  @override
  AtomType get leftType =>
      presub == null && presup == null ? base.leftType : AtomType.ord;

  @override
  AtomType get rightType =>
      sub == null && sup == null ? base.rightType : AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      MultiscriptsNode(
        base: newChildren[0],
        sub: newChildren[1],
        sup: newChildren[2],
        presub: newChildren[3],
        presup: newChildren[4],
      );
}
