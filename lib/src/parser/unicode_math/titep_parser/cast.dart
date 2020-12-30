import 'context.dart';
import 'parser.dart';
import 'result.dart';

/// A parser that casts a `Result` to a `Result<R>`.
class CastParser<I, O1, O2> extends DelegateParser<I, O1, O2> {
  CastParser(Parser<I, O1> delegate) : super(delegate);

  @override
  Result<I, O2> parseOn(Context<I> context) {
    final result = delegate.parseOn(context);
    if (result.isSuccess) {
      return result.success(result.value as O2);
    } else {
      return result.failure(result.message);
    }
  }
}
