import 'package:flutter/foundation.dart';
import 'package:flutter_math/src/ast/syntax_tree.dart';
import '../../utils/iterable_extensions.dart';

GreenNode applyOptimization(SyntaxNode pos,
    List<GreenNode> Function(List<GreenNode> children) optimizePattern) {
  final nodesOfDepth = <int, List<GreenNode>>{};

  final substitutionMap = <GreenNode, GreenNode>{};

  final root = pos.value;

  visitTreeExceptRoot(root, (current, parent, depth) {
    nodesOfDepth.putIfAbsent(depth, () => []);
    nodesOfDepth[depth].add(current);
  });

  nodesOfDepth[0] = [root];

  for (var depth = nodesOfDepth.keys.max() - 1; depth >= 0; depth--) {
    for (final node in nodesOfDepth[depth]) {
      if (node is EquationRowNode || node is TransparentNode) {
        final effChildren = node.children
            .map((e) => substitutionMap[e] ?? e)
            .toList(growable: false);
        final optimizedChildren = optimizePattern(effChildren);
        if (!listEquals(node.children, optimizedChildren)) {
          substitutionMap[node] = node.updateChildren(optimizedChildren);
        }
      }
    }
  }

  return substitutionMap[root] ?? root;
}

/// Post-order
void visitTreeExceptRoot(
  GreenNode node,
  void Function(GreenNode current, GreenNode parent, int depth) visit, [
  int depth = 0,
]) {
  if (node is ParentableNode) {
    for (final child in node.children) {
      visitTreeExceptRoot(child, visit, depth + 1);
      visit(child, node, depth + 1);
    }
  }
}
