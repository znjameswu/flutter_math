import 'dart:ui';

import 'cast.dart';
import 'context.dart';
import 'not.dart';
import 'or.dart';
import 'pick.dart';
import 'repeat.dart';
import 'result.dart';
import 'seq.dart';

// pp.Context = pp.letter().not();

abstract class Parser<I, O> {
  const Parser();

  Result<I, O> parseOn(Context<I> context);

  Result<I, O> parse(
    List<I> input, {
    bool reverse = false,
  }) =>
      parseOn(Context<I>(input, reverse ? input.length - 1 : 0,
          reverse ? TextDirection.rtl : TextDirection.ltr));

  Parser<I, List> seq(Parser<I, dynamic> other) =>
      SequenceParser<I, dynamic>([this, other]);

  Parser<I, O> or(Parser<I, O> other) => ChoiceParser([this, other]);

  Parser<I, List> operator &(Parser<I, dynamic> other) => seq(other);

  Parser<I, O> operator |(Parser<I, O> other) => or(other);

  /// Returns a parser that accepts the receiver zero or more times. The
  /// resulting parser returns a list of the parse results of the receiver.
  ///
  /// This is a greedy and blind implementation that tries to consume as much
  /// input as possible and that does not consider what comes afterwards.
  ///
  /// For example, the parser `letter().star()` accepts the empty string or
  /// any sequence of letters and returns a possibly empty list of the parsed
  /// letters.
  Parser<I, List<O>> star() => repeat(0, unbounded);

  /// Returns a parser that accepts the receiver one or more times. The
  /// resulting parser returns a list of the parse results of the receiver.
  ///
  /// This is a greedy and blind implementation that tries to consume as much
  /// input as possible and that does not consider what comes afterwards.
  ///
  /// For example, the parser `letter().plus()` accepts any sequence of
  /// letters and returns a list of the parsed letters.
  Parser<I, List<O>> plus() => repeat(1, unbounded);

  /// Returns a parser that accepts the receiver exactly [count] times. The
  /// resulting parser returns a list of the parse results of the receiver.
  ///
  /// For example, the parser `letter().times(2)` accepts two letters and
  /// returns a list of the two parsed letters.
  Parser<I, List<O>> times(int count) => repeat(count, count);

  /// Returns a parser that accepts the receiver between [min] and [max] times.
  /// The resulting parser returns a list of the parse results of the receiver.
  ///
  /// This is a greedy and blind implementation that tries to consume as much
  /// input as possible and that does not consider what comes afterwards.
  ///
  /// For example, the parser `letter().repeat(2, 4)` accepts a sequence of
  /// two, three, or four letters and returns the accepted letters as a list.
  Parser<I, List<O>> repeat(int min, [int? max]) =>
      PossessiveRepeatingParser<I, O>(this, min, max ?? min);

  /// Returns a parser (logical not-predicate) that succeeds with the [Failure]
  /// whenever the receiver fails, but never consumes input.
  ///
  /// For example, the parser `char('_').not().seq(identifier)` accepts
  /// identifiers that do not start with an underscore character. If the parser
  /// `char('_')` accepts the input, the negation and subsequently the
  /// complete parser fails. Otherwise the parser `identifier` is given the
  /// ability to process the complete identifier.
  Parser<I, Failure<I, O>> not([String message = 'success not expected']) =>
      NotParser(this, message);

  /// Returns a parser that consumes any input token (character), but the
  /// receiver.
  ///
  /// For example, the parser `letter().neg()` accepts any input but a letter.
  /// The parser fails for inputs like `'a'` or `'Z'`, but succeeds for
  /// input like `'1'`, `'_'` or `'$'`.
  Parser<I, I> neg([String message = 'input not expected']) =>
      [not(message), any<I>()].toSequenceParser().pick(1).cast<I>();

  /// Returns a parser that casts itself to `Parser<R>`.
  // ignore: use_to_and_as_if_applicable
  Parser<I, O2> cast<O2>() => CastParser<I, O, O2>(this);
}

Parser<I, I> any<I>([String message = 'input expected']) =>
    AnyParser<I>(message);

class AnyParser<I> extends Parser<I, I> {
  final String message;

  AnyParser(this.message);

  @override
  Result<I, I> parseOn(Context<I> context) {
    final position = context.position;
    final buffer = context.buffer;
    return position < buffer.length
        ? context.success(buffer[position], position + 1)
        : context.failure(message);
  }
}

abstract class DelegateParser<I, O1, O2> extends Parser<I, O2> {
  Parser<I, O1> delegate;

  DelegateParser(this.delegate);
}
