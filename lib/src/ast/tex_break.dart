import 'nodes/space.dart';

import 'syntax_tree.dart';

extension SyntaxTreeTexStyleBreakExt on SyntaxTree {
  BreakResult<SyntaxTree> texBreak({
    int relPenalty = 500,
    int binOpPenalty = 700,
  }) {
    final eqRowBreakResult = greenRoot.texBreak(
      relPenalty: relPenalty,
      binOpPenalty: binOpPenalty,
    );
    return BreakResult(
      parts: eqRowBreakResult.parts
          .map((part) => SyntaxTree(greenRoot: part))
          .toList(growable: false),
      penalties: eqRowBreakResult.penalties,
    );
  }
}

extension EquationRowNodeTexStyleBreakExt on EquationRowNode {
  BreakResult<EquationRowNode> texBreak({
    int relPenalty = 500,
    int binOpPenalty = 700,
  }) {
    final breakIndices = <int>[];
    final penalties = <int>[];
    for (var i = 0; i < flattenedChildList.length; i++) {
      final child = flattenedChildList[i];
      if (child.rightType == AtomType.bin) {
        breakIndices.add(i);
        penalties.add(binOpPenalty);
      } else if (child.rightType == AtomType.rel) {
        breakIndices.add(i);
        penalties.add(relPenalty);
      } else if (child is SpaceNode && child.breakPenalty != null) {
        breakIndices.add(i);
        penalties.add(child.breakPenalty!);
      }
    }

    final res = <EquationRowNode>[];
    var pos = 1;
    for (var i = 0; i < breakIndices.length; i++) {
      final breakEnd = caretPositions[breakIndices[i] + 1];
      res.add(this.clipChildrenBetween(pos, breakEnd).wrapWithEquationRow());
      pos = breakEnd;
    }
    if (pos != caretPositions.last) {
      res.add(this
          .clipChildrenBetween(pos, caretPositions.last)
          .wrapWithEquationRow());
      penalties.add(10000);
    }
    return BreakResult<EquationRowNode>(
      parts: res,
      penalties: penalties,
    );
  }
}

class BreakResult<T> {
  final List<T> parts;
  final List<int> penalties;

  const BreakResult({
    required this.parts,
    required this.penalties,
  });
}
