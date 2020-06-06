import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../ast/syntax_tree.dart';

class FlutterMathController extends ChangeNotifier {
  FlutterMathController(SyntaxTree equation)
      : assert(equation != null),
        _equation = equation;

  SyntaxTree _equation;
  SyntaxTree get equation => _equation;
  TextSelection _selection =
      const TextSelection.collapsed(offset: 0, affinity: TextAffinity.upstream);

  TextSelection get selection => _selection;

}
