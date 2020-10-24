import 'package:flutter/widgets.dart';

import '../ast/options.dart';
import '../parser/tex/settings.dart';
import 'math.dart';
import 'selectable.dart';

enum FlutterMathMode {
  edit,
  select,
  view,
}

enum EquationFormat {
  tex,
  // unicodeMath,
  // mathml,
  // json,
}

typedef OnErrorFallback = Widget Function(String errmsg);

class FlutterMath {
  @Deprecated('Consider using a more explicit widget variant '
      'and its constructor: Math.tex')
  static Widget fromTexString(
    String expression, {
    Key key,
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    FlutterMathMode mode = FlutterMathMode.view,
    OnErrorFallback onErrorFallback = defaultOnErrorFallback,
  }) =>
      Math.tex(
        expression,
        key: key,
        options: options,
        settings: settings,
        onErrorFallback: onErrorFallback,
      );
}

/// Default fallback function for [Math], [SelectableMath]
Widget defaultOnErrorFallback(String error) => Text(error.toString());
