import 'package:flutter/widgets.dart';

import '../../render/layout/multiscripts.dart';
import '../options.dart';
import '../style.dart';
import '../syntax_tree.dart';
import 'symbol.dart';

/// Node for postscripts and prescripts
///
/// Examples:
///
/// - Word:   _     ^
/// - Latex:  _     ^
/// - MathML: msub  msup  mmultiscripts
class MultiscriptsNode extends SlotableNode {
  /// Whether to align the subscript to the superscript.
  ///
  /// Mimics MathML's mmultiscripts.
  final bool alignPostscripts;

  /// Base where scripts are applied upon.
  final EquationRowNode base;

  /// Subscript.
  final EquationRowNode sub;

  /// Superscript.
  final EquationRowNode sup;

  /// Presubscript.
  final EquationRowNode presub;

  /// Presuperscript.
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
  BuildResult buildWidget(
          Options options, List<BuildResult> childBuildResults) =>
      BuildResult(
        options: options,
        widget: Multiscripts(
          alignPostscripts: alignPostscripts,
          italic: childBuildResults[0].italic,
          isBaseCharacterBox: base.flattenedChildList.length == 1 &&
              base.flattenedChildList[0] is SymbolNode,
          baseOptions: childBuildResults[0].options,
          subOptions: childBuildResults[1]?.options,
          supOptions: childBuildResults[2]?.options,
          presubOptions: childBuildResults[3]?.options,
          presupOptions: childBuildResults[4]?.options,
          base: childBuildResults[0].widget,
          sub: childBuildResults[1]?.widget,
          sup: childBuildResults[2]?.widget,
          presub: childBuildResults[3]?.widget,
          presup: childBuildResults[4]?.widget,
        ),
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
      copyWith(
        base: newChildren[0],
        sub: newChildren[1],
        sup: newChildren[2],
        presub: newChildren[3],
        presup: newChildren[4],
      );

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'base': base.toJson(),
      if (sub != null) 'sub': sub.toJson(),
      if (sup != null) 'sup': sup.toJson(),
      if (presub != null) 'presub': presub.toJson(),
      if (presup != null) 'presup': presup.toJson(),
    });

  MultiscriptsNode copyWith({
    bool alignPostscripts,
    EquationRowNode base,
    EquationRowNode sub,
    EquationRowNode sup,
    EquationRowNode presub,
    EquationRowNode presup,
  }) =>
      MultiscriptsNode(
        alignPostscripts: alignPostscripts ?? this.alignPostscripts,
        base: base ?? this.base,
        sub: sub ?? this.sub,
        sup: sup ?? this.sup,
        presub: presub ?? this.presub,
        presup: presup ?? this.presup,
      );
}
