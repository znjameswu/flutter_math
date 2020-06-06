import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../render/layout/column.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

class FracNode extends SlotableNode {
  final Options options;
  final EquationRowNode numerator;
  final EquationRowNode denumerator;
  final Measurement barSize;
  final bool continued;
  FracNode({
    this.options,
    @required this.numerator,
    @required this.denumerator,
    this.barSize,
    this.continued = false,
  })  : assert(numerator != null),
        assert(denumerator != null);

  @override
  List<EquationRowNode> computeChildren() => [numerator, denumerator];

  FracNode copyWith({
    Options options,
    EquationRowNode numerator,
    EquationRowNode denumerator,
    Measurement barSize,
  }) {
    return FracNode(
      options: options ?? this.options,
      numerator: numerator ?? this.numerator,
      denumerator: denumerator ?? this.denumerator,
      barSize: barSize ?? this.barSize,
    );
  }

  @override
  Widget buildWidget(Options options, List<Widget> childWidgets, List<Options> childOptions) => RelativeWidthColumn(
        baselineReferenceWidgetIndices: const {1},
        baselineOffset: 10,
        children: <Widget>[
          childWidgets[0],
          RelativeWidth(
              child: Container(
            height: barSize.toLpUnder(options),
            color: Colors.black,
          )),
          childWidgets[1],
        ],
      );


  
  @override
  List<Options> computeChildOptions(Options options) => [
        options.havingStyle(options.style.fracNum()),
        options.havingStyle(options.style.fracDen()),
      ];

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      this.copyWith(numerator: newChildren[0], denumerator: newChildren[1]);

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;


}
