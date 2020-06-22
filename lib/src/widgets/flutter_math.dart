import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../ast/syntax_tree.dart';
import 'controller.dart';
import 'scope.dart';

enum FlutterMathMode {
  edit,
  select,
  view,
}

extension FlutterMathModeExt on FlutterMathMode {
  bool get canEdit => this == FlutterMathMode.edit;
  bool get canSelect => this != FlutterMathMode.view;
  bool get canFormat => this != FlutterMathMode.view;
}

class FlutterMath extends StatefulWidget {
  final FlutterMathController controller;
  final FocusNode focusNode;
  final TextSelectionControls selectionControls;
  final bool autofocus;
  final FlutterMathMode mode;
  const FlutterMath({
    Key key,
    @required this.controller,
    @required this.focusNode,
    this.selectionControls,
    this.autofocus = true,
    this.mode = FlutterMathMode.edit,
  })  : assert(mode != null),
        assert(controller != null),
        assert(focusNode != null),
        super(key: key);

  // const FlutterMath.fromAst({
  //   Key key,
  //   @required SyntaxTree equation,
  //   @required this.focusNode,
  //   this.selectionControls,
  //   this.autofocus = true,
  //   this.mode = FlutterMathMode.edit,
  // })  : controller = FlutterMathController(equation),
  //       super(key: key);
  @override
  _FlutterMathState createState() => _FlutterMathState();
}

class _FlutterMathState extends State<FlutterMath> {
  SyntaxTree get equation => widget.controller.equation;

  TextSelection get selection => widget.controller.selection;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => FlutterMathScope(),
    );
}

