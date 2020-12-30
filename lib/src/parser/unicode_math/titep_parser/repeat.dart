import 'context.dart';
import 'parser.dart';
import 'result.dart';

const unbounded = -1;

/// An abstract parser that repeatedly parses between 'min' and 'max' instances
/// of its delegate.
abstract class RepeatingParser<I, O> extends DelegateParser<I, O, List<O>> {
  final int min;
  final int max;

  RepeatingParser(Parser<I, O> parser, this.min, this.max) : super(parser) {
    if (min < 0) {
      throw ArgumentError(
          'Minimum repetitions must be positive, but got $min.');
    }
    if (max != unbounded && max < min) {
      throw ArgumentError(
          'Maximum repetitions must be larger than $min, but got $max.');
    }
  }

  @override
  String toString() =>
      '${super.toString()}[$min..${max == unbounded ? '*' : max}]';
}

class PossessiveRepeatingParser<I, O> extends RepeatingParser<I, O> {
  PossessiveRepeatingParser(Parser<I, O> parser, int min, int max)
      : super(parser, min, max);

  @override
  Result<I, List<O>> parseOn(Context<I> context) {
    final elements = <O>[];
    var current = context;
    while (elements.length < min) {
      final result = delegate.parseOn(current);
      if (result.isFailure) {
        return result.failure(result.message);
      }
      elements.add(result.value);
      current = result;
    }
    while (max == unbounded || elements.length < max) {
      final result = delegate.parseOn(current);
      if (result.isFailure) {
        return current.success(elements);
      }
      elements.add(result.value);
      current = result;
    }
    return current.success(elements);
  }
}