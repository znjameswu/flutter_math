import 'context.dart';
import 'parser.dart';
import 'result.dart';

extension PickParserExtension<I, O> on Parser<I, List<O>> {
  /// Returns a parser that transforms a successful parse result by returning
  /// the element at [index] of a list. A negative index can be used to access
  /// the elements from the back of the list.
  ///
  /// For example, the parser `letter().star().pick(-1)` returns the last
  /// letter parsed. For the input `'abc'` it returns `'c'`.
  Parser<I, O> pick(int index) => PickParser<I, O>(this, index);
}

/// A parser that performs a transformation with a given function on the
/// successful parse result of the delegate.
class PickParser<I, O> extends DelegateParser<I, List<O>, O> {
  final int index;

  PickParser(Parser<I, List<O>> delegate, this.index) : super(delegate);

  @override
  Result<I, O> parseOn(Context<I> context) {
    final result = delegate.parseOn(context);
    if (result.isSuccess) {
      final value = result.value;
      final picked = value[index < 0 ? value.length + index : index];
      return result.success(picked);
    } else {
      return result.failure(result.message);
    }
  }
}
