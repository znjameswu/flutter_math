import 'package:flutter/widgets.dart';

import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';

enum MatrixSeparatorStyle {
  none,
  solid,
  dashed,
}

enum MatrixColumnAlign {
  left,
  center,
  right,
}

enum MatrixRowAlign {
  top,
  bottom,
  center,
  baseline,
  // axis,
}

class MatrixNode extends SlotableNode {
  final double arrayStretch;
  final Measurement hskipBeforeAndAfter; // Latex compatibility
  final List<Measurement>
      columnSpacing; // refers to total spacing between columns, 2*arraycolsep
  final List<MatrixColumnAlign> columnAligns;
  final List<MatrixSeparatorStyle>
      columnLines; // INCLUDE OUTERMOST LINES! DIFFERENT FROM MATHML!
  final List<Measurement> rowSpacing;
  final List<MatrixRowAlign> rowAligns;
  final List<MatrixSeparatorStyle> rowLines;

  final List<List<EquationRowNode>> body;
  MatrixNode({
    this.arrayStretch,
    this.hskipBeforeAndAfter = Measurement.zero,
    this.columnSpacing,
    this.columnAligns,
    this.columnLines,
    this.rowSpacing,
    this.rowAligns,
    this.rowLines,
    @required this.body,
  });

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    throw UnimplementedError();
  }

  @override
  List<Options> computeChildOptions(Options options) {
    // TODO: implement computeChildOptions
    throw UnimplementedError();
  }

  @override
  List<EquationRowNode> computeChildren() =>
      body.expand((row) => row).toList(growable: false);

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
