import 'package:flutter/widgets.dart';

import '../options.dart';
import '../syntax_tree.dart';
import 'math_atom.dart';

class AccentNode extends SlotableNode {
  final EquationRowNode base;
  final String label;
  final bool isStretchy;
  final bool isShifty;
  AccentNode({
    @required this.base,
    @required this.label,
    @required this.isStretchy,
    @required this.isShifty,
  });

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    // Does the accent need to shift for the skew of a character?
    final mustShift = isShifty &&
        base.flattenedChildList.length == 1 &&
        (base.flattenedChildList[0] is AtomNode &&
            (base.flattenedChildList[0] as AtomNode).atomType !=
                AtomType.spacing);
  }

  @override
  List<Options> computeChildOptions(Options options) =>
      [options.havingCrampedStyle()];

  @override
  List<EquationRowNode> computeChildren() => [base];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
      List<EquationRowNode> newChildren) {
    // TODO: implement updateChildren
    throw UnimplementedError();
  }
}
