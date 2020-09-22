import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../ast/options.dart';
import '../ast/syntax_tree.dart';
import '../parser/tex/parse_error.dart';
import '../parser/tex/parser.dart';
import '../parser/tex/settings.dart';
import 'flutter_math.dart';

class MathView extends StatelessWidget {
  final SyntaxTree ast;

  final String parseError;

  final Options options;

  final OnErrorFallback onErrorFallback;

  const MathView({
    Key key,
    this.ast,
    this.parseError,
    this.options,
    this.onErrorFallback,
  }) : super(key: key);

  factory MathView.tex(
    String expression, {
    Key key,
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    OnErrorFallback onErrorFallback,
  }) {
    try {
      final ast =
          SyntaxTree(greenRoot: TexParser(expression, settings).parse());
      return MathView(
        key: key,
        ast: ast,
        options: options,
        onErrorFallback: onErrorFallback,
      );
    } on ParseError catch (e) {
      return MathView(
        key: key,
        parseError: 'Parse Error: ${e.message}',
        onErrorFallback: onErrorFallback,
      );
    } on dynamic catch (e) {
      return MathView(
        key: key,
        parseError: e.toString(),
        onErrorFallback: onErrorFallback,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (parseError != null) {
      return onErrorFallback(parseError);
    }
    try {
      return MultiProvider(
        providers: [
          Provider.value(value: FlutterMathMode.view),
          Provider.value(value: const TextSelection.collapsed(offset: -1)),
        ],
        child: ast.buildWidget(options),
      );
    } on dynamic catch (err) {
      return onErrorFallback(err.toString());
    }
  }
}
