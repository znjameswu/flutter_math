import 'package:flutter/foundation.dart';
import 'package:flutter_math/src/ast/nodes/multiscripts.dart';
import 'package:flutter_math/src/ast/nodes/nary_op.dart';
import 'package:flutter_math/src/render/layout/multiscripts.dart';
import 'package:meta/meta.dart';

import '../../ast/nodes/left_right.dart';
import '../../ast/syntax_tree.dart';
import '../../utils/iterable_extensions.dart';
import 'operators.dart';

/// Elements are divided into two types: operands and operators
///
/// An operand is either
/// - A continuous span of non-operators
/// - A span delimited by parentheses, and directly served as an operand to
///   an operator
///
/// An operator is either
/// - A unicode (with proper unescaped property) AtomNode defined as operator
/// - A Nary operator enclosed in subsup pairs (with no prescripts)
///
/// Parsing from string <==> Edited by a stream of user-input characters.
///
/// Note that the Appendix A in UnicodeMath book gives a pretty good
/// representation of the parsing algorithm itself. However, it serves as a
/// reified model of the grammar explained in previous chapters, and doesn't
/// fit with our model very well here. E.g. Handling '\sqrt 1/2  '
///
/// Cases to consider
/// +1/2 vs 1/+2 vs \sum\of+2 (Incoherence in the spec!)
/// +^2
///
/// We will use a reverse lexer from the input position to better model user
/// input handling.
///
/// When a fold() request was received, following steps will happen:
/// - Try fetch an element
///   - If the element is an operator, if so, jump to operator handling logic.
///     If the operator request a right operand, give it an empty list.
///   - If it is an operand, try fetch another element.
///     - If it is still an operand, this means something is wrong with our
///       lexer. Terminate.
///     - If it is an operator
///       - If it does not request a right operand, terminate. (Like space, or
///         right delimiters)
///       - If it does request a right operand, supply the previous operand and
///         jump to operator handling logic.
/// - After jumping back from handling logic, examine lexer position, and use
/// [List.replaceRange] to replace consumed parts with returned [GreenNode]
///
/// How to fetch
///
class UmReverseParser {
  List<GreenNode> nodes;

  UmReverseParser({
    @required this.nodes,
  });
}

List<GreenNode> foldOnce(List<GreenNode> nodes, int pos, double precedence) {
  _FoldRes foldRes;
  final lexer = UmReverseLexer(nodes: nodes, pos: pos);

  try {
    foldRes = _fold(lexer, precedence);
  } on Object {}
  return foldRes != null
      ? (List.from(nodes)
        ..replaceRange(lexer.index + 1, pos, foldRes.foldedNodes))
      : nodes;
}

class UmReverseLexer {
  final List<GreenNode> nodes;
  int index;

  GreenNode _current;

  UmReverseLexer({
    @required this.nodes,
    @required int pos,
  })  : index = pos - 1,
        _current = pos >= 1 ? nodes[pos - 1] : null;

  GreenNode fetch() => _current;
  GreenNode peekForward({int delta = 1}) =>
      index >= delta ? nodes[index - delta] : null;
  void consume() {
    if (index >= 0) {
      index--;
    }
    _current = index >= 0 ? nodes[index] : null;
  }
}

_FoldRes _fold(
  UmReverseLexer lexer,
  double precedence, {
  List<GreenNode> existingRightOperand = const [],
  bool onlyOnce = false,
  Set<String> allowOp = const {},
  int rightOperandLeftConsumableSpace = 0,
  int rightOperandRightConsumableSpace = 0,
  bool stopOnFirstNary = false, // TODO
}) {
  var accumulated = List<GreenNode>.from(existingRightOperand);
  var leftConsumableSpace = 0;
  var leftOperandRightConsumableSpace = 0;
  var hasRightOperand = existingRightOperand.isNotEmpty;
  var rightConsumableSpace = rightOperandRightConsumableSpace;
  var ignoreSpaceOp = false;

  assert(hasRightOperand ||
      (rightOperandLeftConsumableSpace == 0 &&
          rightOperandRightConsumableSpace == 0));

  GreenNode node;
  while ((node = lexer.fetch()) != null) {
    final opSymbol = checkOperator(node);
    if (opSymbol == null) {
      // If current node is not an operator, collect it
      rightOperandLeftConsumableSpace = 0;
      hasRightOperand = true;
      lexer.consume();
      accumulated.insert(0, node);
    } else {
      // If the current node is an operator
      final spec = umOperators[opSymbol];

      // Adjust precedence
      var effOpPrecedence = spec.precedence;
      // Any normal operators behind division and subsup will have high precedence
      if (spec.precedence == precedenceNormal &&
          opSymbol != ' ' &&
          const {...divideOperators, ...subsupOperators}
              .contains(checkOperator(lexer.peekForward()))) {
        effOpPrecedence = double.infinity;
      }
      // '.' surrounded by ASCII digits is treated as operand
      if (opSymbol == '.' &&
          checkChar(lexer.peekForward())?.isDigit == true &&
          checkChar(accumulated.firstOrNull)?.isDigit == true) {
        effOpPrecedence = double.infinity;
      }
      // '!' preceded by an operand is treated as operand
      if (opSymbol == '!' && checkOperator(lexer.peekForward()) == null) {
        effOpPrecedence = precedenceCombMark - 0.5;
      }

      // Meeting a lower precedence means 'stop', except for bracket operators.
      if (effOpPrecedence <= precedence &&
          !closeOperators.contains(opSymbol) &&
          !allowOp.contains(opSymbol)) {
        break;
      }

      lexer.consume();

      // Prepare left operand (if needed)
      var leftOperand = const <GreenNode>[];
      if (spec.needsLeft) {
        final leftRes = _fold(
          lexer,
          effOpPrecedence +
              (spec.associativity == Associativity.left ? -0.1 : 0.0),
          onlyOnce: false,
          allowOp: !allowOp.contains(opSymbol)
              ? (subsupPair[opSymbol] ?? const {})
              : (subsupPair[opSymbol] ?? const {}).intersection(allowOp),
          rightOperandLeftConsumableSpace:
              rightOperandLeftConsumableSpace + (opSymbol == ' ' ? -1 : 0),
        );
        leftConsumableSpace = leftRes.leftConsumableSpace;
        leftOperandRightConsumableSpace = leftRes.rightConsumableSpace;
        leftOperand = leftRes.foldedNodes;
      }

      if (opSymbol == ' ') {
        if (leftOperandRightConsumableSpace + rightOperandLeftConsumableSpace >
            0) {
          ignoreSpaceOp = true;
        }
        if (!hasRightOperand) {
          rightConsumableSpace = leftOperandRightConsumableSpace - 1;
        }
      }

      // Apply operand
      if (!spec.needsRight) {
        accumulated = spec.handler(
          spec.unwrapLeft ? unpackParentheses(leftOperand) : leftOperand,
          const [],
          node,
          lexer,
        )..addAll(accumulated);
      } else {
        if (opSymbol == ' ' && ignoreSpaceOp) {
          accumulated = [...leftOperand, ...accumulated];
        } else {
          accumulated = spec.handler(
            spec.unwrapLeft ? unpackParentheses(leftOperand) : leftOperand,
            spec.unwrapRight ? unpackParentheses(accumulated) : accumulated,
            node,
            lexer,
          );
        }
      }

      // Expand nary
      final last = accumulated.last;
      if (last is MultiscriptsNode && last.base.children.length == 1) {
        final baseOp = checkOperator(last.base.children[0]);
        // If allowOp does not contain opSymbol, it means we are at the right
        // position to expand.
        if (naryOperators.contains(baseOp) && !allowOp.contains(opSymbol)) {
          accumulated.last = NaryOperatorNode(
            operator: baseOp,
            lowerLimit: last.sub,
            upperLimit: last.sup,
            naryand: EquationRowNode.empty(),
          );
        }
      }

      // If the current operator causes folding, then the immediate space
      // surrounding this expression will be consumed and not displayed as
      // space.
      if (spec.causeFolding) {
        rightConsumableSpace++;
      }

      if (divideOperators.contains(opSymbol)) {
        leftConsumableSpace++;
      }

      if (onlyOnce) {
        break;
      } else {
        final recursionRes = _fold(
          lexer,
          precedence,
          existingRightOperand: accumulated,
          rightOperandLeftConsumableSpace: leftConsumableSpace,
          onlyOnce: false,
        );
        accumulated = recursionRes.foldedNodes;
      }
    }
  }
  return _FoldRes(
    leftConsumableSpace: leftConsumableSpace,
    rightConsumableSpace: rightConsumableSpace,
    foldedNodes: accumulated,
  );
}

class _FoldRes {
  final int leftConsumableSpace;
  final int rightConsumableSpace;
  final List<GreenNode> foldedNodes;
  const _FoldRes({
    @required this.leftConsumableSpace,
    @required this.rightConsumableSpace,
    @required this.foldedNodes,
  });
}

List<GreenNode> unpackParentheses(List<GreenNode> operand) {
  if (operand.length == 1) {
    final node = operand[0];
    if (node is LeftRightNode &&
        node.body.length == 1 &&
        node.leftDelim == '(' &&
        node.rightDelim == ')') {
      return node.body[0].children;
    }
  }
  return operand;
}
