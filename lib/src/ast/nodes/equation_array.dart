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

  // final int rows;

  EquationArrayNode({
    this.addJot = false,
    @required this.body,
    this.arrayStretch = 1.0,
    List<MatrixSeparatorStyle> hlines,
    List<Measurement> rowSpacings,
  })  : assert(body != null),
        assert(body.every((element) => element != null)),
        hlines = (hlines ?? []).extendToByFill(body.length, null),
        rowSpacings =
            (rowSpacings ?? []).extendToByFill(body.length, Measurement.zero);

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
      List.filled(body.length, options, growable: false);

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
      copyWith(body: newChildren);

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      if (addJot != false) 'addJot': addJot,
      'body': body.map((e) => e.toJson()),
      if (arrayStretch != 1.0) 'arrayStretch': arrayStretch,
      'hlines': hlines.map((e) => e.toString()),
      'rowSpacings': rowSpacings.map((e) => e.toString())
    });

  EquationArrayNode copyWith({
    double arrayStretch,
    bool addJot,
    List<EquationRowNode> body,
    List<MatrixSeparatorStyle> hlines,
    List<Measurement> rowSpacings,
  }) =>
      EquationArrayNode(
        arrayStretch: arrayStretch ?? this.arrayStretch,
        addJot: addJot ?? this.addJot,
        body: body ?? this.body,
        hlines: hlines ?? this.hlines,
        rowSpacings: rowSpacings ?? this.rowSpacings,
      );
}
