import 'package:meta/meta.dart';
import 'package:petitparser/petitparser.dart' as pp;

import '../../../ast/nodes/symbol.dart';
import '../../../ast/syntax_tree.dart';
import '../titep_parser/context.dart';
import '../titep_parser/parser.dart';
import '../titep_parser/result.dart';

/// Abstract character predicate class.
@immutable
abstract class SymbolPredicate {
  const SymbolPredicate();

  /// Tests if the character predicate is satisfied.
  // ignore: avoid_positional_boolean_parameters
  bool test(String symbol, bool escaped);
}

class SymbolParser extends Parser<GreenNode, String> {
  final SymbolPredicate predicate;

  final String message;

  SymbolParser(this.predicate, this.message);

  @override
  Result<GreenNode, String> parseOn(Context<GreenNode> context) {
    final buffer = context.buffer;
    final position = context.position;
    if (position < buffer.length && position >= 0) {
      final node = buffer[position];
      if (node is SymbolNode &&
          predicate.test(node.symbol, node.unicodeMathEscaped)) {
        return context.success(node.symbol, 1);
      }
    }
    return context.failure(message);
  }

  @override
  String toString() => '${super.toString()}[$message]';
}

final Parser<GreenNode, String> char =
    SymbolParser(const UmCharPredicate(), 'Unicode char');

class UmCharPredicate extends SymbolPredicate {
  const UmCharPredicate();

  @override
  bool test(String symbol, bool escaped) => true;
}

final Parser<GreenNode, String> space =
    SymbolParser(const UmSpacePredicate(), 'ASCII space');

class UmSpacePredicate extends SymbolPredicate {
  const UmSpacePredicate();

  @override
  bool test(String symbol, bool escaped) => symbol == ' ';
}

/// Converts an object to a character code.
int toCharCode(Object element) {
  if (element is num) {
    return element.round();
  }
  final value = element.toString();
  if (value.length != 1) {
    throw ArgumentError('"$value" is not a character');
  }
  return value.codeUnitAt(0);
}

/// Converts a character to a readable string.
String toReadableString(Object element) => element is String
    ? _toFormattedString(element)
    : _toFormattedChar(toCharCode(element));

String _toFormattedString(String input) =>
    input.codeUnits.map(_toFormattedChar).join();

String _toFormattedChar(int code) {
  switch (code) {
    case 0x08:
      return '\\b'; // backspace
    case 0x09:
      return '\\t'; // horizontal tab
    case 0x0A:
      return '\\n'; // new line
    case 0x0B:
      return '\\v'; // vertical tab
    case 0x0C:
      return '\\f'; // form feed
    case 0x0D:
      return '\\r'; // carriage return
    case 0x22:
      return '\\"'; // double quote
    case 0x27:
      return "\\'"; // single quote
    case 0x5C:
      return '\\\\'; // backslash
  }
  if (code < 0x20) {
    return '\\x${code.toRadixString(16).padLeft(2, '0')}';
  }
  return String.fromCharCode(code);
}

/// Returns a parser that accepts any character in the range
/// between [start] and [stop].
Parser<GreenNode, String> range(Object start, Object stop, [String? message]) {
  return SymbolParser(
      RangeCharPredicate(toCharCode(start), toCharCode(stop)),
      message ??
          '${toReadableString(start)}..${toReadableString(stop)} expected');
}

class RangeCharPredicate implements SymbolPredicate {
  final int start;
  final int stop;

  RangeCharPredicate(this.start, this.stop) {
    if (start > stop) {
      throw ArgumentError('Invalid range: $start-$stop');
    }
  }

  @override
  bool test(String symbol, bool escaped) {
    final value = symbol.codeUnitAt(0);
    return start <= value && value <= stop;
  }
}

Parser<GreenNode, String> pattern(String element, [String? message]) {
  return SymbolParser(PpPatternPredicate(pp.pattern_.parse(element).value),
      message ?? '[${toReadableString(element)}] expected');
}

class PpPatternPredicate implements SymbolPredicate {
  final pp.CharacterPredicate ppPredicate;

  PpPatternPredicate(this.ppPredicate);

  @override
  bool test(String symbol, bool escaped) =>
      ppPredicate.test(symbol.codeUnitAt(0));
}
