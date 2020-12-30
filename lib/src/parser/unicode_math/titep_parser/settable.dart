import 'context.dart';
import 'failure.dart';
import 'parser.dart';
import 'result.dart';

extension SettableParserExtension<I, O> on Parser<I, O> {
  /// Returns a parser that points to the receiver, but can be changed to point
  /// to something else at a later point in time.
  ///
  /// For example, the parser `letter().settable()` behaves exactly the same
  /// as `letter()`, but it can be replaced with another parser using
  /// [SettableParser.set].
  // ignore: use_to_and_as_if_applicable
  SettableParser<I, O> settable() => SettableParser<I, O>(this);
}

/// Returns a parser that is not defined, but that can be set at a later
/// point in time.
///
/// For example, the following code sets up a parser that points to itself
/// and that accepts a sequence of a's ended with the letter b.
///
///     final p = undefined();
///     p.set(char('a').seq(p).or(char('b')));
SettableParser<I, O> undefined<I, O>([String message = 'undefined parser']) =>
    failure<I, O>(message).settable();

/// A parser that is not defined, but that can be set at a later
/// point in time.
class SettableParser<I, O> extends DelegateParser<I, O, O> {
  SettableParser(Parser<I, O> delegate) : super(delegate);

  // ignore: use_setters_to_change_properties
  /// Sets the receiver to delegate to [parser].
  void set(Parser<I, O> parser) => delegate = parser;

  @override
  Result<I, O> parseOn(Context<I> context) => delegate.parseOn(context);
}
