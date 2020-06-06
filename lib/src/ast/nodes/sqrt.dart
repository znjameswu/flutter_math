import 'package:flutter/widgets.dart';

import '../../render/layout/remove_baseline.dart';
import '../../render/svg/svg_painter.dart';
import '../options.dart';
import '../syntax_tree.dart';

/// Word:   \sqrt   \sqrt(index & base)
/// Latex:  \sqrt   \sqrt[index]{base}
/// MathML: msqrt   mroot

class SqrtNode extends SlotableNode {
  final EquationRowNode index;
  final EquationRowNode base;
  SqrtNode({
    @required this.index,
    @required this.base,
  }) : assert(base != null);

  SqrtNode copyWith({
    EquationRowNode index,
    EquationRowNode base,
  }) {
    return SqrtNode(
      index: index ?? this.index,
      base: base ?? this.base,
    );
  }

  @override
  Widget buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 0,
            top: 0,
          ),
          child: childWidgets[1],
        ),
        if (childWidgets[0] != null)
          Positioned(
            child: RemoveBaseline(
              child: childWidgets[0],
            ),
          ),
        Positioned(
          child: SvgPaint(),
        )
      ],
    );
  }

  @override
  List<Options> computeChildOptions(Options options) {
    // TODO: implement computeChildOptions
    return null;
  }

  @override
  List<EquationRowNode> computeChildren() => [index, base];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      this.copyWith(index: index, base: base);
}
