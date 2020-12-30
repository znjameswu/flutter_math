import 'dart:ui';

import 'package:meta/meta.dart';

import 'result.dart';

/// An immutable parse context.
@immutable
class Context<I> {
  const Context(this.buffer, this.position, this.direction);

  /// The buffer we are working on.
  final List<I> buffer;

  final TextDirection direction;

  /// The current position in the [buffer].
  final int position;

  /// Returns a result indicating a parse success.
  Result<I, R> success<R>(R result, [int progress = 0]) => Success<I, R>(
        buffer,
        direction == TextDirection.rtl
            ? this.position - progress
            : this.position + progress,
        result,
        this.direction,
      );

  /// Returns a result indicating a parse failure.
  Result<I, R> failure<R>(String message, [int progress = 0]) => Failure<I, R>(
        buffer,
        direction == TextDirection.rtl
            ? this.position - progress
            : this.position + progress,
        message,
        this.direction,
      );

  // /// Returns the current line:column position in the [buffer].
  // String toPositionString() => Token.positionString(buffer, position);

  // @override
  // String toString() => 'Context[${toPositionString()}]';
}
