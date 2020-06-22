import 'package:flutter/widgets.dart';

import '../../render/layout/multiscripts.dart';
import '../options.dart';
import '../size.dart';
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
  List<BuildResult> buildWidget(
          Options options, List<List<BuildResult>> childBuildResults) =>
      [
        BuildResult(
          options: options,
          widget: Multiscripts(
            alignPostscripts: alignPostscripts,
            italic: childBuildResults[0][0].italic,
            isBaseCharacterBox: base.flattenedChildList.length == 1 &&
                base.flattenedChildList[0] is MathAtomNode,
            baseOptions: childBuildResults[0][0].options,
            subOptions: childBuildResults[1]?.first?.options,
            supOptions: childBuildResults[2]?.first?.options,
            presubOptions: childBuildResults[3]?.first?.options,
            presupOptions: childBuildResults[4]?.first?.options,
            base: childBuildResults[0][0].widget,
            sub: childBuildResults[1]?.first?.widget,
            sup: childBuildResults[2]?.first?.widget,
            presub: childBuildResults[3]?.first?.widget,
            presup: childBuildResults[4]?.first?.widget,
          ),
          italic: Measurement.zero,
        )
      ];

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
