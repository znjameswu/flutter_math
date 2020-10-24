import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../ast/options.dart';
import '../ast/style.dart';
import '../ast/syntax_tree.dart';
import '../parser/tex/parse_error.dart';
import '../parser/tex/parser.dart';
import '../parser/tex/settings.dart';
import 'flutter_math.dart';

class Math extends StatelessWidget {
  const Math({
    Key key,
    this.ast,
    this.mathStyle = MathStyle.display,
    this.onErrorFallback = defaultOnErrorFallback,
    this.options,
    this.parseError,
    this.textScaleFactor,
    this.textStyle,
  })  : assert(ast != null || parseError != null),
        assert(onErrorFallback != null),
        assert(mathStyle != null || options != null),
        super(key: key);

  final SyntaxTree ast;

  final MathStyle mathStyle;

  final OnErrorFallback onErrorFallback;

  final Options options;

  final String parseError;

  final double textScaleFactor;

  final TextStyle textStyle;

  factory Math.tex(
    String expression, {
    Key key,
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    OnErrorFallback onErrorFallback = defaultOnErrorFallback,
    MathStyle mathStyle = MathStyle.display,
    double textScaleFactor,
    TextStyle textStyle,
  }) {
    SyntaxTree ast;
    String parseError;
    try {
      ast = SyntaxTree(greenRoot: TexParser(expression, settings).parse());
    } on ParseError catch (e) {
      parseError = 'Parser Error: ${e.message}';
    } on dynamic catch (e) {
      parseError = e.toString();
    }
    return Math(
      key: key,
      ast: ast,
      parseError: parseError,
      options: options,
      onErrorFallback: onErrorFallback,
      mathStyle: mathStyle,
      textScaleFactor: textScaleFactor,
      textStyle: textStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (parseError != null) {
      return onErrorFallback(parseError);
    }

    var options = this.options;
    if (options == null) {
      var effectiveTextStyle = textStyle;
      if (textStyle == null || textStyle.inherit) {
        effectiveTextStyle =
            DefaultTextStyle.of(context).style.merge(textStyle);
      }
      if (MediaQuery.boldTextOverride(context)) {
        effectiveTextStyle = effectiveTextStyle
            .merge(const TextStyle(fontWeight: FontWeight.bold));
      }

      final textScaleFactor =
          this.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);

      options = Options(
        style: mathStyle,
        fontSize: effectiveTextStyle.fontSize * textScaleFactor,
        mathFontOptions: effectiveTextStyle.fontWeight != FontWeight.normal
            ? FontOptions(fontWeight: effectiveTextStyle.fontWeight)
            : null,
      );
    }

    Widget child;

    try {
      child = ast.buildWidget(options);
    } on dynamic catch (e) {
      return onErrorFallback(e.toString());
    }

    return Provider.value(
      value: FlutterMathMode.view,
      child: child,
    );
  }
}
