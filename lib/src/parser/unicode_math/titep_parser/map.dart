import 'context.dart';
import 'parser.dart';
import 'result.dart';

/// Typed action callback.
typedef MapCallback<T, R> = R Function(T value);

extension MapParserExtension<I, O1> on Parser<I, O1> {
  /// Returns a parser that evaluates a [callback] as the production action
  /// on success of the receiver.
  ///
  /// By default we assume the [callback] to be side-effect free. Unless
  /// [hasSideEffects] is set to `true`, the execution might be skipped if there
  /// are no direct dependencies.
  ///
  /// For example, the parser `digit().map((char) => int.parse(char))` returns
  /// the number `1` for the input string `'1'`. If the delegate fails, the
  /// production action is not executed and the failure is passed on.
  Parser<I, O2> map<O2>(MapCallback<O1, O2> callback,
          {bool hasSideEffects = false}) =>
      MapParser<I, O1, O2>(this, callback, hasSideEffects);
}

/// A parser that performs a transformation with a given function on the
/// successful parse result of the delegate.
class MapParser<I, O1, O2> extends DelegateParser<I, O1, O2> {
  final MapCallback<O1, O2> callback;
  final bool hasSideEffects;

  MapParser(Parser<I, O1> delegate, this.callback,
      // ignore: avoid_positional_boolean_parameters
      [this.hasSideEffects = false])
      : super(delegate);

  @override
  Result<I, O2> parseOn(Context<I> context) {
    final result = delegate.parseOn(context);
    if (result.isSuccess) {
      return result.success(callback(result.value));
    } else {
      return result.failure(result.message);
    }
  }
}
