library flutter_math;

export 'src/ast/options.dart';
export 'src/ast/syntax_tree.dart';
export 'src/parser/tex_parser/parse_error.dart';
export 'src/parser/tex_parser/parser.dart';
export 'src/parser/tex_parser/settings.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
