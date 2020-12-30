import '../../../ast/syntax_tree.dart';

import '../titep_parser/context.dart';
import '../titep_parser/parser.dart';
import '../titep_parser/result.dart';

abstract class NodeParser extends Parser<GreenNode, GreenNode> {
  final NodePredicate predicate;

  final String message;

  const NodeParser(this.predicate, this.message);

  @override
  Result<GreenNode, GreenNode> parseOn(
    Context<GreenNode> context, {
    bool reverse = false,
  }) {
    final buffer = context.buffer;
    final position = context.position;
    if (position < buffer.length && predicate.test(buffer[position])) {
      return context.success(buffer[position], position + (reverse ? -1 : 1));
    }
    return context.failure(message);
  }
}

abstract class NodePredicate {
  const NodePredicate();

  /// Tests if the character predicate is satisfied.
  bool test(GreenNode value);
}


