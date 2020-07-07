import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import '../ast/options.dart';
import '../ast/syntax_tree.dart';
import '../parser/tex/parse_error.dart';
import '../parser/tex/parser.dart';
import '../parser/tex/settings.dart';
import 'controller.dart';
// import 'controller.dart';
// import 'scope.dart';

enum FlutterMathMode {
  edit,
  select,
  view,
}

extension FlutterMathModeExt on FlutterMathMode {
  bool get canEdit => this == FlutterMathMode.edit;
  bool get canSelect => this != FlutterMathMode.view;
}

class FlutterMath extends StatelessWidget {
  final FlutterMathController controller;
  final Options options;
  // final FocusNode focusNode;
  // final TextSelectionControls selectionControls;
  // final bool autofocus;
  final FlutterMathMode mode;
  final Widget Function(String errmsg) onErrorFallback;
  const FlutterMath._({
    Key key,
    @required this.controller,
    this.options = Options.displayOptions,
    // @required this.focusNode,
    // this.selectionControls,
    // this.autofocus = true,
    this.mode = FlutterMathMode.view,
    this.onErrorFallback,
  })  : assert(mode != null),
        // assert(controller != null),
        // assert(focusNode != null),
        super(key: key);

  factory FlutterMath.fromTexString(
    String expression, {
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    FlutterMathMode mode = FlutterMathMode.view,
    Widget Function(String errmsg) onErrorFallback,
  }) {
    if (mode != FlutterMathMode.view) {
      throw UnimplementedError('Other mode is still in development!');
    }
    try {
      final ast = SyntaxTree(
        greenRoot: TexParser(expression, settings).parse(),
      );
      return FlutterMath._(
        controller: FlutterMathController(ast: ast),
        options: options,
        onErrorFallback: onErrorFallback,
      );
    } on Object catch (e) {
      return FlutterMath._(
        controller: FlutterMathController(error: e),
        onErrorFallback: onErrorFallback,
      );
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<FlutterMathController>(
          builder: (context, controller, _) {
            if (controller.error == null) {
              return controller.ast.buildWidget(options);
            } else {
              dynamic error = controller.error;
              final errorMsg = error is ParseError
                  ? error.message
                  : 'Internal error: $error. Please report.';
              if (onErrorFallback != null) {
                return onErrorFallback(errorMsg);
              } else {
                return Text(errorMsg);
              }
            }
          },
        ),
      );
}

