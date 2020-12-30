import 'context.dart';
import 'parser.dart';
import 'result.dart';

/// The not-predicate, a parser that succeeds whenever its delegate does not,
/// but consumes no input [Parr 1994, 1995].
class NotParser<I, O> extends DelegateParser<I, O, Failure<I, O>> {
  final String message;

  NotParser(Parser<I, O> delegate, this.message) : super(delegate);

  @override
  Result<I, Failure<I, O>> parseOn(Context<I> context) {
    final result = delegate.parseOn(context);
    if (result.isFailure) {
      return context.success(result as Failure<I, O>);
    } else {
      return context.failure(message);
    }
  }

  @override
  String toString() => '${super.toString()}[$message]';
}