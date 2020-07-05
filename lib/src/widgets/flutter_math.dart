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
  final dynamic error;
  final Options options;
  // final FocusNode focusNode;
  // final TextSelectionControls selectionControls;
  // final bool autofocus;
  final FlutterMathMode mode;
  const FlutterMath._({
    Key key,
    @required this.controller,
    this.error,
    this.options = Options.displayOptions,
    // @required this.focusNode,
    // this.selectionControls,
    // this.autofocus = true,
    this.mode = FlutterMathMode.view,
  })  : assert(mode != null),
        // assert(controller != null),
        // assert(focusNode != null),
        super(key: key);

  factory FlutterMath.fromTexString(
    String expression, {
    Options options = Options.displayOptions,
    Settings settings = const Settings(),
    FlutterMathMode mode = FlutterMathMode.view,
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
      );
    } on ParseError catch (e) {
      return FlutterMath._(controller: null, error: e);
    } on Object catch (e) {
      return FlutterMath._(controller: null, error: e);
    }
  }

  // const FlutterMath.fromAst({
  //   Key key,
  //   @required SyntaxTree equation,
  //   @required this.focusNode,
  //   this.selectionControls,
  //   this.autofocus = true,
  //   this.mode = FlutterMathMode.edit,
  // })  : controller = FlutterMathController(equation),
  //       super(key: key);
  // @override
  // _FlutterMathState createState() => _FlutterMathState();
  @override
  Widget build(BuildContext context) {
    if (error is ParseError) {
      return Text((error as ParseError).message);
    } else if (error != null) {
      return Text('Internal error: $error. Please report.');
    } else {
      return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<FlutterMathController>(
          builder: (context, controller, _) =>
              controller.ast.buildWidget(options),
        ),
      );
    }
  }
}

// class _FlutterMathState extends State<FlutterMath> {
//   SyntaxTree get ast => widget.controller.ast;

//   // TextSelection get selection => widget.controller.selection;

// }
