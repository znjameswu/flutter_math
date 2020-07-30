import 'package:meta/meta.dart';

import '../../render/layout/shift_baseline.dart';
import '../options.dart';
import '../size.dart';
import '../syntax_tree.dart';

class RaiseBoxNode extends SlotableNode {
  final EquationRowNode body;
  final Measurement dy;

  RaiseBoxNode({
    @required this.body,
    @required this.dy,
  });

  @override
  List<BuildResult> buildSlotableWidget(
          Options options, List<BuildResult> childBuildResults) =>
      [
        BuildResult(
          widget: ShiftBaseline(
            offset: dy.toLpUnder(options),
            child: childBuildResults[0].widget,
          ),
          options: options,
          italic: 0.0,
        )
      ];

  @override
  List<Options> computeChildOptions(Options options) => [options];

  @override
  List<EquationRowNode> computeChildren() => [body];

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      RaiseBoxNode(
        body: newChildren[0],
        dy: dy,
      );

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'body': body.toJson(),
      'dy': dy.toString(),
    });
}
