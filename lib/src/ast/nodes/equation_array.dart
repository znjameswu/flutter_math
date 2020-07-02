import 'package:meta/meta.dart';

import '../../render/layout/eqn_array.dart';
import '../../render/layout/shift_baseline.dart';
import '../../utils/iterable_extensions.dart';
import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';
import 'matrix.dart';

class EquationArrayNode extends SlotableNode {
  final double arrayStretch;
  final bool addJot;
  final List<EquationRowNode> body;
  final List<MatrixSeparatorStyle> hlines;
  final List<Measurement> rowSpacings;

  final int rows;

  EquationArrayNode(
      {@required this.addJot,
      @required this.body,
      this.arrayStretch = 1.0,
      List<MatrixSeparatorStyle> hlines,
      List<Measurement> rowSpacings})
      : assert(body != null),
        assert(body.every((element) => element != null)),
        hlines = (hlines ?? []).extendToByFill(body.length, null),
        rowSpacings =
            (rowSpacings ?? []).extendToByFill(body.length, Measurement.zero),
        rows = body.length;

  @override
  List<BuildResult> buildSlotableWidget(
          Options options, List<BuildResult> childBuildResults) =>
      [
        BuildResult(
          options: options,
          italic: 0.0,
          widget: ShiftBaseline(
            relativePos: 0.5,
            offset: options.fontMetrics.axisHeight.cssEm.toLpUnder(options),
            child: EqnArray(
              ruleThickness: options.fontMetrics.defaultRuleThickness.cssEm
                  .toLpUnder(options),
              jotSize: addJot ? 3.0.pt.toLpUnder(options) : 0.0,
              arrayskip: 12.0.pt.toLpUnder(options) * arrayStretch,
              hlines: hlines,
              rowSpacings: rowSpacings
                  .map((e) => e.toLpUnder(options))
                  .toList(growable: false),
              children: childBuildResults
                  .map((e) => e.widget)
                  .toList(growable: false),
            ),
          ),
        )
      ];

  @override
  List<Options> computeChildOptions(Options options) =>
      List.filled(rows, options, growable: false);

  @override
  List<EquationRowNode> computeChildren() => body;

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      EquationArrayNode(addJot: addJot, body: newChildren);
}
