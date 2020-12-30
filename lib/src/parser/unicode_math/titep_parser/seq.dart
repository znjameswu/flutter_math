import 'dart:ui';

import 'context.dart';
import 'parser.dart';
import 'result.dart';

class SequenceParser<I, O> extends Parser<I, List<O>> {
  final List<Parser<I, O>> children;
  SequenceParser(
    this.children,
  );

  @override
  Result<I, List<O>> parseOn(Context<I> context) {
    var current = context;
    final elements = <O>[];
    final _indices =
        List.generate(children.length, (index) => index, growable: false);
    final indices =
        context.direction == TextDirection.rtl ? _indices.reversed : _indices;
    for (final i in indices) {
      final result = children[i].parseOn(current);
      if (result.isFailure) {
        return result.failure(result.message);
      }
      elements.add(result.value);
      current = result;
    }
    return current.success(elements);
  }

  @override
  Parser<I, List> seq(Parser<I, dynamic> other) =>
      SequenceParser<I, dynamic>([...children, other]);
}

extension SequenceIterableExtension<I, O> on List<Parser<I,O>> {
  /// Converts the parser in this iterable to a sequence of parsers.
  Parser<I, List<O>> toSequenceParser() => SequenceParser<I, O>(this);
}