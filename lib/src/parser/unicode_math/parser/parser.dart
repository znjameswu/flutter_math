import 'package:meta/meta.dart';
import 'package:petitparser/petitparser.dart' as pp;

import 'package:flutter_math/src/ast/syntax_tree.dart';

import 'result.dart';

abstract class Parser<I, O> {
  const Parser();

  Result<I, O> parseOn(
    Context<I> context, {
    bool reverse = false,
  });

  Result<I, O> parse(
    List<I> input, {
    bool reverse = false,
  }) =>
      parseOn(Context<I>(input, reverse ? input.length -1: 0));

  Parser<I, O> seq(Parser<I, O> other) => SequenceParser([this, other]);

  Parser<I, O> or(Parser<I, O> other) => ChoiceParser([this, other]);

  Parser<I, O> operator &(Parser<I,O> other) => seq(other);
  
  Parser<I, O> operator |(Parser<I,O> other) => or(other);
}

abstract class NodeParser extends Parser<GreenNode, GreenNode> {
  final NodePredicate predicate;

  final String message;

  const NodeParser(this.predicate, this.message)
      : assert(predicate != null, 'predicate must not be null'),
        assert(message != null, 'message must not be null');

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

class SequenceParser<I, O> extends Parser<I, O> {
  final List<Parser<I, O>> children;
  SequenceParser(
    this.children,
  );

  @override
  Result<I, O> parseOn(Context<I> context, {bool reverse = false}) {
    // TODO: implement parseOn
    throw UnimplementedError();
  }

  @override
  Parser<I, O> seq(Parser<I, O> other) => SequenceParser([...children, other]);
}

class ChoiceParser<I, O> extends Parser<I, O> {
  final List<Parser<I, O>> children;
  ChoiceParser(
    this.children,
  );

  @override
  Result<I, O> parseOn(Context<I> context, {bool reverse = false}) {
    // TODO: implement parseOn
    throw UnimplementedError();
  }

  @override
  Parser<I, O> or(Parser<I, O> other) => ChoiceParser([...children, other]);
}
