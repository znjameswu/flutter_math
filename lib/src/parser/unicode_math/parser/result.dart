abstract class Result<I, O> extends Context<I> {
  const Result(List<I> buffer, int position) : super(buffer, position);

  /// Returns `true` if this result indicates a parse success.
  bool get isSuccess => false;

  /// Returns `true` if this result indicates a parse failure.
  bool get isFailure => false;

  /// Returns the parse result of the current context.
  O get value;

  /// Returns the parse message of the current context.
  String get message;

  /// Transform the result with a [callback].
  Result<I, T> map<T>(T Function(O element) callback);
}

/// An immutable parse context.
class Context<I> {
  const Context(this.buffer, this.position);

  /// The buffer we are working on.
  final List<I> buffer;

  /// The current position in the buffer.
  final int position;

  /// Returns a result indicating a parse success.
  Result<I, R> success<R>(R result, [int position]) =>
      Success<I, R>(buffer, position ?? this.position, result);

  /// Returns a result indicating a parse failure.
  Result<I, R> failure<R>(String message, [int position]) =>
      Failure<I, R>(buffer, position ?? this.position, message);

  // /// Returns a human readable string of the current context.
  // @override
  // String toString() => 'Context[${toPositionString()}]';

  // /// Returns the line:column if the input is a string, otherwise the position.
  // String toPositionString() => Token.positionString(buffer, position);
}

/// An immutable parse result in case of a successful parse.
class Success<I, R> extends Result<I, R> {
  const Success(List<I> buffer, int position, this.value)
      : super(buffer, position);

  @override
  bool get isSuccess => true;

  @override
  final R value;

  @override
  String get message => null;

  @override
  Result<I, T> map<T>(T Function(R element) callback) =>
      success(callback(value));

  // @override
  // String toString() => 'Success[${toPositionString()}]: $value';
}

/// An immutable parse result in case of a failed parse.
class Failure<I, O> extends Result<I, O> {
  const Failure(List<I> buffer, int position, this.message)
      : super(buffer, position);

  @override
  bool get isFailure => true;

  @override
  O get value => throw ParserException(this);

  @override
  final String message;

  @override
  Result<I, T> map<T>(T Function(O element) callback) => failure(message);

  // @override
  // String toString() => 'Failure[${toPositionString()}]: $message';
}

/// An exception raised in case of a parse error.
class ParserException implements Exception {
  final Failure failure;

  ParserException(this.failure);

  @override
  String toString() =>
      '${failure.message}'; // at ${failure.toPositionString()}';
}

/// A token represents a parsed part of the input stream.
///
/// The token holds the resulting value of the input, the input buffer,
/// and the start and stop position in the input buffer. It provides many
/// convenience methods to access the state of the token.
class Token<O> {
  /// Constructs a token from the parsed value, the input buffer, and the
  /// start and stop position in the input buffer.
  const Token(this.value, this.buffer, this.start, this.stop);

  /// The parsed value of the token.
  final O value;

  /// The parsed buffer of the token.
  final String buffer;

  /// The start position of the token in the buffer.
  final int start;

  /// The stop position of the token in the buffer.
  final int stop;

  /// The consumed input of the token.
  String get input => buffer.substring(start, stop);

  /// The length of the token.
  int get length => stop - start;

  // /// The line number of the token (only works for [String] buffers).
  // int get line => Token.lineAndColumnOf(buffer, start)[0];

  // /// The column number of this token (only works for [String] buffers).
  // int get column => Token.lineAndColumnOf(buffer, start)[1];

  // @override
  // String toString() => 'Token[${positionString(buffer, start)}]: $value';

  @override
  bool operator ==(Object other) {
    return other is Token &&
        value == other.value &&
        start == other.start &&
        stop == other.stop;
  }

  @override
  int get hashCode => value.hashCode + start.hashCode + stop.hashCode;

  /// Returns a parser for that detects newlines platform independently.
  // static Parser newlineParser() => _newlineParser;

  // static final Parser _newlineParser =
  //     char('\n') | (char('\r') & char('\n').optional());

  // /// Converts the [position] index in a [buffer] to a line and column tuple.
  // static List<int> lineAndColumnOf(String buffer, int position) {
  //   var line = 1, offset = 0;
  //   for (final token in newlineParser().token().matchesSkipping(buffer)) {
  //     if (position < token.stop) {
  //       return [line, position - offset + 1];
  //     }
  //     line++;
  //     offset = token.stop;
  //   }
  //   return [line, position - offset + 1];
  // }

  // /// Returns a human readable string representing the [position] index in a
  // /// [buffer].
  // static String positionString(String buffer, int position) {
  //   final lineAndColumn = lineAndColumnOf(buffer, position);
  //   return '${lineAndColumn[0]}:${lineAndColumn[1]}';
  // }
}
