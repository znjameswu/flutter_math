import 'package:flutter/widgets.dart';

import '../ast/options.dart';
import '../parser/tex/settings.dart';
import 'view.dart';

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
  static Widget fromTexString(
    String expression, {
    Key key,
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    FlutterMathMode mode = FlutterMathMode.view,
    OnErrorFallback onErrorFallback = defaultOnErrorFallback,
  }) =>
      MathView.tex(
        expression,
        key: key,
        options: options,
        settings: settings,
        onErrorFallback: onErrorFallback,
      );
}

Widget defaultOnErrorFallback(String error) => Text(error.toString());
