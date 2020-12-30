import 'context.dart';
import 'parser.dart';
import 'result.dart';

/// Returns a parser that consumes nothing and fails.
///
/// For example, `failure()` always fails, no matter what input it is given.
Parser<I, O> failure<I,O>([String message = 'unable to parse']) =>
    FailureParser<I,O>(message);

/// A parser that consumes nothing and fails.
class FailureParser<I,O> extends Parser<I,O> {
  final String message;

  FailureParser(this.message);

  @override
  Result<I,O> parseOn(Context<I> context) => context.failure(message);

  @override
  int fastParseOn(String buffer, int position) => -1;

  @override
  String toString() => '${super.toString()}[$message]';
}
